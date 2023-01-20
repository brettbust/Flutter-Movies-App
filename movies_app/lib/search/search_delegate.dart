import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query =
            '', //el query es una propiedad del SearchDelegate que nos permite obtener el texto que se esta escribiendo en el buscador
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context,
          null), //el close es una propiedad del SearchDelegate que nos permite cerrar el buscador
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Widget _emptyContainer() {
    return Container(
      child: const Center(
        child: Icon(Icons.movie_creation_outlined, size: 150),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //este metodo se ejecuta cada vez que se escribe algo en el buscador
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(
        query); //llamo al metodo que obtiene las sugerencias luego de 500ms

    return StreamBuilder(
      //se ejecuta unicamente cuando se obtiene una respuesta del servidor
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) => _MovieItem(movies[index]),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/images/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
