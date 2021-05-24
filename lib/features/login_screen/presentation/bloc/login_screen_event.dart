part of 'login_screen_bloc.dart';

@immutable
abstract class LoginScreenEvent extends Equatable {
  LoginScreenEvent([List props = const <dynamic>[]]) : super(props);
}

class GetUserLogin extends LoginScreenEvent {
  final String emailString;
  final String passwordString;

  GetUserLogin(this.emailString, this.passwordString) : super([emailString,passwordString]);
}

