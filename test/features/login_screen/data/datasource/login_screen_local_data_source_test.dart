import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neostore_clean_arch/core/errors/exception.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_local_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LoginScreenLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LoginScreenLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getSharedPreferenceData', () {
    final tLoginScreenModel = LoginScreenModel.fromJson(
        json.decode(fixture('login_response_data.json')));

    test(
        'should return LoginEntity from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('login_response_data.json'));

      final result = await dataSource.getSharedPreferenceData();

      verify(mockSharedPreferences.getString(LOGIN_DATA_RESPONSE));
      expect(result, equals(tLoginScreenModel));
    });

    test('should throw a CacheException when there is not a cached value ',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getSharedPreferenceData;

      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheLoginResponseData', () {
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

    test('should call SharedPreferences to cache the data', () async {
      dataSource.cacheLoginResponseData(tLoginScreenModel);

      final expectedJson = json.encode(tLoginScreenModel.toJson());
      verify(mockSharedPreferences.setString(
        LOGIN_DATA_RESPONSE,
        expectedJson,
      ));
    });
  });
}
