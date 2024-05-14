import 'package:contacts/features/contacts/domain/entities/user.dart';

class UserModel extends UserEntity {

  const UserModel({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    phoneNumber: phoneNumber,
    profileImageUrl: profileImageUrl,
  );

  factory UserModel.fromJson(Map<String,dynamic> json) => UserModel(
    id: json["id"] ?? "",
    firstName: json["firstName"] ?? "",
    lastName: json["lastName"] ?? "",
    phoneNumber: json["phoneNumber"] ?? "",
    profileImageUrl: json["profileImageUrl"] ?? "",
  );

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        phoneNumber: entity.phoneNumber,
        profileImageUrl: entity.profileImageUrl,
    );
  }
}