import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/core/platform/network_info.dart';
import 'package:travel/features/destination/data/datasource/destination_local_data_source.dart';
import 'package:travel/features/destination/data/datasource/destination_remote_data_source.dart';
import 'package:travel/features/destination/data/repositories/destination_repository_data.dart';
import 'package:travel/features/destination/domain/repositories/destination_repository.dart';
import 'package:travel/features/destination/domain/usecases/get_all_destination_usecase.dart';
import 'package:travel/features/destination/domain/usecases/get_top_destination_usecase.dart';
import 'package:travel/features/destination/domain/usecases/search_destination_usecase.dart';
import 'package:travel/features/destination/presentation/bloc/all_destination/all_destination_bloc.dart';
import 'package:travel/features/destination/presentation/bloc/search_destination/search_destination_bloc.dart';
import 'package:travel/features/destination/presentation/bloc/top_destination/top_destination_bloc.dart';
import 'package:http/http.dart' as http;

// instance semua
final locator = GetIt.instance;

Future<void> initLocator() async {
  // bloc
  // registerFactory buat state management
  locator.registerFactory(() => AllDestinationBloc(locator()));
  locator.registerFactory(() => SearchDestinationBloc(locator()));
  locator.registerFactory(() => TopDestinationBloc(locator()));

  // usecase
  // registerLazySingleton = ketika Instance akan digunakan
  locator.registerLazySingleton(() => GetAllDestinationUseCase(locator()));
  locator.registerLazySingleton(() => GetTopDestinationUseCase(locator()));
  locator.registerLazySingleton(() => SearchDestinationUseCase(locator()));

  // repository
  locator.registerLazySingleton<DestinationRepository>(
    () => DestinationRepositoryData(
      networkInfo: locator(),
      localDataSource: locator(),
      remoteDataSource: locator(),
    ),
  );

  // datasource
  locator.registerLazySingleton<DestinationLocalDataSource>(
      () => DestinationLocalDataSourceImplementation(locator()));
  locator.registerLazySingleton<DestinationRemoteDataSource>(
      () => DestinationRemoteDataSourceImplementation(locator()));

  // platform
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(connectivity: locator()));

  // external
  final pref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => pref);
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());
}
