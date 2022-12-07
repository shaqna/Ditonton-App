import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/db/database_tv_helper.dart';
import 'package:ditonton/data/datasources/local/movie/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/local/tv/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/remote/movie/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/remote/tv/tv_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  TvRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  DatabaseTvHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
