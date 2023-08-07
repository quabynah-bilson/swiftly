import 'package:hive_flutter/adapters.dart';
import 'package:mobile/features/common/data/models/user.dart';

final class UserAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) =>
      UserModel.fromJson(reader.readMap());

  @override
  void write(BinaryWriter writer, UserModel obj) =>
      writer.writeMap(obj.toJson());
}
