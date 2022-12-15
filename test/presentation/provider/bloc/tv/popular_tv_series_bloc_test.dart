import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_popular.dart';
import 'package:ditonton/presentation/provider/bloc/tv/popular/popular_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_bloc_test.mocks.dart';


@GenerateMocks([GetTvPopular])
void main(){
  late PopularTvBloc popularTvBloc;
  late MockGetTvPopular mockGetPopularTv;

  setUp((){
    mockGetPopularTv = MockGetTvPopular();
    popularTvBloc = PopularTvBloc(
      mockGetPopularTv
    );
  });

  test('initial state should be empty', (){
    expect(popularTvBloc.state, PopularTvEmpty());
  });

  blocTest<PopularTvBloc, PopularTvState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(testTvList));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopularTv()),
      expect: () => [
        PopularTvLoading(),
        PopularTvHasData(testTvList)
      ],
      verify: (bloc) => verify(mockGetPopularTv.execute())
  );

  blocTest<PopularTvBloc, PopularTvState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchPopularTv()),
      expect: () => [
        PopularTvLoading(),
        PopularTvError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetPopularTv.execute())
  );
}