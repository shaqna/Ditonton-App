import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_recomendations_tv.dart';
import 'package:ditonton/presentation/provider/bloc/tv/recommendation/tv_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'recommendation_tv_series_bloc_test.mocks.dart';


@GenerateMocks([GetRecommendationsTv])
void main(){
  late TvRecommendationBloc tvRecommendationBloc;
  late MockGetRecommendationsTv mockTvRecommendationBloc;

  setUp((){
    mockTvRecommendationBloc = MockGetRecommendationsTv();
    tvRecommendationBloc = TvRecommendationBloc(
      mockTvRecommendationBloc
    );
  });

  test('initial state should be empty', (){
    expect(tvRecommendationBloc.state, TvRecommendationEmpty());
  });

  const tId = 1;
  blocTest<TvRecommendationBloc, TvRecommendationState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockTvRecommendationBloc.execute(tId))
            .thenAnswer((_) async => Right(testTvList));
        return tvRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchTvRecommendation(tId)),
      expect: () => [
        TvRecommendationLoading(),
        TvRecommendationHasData(testTvList)
      ],
      verify: (bloc) => verify(mockTvRecommendationBloc.execute(tId))
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockTvRecommendationBloc.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvRecommendationBloc;
      },
      act: (bloc) => bloc.add(OnFetchTvRecommendation(tId)),
      expect: () => [
        TvRecommendationLoading(),
        TvRecommendationError('Server Failure')
      ],
      verify: (bloc) => verify(mockTvRecommendationBloc.execute(tId))
  );
}