import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:neostore_clean_arch/core/network/network_info.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_local_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/datasource/login_screen_remote_data_source.dart';
import 'package:neostore_clean_arch/features/login_screen/data/repositories/login_screen_repo_impl.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/repositories/login_screen_repo.dart';
import 'package:neostore_clean_arch/features/login_screen/domain/usecase/get_user_login_info.dart';
import 'package:neostore_clean_arch/features/login_screen/presentation/bloc/login_screen_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  ///Features - Login Screen
  //Bloc
  sl.registerFactory(() => LoginScreenBloc(loginInfo: sl()));

  //Usecases
  sl.registerLazySingleton(() => GetUserLoginInfo(sl()));

  //Repository
  sl.registerLazySingleton<LoginScreenRepo>(() => LoginScreenRepoImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));
  //Data Source
  sl.registerLazySingleton<LoginScreenRemoteDataSource>(
      () => LoginScreenRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<LoginScreenLocalDataSource>(
      () => LoginScreenLocalDataSourceImpl(sharedPreferences: sl()));

  ///Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  ///External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
