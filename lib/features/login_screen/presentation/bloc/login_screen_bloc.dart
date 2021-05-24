import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/usecase/get_user_login_info.dart';

part 'login_screen_event.dart';

part 'login_screen_state.dart';

const String SERVER_FAILURE_MESSAGE = 'User login unsuccessful';
const String SERVER_FAILURE_USER_MESSAGE = 'Email or password is wrong. Try again';
const String CACHE_FAILURE_MESSAGE = 'Data Missing';
const String CACHE_FAILURE_USER_MESSAGE = 'Data Missing';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final GetUserLoginInfo getUserLogin;

  ///to check null values are not passed to the constructor not necessary
  LoginScreenBloc({@required GetUserLoginInfo loginInfo})
      : assert(loginInfo != null),
        getUserLogin = loginInfo;

  @override
  LoginScreenState get initialState => Empty();

  @override
  Stream<LoginScreenState> mapEventToState(
    LoginScreenEvent event,
  ) async* {
    if (event is GetUserLogin) {
      yield Loading();
      final failureOrLogin = await getUserLogin.call(
          Params(email: event.emailString, password: event.passwordString));
      yield failureOrLogin.fold(
          (failure) => Error(
              message: _mapFailureToMessage(failure),
              userMsg: _mapFailureToUserMessage(failure)),
          (login) => Loaded(loginEntity: login));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }

  String _mapFailureToUserMessage(Failure failure) {
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_USER_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_USER_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
