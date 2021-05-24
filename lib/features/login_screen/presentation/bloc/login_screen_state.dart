part of 'login_screen_bloc.dart';

@immutable
abstract class LoginScreenState extends Equatable {
  LoginScreenState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends LoginScreenState {}

class Loading extends LoginScreenState {}

class Loaded extends LoginScreenState {
  final LoginEntity loginEntity;

  Loaded({@required this.loginEntity}) : super([loginEntity]);
}

class Error extends LoginScreenState {
  final String message;
  final String userMsg;

  Error({@required this.message, @required this.userMsg}) : super([message, userMsg]);
}
