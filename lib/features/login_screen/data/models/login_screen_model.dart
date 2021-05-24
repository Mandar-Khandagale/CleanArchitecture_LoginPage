import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';

class LoginScreenModel extends LoginEntity {
  int status;
  UserDataModel userDataModel;
  String message;
  String userMsg;
  LoginScreenModel({
    @required this.status,
    @required this.userDataModel,
    @required this.message,
    @required this.userMsg,
  }) : super(status: status, data: userDataModel, message: message, userMsg: userMsg);

  factory LoginScreenModel.fromJson(Map<String, dynamic> json) {
    return LoginScreenModel(
      status: json['status'],
      userDataModel: json['data'] != null
          ? new UserDataModel.fromJson(json['data'])
          : null,
      message: json['message'],
      userMsg: json['user_msg'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userDataModel != null) {
      data['data'] = this.userDataModel.toJson();
    }
    data['message'] = this.message;
    data['user_msg'] = this.userMsg;
    return data;
  }
}

class UserDataModel extends UserData {
   String firstName;
   String lastName;
   String email;
   String profilePic;
   String gender;
   String phoneNo;
   String dob;
   String accessToken;

  UserDataModel({
     this.firstName,
     this.lastName,
     this.email,
     this.profilePic,
     this.gender,
     this.phoneNo,
     this.dob,
     this.accessToken,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      profilePic: json['profile_pic'],
      gender: json['gender'],
      phoneNo: json['phone_no'],
      dob: json['dob'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['gender'] = this.gender;
    data['phone_no'] = this.phoneNo;
    data['dob'] = this.dob;
    data['access_token'] = this.accessToken;
    return data;
  }
}
