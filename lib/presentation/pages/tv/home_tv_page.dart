import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/components/tv_list.dart';
import 'package:ditonton/presentation/pages/tv/on_the_air_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv-page';

  const HomeTvPage({Key? key}) : super(key: key);

  @override
  State<HomeTvPage> createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> with RouteAware {


  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
    Provider.of<TvListNotifier>(context, listen: false)
      ..fetchTvTopRated()
      ..fetchTvAiringToday()
      ..fetchTvOnTheAir()
      ..fetchTvPopular()
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<TvListNotifier>(context, listen: false)
      ..fetchTvTopRated()
      ..fetchTvAiringToday()
      ..fetchTvOnTheAir()
      ..fetchTvPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Airing Today',
                  style: kHeading6,
                ),
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.tvAiringTodayState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return TvList(data.tvAiringToday);
                  } else {
                    return Text('Failed');
                  }
                }),
                _buildSubHeading(
                    title: 'TV Now Playing',
                    onTap: () {
                      Navigator.pushNamed(context, OnTheAirTvPage.ROUTE_NAME);
                    }
                ),
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.tvOnTheAirState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return TvList(data.tvOnTheAir);
                  } else {
                    return Text('Failed');
                  }
                }),
                _buildSubHeading(
                    title: 'Top Rated',
                    onTap: () {
                      Navigator.pushNamed(context, TopRatedTvPage.ROUTE_NAME);
                    }
                ),
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.topRatedTvState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return TvList(data.topRatedTv);
                  } else {
                    return Text('Failed');
                  }
                }),
                _buildSubHeading(
                    title: 'Popular',
                    onTap: () {
                      Navigator.pushNamed(context, PopularTvPage.ROUTE_NAME);
                    }
                ),
                Consumer<TvListNotifier>(builder: (context, data, child) {
                  final state = data.popularTvState;
                  if (state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state == RequestState.Loaded) {
                    return TvList(data.popularTv);
                  } else {
                    return Text('Failed');
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
    @override
    void dispose() {
      routeObserver.unsubscribe(this);
      super.dispose();
    }
  }
