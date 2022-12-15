import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/presentation/provider/bloc/movie/now_playing/now_playing_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';



@GenerateMocks([GetNowPlayingMovies])
void main(){
  late NowPlayingMovieBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp((){
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMovieBloc(
        mockGetNowPlayingMovies
    );
  });

  test('initial state should be empty', (){
    expect(nowPlayingMoviesBloc.state, NowPlayingMovieEmpty());
  });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlayingMovie()),
      expect: () => [
        NowPlayingMovieLoading(),
        NowPlayingMovieHasData(testMovieList)
      ],
      verify: (bloc) => verify(mockGetNowPlayingMovies.execute())
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(OnFetchNowPlayingMovie()),
      expect: () => [
        NowPlayingMovieLoading(),
        NowPlayingMovieError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetNowPlayingMovies.execute())
  );
}