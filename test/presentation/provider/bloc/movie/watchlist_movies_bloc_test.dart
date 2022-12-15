import 'package:bloc_test/bloc_test.dart';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/presentation/provider/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';



@GenerateMocks([GetWatchlistMovies])
void main(){
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp((){
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(
      mockGetWatchlistMovies
    );
  });

  test('initial state should be empty', (){
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData(testMovieList)
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute())
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute())
  );
}