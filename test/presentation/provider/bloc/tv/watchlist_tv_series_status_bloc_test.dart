import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/usecases/tv/get_watch_list_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/bloc/tv/watchlist_status/watchlist_tv_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_tv_series_status_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatusTv, RemoveWatchlistTv, SaveWatchlistTv])
void main() {
  late WatchlistTvStatusBloc watchlistTvSeriesStatusBloc;
  late MockGetWatchListStatusTv mockGetWatchListTvSeriesStatus;
  late MockSaveWatchlistTv mockSaveTvSeriesWatchlist;
  late MockRemoveWatchlistTv mockRemoveTvSeriesWatchlist;

  setUp(() {
    mockGetWatchListTvSeriesStatus = MockGetWatchListStatusTv();
    mockSaveTvSeriesWatchlist = MockSaveWatchlistTv();
    mockRemoveTvSeriesWatchlist = MockRemoveWatchlistTv();
    watchlistTvSeriesStatusBloc = WatchlistTvStatusBloc(
        mockGetWatchListTvSeriesStatus,
        mockRemoveTvSeriesWatchlist,
        mockSaveTvSeriesWatchlist);
  });

  test('initial state should be empty', () {
    expect(watchlistTvSeriesStatusBloc.state, WatchlistTvStatusEmpty());
  });

  const tId = 1;
  blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
      'should get watchlist status',
      build: () {
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistTvSeriesStatusBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistStatus(tId)),
      expect: () => [
            WatchlistTvStatusLoading(),
            WatchlistTvStatusHasData(true, 'message')
          ],
      verify: (bloc) => mockGetWatchListTvSeriesStatus.execute(tId));
}
