part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OnFetchTvRecommendation extends TvRecommendationEvent {
  final int id;

  OnFetchTvRecommendation(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
