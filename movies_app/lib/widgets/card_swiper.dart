import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:movies_app/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  const CardSwiper({Key? key, required this.movies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //el context nos proporciona las caracteristicas del dispositivo en el que se esta ejecutando la app

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, int index) {
          final movie = movies[index];
          movie.heroId =
              'swiper-${movie.id}'; //le asigno a la propiedad heroId el id de la pelicula para este caso
          return GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie
                  .heroId!, //para que sepa que es el mismo elemento que se va a mostrar en la otra pantalla.
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
