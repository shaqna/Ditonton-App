import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:equatable/equatable.dart';

part 'detail_movie_event.dart';
part 'detail_movie_state.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail _getMovieDetail;

  DetailMovieBloc(this._getMovieDetail) : super(DetailMovieEmpty()) {
    on<OnFetchMovieDetail>((event, emit) async {
      emit(DetailMovieLoading());

      final result = await _getMovieDetail.execute(event.id);

      result.fold(
          (failure) {
            emit(DetailMovieError(failure.message));
          },
          (detailMovie) {
            emit(DetailMovieHasData(detailMovie));
          }
      );

    });
  }
}
