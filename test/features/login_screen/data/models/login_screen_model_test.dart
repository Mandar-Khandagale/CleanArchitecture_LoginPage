import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tLoginScreenModel = LoginScreenModel(
    status: 200,
    message: "User login is successful.",
    userMsg: "Logged In successfully",
    userDataModel: UserDataModel(
        firstName: "Mandar",
        lastName: "Khandagale",
        email: "mandarkhandagale08@gmail.com",
        profilePic:
            "http://staging.php-dev.in:8844/trainingapp/uploads/prof_img/thumb/medium/605d8a714230a.jpg",
        gender: "M",
        phoneNo: "8692933498",
        dob: "08-10-1998",
        accessToken: "6034f93060f34"),
  );

  test(
    'should be a subclass of LoginEntity entity',
    () async {
      expect(tLoginScreenModel, isA<LoginEntity>());
    },
  );

  group('fromJson', () {
    test('should return a valid model', () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('login.json'));
      //act
      final result = LoginScreenModel.fromJson(jsonMap);
      //assert
      expect(result, tLoginScreenModel);
    });
  });

  group("toJson", () {
    test('should return a JSON map containing a proper data', () async{
      //act
      final result = tLoginScreenModel.toJson();
      //assert
      final expectedMap = {
        "status": 200,
        "data": {
          "first_name": "Mandar",
          "last_name": "Khandagale",
          "email": "mandarkhandagale08@gmail.com",
          "profile_pic": "http://staging.php-dev.in:8844/trainingapp/uploads/prof_img/thumb/medium/605d8a714230a.jpg",
          "gender": "M",
          "phone_no": "8692933498",
          "dob": "08-10-1998",
          "access_token": "6034f93060f34"
        },
        "message": "User login is successful.",
        "user_msg": "Logged In successfully"
      };
      expect(result,expectedMap);
    });
  });

}
