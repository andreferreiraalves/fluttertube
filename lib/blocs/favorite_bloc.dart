import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'dart:async';

import 'package:fluttertube/models/video.dart';
import 'package:shared_preferences/shared_preferences.dart';

const FAVORITES = "favorites";

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites = {};

  final _favController = StreamController<Map<String, Video>>.broadcast();
  Stream<Map<String, Video>> get outFav => _favController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains(FAVORITES)) {
        _favorites = json.decode(prefs.getString(FAVORITES)).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
        _favController.add(_favorites);
      }
    });
  }

  void toogleFavorite(Video video) {
    if (_favorites.containsKey(video.id))
      _favorites.remove(video.id);
    else
      _favorites[video.id] = video;

    _favController.sink.add(_favorites);

    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(FAVORITES, json.encode(_favorites));
    });
  }

  @override
  void addListener(listener) {}

  @override
  void dispose() {
    _favController.close();
  }

  @override
  bool get hasListeners => null;

  @override
  void notifyListeners() {}

  @override
  void removeListener(listener) {}
}
