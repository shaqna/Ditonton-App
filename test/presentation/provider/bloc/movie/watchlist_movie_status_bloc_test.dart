import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../lib/presentation/provider/bloc/movie/watchlist_status/watchlist_movie_status_bloc.dart';
import 'watchlist_movie_status_bloc_test.mocks.dart';


@GenerateMocks([
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist
])
void main(){
  late WatchlistMovieStatusBloc watchlistMovieStatusBloc;
  late MockGetWatchListStatus mockGetWatchListMovieStatus;
  late MockSaveWatchlist mockSaveMovieWatchlist;
  late MockRemoveWatchlist mockRemoveMovieWatchlist;

  setUp((){
    mockGetWatchListMovieStatus = MockGetWatchListStatus();
    mockSaveMovieWatchlist = MockSaveWatchlist();
    mockRemoveMovieWatchlist = MockRemoveWatchlist();
    watchlistMovieStatusBloc = WatchlistMovieStatusBloc(
      mockSaveMovieWatchlist,
      mockRemoveMovieWatchlist,
      mockGetWatchListMovieStatus
    );
  });

  test('initial state should be empty', (){
    expect(watchlistMovieStatusBloc.state, WatchlistMovieStatusEmpty());
  });

  const tId = 1;
  blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
    'should get watchlist status',
    build: (){
      when(mockGetWatchListMovieStatus.execute(tId)).thenAnswer((_) async => true);
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(const OnFetchWatchlistStatus(tId)),
    expect: () => [
      WatchlistMovieStatusLoading(),
      WatchlistMovieStatusHasData(
          isAdded: true,
          message: ''
      )
    ],
    verify: (bloc) => mockGetWatchListMovieStatus.execute(tId)
  );
}