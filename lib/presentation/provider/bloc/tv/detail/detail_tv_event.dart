part of 'detail_tv_bloc.dart';

abstract class DetailTvEvent extends Equatable {
  const DetailTvEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnFetchDetailTv extends DetailTvEvent {
  final int id;

  OnFetchDetailTv(this.id);

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
