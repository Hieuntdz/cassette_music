package com.example.notification;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.RemoteViews;
import androidx.core.app.NotificationCompat;
import com.example.cassettemusic.R;


public class NotificationPanel {


    private Context parent;
    private NotificationManager nManager;
    private NotificationCompat.Builder nBuilder;
    private RemoteViews remoteView;
    private String title;
    private String author;
    private boolean play;

    NotificationPanel(Context parent, String title, String author, boolean play) {

        Log.d("NotificationPanel","SHOWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");

        this.parent = parent;
        this.title = title;
        this.play = play;
        this.author = author;

        nBuilder = new NotificationCompat.Builder(parent, MediaNotificationPlugin.CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_stat_music_note)
                .setPriority(Notification.PRIORITY_DEFAULT)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC);

        remoteView = new RemoteViews(parent.getPackageName(), R.layout.notificationlayout);

        remoteView.setTextViewText(R.id.tv_sound_name, title);
        remoteView.setTextViewText(R.id.tv_author, author);

        if (this.play) {
            remoteView.setImageViewResource(R.id.toggle, R.drawable.ic_pause);
        } else {
            remoteView.setImageViewResource(R.id.toggle, R.drawable.ic_play);
        }

        setListeners(remoteView);
        nBuilder.setContent(remoteView);

        Notification notification = nBuilder.build();

        nManager = (NotificationManager) parent.getSystemService(Context.NOTIFICATION_SERVICE);
        nManager.notify(1, notification);
    }

    private void setListeners(RemoteViews view) {
        // Пауза/Воспроизведение
        Intent intent = new Intent(parent, NotificationReturnReceiver.class)
                .setAction("toggle")
                .putExtra("title", this.title)
                .putExtra("action", !this.play ? "play" : "pause");
        PendingIntent pendingIntent = PendingIntent.getBroadcast(parent, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.toggle, pendingIntent);

        // Вперед
        Intent nextIntent = new Intent(parent, NotificationReturnReceiver.class)
                .setAction("next");
        PendingIntent pendingNextIntent = PendingIntent.getBroadcast(parent, 0, nextIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.next, pendingNextIntent);

        // Назад
        Intent prevIntent = new Intent(parent, NotificationReturnReceiver.class)
                .setAction("prev");
        PendingIntent pendingPrevIntent = PendingIntent.getBroadcast(parent, 0, prevIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        view.setOnClickPendingIntent(R.id.prev, pendingPrevIntent);

        // Нажатие на уведомление
        Intent selectIntent = new Intent(parent, NotificationReturnReceiver.class)
                .setAction("select");
        PendingIntent selectPendingIntent = PendingIntent.getBroadcast(parent, 0, selectIntent, PendingIntent.FLAG_CANCEL_CURRENT);
        view.setOnClickPendingIntent(R.id.layout, selectPendingIntent);
    }


     void updateTitle(String title){
        remoteView.setTextViewText(R.id.title, title);
    }

     void updatePlayButton(boolean isPlay){
        if (isPlay) {
            remoteView.setImageViewResource(R.id.toggle, R.drawable.ic_pause);
        } else {
            remoteView.setImageViewResource(R.id.toggle, R.drawable.ic_play);
        }
    }

     void notificationCancel() {
        nManager.cancel(1);
    }
}

