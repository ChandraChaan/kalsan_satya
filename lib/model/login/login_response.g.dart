// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      status: json['status'] as int?,
      user_information: json['user_information'] == null
          ? null
          : UserInformation.fromJson(
              json['user_information'] as Map<String, dynamic>),
      message: json['message'] as String?,
      Profile: json['Profile'] == null
          ? null
          : UserInformation.fromJson(json['Profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'user_information': instance.user_information,
      'Profile': instance.Profile,
      'message': instance.message,
    };

UserInformation _$UserInformationFromJson(Map<String, dynamic> json) =>
    UserInformation(
      json['user_id'] as String?,
      json['user_name'] as String?,
      json['first_name'] as String?,
      json['email'] as String?,
      json['password'] as String?,
      json['mobile_no'] as String?,
      json['user_image'] as String?,
      json['auth_level'] as String?,
      json['login_status'] as String?,
      json['role'] as String?,
      json['register_date'] as String?,
      json['address'] as String?,
      json['city'] as String?,
    );

Map<String, dynamic> _$UserInformationToJson(UserInformation instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'first_name': instance.firstName,
      'email': instance.email,
      'password': instance.password,
      'mobile_no': instance.mobileNo,
      'user_image': instance.userImage,
      'auth_level': instance.authLevel,
      'login_status': instance.loginStatus,
      'role': instance.role,
      'register_date': instance.registerDate,
      'address': instance.address,
      'city': instance.city,
    };
