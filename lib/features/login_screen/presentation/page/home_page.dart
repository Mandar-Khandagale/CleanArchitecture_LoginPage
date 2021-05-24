import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';

class HomePage extends StatelessWidget {
  final LoginEntity loginData;

  const HomePage({Key key, @required this.loginData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserData data = loginData.data;
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Page'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: data.profilePic != null ?
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:NetworkImage(data.profilePic),fit: BoxFit.fill),),) :
                      Container(
                        child: Center(
                          child: Text(data.firstName != null ? data.firstName[0]+data.lastName[0] : "",
                            style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),),),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(data.firstName.toUpperCase() + ' ' + data.lastName.toUpperCase(),
                      style: TextStyle(fontSize: 23.0,),),
                    SizedBox(height: 10.0,),
                    Text(data.email,style: TextStyle(fontSize: 15.0,),),
                  ],
                ),
              ),
            ),
            Divider(thickness: 1.0,),
            ListTile(
              title: Text('Phone No:- '+data.phoneNo),
            ),
            Divider(thickness: 1.0,),
            ListTile(
              title: Text('Gender:- '+data.gender),
            ),
            Divider(thickness: 1.0,),
            ListTile(
              title: Text('Token:- '+data.accessToken),
            ),
            Divider(thickness: 1.0,),
          ],
        ),
      ),
    );
  }
}
