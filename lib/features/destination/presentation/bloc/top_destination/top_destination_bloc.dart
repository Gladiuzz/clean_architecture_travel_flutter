import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:travel/features/destination/domain/entities/destination_entity.dart';
import 'package:travel/features/destination/domain/usecases/get_top_destination_usecase.dart';

part 'top_destination_event.dart';
part 'top_destination_state.dart';

class TopDestinationBloc
    extends Bloc<TopDestinationEvent, TopDestinationState> {
  final GetTopDestinationUseCase _useCase;
  TopDestinationBloc(this._useCase) : super(TopDestinationInitial()) {
    on<OnGetTopDestination>((event, emit) async {
      emit(TopDestinationLoading());
      final result = await _useCase();
      result.fold(
        (failure) => emit(TopDestinationFailure(failure.message)),
        (data) => emit(TopDestinationLoaded(data)),
      );
    });
  }
}
