import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/provider/bloc/tv/search/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'search_tv_series_bloc_test.mocks.dart';



@GenerateMocks([SearchTv])
void main(){
  late SearchTvBloc searchTvSeriesBloc;
  late MockSearchTv mockSearchTvSeries;

  setUp((){
    mockSearchTvSeries = MockSearchTv();
    searchTvSeriesBloc = SearchTvBloc(
      mockSearchTvSeries
    );
  });

  test('initial state should be empty', (){
    expect(searchTvSeriesBloc.state, SearchTvEmpty());
  });

  const query = 'abc';
  blocTest<SearchTvBloc, SearchTvState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockSearchTvSeries.execute(query))
            .thenAnswer((_) async => Right(testTvList));
        return searchTvSeriesBloc;
      },
      wait: const Duration(milliseconds: 500),
      act: (bloc) => bloc.add(OnQueryChanged(query)),
      expect: () => [
        SearchTvLoading(),
        SearchTvHasData(testTvList)
      ],
      verify: (bloc) => verify(mockSearchTvSeries.execute(query))
  );

  blocTest<SearchTvBloc, SearchTvState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockSearchTvSeries.execute(query))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return searchTvSeriesBloc;
      },
      wait: const Duration(milliseconds: 500),
      act: (bloc) => bloc.add(OnQueryChanged(query)),
      expect: () => [
        SearchTvLoading(),
        SearchTvError('Server Failure')
      ],
      verify: (bloc) => verify(mockSearchTvSeries.execute(query))
  );
}