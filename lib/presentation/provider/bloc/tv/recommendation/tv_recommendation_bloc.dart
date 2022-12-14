import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_recomendations_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_recommendation_event.dart';
part 'tv_recommendation_state.dart';

class TvRecommendationBloc extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetRecommendationsTv _getRecommendationsTv;

  TvRecommendationBloc(this._getRecommendationsTv) : super(TvRecommendationEmpty()) {
    on<OnFetchTvRecommendation>((event, emit) async {
      emit(TvRecommendationLoading());

      final results = await _getRecommendationsTv.execute(event.id);

      results.fold(
          (failure){
            emit(TvRecommendationError(failure.message));
          },
          (list) {
            emit(TvRecommendationHasData(list));
          }
      );
    });
  }
}
