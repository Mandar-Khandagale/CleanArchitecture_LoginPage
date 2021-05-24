import 'package:dartz/dartz.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';

abstract class LoginScreenRepo{
  Future<Either<Failure,LoginEntity>>getUserLogin(String email, String password);
}