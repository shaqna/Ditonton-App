import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTv _searchTv;
  SearchTvBloc(this._searchTv) : super(SearchTvEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      emit(SearchTvLoading());
      
      final results = await _searchTv.execute(event.query);
      
      results.fold(
          (failure) {
            emit(SearchTvError(failure.message));
          },
          (list) {
            emit(SearchTvHasData(list));
          }
      );
    });
  }
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
