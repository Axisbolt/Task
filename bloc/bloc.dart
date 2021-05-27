import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:MusicLyrics/networking/response.dart';
import 'package:MusicLyrics/repository/music_details_repository.dart';
import 'package:MusicLyrics/models/music_details.dart';
import 'package:MusicLyrics/repository/music_list_repository.dart';
import 'package:MusicLyrics/models/music_list.dart';
import 'package:MusicLyrics/repository/music_lyrics_repository.dart';
import 'package:MusicLyrics/models/music_lyrics.dart';
import 'package:flutter/cupertino.dart';

class ConnectBloc {
  StreamController _connectivityController;
  StreamSink<ConnectivityResult> get connectivityResultSink =>
      _connectivityController.sink;
  Stream<ConnectivityResult> get connectivityResultStream =>
      _connectivityController.stream;

  ConnectBloc() {
    _connectivityController = StreamController<ConnectivityResult>.broadcast();
    checkCurrentConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityController.add(result);
    });
  }
  void checkCurrentConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    _connectivityController.add(connectivityResult);
  }

  dispose() {
    _connectivityController?.close();
  }
}


class MusicDetailsBloc {
  MusicDetailsRepository _musicDetailsRepository;
  StreamController _musicDetailsController;
  int trackId;
  StreamSink<Response<MusicDetails>> get musicDetailsSink =>
      _musicDetailsController.sink;

  Stream<Response<MusicDetails>> get musicDetailsStream =>
      _musicDetailsController.stream;

  MusicDetailsBloc({this.trackId}) {
    _musicDetailsController =
    StreamController<Response<MusicDetails>>.broadcast();
    _musicDetailsRepository = MusicDetailsRepository(trackId: trackId);
    //fetchMusicDetails();
  }
  fetchMusicDetails() async {
    musicDetailsSink.add(Response.loading('Loading details.. '));
    try {
      MusicDetails musicDetails =
      await _musicDetailsRepository.fetchMusicDetailsData();
      musicDetailsSink.add(Response.completed(musicDetails));
    } catch (e) {
      musicDetailsSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _musicDetailsController?.close();
  }
}

class MusicListBloc {
  MusicListRepository _musicListRepository;
  StreamController _musicListController;

  StreamSink<Response<MusicList>> get musicListSink =>
      _musicListController.sink;

  Stream<Response<MusicList>> get musicListStream =>
      _musicListController.stream;

  MusicListBloc() {
    _musicListController = StreamController<Response<MusicList>>.broadcast();
    _musicListRepository = MusicListRepository();
    fetchMusicList();
  }

  fetchMusicList() async {
    musicListSink.add(Response.loading('Loading list. '));
    try {
      MusicList musicList = await _musicListRepository.fetchMusicListData();
      musicListSink.add(Response.completed(musicList));
    } catch (e) {
      musicListSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _musicListController?.close();
  }
}
class MusicLyricsBloc {
  MusicLyricsRepository _musicLyricsRepository;
  StreamController _musicLyricsController;
  int trackId;
  StreamSink<Response<MusicLyrics>> get musicLyricsSink =>
      _musicLyricsController.sink;

  Stream<Response<MusicLyrics>> get musicLyricsStream =>
      _musicLyricsController.stream;

  MusicLyricsBloc({@required this.trackId}) {
    _musicLyricsController =
    StreamController<Response<MusicLyrics>>.broadcast();
    _musicLyricsRepository = MusicLyricsRepository(trackId: trackId);
    fetchMusicLyrics();
  }
  fetchMusicLyrics() async {
    musicLyricsSink.add(Response.loading('Loading lyrics'));
    try {
      MusicLyrics musicLyrics =
      await _musicLyricsRepository.fetchMusicDetailsData();
      musicLyricsSink.add(Response.completed(musicLyrics));
    } catch (e) {
      musicLyricsSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _musicLyricsController?.close();
  }
}
