import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTvTopRated _getTvTopRated;
  TopRatedTvBloc(this._getTvTopRated) : super(TopRatedTvEmpty()) {
    on<OnFetchTopRatedTv>((event, emit) async {
      emit(TopRatedTvLoading());

      final results = await _getTvTopRated.execute();

      results.fold(
          (failure) {
            emit(TopRatedTvError(failure.message));
          },
          (list) {
            emit(TopRatedTvHasData(list));
          }
      );

    });
  }
}
