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
    required String password,
    String? creditCardNumber,
    String? creditCardExpiryDate,
    String? creditCardCvv,
    String? zipCode,
    String? photoUrl,
  }) async {
    try {
      var uid = await _persistentStorage.getUserId();
      if (uid.isNullOrEmpty()) return right('errors.user_not_found');

      // validate zip code
      if (!zipCode.isNullOrEmpty() && zipCode!.length != 5) {
        return right(tr('errors.invalid_zip_code'));
      }

      // validate credit card expiry date
      // if (!creditCardExpiryDate.isNullOrEmpty()) {
      //   var (month, year) = _splitCreditCardExpiryDate(creditCardExpiryDate!);
      //   var now = DateTime.now();
      //   if (year < now.year || (year == now.year && month < now.month)) {
      //     return right(tr('errors.invalid_credit_card_expiry_date'));
      //   }
      // }

      // validate phone number
      if (!_validatePhoneNumber(phoneNumber)) {
        return right(tr('errors.invalid_phone_number'));
      }

      // validate credit card number
      // if (!creditCardNumber!.isCreditCard) {
      //   return right(tr('errors.invalid_credit_card_number'));
      // }

      // validate credit card cvv
      // if (!creditCardCvv.isNullOrEmpty() && creditCardCvv!.length != 3) {
      //   return right(tr('errors.invalid_credit_card_cvv'));
      // }

      // @fixme -> bind user to the password

      var user = UserEntity(
        id: uid!,
        name: name,
        email: email,
        photoUrl: photoUrl ?? '',
        phoneNumber: phoneNumber,
        // creditCardNumber: creditCardNumber,
        // creditCardExpiryDate: creditCardExpiryDate ??= '',
        // creditCardCvv: creditCardCvv ??= '',
        // zipCode: zipCode ??= '',
      );
      await _remote.createUser(user.fromEntity());
      await _local.saveUser(user.fromEntity());
      return left(null);
    } catch (e) {
      logger.e(e);
      return right(tr('errors.something_went_wrong'));
    }
  }

  @override
  Future<Either<String, Stream<UserEntity>>> get currentUser async {
    var localData = await _local.currentUser;
    var remoteData = await _remote.currentUser;
    remoteData.fold(
      (_) => null,
      (r) => r.listen((user) => _local.saveUser(user.fromEntity())),
    );
    // return kReleaseMode
    //     ? localData
    //     : right(
    //         Stream.value(
    //           UserEntity(
    //             id: (await _persistentStorage.getUserId())!,
    //             name: 'John Doe',
    //             email: 'john@swiftly.com',
    //             photoUrl:
    //                 'https://images.unsplash.com/photo-1531384441138-2736e62e0919?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGhhbmRzb21lJTIwYmxhY2slMjBtYW58ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=40',
    //             phoneNumber: '+44 2342 567690',
    //             creditCardNumber: '1234 5678 9012 3456',
    //           ),
    //         ),
    //       );
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
    var pattern = r'^(\+?\d{1,3})? ?(\d{2,3}){1,3} ?\d{4,5}$';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber.replaceAll(' ', ''));
  }
}
