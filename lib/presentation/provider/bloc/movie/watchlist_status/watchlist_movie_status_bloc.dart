import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_status_event.dart';

part 'watchlist_movie_status_state.dart';

class WatchlistMovieStatusBloc
    extends Bloc<WatchlistMovieStatusEvent, WatchlistMovieStatusState> {
  final GetWatchListStatus _getWatchListMovieStatus;
  final SaveWatchlist _saveMovieWatchlist;
  final RemoveWatchlist _removeMovieWatchlist;

  WatchlistMovieStatusBloc(this._saveMovieWatchlist, this._removeMovieWatchlist,
      this._getWatchListMovieStatus)
      : super(WatchlistMovieStatusEmpty()) {
    on<OnFetchWatchlistStatus>((event, emit) async {
      emit(WatchlistMovieStatusLoading());

      final isAddedToWatchlist =
          await _getWatchListMovieStatus.execute(event.id);
      emit(WatchlistMovieStatusHasData(
          isAdded: isAddedToWatchlist, message: ''));
    });

    on<OnAddedToWatchlist>((event, emit) async {
      emit(WatchlistMovieStatusLoading());

      final result = await _saveMovieWatchlist.execute(event.movie);

      await result.fold((failure) async {
        emit(WatchlistMovieStatusError(failure.message));
      }, (successMessage) async {
        final isAddedToWatchlist =
            await _getWatchListMovieStatus.execute(event.movie.id);

        emit(WatchlistMovieStatusHasData(
            isAdded: isAddedToWatchlist, message: successMessage));
      });
    });

    on<OnRemoveFromWatchList>((event, emit) async {
      emit(WatchlistMovieStatusLoading());

      final result = await _removeMovieWatchlist.execute(event.movie);

      await result.fold((failure) async {
        emit(WatchlistMovieStatusError(failure.message));
      }, (successMessage) async {
        final isAddedToWatchlist =
            await _getWatchListMovieStatus.execute(event.movie.id);
        emit(WatchlistMovieStatusHasData(
            isAdded: isAddedToWatchlist, message: successMessage));
      });
    });
  }
}
