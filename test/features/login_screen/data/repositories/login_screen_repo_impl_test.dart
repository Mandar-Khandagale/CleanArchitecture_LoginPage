import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neostore_clean_arch/core/errors/exception.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';
import 'package:neostore_clean_arch/core/network/network_info.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_local_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_remote_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/models/login_screen_model.dart';
import 'package:neostore_clean_arch/features/login_screen/data/repositories/login_screen_repo_impl.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';

class MockRemoteDataSource extends Mock implements LoginScreenRemoteDataSource {
}

class MockLocalDataSource extends Mock implements LoginScreenLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  LoginScreenRepoImpl loginScreenRepo;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    loginScreenRepo = LoginScreenRepoImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getUserLogin', () {
    final tEmail = 'test@123';
    final tPassword = '123456';
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
    final LoginEntity tLoginEntity = tLoginScreenModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      loginScreenRepo.getUserLogin(tEmail, tPassword);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when the call to remote data is success',
          () async {
        when(mockRemoteDataSource.getUserLogin(tEmail, tPassword))
            .thenAnswer((_) async => tLoginScreenModel);

        final result = await loginScreenRepo.getUserLogin(tEmail, tPassword);

        verify(mockRemoteDataSource.getUserLogin(tEmail, tPassword));
        expect(result, equals(Right(tLoginEntity)));
      });

      test(
          'should return cache data locally when the call to remote data is success',
          () async {
        when(mockRemoteDataSource.getUserLogin(tEmail, tPassword))
            .thenAnswer((_) async => tLoginScreenModel);

        await loginScreenRepo.getUserLogin(tEmail, tPassword);

        verify(mockRemoteDataSource.getUserLogin(tEmail, tPassword));
        verify(mockLocalDataSource.cacheLoginResponseData(tLoginScreenModel));
      });

      test(
          'should return Server Failure when the call to remote data is unsuccessful',
          () async {
        when(mockRemoteDataSource.getUserLogin(tEmail, tPassword))
            .thenThrow(ServerException());

        final result = await loginScreenRepo.getUserLogin(tEmail, tPassword);

        verify(mockRemoteDataSource.getUserLogin(tEmail, tPassword));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getSharedPreferenceData())
            .thenAnswer((_) async => tLoginScreenModel);

        final result = await loginScreenRepo.getUserLogin(tEmail, tPassword);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getSharedPreferenceData());
        expect(result, equals(Right(tLoginEntity)));
      });

      test('should return Cache Failure when there is no cached data present',
              () async {
            when(mockLocalDataSource.getSharedPreferenceData())
                .thenThrow(CacheException());

            final result = await loginScreenRepo.getUserLogin(tEmail, tPassword);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getSharedPreferenceData());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}
