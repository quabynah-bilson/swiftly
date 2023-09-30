import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/common/data/models/user.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:shared_utils/shared_utils.dart';

const _kUserCollectionName = 'users';

@singleton
final class UserRemoteDataSource {
  final FirebaseFirestore _db;
  final BasePersistentStorage _storage;
  final FirebaseAuth _auth;

  const UserRemoteDataSource(this._db, this._storage, this._auth);

  Future<Either<String, Stream<UserModel>>> get currentUser async {
    try {
      final id = await _storage.getUserId();
      if (id == null) return left(tr('errors.user_not_found'));
      final snapshot = _db.collection(_kUserCollectionName).doc(id).snapshots();
      return right(snapshot.map((event) {
        if (!event.exists) throw Exception(tr('errors.user_not_found'));
        return UserModel.fromJson(event.data()!);
      }));
    } on FirebaseException catch (e) {
      logger.e(e);
    }
    return left(tr('errors.error_occurred'));
  }

  Future<void> createUser(UserModel user) async {
    try {
      unawaited(_auth.currentUser?.updateDisplayName(user.name));
      unawaited(_auth.currentUser?.updatePhotoURL(user.photoUrl));
      await _auth.currentUser?.verifyBeforeUpdateEmail(user.email);
      await _auth.currentUser?.reload();

      await _db
          .collection(_kUserCollectionName)
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> updateUser(UserModel user) async => await _db
      .collection(_kUserCollectionName)
      .doc(user.id)
      .update(user.toJson());

  Future<void> deleteUser(String id) async =>
      await _db.collection(_kUserCollectionName).doc(id).delete();
}
