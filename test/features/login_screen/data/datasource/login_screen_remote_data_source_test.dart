import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neostore_clean_arch/core/errors/exception.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_remote_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  LoginScreenRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = LoginScreenRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getUserLogin', () {
    final tEmail = 'test@123';
    final tPassword = '123456';
    final tLoginScreenModel = LoginScreenModel.fromJson(json.decode(fixture('login.json')));

    test('should perform a POST request on a URL', () async {
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('login.json'), 200));

      dataSource.getUserLogin(tEmail, tPassword);

      verify(mockHttpClient.post(
        'http://staging.php-dev.in:8844/trainingapp/api/users/login',
        body: {"email": tEmail, "password": tPassword},
      ));
    });

    test('should return LoginEntity when the response code is 200(success)', () async {
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(fixture('login.json'), 200));

      final result = await dataSource.getUserLogin(tEmail, tPassword);

     expect(result, equals(tLoginScreenModel));
    });

    test('should throw ServerException when the response code is 404 or other ', () async {
      when(mockHttpClient.post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Something Went Wrong', 404));

      final call = dataSource.getUserLogin(tEmail, tPassword);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
