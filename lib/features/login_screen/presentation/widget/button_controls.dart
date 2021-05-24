import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neostore_clean_arch/constants.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/bloc/login_screen_bloc.dart';

class ButtonControls extends StatefulWidget {
  const ButtonControls({Key key}) : super(key: key);

  @override
  _ButtonControlsState createState() => _ButtonControlsState();
}

class _ButtonControlsState extends State<ButtonControls> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: email,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            decoration: textInputDecoration.copyWith(
              hintText: 'Email Address',
              prefixIcon: Icon(Icons.email,color: Colors.white,),
            ),
            validator: emailValidation,
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: password,
            style: TextStyle(color: Colors.white),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Colors.white,
            decoration: textInputDecoration.copyWith(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock,color: Colors.white,),
            ),
            validator: passwordValidation,
          ),
          SizedBox(height: 20.0,),
          FlatButton(
              onPressed: () {
                if(key.currentState.validate())
                  {
                    final emailString = email.text;
                    final passwordString = password.text;
                    email.clear();
                    password.clear();
                    BlocProvider.of<LoginScreenBloc>(context)
                    .add(GetUserLogin(emailString, passwordString));
                  }
              },
              child: Text('Login',style: TextStyle(color: Colors.red),),
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  String emailValidation(String value) {
    if (value.isEmpty) {
      return 'Required';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String passwordValidation(String value) {
    if (value.isEmpty) {
      return 'Please Enter Password';
    } else {
      return null;
    }
  }

}
