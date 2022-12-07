import 'dart:convert';

import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      id: 11250,
      name: "Hidden Passion",
      overview: "The Reyes-Elizondo's idyllic lives are shattered by a murder charge against Eric and León.",
      originCountry: ["CO"],
      genreIds: [18],
      originalLanguage: 'es',
      originalName: 'Pasión de gavilanes',
      popularity: 3224.751,
      voteAverage: 7.6,
      voteCount: 1805,
      posterPath: "/lWlsZIsrGVWHtBeoOeLxIKDd9uy.jpg",
      backdropPath: "/4g5gK5eGWZg8swIZl6eX2AoJp8S.jpg"
  );
  final tTvResponseModel =
  TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/tv_now_playing.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/4g5gK5eGWZg8swIZl6eX2AoJp8S.jpg",
            "genre_ids": [
              18
            ],
            "id": 11250,
            "name": "Hidden Passion",
            "origin_country": [
              "CO"
            ],
            "original_language": "es",
            "original_name": "Pasión de gavilanes",
            "overview": "The Reyes-Elizondo's idyllic lives are shattered by a murder charge against Eric and León.",
            "popularity": 3224.751,
            "poster_path": "/lWlsZIsrGVWHtBeoOeLxIKDd9uy.jpg",
            "vote_average": 7.6,
            "vote_count": 1805
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}