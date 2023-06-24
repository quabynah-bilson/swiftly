import 'package:bloc/bloc.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/constants.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';
import 'package:mobile/features/auth/domain/repositories/auth.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:shared_utils/shared_utils.dart';

/// Authentication cubit
class AuthCubit extends Cubit<BlocState> {
  AuthCubit(this._persistentStorage, this._authRepository)
      : super(BlocState.initialState());
  final BasePersistentStorage _persistentStorage;
  final BaseAuthRepository _authRepository;

  /// get user authentication state
  Future<bool> get isAuthenticated async =>
      (await _persistentStorage.getUserId()) != null;

  /// check if user is authenticated
  Future<void> checkAuthState() async {
    emit(BlocState.loadingState());
    await Future.delayed(kDurationFakeLoading);
    var isAuthenticated = await this.isAuthenticated;
    emit(BlocState<String>.successState(
        data: isAuthenticated
            ? AppRouter.welcomeRoute
            : AppRouter.userAuthRoute));
  }

  /// sign in with apple
  Future<void> signInWithApple() async {
    emit(BlocState.loadingState());
    var either = await _authRepository.signInWithApple();
    either.fold(
      (l) => emit(BlocState<String>.successState(data: l)),
      (r) => emit(BlocState<String>.errorState(failure: r)),
    );
  }

  /// sign in with google
  Future<void> signInWithGoogle() async {
    emit(BlocState.loadingState());
    var either = await _authRepository.signInWithGoogle();
    either.fold(
      (l) => emit(BlocState<String>.successState(data: l)),
      (r) => emit(BlocState<String>.errorState(failure: r)),
    );
  }

  /// sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    emit(BlocState.loadingState());
    var stream = await _authRepository.signInWithPhoneNumber(phoneNumber);
    stream.listen((event) =>
        emit(BlocState<PhoneAuthResponse>.successState(data: event)));
  }

  Future<void> verifyOTPForPhoneNumber({
    required String verificationId,
    required String otp,
  }) async {
    emit(BlocState.loadingState());
    var either = await _authRepository.verifyPhoneNumber(
        verificationId: verificationId, otp: otp);
    either.fold(
      (l) => emit(BlocState<String>.successState(data: l)),
      (r) => emit(BlocState<String>.errorState(failure: r)),
    );
  }

  /// sign out
  Future<void> signOut() async {
    emit(BlocState.loadingState());
    await _authRepository.signOut();
    emit(BlocState<String>.successState(data: AppRouter.userAuthRoute));
  }
}
