import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:travel/core/error/exceptions.dart';
import 'package:travel/core/error/failure.dart';
import 'package:travel/core/platform/network_info.dart';
import 'package:travel/features/destination/data/datasource/destination_local_data_source.dart';
import 'package:travel/features/destination/data/datasource/destination_remote_data_source.dart';
import 'package:travel/features/destination/domain/entities/destination_entity.dart';
import 'package:travel/features/destination/domain/repositories/destination_repository.dart';

class DestinationRepositoryData implements DestinationRepository {
  final NetworkInfo networkInfo;
  final DestinationLocalDataSource localDataSource;
  final DestinationRemoteDataSource remoteDataSource;

  DestinationRepositoryData({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<DestinationEntity>>> all() async {
    bool online = await networkInfo.isConnected();
    if (online) {
      try {
        final result = await remoteDataSource.all();
        await localDataSource.cacheAll(result);
        return Right(result.map((e) => e.toEntity).toList());
      } on TimeoutException {
        return const Left(TimeOutFailure('Timeout. No Response'));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message.toString()));
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      } catch (e) {
        return const Left(ServerFailure('Something went wrong'));
      }
    } else {
      try {
        final result = await localDataSource.getAll();
        return Right(result.map((e) => e.toEntity).toList());
      } on CachedException {
        return const Left(CachedFailure('Data is not present'));
      }
    }
  }

  @override
  Future<Either<Failure, List<DestinationEntity>>> search(String query) async {
    try {
      final result = await remoteDataSource.search(query);
      return Right(result.map((e) => e.toEntity).toList());
    } on TimeoutException {
      return const Left(TimeOutFailure('Timeout. No Response'));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message.toString()));
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed connect to the network'));
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<DestinationEntity>>> top() async {
    try {
      final result = await remoteDataSource.top();
      return Right(result.map((e) => e.toEntity).toList());
    } on TimeoutException {
      return const Left(TimeOutFailure('Timeout. No Response'));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message.toString()));
    } on ServerException {
      return const Left(ServerFailure('Server Error'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed connect to the network'));
    } catch (e) {
      return const Left(ServerFailure('Something went wrong'));
    }
  }
}
