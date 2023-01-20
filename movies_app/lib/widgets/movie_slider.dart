import 'package:flutter/material.dart';

import 'package:movies_app/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider(
      {Key? key, required this.movies, this.title, required this.onNextPage})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController =
      ScrollController(); //me permite crearme un listener en el initstate

  @override
  void initState() {
    // This is called when the widget is created
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // This is called when the widget is removed from the widget tree
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        height: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.title != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _MoviePoster(
                        movie: widget.movies[index],
                        heroId:
                            '${widget.title}-$index-${widget.movies[index].id}');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  final String heroId;

  const _MoviePoster({
    Key? key,
    required this.movie,
    required this.heroId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId =
        heroId; //para que el heroId sea único y no se repita lo puedo pasar como parametro

    return Container(
        width: 130,
        height: 190,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              child: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(movie.fullPosterImg),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            )
          ],
        ));
  }
}
