import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/common/domain/entities/user.dart';
import 'package:mobile/features/common/domain/repositories/user.dart';
import 'package:shared_utils/shared_utils.dart';

@injectable
class UserCubit extends Cubit<BlocState> {
  final BaseUserRepository _repo;

  @factoryMethod
  UserCubit(this._repo) : super(BlocState.initialState());

  Future<void> createUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String creditCardNumber,
    required String creditCardExpiryDate,
    required String creditCardCvv,
    required String zipCode,
    String? photoUrl,
  }) async {
    emit(BlocState.loadingState());
    var result = await _repo.createUser(
      name: name,
      email: email,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      creditCardNumber: creditCardNumber,
      creditCardExpiryDate: creditCardExpiryDate,
      creditCardCvv: creditCardCvv,
      zipCode: zipCode,
    );
    result.fold(
      (l) => emit(BlocState<void>.successState(data: null)),
      (r) => emit(BlocState<String>.errorState(failure: r)),
    );
  }

  Future<void> updateUser(UserEntity user) async {
    emit(BlocState.loadingState());
    await _repo.updateUser(user);
    emit(BlocState<void>.successState(data: null));
  }

  Future<void> deleteUser(String id) async {
    emit(BlocState.loadingState());
    await _repo.deleteUser(id);
    emit(BlocState<void>.successState(data: null));
  }

  Future<void> currentUser() async {
    emit(BlocState.loadingState());
    var result = await _repo.currentUser;
    result.fold(
      (l) => emit(BlocState<Stream<UserEntity>>.successState(data: l)),
      (r) => emit(BlocState<String>.errorState(failure: r)),
    );
  }
}