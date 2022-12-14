import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_on_the_air.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_popular.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:flutter/cupertino.dart';

class TvListNotifier extends ChangeNotifier {
  var _popularTv = <Tv>[];
  List<Tv> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  var _topRatedTv = <Tv>[];
  List<Tv> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.Empty;
  RequestState get topRatedTvState => _topRatedTvState;

  var _tvAiringToday = <Tv>[];
  List<Tv> get tvAiringToday => _tvAiringToday;

  RequestState _tvAiringTodayState = RequestState.Empty;
  RequestState get tvAiringTodayState => _tvAiringTodayState;

  var _tvOnTheAir = <Tv>[];
  List<Tv> get tvOnTheAir => _tvOnTheAir;

  RequestState _tvOnTheAirState = RequestState.Empty;
  RequestState get tvOnTheAirState => _tvOnTheAirState;

  String _message = '';
  String get message => _message;

  TvListNotifier(
      {required this.getTvAiringToday,
      required this.getTvTopRated,
      required this.getTvPopular,
      required this.getTvOnTheAir});

  final GetTvAiringToday getTvAiringToday;
  final GetTvTopRated getTvTopRated;
  final GetTvPopular getTvPopular;
  final GetTvOnTheAir getTvOnTheAir;

  Future<void> fetchTvAiringToday() async {
    _tvAiringTodayState = RequestState.Loading;
    notifyListeners();

    final result = await getTvAiringToday.execute();

    result.fold(
      (failure) {
        _tvAiringTodayState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _tvAiringTodayState = RequestState.Loaded;
        _tvAiringToday = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvTopRated() async {
    _topRatedTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTvTopRated.execute();

    result.fold((failure) {
      _topRatedTvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvTopRated) {
      _topRatedTvState = RequestState.Loaded;
      _topRatedTv = tvTopRated;
    });
  }

  Future<void> fetchTvPopular() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTvPopular.execute();

    result.fold((failure) {
      _popularTvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvPopular) {
      _popularTvState = RequestState.Loaded;
      _popularTv = tvPopular;
      notifyListeners();
    });
  }

  Future<void> fetchTvOnTheAir() async {
    _tvOnTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getTvOnTheAir.execute();

    result.fold((failure) {
      _tvOnTheAirState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvOnTheAir) {
      _tvOnTheAirState = RequestState.Loaded;
      _tvOnTheAir = tvOnTheAir;
      notifyListeners();
    });
  }
}
