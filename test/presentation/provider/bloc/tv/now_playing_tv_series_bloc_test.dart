import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_on_the_air.dart';
import 'package:ditonton/presentation/provider/bloc/tv/%20now_playing/now_playing_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import '../../../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_series_bloc_test.mocks.dart';



@GenerateMocks([GetTvOnTheAir])
void main(){
  late NowPlayingTvBloc nowPlayingTvBloc;
  late MockGetTvOnTheAir mockGetTvOnTheAir;

  setUp((){
    mockGetTvOnTheAir = MockGetTvOnTheAir();
    nowPlayingTvBloc = NowPlayingTvBloc(
        mockGetTvOnTheAir
    );
  });

  test('initial state should be empty', (){
    expect(nowPlayingTvBloc.state, NowPlayingTvEmpty());
  });

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emit when data is loaded successfully',
      build: (){
        when(mockGetTvOnTheAir.execute())
            .thenAnswer((_) async => Right(testTvList));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchOnTheAirTv()),
      expect: () => [
        NowPlayingTvLoading(),
        NowPlayingTvHasData(testTvList)
      ],
      verify: (bloc) => verify(mockGetTvOnTheAir.execute())
  );

  blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emit error when data is loaded unsuccessfully',
      build: (){
        when(mockGetTvOnTheAir.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(OnFetchOnTheAirTv()),
      expect: () => [
        NowPlayingTvLoading(),
         NowPlayingTvError('Server Failure')
      ],
      verify: (bloc) => verify(mockGetTvOnTheAir.execute())
  );
}