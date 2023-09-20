
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';


@JsonSerializable()
class LoginResponse {
  final int? status;
  final UserInformation? user_information;
  final UserInformation? Profile;
  final String? message;

  LoginResponse({this.status,this.user_information,this.message,this.Profile});
  factory LoginResponse.fromJson(Map<String,dynamic> json) => _$LoginResponseFromJson(json);
}
@JsonSerializable(fieldRename: FieldRename.snake)
class UserInformation {
 String?  userId;
 String?  userName;
 String? firstName;
 String? email;
 String? password ;
 String? mobileNo ;
 String? userImage;
 String? authLevel ;
 String? loginStatus ;
 String? role ;
 String? registerDate ;
 String? address;
 String? city;
 UserInformation(
      this.userId,
      this.userName,
      this.firstName,
      this.email,
      this.password,
      this.mobileNo,
      this.userImage,
      this.authLevel,
      this.loginStatus,
      this.role,
      this.registerDate,
      this.address,
      this.city);



  factory UserInformation.fromJson(Map<String,dynamic> json) => _$UserInformationFromJson(json);
  Map<String,dynamic> toJson()=> _$UserInformationToJson(this);


}