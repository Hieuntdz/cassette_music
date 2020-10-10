package com.example.notification;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import com.example.Const;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * MediaNotificationPlugin
 */
public class MediaNotificationPlugin implements MethodCallHandler {
    public static final String CHANNEL_ID = "MediaNotificationPlugin";
    public static final String CHANNEL_NAME = "MediaNotificationPlugin";
    private BinaryMessenger messenger;
    private NotificationPanel nPanel;
    private MethodChannel channel;
    private Context context;

    private static MediaNotificationPlugin instance;

    private MediaNotificationPlugin(BinaryMessenger messenger, Context context) {
        this.messenger = messenger;
        this.context = context;
        channel = new MethodChannel(messenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
    }

    private MediaNotificationPlugin() {

    }

    public static MediaNotificationPlugin getInstance() {
        if (instance != null) {
            return instance;
        } else {
            return new MediaNotificationPlugin();
        }
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(BinaryMessenger messenger, Context context) {
        instance = new MediaNotificationPlugin(messenger, context);
    }

    Result mResult;

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        mResult = result;
        switch (call.method) {
            case Const.NotificationMethod.methodShow:
                final String title = call.argument("title");
                final String author = call.argument("author");
                final boolean play = call.argument("is_play");
                show(title,author, play);
                result.success(null);
                break;
            case Const.NotificationMethod.methodPlay:
                nPanel.updatePlayButton(true);
                result.success(null);
                break;
            case Const.NotificationMethod.methodPause:
                nPanel.updatePlayButton(false);
                result.success(null);
                break;
            case Const.NotificationMethod.methodUpdateTitle:
                final String titleUpdate = call.argument("title");
                nPanel.updateTitle(titleUpdate);
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    public void callEvent(NotifiEvent event) {
        switch (event) {
            case BACK:
                mResult.success("back");
                break;
            case NEXT:
                mResult.success("next");
                break;
            case PLAY:
                mResult.success("play");
                break;
            case PAUSE:
                mResult.success("pause");
                break;
            default:
                break;
        }
    }

    public void show(String title, String author,boolean play) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_ID, importance);
            channel.enableVibration(false);
            channel.setSound(null, null);
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }

        nPanel = new NotificationPanel(context, title,author, play);
    }

    private void hide() {
        nPanel.notificationCancel();
    }
}




