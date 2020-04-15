import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///E:/FlutterProject/CassetteMusic/cassette_music/lib/orign/Constant.dart';

import 'BreakLine.dart';
import 'HexColor.dart';
import 'model/AudioModel.dart';

class MenuScreen extends StatelessWidget {
  static final String KEY_TYPE = "TYPE";
  static final String KEY_POS = "POS";
  static final String KEY_VALUE = "VALUE";
  static final String DANH_SACH = "DANH_SACH"; // danhsach, artist, folder
  static final String ARTIST = "ARTIST";
  static final String FOLDER = "FOLDER"; // danhsach, artist, folder
  final List<AudioModel> listAudioModel;

  const MenuScreen({Key key, @required this.listAudioModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MenuScreenPage(listAudioModel),
    );
  }
}

class MenuScreenPage extends StatefulWidget {
  List<AudioModel> listAudioModel;

  MenuScreenPage(this.listAudioModel);

  @override
  State<StatefulWidget> createState() {
    return MenuScreenPageState(listAudioModel);
  }
}

class MenuScreenPageState extends State<MenuScreenPage> {
  String currentTYPE; // danhsach, artist, folder

  List<AudioModel> listAudioModel;
  List<String> listContent = new List();
  List<String> listAll = new List();
  List<String> listArtist = new List();
  List<String> listFolder = new List();

  Color defaulTabColor = Colors.transparent;
  Color selectColor = HexColor("#9A3B3E42");

  Color colorTabDs = Colors.transparent;
  Color colorTabArtist = Colors.transparent;
  Color colorTabFolder = Colors.transparent;

  MenuScreenPageState(this.listAudioModel);
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#E5DFD6"),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/ic_arrow_back.png",
                              height: 16,
                              width: 16,
                            ),
                            Text(
                              "Back",
                              style: TextStyle(fontSize: AppTextSize.textTitle),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BreakLine("#FF8E8E91", 1),
                    GestureDetector(
                      onTap: () {
                        currentTYPE = MenuScreen.DANH_SACH;
                        scrollController.jumpTo(scrollController.position.minScrollExtent);
                        setState(() {
                          colorTabDs = selectColor;
                          colorTabArtist = defaulTabColor;
                          colorTabFolder = defaulTabColor;

                          listContent.clear();
                          listContent.addAll(listAll);
                        });
                      },
                      child: Container(
                        color: colorTabDs,
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Danh sách",
                              style: TextStyle(fontSize: AppTextSize.textTitle),
                            ),
                            new Spacer(),
                            Image.asset(
                              "assets/images/ic_arrow_next.png",
                              height: 16,
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    BreakLine("#FF8E8E91", 1),
                    GestureDetector(
                      onTap: () {
                        currentTYPE = MenuScreen.ARTIST;
                        scrollController.jumpTo(scrollController.position.minScrollExtent);
                        setState(() {
                          colorTabDs = defaulTabColor;
                          colorTabArtist = selectColor;
                          colorTabFolder = defaulTabColor;

                          listContent.clear();
                          listContent.addAll(listArtist);
                        });
                      },
                      child: Container(
                        color: colorTabArtist,
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text("Nghệ sỹ", style: TextStyle(fontSize: AppTextSize.textTitle)),
                            new Spacer(),
                            Image.asset(
                              "assets/images/ic_arrow_next.png",
                              height: 16,
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    BreakLine("#FF8E8E91", 1),
                    GestureDetector(
                      onTap: () {
                        currentTYPE = MenuScreen.FOLDER;
                        scrollController.jumpTo(scrollController.position.minScrollExtent);
                        setState(() {
                          colorTabDs = defaulTabColor;
                          colorTabArtist = defaulTabColor;
                          colorTabFolder = selectColor;
                          listContent.clear();
                          listContent.addAll(listFolder);
                        });
                      },
                      child: Container(
                        color: colorTabFolder,
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Text("Album (Folder)", style: TextStyle(fontSize: AppTextSize.textTitle)),
                            new Spacer(),
                            Image.asset(
                              "assets/images/ic_arrow_next.png",
                              height: 16,
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    BreakLine("#FF8E8E91", 1),
                  ],
                ),
              ),
            ),
            Container(
              color: HexColor("#FF8E8E91"),
              width: 1,
              height: double.infinity,
              margin: EdgeInsets.only(top: 20),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: ListView.builder(
                    itemCount: listContent.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop({
                            MenuScreen.KEY_TYPE: currentTYPE,
                            MenuScreen.KEY_POS: index,
                            MenuScreen.KEY_VALUE: listContent[index]
                          });
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  listContent[index],
                                  style: TextStyle(fontSize: AppTextSize.textTitle),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initData() {
    if (listAudioModel == null) {
      return;
    }
    for (AudioModel audioModel in listAudioModel) {
      String artist = audioModel.artist;
      String folder = audioModel.folder;
      listAll.add(audioModel.name);
      if (artist.isNotEmpty && !listArtist.contains(artist)) {
        listArtist.add(artist);
      }
      if (folder.isNotEmpty && !listFolder.contains(folder)) {
        listFolder.add(folder);
      }
    }

    listArtist.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    listFolder.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
  }
}
