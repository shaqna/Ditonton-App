import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTvs;
  WatchlistTvBloc(this._getWatchlistTvs) : super(WatchlistTvEmpty()) {
    on<OnFetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());

      final results = await _getWatchlistTvs.execute();

      results.fold(
          (failure) {
            emit(WatchlistTvError(failure.message));
          },
          (list) {
            emit(WatchlistTvHasData(list));
          }
      );
    });
  }
}
