import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/provider/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_top_rated.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTvTopRated])
void main(){
  late TopRatedTvBloc topRatedTvSeriesBloc;
  late MockGetTvTopRated mockGetTopRatedTvSeries;

  setUp((){
    mockGetTopRatedTvSeries = MockGetTvTopRated();
    topRatedTvSeriesBloc = TopRatedTvBloc(
      mockGetTopRatedTvSeries
    );
  });

  test('initial state should be empty', (){
    expect(topRatedTvSeriesBloc.state, TopRatedTvEmpty());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(testTvList));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRatedTv()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvHasData(testTvList)
      ],
      verify: (bloc) => verify(mockGetTopRatedTvSeries.execute())
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnFetchTopRatedTv()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetTopRatedTvSeries.execute())
  );
}