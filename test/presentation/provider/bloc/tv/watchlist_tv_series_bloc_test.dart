import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main(){
  late WatchlistTvBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTv mockGetWatchlistTvSeries;

  setUp((){
    mockGetWatchlistTvSeries = MockGetWatchlistTv();
    watchlistTvSeriesBloc = WatchlistTvBloc(
      mockGetWatchlistTvSeries
    );
  });

  test('initial state should be empty', (){
    expect(watchlistTvSeriesBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(testTvList));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData(testTvList)
      ],
      verify: (bloc) => verify(mockGetWatchlistTvSeries.execute())
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnFetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetWatchlistTvSeries.execute())
  );
}