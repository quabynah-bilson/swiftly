import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/constants.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';
import 'package:mobile/features/auth/domain/repositories/auth.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:shared_utils/shared_utils.dart';

/// Authentication cubit
@injectable
class AuthCubit extends Cubit<BlocState> {
  final BaseAuthRepository _authRepo;

  @factoryMethod
  AuthCubit(this._authRepo) : super(BlocState.initialState());

  /// check if user is authenticated
  Future<void> checkAuthState() async {
    emit(BlocState.loadingState());
    await Future.delayed(kDurationFakeLoading);
    var isAuthenticated = await sl<BasePersistentStorage>().getUserId() != null;
    emit(BlocState<String>.successState(
        data: isAuthenticated ? AppRouter.homeRoute : AppRouter.userAuthRoute));
  }

  /// sign in with apple
  Future<void> signInWithApple() async {
    emit(BlocState.loadingState());
    var either = await _authRepo.signInWithApple();
    either.fold(
      (l) => emit(BlocState<String>.errorState(failure: l)),
      (r) => emit(BlocState<AuthResult>.successState(data: r)),
    );
  }

  /// sign in with google
  Future<void> signInWithGoogle() async {
    emit(BlocState.loadingState());
    var either = await _authRepo.signInWithGoogle();
    either.fold(
      (l) => emit(BlocState<String>.errorState(failure: l)),
      (r) => emit(BlocState<AuthResult>.successState(data: r)),
    );
  }

  /// sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    emit(BlocState.loadingState());
    var stream = await _authRepo.signInWithPhoneNumber(phoneNumber);
    stream.listen((event) =>
        emit(BlocState<PhoneAuthResponse>.successState(data: event)));
  }

  Future<void> verifyOTPForPhoneNumber({
    required String verificationId,
    required String otp,
  }) async {
    emit(BlocState.loadingState());
    var either = await _authRepo.verifyPhoneNumber(
        verificationId: verificationId, otp: otp);
    either.fold(
      (l) => emit(BlocState<String>.errorState(failure: l)),
      (r) => emit(BlocState<AuthResult>.successState(data: r)),
    );
  }

  Future<void> updateUsername(String username) async {
    emit(BlocState.loadingState());
    var either = await _authRepo.updateUsername(username);
    either.fold(
      (l) => emit(BlocState<String>.successState(data: l)),
      (r) => emit(BlocState<String>.errorState(failure: r)),
    );
  }

  /// sign out
  Future<void> signOut() async {
    emit(BlocState.loadingState());
    await _authRepo.signOut();
    emit(BlocState<String>.successState(data: AppRouter.userAuthRoute));
  }
}
