part of 'watchlist_tv_status_bloc.dart';

abstract class WatchlistTvStatusState extends Equatable {
  const WatchlistTvStatusState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WatchlistTvStatusEmpty extends WatchlistTvStatusState{}

class WatchlistTvStatusLoading extends WatchlistTvStatusState{}

class WatchlistTvStatusError extends WatchlistTvStatusState{
  final String message;
  const WatchlistTvStatusError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvStatusHasData extends WatchlistTvStatusState{
  bool isAdded;
  String message;
  WatchlistTvStatusHasData(this.isAdded, this.message);

  @override
  List<Object> get props => [isAdded, message];
}
