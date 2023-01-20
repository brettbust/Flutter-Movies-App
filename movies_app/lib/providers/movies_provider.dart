import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:movies_app/models/models.dart';

import '../helpers/debouncer.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '6d2096a303a2a0fa0bbb35c5fbdb0c59';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast =
      {}; //para guardar los actores de cada película

  int _popularPage = 0;

  final debouncer =
      Debouncer<String>(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider constructor');
    getOnDisplayMovies();
    getPopularMovies();
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');

    /* final Map<String, dynamic> decodedData = json.decode(resp.body); */
/* 
    print(decodedData['dates']);
    print(decodedData['results']); */

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    /* print(nowPlayingResponse.results[0].title); */

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);

    /* final Map<String, dynamic> decodedData = json.decode(resp.body); */
/* 
    print(decodedData['dates']);
    print(decodedData['results']); */

    final popularResponse = PopularResponse.fromJson(jsonData);

    /* print(nowPlayingResponse.results[0].title); */

    popularMovies = [
      ...popularMovies,
      ...popularResponse.results
    ]; //spread operator (...) para concatenar listas o mapas
    notifyListeners();
  }

  //hacemos la petición a la API para obtener los actores

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    /*  print('haciendo petición a la API para obtener los actores'); */

    final jsonData = await _getJsonData('/3/movie/$movieId/credits');

    final creditsResponse = GetCreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  //método para hacer la petición a la API para traer las películas

  Future<String> _getJsonData(String segmento, [int page = 1]) async {
    final url = Uri.https(_baseUrl, segmento, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    }); //page es un string porque es un parámetro de la url

    final resp = await http.get(url);

    return resp.body;
  }

//método  que recibirá el query de la búsqueda y devolverá una lista de películas
  Future<List<Movie>> searchMovie(String query) async {
    //verificar si es necesario el ? después de Movie y List
    final url = Uri.https(_baseUrl, '/3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final resp = await http.get(url);

    final searchResponse = SearchResponse.fromJson(resp.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    //método que recibirá el query de la búsqueda y devolverá una lista de películas
    debouncer.value = '';
    debouncer.onValue = (value) async {
      /* print('$value'); */
      final results = await this.searchMovie(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
