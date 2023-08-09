import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/common/data/models/user.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:shared_utils/shared_utils.dart';

@singleton
final class UserLocalDataSource {
  final Box<UserModel> _box;
  final BasePersistentStorage _storage;

  StreamController<UserModel> _controller = StreamController.broadcast();

  UserLocalDataSource(this._box, this._storage);

  Future<void> saveUser(UserModel user) async {
    try {
      await _box.put(user.id, user);
      _controller.addStream(Stream<UserModel>.value(user));
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _box.delete(id);
      // await _controller.close();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<Either<Stream<UserModel>, String>> get currentUser async {
    final id = await _storage.getUserId();
    if (id == null) return right(tr('errors.user_not_found'));
    final user = _box.watch(key: id);
    _controller
        .addStream(user.map((event) => event.deleted ? null : event.value));
    return left(_controller.stream);
  }
}
