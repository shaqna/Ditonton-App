import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, TvDetail>> getDetailTv(int id);
  Future<Either<Failure, List<Tv>>> getTvAiringToday();
  Future<Either<Failure, List<Tv>>> getTvOnTheAir();
  Future<Either<Failure, List<Tv>>> getTvTopRated();
  Future<Either<Failure, List<Tv>>> getTvPopular();
  Future<Either<Failure, List<Tv>>> searchTv(String query);
  Future<Either<Failure, List<Tv>>> getRecommendationsTv(int id);
  Future<Either<Failure, String>> saveWatchlistTv(TvDetail tvDetail);
  Future<Either<Failure, String>> removeWatchlistTv(TvDetail tvDetail);
  Future<bool> isAddedToWatchlistTv(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTv();
}