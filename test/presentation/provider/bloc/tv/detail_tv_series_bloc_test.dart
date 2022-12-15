import 'package:bloc_test/bloc_test.dart';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/presentation/provider/bloc/tv/detail/detail_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'detail_tv_series_bloc_test.mocks.dart';


@GenerateMocks([GetTvDetail])
void main(){
  late DetailTvBloc detailTvSeriesBloc;
  late MockGetTvDetail mockGetTvSeriesDetail;

  setUp((){
    mockGetTvSeriesDetail = MockGetTvDetail();
    detailTvSeriesBloc = DetailTvBloc(
      mockGetTvSeriesDetail
    );
  });

  test('initial state should be empty', (){
    expect(detailTvSeriesBloc.state, DetailTvEmpty());
  });

  const tId = 1;
  blocTest<DetailTvBloc, DetailTvState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnFetchDetailTv(tId)),
      expect: () => [
        DetailTvLoading(),
        DetailTvHasData(testTvDetail)
      ],
      verify: (bloc) => verify(mockGetTvSeriesDetail.execute(tId))
  );

  blocTest<DetailTvBloc, DetailTvState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnFetchDetailTv(tId)),
      expect: () => [
        DetailTvLoading(),
        DetailTvError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetTvSeriesDetail.execute(tId))
  );
}