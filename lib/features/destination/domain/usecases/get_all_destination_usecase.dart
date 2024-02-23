import 'package:dartz/dartz.dart';
import 'package:travel/core/error/failure.dart';
import 'package:travel/features/destination/domain/entities/destination_entity.dart';
import 'package:travel/features/destination/domain/repositories/destination_repository.dart';

class GetAllDestinationUseCase {
  final DestinationRepository _repository;

  GetAllDestinationUseCase(this._repository);

  Future<Either<Failure, List<DestinationEntity>>> call() {
    return _repository.all();
  }
}
