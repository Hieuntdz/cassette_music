class Const {
  static final tapeRatio = 1120 / 708;
  static final tapeContentRatio = 900 / 485;
  static final tapeContentWithTapeRatio = 0.65;
  static final tapeContentLabelRatio = 60 / 620;

  static final controlHeight = 0.17;
  static final SoundData volume = SoundData(
    def: 50,
    min: 0,
    max: 100,
  );
  static final SoundData bass = SoundData(
    def: 50,
    min: 0,
    max: 100,
  );
  static final SoundData treble = SoundData(
    def: 50,
    min: 0,
    max: 100,
  );
  static final controlButtonSpace = 2.0;
  static final controlButtonIconSize = 16.0;

  static final songNameTextSize = 16.0;
  static final songNameLabel = 'Name';
  static final songDesTextSize = 16.0;
  static final songDesLabel = 'Location';

  static final filter = [
    'mp3',
    'mp4',
  ];
}

class Images {
  static final root = 'assets/images/upgrate';

  static final tapeBackground = '$root/tape_background.png';
  static final tapeCenterBackground1 = '$root/tape_center_bg1.png';
  static final tapeCenterBackground2 = '$root/tape_center_bg2.png';
  static final tapeLabel1 = '$root/tape_label_1.png';
  static final tapeLabel2 = '$root/tape_label_2.png';

  static final controlBackground = '$root/control_background.png';
  static final controlButton = '$root/control_button.png';
  static final controlButtonPressed = '$root/control_button_pressed.png';
  static final ButtonData play = ButtonData(
    icon: '$root/ic_play_blue.png',
    iconPressed: '$root/ic_play_blue.png',
  );
  static final ButtonData pause = ButtonData(
    icon: '$root/ic_pause_black.png',
    iconPressed: '$root/ic_pause_blue.png',
  );
  static final ButtonData stop = ButtonData(
    icon: '$root/ic_stop_black.png',
    iconPressed: '$root/ic_stop_blue.png',
  );
  static final ButtonData rewind = ButtonData(
    icon: '$root/ic_rewind_black.png',
    iconPressed: '$root/ic_rewind_blue.png',
  );
  static final ButtonData forward = ButtonData(
    icon: '$root/ic_forward_black.png',
    iconPressed: '$root/ic_forward_blue.png',
  );
  static final ButtonData eject = ButtonData(
    icon: '$root/ic_eject_black.png',
    iconPressed: '$root/ic_eject_blue.png',
  );
}

class ButtonData {
  String background = Images.controlButton;
  String backgroundPressed = Images.controlButtonPressed;
  String icon;
  String iconPressed;

  ButtonData({this.icon, this.iconPressed});
}

class SoundData {
  int def;
  int min;
  int max;

  SoundData({
    this.def,
    this.min,
    this.max,
  });
}
