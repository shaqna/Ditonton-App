part of 'now_playing_tv_bloc.dart';

abstract class NowPlayingTvEvent extends Equatable {
  const NowPlayingTvEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnFetchOnTheAirTv extends NowPlayingTvEvent {}


