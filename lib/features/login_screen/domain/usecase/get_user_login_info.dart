import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';
import 'package:neostore_clean_arch/core/usecase/usecase.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/repositories/login_screen_repo.dart';

class GetUserLoginInfo implements UseCase<LoginEntity, Params> {
  final LoginScreenRepo repository;

  GetUserLoginInfo(this.repository);

  @override
  Future<Either<Failure, LoginEntity>> call(
    Params params
  ) async {
    return await repository.getUserLogin(params.email, params.password);
  }
}

class Params extends Equatable {
  final String email;
  final String password;

  Params({@required this.email, @required this.password})
      : super([email, password]);
}
