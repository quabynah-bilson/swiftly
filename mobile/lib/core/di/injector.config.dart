// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i7;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:firebase_messaging/firebase_messaging.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i9;
import 'package:hive_flutter/hive_flutter.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;
import 'package:intercom_flutter/intercom_flutter.dart' as _i10;
import 'package:mobile/core/di/modules.dart' as _i23;
import 'package:mobile/features/auth/data/data_sources/local/local.dart' as _i3;
import 'package:mobile/features/auth/data/data_sources/remote/remote.dart'
    as _i16;
import 'package:mobile/features/auth/data/repositories/auth.dart' as _i18;
import 'package:mobile/features/auth/domain/repositories/auth.dart' as _i17;
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart'
    as _i22;
import 'package:mobile/features/common/data/data_sources/local/local.dart'
    as _i14;
import 'package:mobile/features/common/data/data_sources/remote/remote.dart'
    as _i15;
import 'package:mobile/features/common/data/models/user.dart' as _i5;
import 'package:mobile/features/common/data/repositories/persistent.storage.dart'
    as _i13;
import 'package:mobile/features/common/data/repositories/user.dart' as _i20;
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart'
    as _i12;
import 'package:mobile/features/common/domain/repositories/user.dart' as _i19;
import 'package:mobile/features/common/presentation/manager/user_cubit.dart'
    as _i21;
import 'package:shared_preferences/shared_preferences.dart' as _i11;

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
    gh.lazySingleton<_i3.AuthLocalDataSource>(() => _i3.AuthLocalDataSource());
    await gh.singletonAsync<_i4.Box<_i5.UserModel>>(
      () => hiveModule.userBox,
      preResolve: true,
    );
    gh.singleton<_i6.FirebaseAuth>(firebaseModule.firebaseAuth);
    gh.singleton<_i7.FirebaseFirestore>(firebaseModule.firestore);
    await gh.singletonAsync<_i8.FirebaseMessaging>(
      () => firebaseModule.firebaseMessaging,
      preResolve: true,
    );
    gh.lazySingleton<_i9.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.singleton<_i10.Intercom>(messengerModule.intercom);
    await gh.singletonAsync<_i11.SharedPreferences>(
      () => secureStorageModule.sharedPrefs,
      preResolve: true,
    );
    gh.singleton<_i12.BasePersistentStorage>(
        _i13.SharedPrefsPersistentStorage(gh<_i11.SharedPreferences>()));
    gh.singleton<_i14.UserLocalDataSource>(_i14.UserLocalDataSource(
      gh<_i4.Box<_i5.UserModel>>(),
      gh<_i12.BasePersistentStorage>(),
    ));
    gh.singleton<_i15.UserRemoteDataSource>(_i15.UserRemoteDataSource(
      gh<_i7.FirebaseFirestore>(),
      gh<_i12.BasePersistentStorage>(),
      gh<_i6.FirebaseAuth>(),
    ));
    gh.lazySingleton<_i16.AuthRemoteDataSource>(() => _i16.AuthRemoteDataSource(
          gh<_i7.FirebaseFirestore>(),
          gh<_i6.FirebaseAuth>(),
          gh<_i9.GoogleSignIn>(),
          gh<_i12.BasePersistentStorage>(),
          gh<_i10.Intercom>(),
        ));
    gh.singleton<_i17.BaseAuthRepository>(_i18.FirebaseAuthRepository(
      gh<_i16.AuthRemoteDataSource>(),
      gh<_i3.AuthLocalDataSource>(),
    ));
    gh.singleton<_i19.BaseUserRepository>(_i20.UserRepository(
      gh<_i14.UserLocalDataSource>(),
      gh<_i15.UserRemoteDataSource>(),
      gh<_i12.BasePersistentStorage>(),
    ));
    gh.factory<_i21.UserCubit>(
        () => _i21.UserCubit(gh<_i19.BaseUserRepository>()));
    gh.factory<_i22.AuthCubit>(
        () => _i22.AuthCubit(gh<_i17.BaseAuthRepository>()));
    return this;
  }
}

class _$HiveModule extends _i23.HiveModule {}

class _$FirebaseModule extends _i23.FirebaseModule {}

class _$MessengerModule extends _i23.MessengerModule {}

class _$SecureStorageModule extends _i23.SecureStorageModule {}
