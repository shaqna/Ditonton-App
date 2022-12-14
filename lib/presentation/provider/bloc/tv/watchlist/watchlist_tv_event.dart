part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchWatchlistTv extends WatchlistTvEvent {}
