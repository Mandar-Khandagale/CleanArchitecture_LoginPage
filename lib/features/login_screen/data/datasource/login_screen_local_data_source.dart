import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/core/errors/exception.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginScreenLocalDataSource {
  Future<LoginScreenModel> getSharedPreferenceData();

  Future<void> cacheLoginResponseData(LoginScreenModel responseToCache);
}

const LOGIN_DATA_RESPONSE = 'LOGIN_DATA_RESPONSE';

class LoginScreenLocalDataSourceImpl implements LoginScreenLocalDataSource {
  final SharedPreferences sharedPreferences;

  LoginScreenLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheLoginResponseData(LoginScreenModel responseToCache) {
   return sharedPreferences.setString(
        LOGIN_DATA_RESPONSE,
        json.encode(responseToCache.toJson(),
        ));
  }

  @override
  Future<LoginScreenModel> getSharedPreferenceData() {
    final jsonString = sharedPreferences.getString(LOGIN_DATA_RESPONSE);
    if (jsonString != null) {
      return Future.value(LoginScreenModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
