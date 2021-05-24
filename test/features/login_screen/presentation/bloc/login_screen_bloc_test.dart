import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/usecase/get_user_login_info.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/bloc/login_screen_bloc.dart';

class MockGetUserLoginInfo extends Mock implements GetUserLoginInfo {}

void main() {
  LoginScreenBloc bloc;
  MockGetUserLoginInfo mockGetUserLoginInfo;

  setUp(() {
    mockGetUserLoginInfo = MockGetUserLoginInfo();
    bloc = LoginScreenBloc(loginInfo: mockGetUserLoginInfo);
  });

  ///to check for initial implementation
  test('initialState should be empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetUserLoginInfo', () {
    final tEmail = 'test@123';
    final tPassword = '123456';
    final tLoginEntity = LoginEntity(
      status: 200,
      message: "User login is successful.",
      userMsg: "Logged In successfully",
      data: UserDataModel(
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

    test('should get data from the user use case', () async {
      when(mockGetUserLoginInfo(any))
          .thenAnswer((_) async => Right(tLoginEntity));

      bloc.add(GetUserLogin(tEmail, tPassword));
      await untilCalled(mockGetUserLoginInfo(any));

      verify(mockGetUserLoginInfo(Params(email: tEmail, password: tPassword)));
    });

    test('should emit [Loading, Loaded] when data is gotten successful',
        () async {
      when(mockGetUserLoginInfo(any))
          .thenAnswer((_) async => Right(tLoginEntity));

      final expected = [
        Empty(),
        Loading(),
        Loaded(loginEntity: tLoginEntity),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetUserLogin(tEmail, tPassword));
    });

    test(
        'should emit [Loading, Error] with a proper message for error when getting data fails',
        () async {
      when(mockGetUserLoginInfo(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(
            message: SERVER_FAILURE_MESSAGE,
            userMsg: SERVER_FAILURE_USER_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

      bloc.add(GetUserLogin(tEmail, tPassword));
    });

    test(
        'should emit [Loading, Error] with a proper message for error when getting data fails',
            () async {
          when(mockGetUserLoginInfo(any))
              .thenAnswer((_) async => Left(CacheFailure()));

          final expected = [
            Empty(),
            Loading(),
            Error(
                message: CACHE_FAILURE_MESSAGE,
                userMsg: CACHE_FAILURE_USER_MESSAGE),
          ];
          expectLater(bloc.asBroadcastStream(), emitsInOrder(expected));

          bloc.add(GetUserLogin(tEmail, tPassword));
        });
  });
}
