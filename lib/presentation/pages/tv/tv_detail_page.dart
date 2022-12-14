import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie/genre.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/presentation/provider/bloc/tv/detail/detail_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/recommendation/tv_recommendation_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/watchlist_status/watchlist_tv_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DetailTvBloc>().add(OnFetchDetailTv(widget.id));
      context.read<WatchlistTvStatusBloc>().add(OnFetchWatchlistStatus(widget.id));
      context.read<TvRecommendationBloc>().add(OnFetchTvRecommendation(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailTvBloc, DetailTvState>(
        builder: (context,state) {
          if (state is DetailTvLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailTvHasData) {
            final tv = state.tv;
            return SafeArea(
              child: DetailContent(
                tv,
              ),
            );
          } else {
            return Text('Failed');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;

  DetailContent(this.tv, );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            BlocConsumer<WatchlistTvStatusBloc,
                                WatchlistTvStatusState>(
                              listener: (context, state) {
                                if (state is WatchlistTvStatusHasData) {
                                  if (state.message.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(state.message),
                                            duration: const Duration(
                                                milliseconds: 700)));
                                  }
                                }
                              },
                              builder: (context, state) {
                                if (state is WatchlistTvStatusHasData) {
                                  return ElevatedButton(
                                    onPressed: () async {
                                      if (state.isAdded) {
                                        context
                                            .read<WatchlistTvStatusBloc>()
                                            .add(OnRemoveFromWatchList(tv));
                                      } else {
                                        context
                                            .read<WatchlistTvStatusBloc>()
                                            .add(OnAddedToWatchlist(tv));
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.isAdded
                                            ? Icon(Icons.check)
                                            : Icon(Icons.add),
                                        Text('Watchlist'),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              _showEpisodes(tv.numberOfEpisodes),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            SizedBox(
                                height: 150,
                                child: BlocBuilder<TvRecommendationBloc,
                                    TvRecommendationState>(
                                    builder: (context, state) {
                                      if (state is TvRecommendationLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state
                                      is TvRecommendationHasData) {
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final movie = state.list[index];
                                            return Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pushReplacementNamed(
                                                    context,
                                                    TvDetailPage.ROUTE_NAME,
                                                    arguments: movie.id,
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                    placeholder: (context, url) =>
                                                    const Center(
                                                      child:
                                                      CircularProgressIndicator(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                    const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: state.list.length,
                                        );
                                      } else {
                                        return const Center(
                                          child: Text('Failed'),
                                        );
                                      }
                                    })),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showEpisodes(int? episode) {
    if(episode == null) {
      return '- Episodes';
    }
    return '$episode Episodes';
  }
}
