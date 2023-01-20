import 'package:flutter/material.dart';

import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';

import 'package:movies_app/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Movies in Theaters')),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MovieSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //card swiper (Widget personalizado 1)

            CardSwiper(movies: moviesProvider.onDisplayMovies),

            //horizontal movie slider (Widget personalizado 2)

            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares', //optional
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
