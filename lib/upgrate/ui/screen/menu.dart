import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cassettemusic/orign/BreakLine.dart';
import 'package:cassettemusic/orign/Constant.dart';
import 'package:cassettemusic/orign/HexColor.dart';
import 'package:cassettemusic/orign/model/AudioModel.dart';
import 'package:cassettemusic/upgrate/control/menu_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMenuScreen extends StatelessWidget {
  static final String KEY_TYPE = "TYPE";
  static final String KEY_POS = "POS";
  static final String KEY_VALUE = "VALUE";
  static final String DANH_SACH = "DANH_SACH"; // danhsach, artist, folder
  static final String ARTIST = "ARTIST";
  static final String FOLDER = "FOLDER"; // danhsach, artist, folder
  final List<AudioModel> listAudioModel;

  const MyMenuScreen({Key key, @required this.listAudioModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MenuScreenBloc menuBloc = new MenuScreenBloc();
    return BlocProvider(
      blocs: [
        Bloc((i) => menuBloc),
      ],
      child: Scaffold(
        body: MenuScreenPage(listAudioModel),
      ),
    );
  }
}

class MenuScreenPage extends StatefulWidget {
  List<AudioModel> listAudioModel;

  MenuScreenPage(this.listAudioModel);

  @override
  State<StatefulWidget> createState() {
    return MenuScreenPageState();
  }
}

class MenuScreenPageState extends State<MenuScreenPage> {
  MenuScreenPageState();
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
    MenuScreenBloc bloc = BlocProvider.getBloc<MenuScreenBloc>();
    bloc.setListAudioModel(widget.listAudioModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MenuScreenBloc>(builder: (context, value) {
        return Container(
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
                          scrollController.jumpTo(scrollController.position.minScrollExtent);
                          value.tabDsClick();
                        },
                        child: Container(
                          color: value.colorTabDs,
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
                          scrollController.jumpTo(scrollController.position.minScrollExtent);
                          value.tabArtistClick();
                        },
                        child: Container(
                          color: value.colorTabArtist,
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
                          scrollController.jumpTo(scrollController.position.minScrollExtent);
                          value.tabFolderClick();
                        },
                        child: Container(
                          color: value.colorTabFolder,
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
                      itemCount: value.listContent.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop({
                              MyMenuScreen.KEY_TYPE: value.currentTYPE,
                              MyMenuScreen.KEY_POS: index,
                              MyMenuScreen.KEY_VALUE: value.listContent[index]
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
                                    value.listContent[index],
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
        );
      }),
    );
  }
}
