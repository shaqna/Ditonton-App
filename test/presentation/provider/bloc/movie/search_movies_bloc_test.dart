
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/provider/bloc/movie/search/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main(){
  late SearchBloc searchMovieBloc;
  late MockSearchMovies mockSearchMovies;

  setUp((){
    mockSearchMovies = MockSearchMovies();
    searchMovieBloc = SearchBloc(
      mockSearchMovies
    );
  });

  test('initial state should be empty', (){
    expect(searchMovieBloc.state, SearchEmpty());
  });

  const query = 'abc';
  blocTest<SearchBloc, SearchState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockSearchMovies.execute(query))
            .thenAnswer((_) async => Right(testMovieList));
        return searchMovieBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(query)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchHasData(testMovieList)
      ],
      verify: (bloc) => verify(mockSearchMovies.execute(query))
  );

  blocTest<SearchBloc, SearchState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockSearchMovies.execute(query))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchMovieBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(query)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchLoading(),
        SearchError('Server Failure')
      ],
      verify: (bloc) => verify(mockSearchMovies.execute(query))
  );
}