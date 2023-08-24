// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:firebase_messaging/firebase_messaging.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i8;
import 'package:hive_flutter/hive_flutter.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:intercom_flutter/intercom_flutter.dart' as _i9;
import 'package:mobile/core/di/modules.dart' as _i21;
import 'package:mobile/features/auth/data/repositories/auth.dart' as _i16;
import 'package:mobile/features/auth/domain/repositories/auth.dart' as _i15;
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart'
    as _i20;
import 'package:mobile/features/common/data/data_sources/local/local.dart'
    as _i13;
import 'package:mobile/features/common/data/data_sources/remote/remote.dart'
    as _i14;
import 'package:mobile/features/common/data/models/user.dart' as _i4;
import 'package:mobile/features/common/data/repositories/persistent.storage.dart'
    as _i12;
import 'package:mobile/features/common/data/repositories/user.dart' as _i18;
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart'
    as _i11;
import 'package:mobile/features/common/domain/repositories/user.dart' as _i17;
import 'package:mobile/features/common/presentation/manager/user_cubit.dart'
    as _i19;
import 'package:shared_preferences/shared_preferences.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final hiveModule = _$HiveModule();
    final firebaseModule = _$FirebaseModule();
    final messengerModule = _$MessengerModule();
    final secureStorageModule = _$SecureStorageModule();
    await gh.singletonAsync<_i3.Box<_i4.UserModel>>(
      () => hiveModule.userBox,
      preResolve: true,
    );
    gh.singleton<_i5.FirebaseAuth>(firebaseModule.firebaseAuth);
    gh.singleton<_i6.FirebaseFirestore>(firebaseModule.firestore);
    await gh.singletonAsync<_i7.FirebaseMessaging>(
      () => firebaseModule.firebaseMessaging,
      preResolve: true,
    );
    gh.lazySingleton<_i8.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.singleton<_i9.Intercom>(messengerModule.intercom);
    await gh.singletonAsync<_i10.SharedPreferences>(
      () => secureStorageModule.sharedPrefs,
      preResolve: true,
    );
    gh.singleton<_i11.BasePersistentStorage>(
        _i12.SharedPrefsPersistentStorage(gh<_i10.SharedPreferences>()));
    gh.singleton<_i13.UserLocalDataSource>(_i13.UserLocalDataSource(
      gh<_i3.Box<_i4.UserModel>>(),
      gh<_i11.BasePersistentStorage>(),
    ));
    gh.singleton<_i14.UserRemoteDataSource>(_i14.UserRemoteDataSource(
      gh<_i6.FirebaseFirestore>(),
      gh<_i11.BasePersistentStorage>(),
      gh<_i5.FirebaseAuth>(),
    ));
    gh.singleton<_i15.BaseAuthRepository>(_i16.FirebaseAuthRepository(
      gh<_i5.FirebaseAuth>(),
      gh<_i8.GoogleSignIn>(),
      gh<_i11.BasePersistentStorage>(),
      gh<_i9.Intercom>(),
    ));
    gh.singleton<_i17.BaseUserRepository>(_i18.UserRepository(
      gh<_i13.UserLocalDataSource>(),
      gh<_i14.UserRemoteDataSource>(),
      gh<_i11.BasePersistentStorage>(),
    ));
    gh.factory<_i19.UserCubit>(
        () => _i19.UserCubit(gh<_i17.BaseUserRepository>()));
    gh.factory<_i20.AuthCubit>(
        () => _i20.AuthCubit(gh<_i15.BaseAuthRepository>()));
    return this;
  }
}

class _$HiveModule extends _i21.HiveModule {}

class _$FirebaseModule extends _i21.FirebaseModule {}

class _$MessengerModule extends _i21.MessengerModule {}

class _$SecureStorageModule extends _i21.SecureStorageModule {}
