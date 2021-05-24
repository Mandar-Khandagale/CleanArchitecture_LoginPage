import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/bloc/login_screen_bloc.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/page/home_page.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/widget/button_controls.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/widget/loading_screen.dart';
import '../../../../injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocProvider(
      create: (_) => sl<LoginScreenBloc>(),
      child: BlocListener<LoginScreenBloc, LoginScreenState>(
        listener: (context, state) {
          if (state is Error) {
            Fluttertoast.showToast(
                msg: state.userMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Colors.red
            );
          } else if (state is Loaded) {
            Fluttertoast.showToast(
                msg: state.loginEntity.userMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Colors.red
            );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage(loginData: state.loginEntity,)));
          }
        },
        child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
          builder: (context, state) {
            if(state is Empty){
              return buildUI();
            } else if(state is Loading){
              return LoadingScreen();
            }else{
              return buildUI();
            }
          },
        ),
      ),
    );
  }

  Widget buildUI() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           SizedBox(
             height: 20.0,
           ),
          ButtonControls(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Don't Have An Account ?",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Container(
                color: Colors.red[800],
                height: 46.0,
                width: 46.0,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
