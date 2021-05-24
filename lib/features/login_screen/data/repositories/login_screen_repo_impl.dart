import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:neostore_clean_arch/core/errors/exception.dart';
import 'package:neostore_clean_arch/core/errors/failures.dart';
import 'package:neostore_clean_arch/core/network/network_info.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_local_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_remote_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/entities/login_entity.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/repositories/login_screen_repo.dart';

class LoginScreenRepoImpl implements LoginScreenRepo {
  final LoginScreenRemoteDataSource remoteDataSource;
  final LoginScreenLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LoginScreenRepoImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoginEntity>> getUserLogin(
      String email, String password) async{
    networkInfo.isConnected;
    if(await networkInfo.isConnected){
      try{
        final remoteData = await remoteDataSource.getUserLogin(email, password);
        localDataSource.cacheLoginResponseData(remoteData);
        return Right(remoteData);
      }on ServerException {
        return Left(ServerFailure());
      }
    }else {
      try{
        final localData = await localDataSource.getSharedPreferenceData();
        return Right(localData);
      }on CacheException {
        return Left(CacheFailure());
      }
    }


  }
}
