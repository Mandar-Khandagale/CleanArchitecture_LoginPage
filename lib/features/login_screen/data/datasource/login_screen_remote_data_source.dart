import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/core/errors/exception.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:http/http.dart' as http;

abstract class LoginScreenRemoteDataSource {
  Future<LoginScreenModel> getUserLogin(String email, String password);
}

class LoginScreenRemoteDataSourceImpl implements LoginScreenRemoteDataSource {
  final http.Client client;

  LoginScreenRemoteDataSourceImpl({@required this.client});

  @override
  Future<LoginScreenModel> getUserLogin(String email, String password) async{
    final response = await client.post('http://staging.php-dev.in:8844/trainingapp/api/users/login',
        body: {"email": email, "password": password});
    if(response.statusCode == 200){
      return LoginScreenModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
