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

  final StreamController<UserModel> _controller = StreamController.broadcast();

  UserLocalDataSource(this._box, this._storage);

  Future<void> saveUser(UserModel user) async {
    try {
      await _box.put(user.id, user);
      _controller.add(user);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _box.delete(id);
      await _controller.close();
    } catch (e) {
      logger.e(e);
    }
  }

  Future<Either<String, Stream<UserModel>>> get currentUser async {
    try {
      final id = await _storage.getUserId();
      if (id == null) return left(tr('errors.user_not_found'));
      // final user = _box.watch(key: id);
      // @fixme: this is a hack to fix the issue of multiple listeners
      //   await _controller
      //       .addStream(user.map((event) => event.deleted ? null : event.value));
      // if (!_controller.hasListener) {}
      var userModel = _box.get(id);
      if (userModel == null) return left(tr('errors.user_not_found'));
      return right(Stream.value(userModel));
    } catch (e) {
      logger.e(e);
      return left(tr('errors.user_not_found'));
    }
  }
}
