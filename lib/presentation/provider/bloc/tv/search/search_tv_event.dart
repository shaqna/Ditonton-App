part of 'search_tv_bloc.dart';

abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnQueryChanged extends SearchTvEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  // TODO: implement props
  List<Object> get props => [query];
}
