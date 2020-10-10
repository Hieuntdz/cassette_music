package com.example.notification;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

public class NotificationReturnReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        switch (intent.getAction()) {
            case "prev":
                MediaNotificationPlugin.getInstance().callEvent(NotifiEvent.BACK);
                break;
            case "next":
                MediaNotificationPlugin.getInstance().callEvent(NotifiEvent.NEXT);
                break;
            case "toggle":
//                String title = intent.getStringExtra("title");
//                String action = intent.getStringExtra("action");
                String action = intent.getStringExtra("action");
//
//                MediaNotificationPlugin.getInstance().show(title, action.equals("play"));
                if (action.equals("play")) {
                    MediaNotificationPlugin.getInstance().callEvent(NotifiEvent.PLAY);
                } else {
                    MediaNotificationPlugin.getInstance().callEvent(NotifiEvent.PAUSE);
                }
                break;
            case "select":
                Intent closeDialog = new Intent(Intent.ACTION_CLOSE_SYSTEM_DIALOGS);
                context.sendBroadcast(closeDialog);
                String packageName = context.getPackageName();
                PackageManager pm = context.getPackageManager();
                Intent launchIntent = pm.getLaunchIntentForPackage(packageName);
                context.startActivity(launchIntent);
//                MediaNotificationPlugin.callEvent("select");
                break;
            default:
                break;
        }
    }
}

