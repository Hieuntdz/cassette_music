package com.example.cassettemusic

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.media.MediaMetadataRetriever
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import com.example.audioplayers.AudioPlayersPlugin
import com.example.notification.MediaNotificationPlugin
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.*

class MainActivity : FlutterActivity() {
    val TAG = "MainActivity TAG";
    private val CHANNEL = "CHANNEL_GET_AUDIO_LIST"
    val RUNTIME_PERMISSION_CODE = 7
    var fileAudioList = ArrayList<AudioModel>()
    val rootPath = Environment.getExternalStorageDirectory().absolutePath
    var audioListResult: MethodChannel.Result? = null
    var permisionSuccess = false
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AudioPlayersPlugin.registerWith(flutterEngine.dartExecutor.binaryMessenger,this)
        MediaNotificationPlugin.registerWith(flutterEngine.dartExecutor.binaryMessenger,this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            audioListResult = result
            if (call.method == "getAudioList") {
                fileAudioList.clear()
                getAudioList()
                if (permisionSuccess) {
                    result.success(Gson().toJson(fileAudioList))
//                    result.success(fileAudioList.size)
                }
            }
        }
    }

    private fun getAudioList() {
        print(TAG + "getAudioList")
        Log.d(TAG, "getAudioList")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) !== PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(
                        this@MainActivity, arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE), RUNTIME_PERMISSION_CODE
                )
            } else {
                permisionSuccess = true
                getPlayList(rootPath)
            }
        } else {
            permisionSuccess = true
            getPlayList(rootPath)
        }
    }

    @SuppressLint("NewApi")
    private fun getPlayList(rootPath: String?) {
        Log.d(TAG, "getPlayList")
        try {
            val rootFolder = File(rootPath)
            val files = rootFolder.listFiles() //here you will get NPE if directory doesn't contains  any file,handle it like this.
            for (file in files) {
                if (file.isDirectory && file.name != "Android") {
                    getPlayList(file.absolutePath)
                } else if (file.name.endsWith(".mp3")) {
                    val audioModel = AudioModel()
                    var name: String = file.name;
                    name = name.substring(0, name.lastIndexOf(".mp3"))
                    audioModel.name = name
                    audioModel.path = file.absolutePath
                    //                    Log.d("BBBBBBBBBBBBBBBBBBBBBB ", file.getName());
                    val metaRetriver = MediaMetadataRetriever()
                    metaRetriver.setDataSource(file.path)

                    audioModel.album = metaRetriver.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM)
                            ?: ""
                    audioModel.artist = metaRetriver.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST)
                            ?: ""
                    audioModel.genre = metaRetriver.extractMetadata(MediaMetadataRetriever.METADATA_KEY_GENRE)
                            ?: ""
                    audioModel.folder = file.parentFile.name
                    val durationStr: String = metaRetriver.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
                    val millSecond = durationStr.toInt()
                    audioModel.duartion = millSecond;

                    fileAudioList.add(audioModel)
                }
            }
        } catch (e: Exception) {
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            RUNTIME_PERMISSION_CODE -> {
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    getPlayList(rootPath)
                    audioListResult?.success(Gson().toJson(fileAudioList))
                } else {
                    audioListResult?.success(Gson().toJson(fileAudioList))
                }
            }
        }
    }
}
