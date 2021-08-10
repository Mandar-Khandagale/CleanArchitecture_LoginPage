import 'dart:math';

import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class UPIPaymentsPage extends StatefulWidget {
  const UPIPaymentsPage({Key key}) : super(key: key);

  @override
  _UPIPaymentsPageState createState() => _UPIPaymentsPageState();
}

class _UPIPaymentsPageState extends State<UPIPaymentsPage> {
  String _upiAddOrError;
  TextEditingController _upiAddressController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  Future<List<ApplicationMeta>> _appsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _appsFuture = UpiPay.getInstalledUpiApplications();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _upiAddressController.dispose();
    _amountController.dispose();
  }

  Future<void> _openUPIGateway(ApplicationMeta app) async {
    final error = _validateUpiAddress(_upiAddressController.text);
    if (error != null) {
      setState(() {
        _upiAddOrError = error;
      });
      return;
    }
    setState(() {
      _upiAddOrError = null;
    });

    final transactionRef = Random.secure().nextInt(1<<32);
    print("Starting transaction with id $transactionRef");

    final initiate = await UpiPay.initiateTransaction(
      app: app.upiApplication,
      receiverUpiAddress: _upiAddressController.text,
      receiverName: 'Mandar',
      transactionRef: transactionRef.toString(),
      amount: _amountController.text,
      merchantCode: '7372',
    );

    print('MAndar:- $initiate');
  }

  String _validateUpiAddress(String text) {
    if (text.isEmpty) {
      return 'UPI Address is Required';
    }
    if (!UpiPay.checkIfUpiAddressIsValid(text)) {
      return 'UPI Address is Invalid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI Payment'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _upiAddressController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'address@upi',
                      labelText: 'Receiver UPI Address'),
                ),
              ),
              if (_upiAddOrError != null)
                Container(
                  margin: EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _upiAddOrError,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Amount'),
                ),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Pay Using'),
                    ),
                    FutureBuilder<List<ApplicationMeta>>(
                      future: _appsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container();
                        }
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.6,
                          physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data
                              .map(
                                (e) => Material(
                                  key: ObjectKey(e.upiApplication),
                                  color: Colors.grey[300],
                                  child: InkWell(
                                    onTap: () => _openUPIGateway(e),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.memory(
                                          e.icon,
                                          width: 60,
                                          height: 60,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 4),
                                          child: Text(
                                            e.upiApplication.getAppName(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
