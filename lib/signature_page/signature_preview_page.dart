import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({Key key, @required this.signature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: CloseButton(),
        title: Text('Store Signature'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              storeSignature(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Image.memory(
          signature,
          width: double.infinity,
        ),
      ),
    );
  }

  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now();
    final name = 'signature_$time.png';

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      Navigator.pop(context);

      Fluttertoast.showToast(
          msg: 'Saved to Gallery',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.red);
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to save Signature',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Colors.red);
    }
  }
}
