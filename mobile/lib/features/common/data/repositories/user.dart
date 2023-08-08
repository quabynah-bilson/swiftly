import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/common/data/data_sources/local/local.dart';
import 'package:mobile/features/common/data/data_sources/remote/remote.dart';
import 'package:mobile/features/common/data/models/user.mapper.dart';
import 'package:mobile/features/common/domain/entities/user.dart';
import 'package:mobile/features/common/domain/repositories/persistent.storage.dart';
import 'package:mobile/features/common/domain/repositories/user.dart';
import 'package:shared_utils/shared_utils.dart';

@Singleton(as: BaseUserRepository)
final class UserRepository implements BaseUserRepository {
  final UserLocalDataSource _local;
  final UserRemoteDataSource _remote;
  final BasePersistentStorage _persistentStorage;

  const UserRepository(this._local, this._remote, this._persistentStorage);

  @override
  Future<Either<void, String>> createUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String creditCardNumber,
    required String creditCardExpiryDate,
    required String creditCardCvv,
    required String zipCode,
    required String password,
    String? photoUrl,
  }) async {
    var uid = await _persistentStorage.getUserId();
    if (uid.isNullOrEmpty()) return right('errors.user_not_found');

    // validate zip code
    if (zipCode.length != 5) return right(tr('errors.invalid_zip_code'));

    // validate credit card expiry date
    var (month, year) = _splitCreditCardExpiryDate(creditCardExpiryDate);
    var now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return right(tr('errors.invalid_credit_card_expiry_date'));
    }

    // validate phone number
    if (_validatePhoneNumber(phoneNumber)) {
      return right(tr('errors.invalid_phone_number'));
    }

    // validate credit card number
    if (!creditCardNumber.isCreditCard) {
      return right(tr('errors.invalid_credit_card_number'));
    }

    // validate credit card cvv
    if (creditCardCvv.length != 3) {
      return right(tr('errors.invalid_credit_card_cvv'));
    }

    // @fixme -> bind user to the password

    var user = UserEntity(
      id: uid!,
      name: name,
      email: email,
      photoUrl: photoUrl ?? '',
      phoneNumber: phoneNumber,
      creditCardNumber: creditCardNumber,
      creditCardExpiryDate: creditCardExpiryDate,
      creditCardCvv: creditCardCvv,
      zipCode: zipCode,
    );
    await _remote.createUser(user.fromEntity());
    await _local.saveUser(user.fromEntity());
    return left(null);
  }

  @override
  Future<Either<Stream<UserEntity>, String>> get currentUser async {
    var localData = await _local.currentUser;
    var remoteData = await _remote.currentUser;
    remoteData.fold(
        (l) => l.listen((user) => _local.saveUser(user.fromEntity())),
        (r) => null);
    return localData;
  }

  @override
  Future<void> deleteUser(String id) async {
    await _remote.deleteUser(id);
    await _local.deleteUser(id);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    await _remote.updateUser(user.fromEntity());
    await _local.saveUser(user.fromEntity());
  }

  (int, int) _splitCreditCardExpiryDate(String creditCardExpiryDate) {
    var month = creditCardExpiryDate.split('/')[0];
    var year = creditCardExpiryDate.split('/')[1];
    return (int.parse(month), int.parse('20$year'));
  }

  bool _validatePhoneNumber(String phoneNumber) {
    var pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    var regExp = RegExp(pattern);
    return !regExp.hasMatch(phoneNumber);
  }
}
