package com.example.malte.app;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.mindorks.placeholderview.PlaceHolderView;

import org.json.*;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        PlaceHolderView mGalleryView = (PlaceHolderView) findViewById(R.id.galleryView);

        try {
            InputStream stream = getResources().openRawResource(R.raw.tweets);
            InputStreamReader reader = new InputStreamReader(stream);
            BufferedReader bufferedReader = new BufferedReader(reader);
            String line;
            StringBuilder text = new StringBuilder();
            try {
                while (( line = bufferedReader.readLine()) != null) {
                    text.append(line);
                    text.append('\n');
                }
            } catch (Exception e) {
                Log.e("DatenParty", "Exception");
            }
            JSONArray jArray = new JSONArray(text.toString());
            for (int i=0; i < jArray.length(); i++) {
                JSONObject oneObject = jArray.getJSONObject(i);
                String profilname = oneObject.getString("profilname");
                String tweet = oneObject.getString("tweet");
                String tweetid = oneObject.getString("tweetid");
                String tweetlink = oneObject.getString("tweetlink");
                String profilimage = oneObject.getString("profilimage");
                String date = oneObject.getString("date");
                int yes = oneObject.getInt("yes");
                int no = oneObject.getInt("no");
                int total = yes+no;
                ArrayList<Integer> list = new ArrayList<>();
                list.add(total);
                list.add(yes);

                String pattern = "HH:mm:ss";
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                Date daten = sdf.parse(date);

                SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
                mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView,
                        profilimage, profilname, tweet, "", dateFormat.format(daten), list, mGalleryView));
            }
        } catch (Exception e){
            e.printStackTrace();
        }
    }
    
    private void out(String x) {
        Log.d("DatenParty", x);
    }
}
