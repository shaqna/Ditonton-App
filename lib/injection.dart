import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/db/database_tv_helper.dart';
import 'package:ditonton/data/datasources/local/movie/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/local/tv/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/remote/movie/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/remote/tv/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_popular.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_on_the_air.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/provider/bloc/movie/detail/detail_movie_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/now_playing/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/popular/popular_movie_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/recommendations/recommendation_movie_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/search/search_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/top_rated/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/movie/watchlist_status/watchlist_movie_status_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/%20now_playing/now_playing_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/detail/detail_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/popular/popular_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/recommendation/tv_recommendation_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/search/search_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/watchlist/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/watchlist_status/watchlist_tv_status_bloc.dart';
import 'package:ditonton/presentation/provider/notifier/movie/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/movie/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/movie/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/movie/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/movie/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/movie/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/tv/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/notifier/tv/tv_detail_notifier.dart';
import 'package:ditonton/utils/ssl_client.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:ditonton/presentation/provider/notifier/tv/tv_list_notifier.dart';
import 'package:ditonton/domain/usecases/tv/get_recomendations_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watch_list_tv_status.dart';

import 'presentation/provider/notifier/tv/on_the_air_tv_notifier.dart';
import 'presentation/provider/notifier/tv/search_tv_notifier.dart';
import 'presentation/provider/notifier/tv/top_rated_tv_notifier.dart';
import 'presentation/provider/notifier/tv/watchlist_tv_notifier.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  // bloc movie
  locator.registerFactory(
      () => SearchBloc(locator()),
  );
  locator.registerFactory(
      () => DetailMovieBloc(locator()),
  );
  locator.registerFactory(
      () => NowPlayingMovieBloc(locator()),
  );
  locator.registerFactory(
      () => PopularMovieBloc(locator()),
  );
  locator.registerFactory(
      () => RecommendationMovieBloc(locator()),
  );
  locator.registerFactory(
      () => TopRatedMovieBloc(locator())
  );
  locator.registerFactory(
      () => WatchlistMovieBloc(locator())
  );
  locator.registerFactory(
      () => WatchlistMovieStatusBloc(
        locator(),
        locator(),
        locator()
      ),
  );

  // bloc tv
  locator.registerFactory(
        () => SearchTvBloc(locator()),
  );
  locator.registerFactory(
        () => DetailTvBloc(locator()),
  );
  locator.registerFactory(
        () => NowPlayingTvBloc(locator()),
  );

  locator.registerFactory(
        () => PopularTvBloc(locator()),
  );
  locator.registerFactory(
        () => TvRecommendationBloc(locator()),
  );
  locator.registerFactory(
          () => TopRatedTvBloc(locator())
  );
  locator.registerFactory(
          () => WatchlistTvBloc(locator())
  );
  locator.registerFactory(
        () => WatchlistTvStatusBloc(
        locator(),
        locator(),
        locator()
    ),
  );

  // tv provider
  locator.registerFactory(
    () => TvListNotifier(
        getTvAiringToday: locator(),
        getTvOnTheAir: locator(),
        getTvPopular: locator(),
        getTvTopRated: locator()),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getRecommendationsTv: locator(),
      getTvDetail: locator(),
      getWatchListStatusTv: locator(),
      saveWatchlistTv: locator(),
      removeWatchlistTv: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvNotifier(getWatchlistTvs: locator()),
  );
  locator.registerFactory(() => OnTheAirTvNotifier(
        getTvOnTheAir: locator(),
      ));
  locator.registerFactory(
    () => PopularTvNotifier(getPopularTv: locator()),
  );
  locator.registerFactory(
    () => SearchTvNotifier(searchTv: locator()),
  );
  locator.registerFactory(
        () => TopRatedTvNotifier(getTvTopRated: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // tv use case
  locator.registerLazySingleton(() => GetTvAiringToday(locator()));
  locator.registerLazySingleton(() => GetTvPopular(locator()));
  locator.registerLazySingleton(() => GetTvOnTheAir(locator()));
  locator.registerLazySingleton(() => GetTvTopRated(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetRecommendationsTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      tvLocalDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelperTv: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<DatabaseTvHelper>(() => DatabaseTvHelper());

  // utils
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton<SSLClient>(() => SSLClient());
}
