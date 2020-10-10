class Const {
  static final isLog = false;

  static final tapeRatio = 1120 / 708;
  static final tapeContentRatio = 900 / 485;
  static final tapeContentWithTapeRatio = 478 / 720;
  static final tapeContentLabelRatio = 60 / 720;
  static final tapeAnimRatio = 194 / 720;
  static final tapeAnimOwnerRatio = 194 / 657;
  static final bgMoRatio = 150 / 720;
  static final equalizerThumbRatio = 49 / 720;
  static final equalizerOwnerThumbRatio = 63 / 49;

  static final controlHeight = 0.17;
  static final SoundData volume = SoundData(
    def: 0.7,
    min: 0.0,
    max: 1.0,
  );
  static final SoundData bass = SoundData(
    def: 500.0,
    min: 0.0,
    max: 1000.0,
  );
  static final SoundData treble = SoundData(
    def: 500.0,
    min: 0.0,
    max: 1000.0,
  );
  static final controlButtonSpace = 2.0;
  static final controlButtonIconSize = 16.0;

  static final songNameTextSize = 16.0;
  static final songNameLabel = 'Name';
  static final songDesTextSize = 16.0;
  static final songDesLabel = 'Location';

  static final String TREBLE = "TREBLE";
  static final String BASS = "BASS";

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
  static final tapeReelBorder = '$root/tape_reel_border.png';
  static final tapeReel = '$root/tape_reel.png';
  static final tapeContent = '$root/tape_content.png';
  static final tapeSubBackground = '$root/tape_sub_background.png';
  static final tapeParentBackground = '$root/tape_parent_background.png';

  static final controlBackground = '$root/control_background.png';
  static final controlButton = '$root/control_button.png';
  static final controlButtonPressed = '$root/control_button_pressed.png';
  static final buttonBackground = '$root/button_background.png';
  static final equalizerThumb = '$root/ic_thumb.png';
  static final equalizerTrack = '$root/equalizer_track.png';
  static final bgVolume = '$root/bg_volume.png';
  static final ButtonData play = ButtonData(
    icon: '$root/ic_play_black.png',
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
  double def;
  double min;
  double max;

  SoundData({
    this.def,
    this.min,
    this.max,
  });
}

class BridgeNative {
  static String audioChanel = "AudioPlayersPlugin";
  static String notificationChanel = "MediaNotificationPlugin";
  static NotificationMethod notificationMethod = new NotificationMethod();
  static NotificationParams notificationParams = new NotificationParams();
}

class NotificationMethod {
  String methodShow = "show";
  String methodPlay = "play";
  String methodPause = "pause";
  String methodUpdateTitle = "update_title";
}

class NotificationParams {
  String paramTitle = "title";
  String paramAuthor = "author";
  String paramIsPlay = "is_play";
}
