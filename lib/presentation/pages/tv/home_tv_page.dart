import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/components/tv_list.dart';
import 'package:ditonton/presentation/pages/tv/on_the_air_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:ditonton/presentation/provider/bloc/tv/%20now_playing/now_playing_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/popular/popular_tv_bloc.dart';
import 'package:ditonton/presentation/provider/bloc/tv/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/provider/notifier/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Future.microtask(() {
      context.read<NowPlayingTvBloc>().add(OnFetchOnTheAirTv());
      context.read<PopularTvBloc>().add(OnFetchPopularTv());
      context.read<TopRatedTvBloc>().add(OnFetchTopRatedTv());
    }
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<NowPlayingTvBloc>().add(OnFetchOnTheAirTv());
    context.read<PopularTvBloc>().add(OnFetchPopularTv());
    context.read<TopRatedTvBloc>().add(OnFetchTopRatedTv());
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
                _buildSubHeading(
                    title: 'TV Now Playing',
                    onTap: () {
                      Navigator.pushNamed(context, OnTheAirTvPage.ROUTE_NAME);
                    }
                ),
                BlocBuilder<NowPlayingTvBloc, NowPlayingTvState>(builder: (context, state) {
                  if (state is NowPlayingTvLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingTvHasData) {
                    return TvList(state.list);
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
                BlocBuilder<TopRatedTvBloc, TopRatedTvState>(builder: (context, state) {

                  if (state is TopRatedTvLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedTvHasData) {
                    return TvList(state.list);
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
                BlocBuilder<PopularTvBloc, PopularTvState>(builder: (context,state) {

                  if (state is PopularTvLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularTvHasData) {
                    return TvList(state.list);
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
