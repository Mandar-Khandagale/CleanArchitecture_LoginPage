import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/repositories/login_screen_repo.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/usecase/get_user_login_info.dart';

class MockLoginScreenRepo extends Mock implements LoginScreenRepo {}

void main() {

  GetUserLoginInfo usecase;
  MockLoginScreenRepo mockLoginScreenRepo;

  setUp(() {
    mockLoginScreenRepo = MockLoginScreenRepo();
    usecase = GetUserLoginInfo(mockLoginScreenRepo);
  });

  final tEmail = 'test@123';
  final tPassword = '123456';
  final tLoginEntity = LoginEntity(status: 200, message: 'Logged in', userMsg: 'Successfully Login',data: null);
  test(
      'should get a response for the user from the repository',
      () async{
        when(mockLoginScreenRepo.getUserLogin(any, any))
            .thenAnswer((_) async=> Right(tLoginEntity));

        final result = await usecase(Params(email: tEmail,  password: tPassword)) ;

        expect(result, Right(tLoginEntity));
        verify(mockLoginScreenRepo.getUserLogin(tEmail,tPassword));
        verifyNoMoreInteractions(mockLoginScreenRepo);
      });

}