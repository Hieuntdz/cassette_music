//import 'dart:ui';
//
//import 'package:bloc_pattern/bloc_pattern.dart';
//import 'package:cassettemusic/orign/hex_color.dart';
//import 'package:cassettemusic/orign/model/AudioModel.dart';
//import 'package:cassettemusic/upgrate/ui/screen/menu.dart';
//import 'package:flutter/material.dart';
//
//class MenuScreenBloc extends BlocBase {
//  List<AudioModel> listAudioModel = new List();
//
//  List<String> listContent = new List();
//  List<String> listAll = new List();
//  List<String> listArtist = new List();
//  List<String> listFolder = new List();
//
//  Color colorTabDs = Colors.transparent;
//  Color colorTabArtist = Colors.transparent;
//  Color colorTabFolder = Colors.transparent;
//
//  Color defaulTabColor = Colors.transparent;
//  Color selectColor = HexColor("#9A3B3E42");
//
//  String currentTYPE; // danhsach, artist, folder
//
//  void tabDsClick() {
//    colorTabDs = selectColor;
//    colorTabArtist = defaulTabColor;
//    colorTabFolder = defaulTabColor;
//    currentTYPE = MyMenuScreen.DANH_SACH;
//    loadAllList();
//  }
//
//  void tabArtistClick() {
//    colorTabDs = defaulTabColor;
//    colorTabArtist = selectColor;
//    colorTabFolder = defaulTabColor;
//    currentTYPE = MyMenuScreen.ARTIST;
//    loadArtist();
//  }
//
//  void tabFolderClick() {
//    colorTabDs = defaulTabColor;
//    colorTabArtist = defaulTabColor;
//    colorTabFolder = selectColor;
//    currentTYPE = MyMenuScreen.FOLDER;
//    loadFolder();
//  }
//
//  void setListAudioModel(List<AudioModel> listAudioModel) {
//    this.listAudioModel.clear();
//    this.listAudioModel.addAll(listAudioModel);
//
//    if (listAudioModel == null) {
//      return;
//    }
//    for (AudioModel audioModel in listAudioModel) {
//      String artist = audioModel.artist;
//      String folder = audioModel.folder;
//      listAll.add(audioModel.name);
//      if (artist.isNotEmpty && !listArtist.contains(artist)) {
//        listArtist.add(artist);
//      }
//      if (folder.isNotEmpty && !listFolder.contains(folder)) {
//        listFolder.add(folder);
//      }
//    }
//
//    listArtist.sort((a, b) {
//      return a.toLowerCase().compareTo(b.toLowerCase());
//    });
//    listFolder.sort((a, b) {
//      return a.toLowerCase().compareTo(b.toLowerCase());
//    });
//  }
//
//  void loadAllList() {
//    listContent.clear();
//    listContent.addAll(listAll);
//    notifyListeners();
//  }
//
//  void loadArtist() {
//    listContent.clear();
//    listContent.addAll(listArtist);
//    notifyListeners();
//  }
//
//  void loadFolder() {
//    listContent.clear();
//    listContent.addAll(listFolder);
//    notifyListeners();
//  }
//}
