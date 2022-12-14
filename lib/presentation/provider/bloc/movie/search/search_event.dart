part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnQueryChanged extends SearchEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  // TODO: implement props
  List<Object> get props => [query];
}
