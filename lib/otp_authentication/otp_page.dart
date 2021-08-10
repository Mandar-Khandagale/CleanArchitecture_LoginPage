import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/custom_ui/home_page.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key key}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listOTP();
  }

  void _listOTP() async{
    await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP Send on your Number',
            style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
              child: PinFieldAutoFill(
                codeLength: 4,
                onCodeSubmitted: (code){},
                onCodeChanged: (code) {
                  if(code.length == 4){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeScreenPage(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
