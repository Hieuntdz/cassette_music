package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        String s = "https://www.youtube.com/watch?v=7C7pkK98Zgk";
        String replace = "<a href =\"" + s + "\">" + s + "</a>";
        String s2 = "https://www.24h.com.vn/tin-tuc-trong-ngay/nhung-quy-dinh-ve-cach-ly-xa-hoi-tu-16-4-nguoi-dan-can-biet-c46a1141223.html";
        Log.d("XXXXXXXXXX", "S : " + s.replace(s,replace));
        Log.d("XXXXXXXXXX","S2 : " +s2.replace(s2,"ABCD"));
    }
}
