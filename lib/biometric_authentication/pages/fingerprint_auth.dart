import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/biometric_authentication/api/local_auth.dart';
import 'package:neostore_clean_arch/custom_ui/home_page.dart';
import 'package:neostore_clean_arch/otp_authentication/otp_page.dart';
import 'package:neostore_clean_arch/upi_payment_options/upi_payments.dart';
import 'package:sms_autofill/sms_autofill.dart';

class FingerPrintAuth extends StatefulWidget {
  const FingerPrintAuth({Key key}) : super(key: key);

  @override
  _FingerPrintAuthState createState() => _FingerPrintAuthState();
}

class _FingerPrintAuthState extends State<FingerPrintAuth> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/to-do-3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                  letterSpacing: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('using'),
              ),
               _authFingerPrint('FingerPrint Authentication', context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('OR'),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                onPressed: () async{
                  final appSignature = await SmsAutoFill().getAppSignature;
                  print('AppSignature:- $appSignature');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPPage()));
                },
                child: Text('Login using OTP'),
              ),
              // _authFaceID('Face Authentication', context),
            ],
          ),
        ),
      ),
    );
  }

  ///For fingerprint authentication
  Widget _authFingerPrint(String title, BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      onPressed: () async {
        final isAuthenticated = await LocalAuthApi.fingerprintAuthentication();

        if (isAuthenticated) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UPIPaymentsPage(),
            ),
          );
        } else {
          print('mandar');
        }
      },
      child: Text(title),
    );
  }

  ///For Face Authentication
  Widget _authFaceID(String title, BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      onPressed: () async {
        final isAuthenticated = await LocalAuthApi.faceAuthenticate();

        if (isAuthenticated) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UPIPaymentsPage(),
            ),
          );
        } else {
          print('mandar');
        }
      },
      child: Text(title),
    );
  }

}
