import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_on_the_air.dart';
import 'package:equatable/equatable.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetTvOnTheAir _getTvOnTheAir;

  NowPlayingTvBloc(this._getTvOnTheAir) : super(NowPlayingTvEmpty()) {
    on<OnFetchOnTheAirTv>((event, emit) async{
      emit(NowPlayingTvLoading());

      final results = await _getTvOnTheAir.execute();

      results.fold(
          (failure) {
            emit(NowPlayingTvError(failure.message));
          },
          (list) {
            emit(NowPlayingTvHasData(list));
          }

      );
    });
  }
}
