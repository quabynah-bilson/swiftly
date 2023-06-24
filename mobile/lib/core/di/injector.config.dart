// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:firebase_messaging/firebase_messaging.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:mobile/core/di/modules.dart' as _i11;
import 'package:mobile/features/auth/data/repositories/auth.dart' as _i10;
import 'package:mobile/features/auth/domain/repositories/auth.dart' as _i9;
import 'package:mobile/features/common/data/repositories/persistent.storage.dart'
    as _i8;
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart'
    as _i7;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

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
    final firebaseModule = _$FirebaseModule();
    final secureStorageModule = _$SecureStorageModule();
    gh.singleton<_i3.FirebaseAuth>(firebaseModule.firebaseAuth);
    await gh.singletonAsync<_i4.FirebaseMessaging>(
      () => firebaseModule.firebaseMessaging,
      preResolve: true,
    );
    gh.lazySingleton<_i5.GoogleSignIn>(() => firebaseModule.googleSignIn);
    await gh.singletonAsync<_i6.SharedPreferences>(
      () => secureStorageModule.sharedPrefs,
      preResolve: true,
    );
    gh.singleton<_i7.BasePersistentStorage>(
        _i8.SharedPrefsPersistentStorage(gh<_i6.SharedPreferences>()));
    gh.singleton<_i9.BaseAuthRepository>(_i10.FirebaseAuthRepository(
      gh<_i3.FirebaseAuth>(),
      gh<_i5.GoogleSignIn>(),
      gh<_i7.BasePersistentStorage>(),
    ));
    return this;
  }
}

class _$SecureStorageModule extends _i11.SecureStorageModule {}

class _$FirebaseModule extends _i11.FirebaseModule {}
