import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/biometric_authentication/pages/fingerprint_auth.dart';
import 'package:neostore_clean_arch/custom_ui/home_page.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/page/login_page.dart';
import 'package:neostore_clean_arch/signature_page/signature_page.dart';
import 'injection_container.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FingerPrintAuth(),
    );
  }
}
