import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure, Type>> call(Params params);

}