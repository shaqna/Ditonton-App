part of 'detail_tv_bloc.dart';

abstract class DetailTvState extends Equatable {
  const DetailTvState();

  @override
  List<Object> get props => [];
}

class DetailTvEmpty extends DetailTvState {

}

class DetailTvLoading extends DetailTvState {

}

class DetailTvError extends DetailTvState {
  final String message;

  DetailTvError(this.message);

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class DetailTvHasData extends DetailTvState {
  final TvDetail tv;

  DetailTvHasData(this.tv);

  @override
  // TODO: implement props
  List<Object> get props => [tv];
}