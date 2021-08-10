import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/signature_page/signature_preview_page.dart';
import 'package:signature/signature.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({Key key}) : super(key: key);

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  SignatureController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Page'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(''),
            Signature(
              controller: controller,
              backgroundColor: Colors.white,
              height: 200,
              width: 300,
            ),
            buttons(context),
          ],
        ),
      ]),
    );
  }

  Widget buttons(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          checkButton(context),
          clearButton(),
        ],
      ),
    );
  }

  Widget checkButton(BuildContext context) {
    return IconButton(
      iconSize: 40,
      icon: Icon(
        Icons.check,
        color: Colors.green,
      ),
      onPressed: () async {
        if (controller.isNotEmpty) {
          final signature = await exportSignature();

          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignaturePreviewPage(
                    signature: signature,
                  )));

          controller.clear();
        }
      },
    );
  }

  Widget clearButton() {
    return IconButton(
      iconSize: 40,
      icon: Icon(
        Icons.clear,
        color: Colors.red,
      ),
      onPressed: () {
        controller.clear();
      },
    );
  }

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }
}
