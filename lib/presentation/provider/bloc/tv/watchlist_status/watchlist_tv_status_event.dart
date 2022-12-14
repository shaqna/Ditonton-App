part of 'watchlist_tv_status_bloc.dart';

abstract class WatchlistTvStatusEvent extends Equatable {
  const WatchlistTvStatusEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchWatchlistStatus extends WatchlistTvStatusEvent{
  final int id;
  const OnFetchWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddedToWatchlist extends WatchlistTvStatusEvent{
  final TvDetail tv;
  const OnAddedToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class OnRemoveFromWatchList extends WatchlistTvStatusEvent{
  final TvDetail tv;
  const OnRemoveFromWatchList(this.tv);

  @override
  List<Object> get props => [tv];
}
