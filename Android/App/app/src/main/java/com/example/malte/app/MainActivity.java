package com.example.malte.app;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.mindorks.placeholderview.PlaceHolderView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        PlaceHolderView mGalleryView = (PlaceHolderView) findViewById(R.id.galleryView);

// (Optional): If customisation is Required then use Builder with the PlaceHolderView
// placeHolderView.getBuilder()
//      .setHasFixedSize(false)
//      .setItemViewCacheSize(10)
//      .setLayoutManager(new GridLayoutManager(this, 3));


        try {
           // JSONObject jObject = new JSONObject(result);
            InputStream stream = getResources().openRawResource(R.raw.tweets);
            
            Log.d("DatenParty", str);
            JSONArray jArray = new JSONArray(str);//jObject.getJSONArray("");
            for (int i=0; i < jArray.length(); i++) {
                JSONObject oneObject = jArray.getJSONObject(i);
                String profilname = oneObject.getString("profilname");
                String tweet = oneObject.getString("tweet");
                String tweetid = oneObject.getString("tweetid");
                String tweetlink = oneObject.getString("tweetlink");
                String profilimage = oneObject.getString("profilimage");
                String date = oneObject.getString("date");

//                DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ", Locale.ENGLISH);
//                String datum = format.parse(date).toString();
                String dateString = "2010-03-01T00:00:00-08:00";
                String pattern = "yyyy-MM-dd'T'HH:mm:ss";
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                Date daten = sdf.parse(date);

                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                   // Date newdate = new Date();
                mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView,
                        profilimage, profilname, tweet, "", dateFormat.format(daten), getVotes()));
            }

//            String profilname = jObject.getString("profilname");
  //          String

        } catch (Exception e){
            e.printStackTrace();
        }

        //mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.bild), "Trump lästerte über Sex mit Lindsay Lohan" , "„Sie ist vermutlich in einer Krise und darum super im Bett“", "@bild", "15.10.16", har));
       // mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.tagesschow), "Bundesliga" , "„Köln bleibt auf Champions-League-Kurs“", "@tagesschau", "15.10.16", getVotes()));


       // mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.bild), "Süßlicher Geruch in der Luft" , "„Drogenplantage bei Löscharbeiten gefunden“", "@bild", "14.10.16",getVotes()));

    }
    private ArrayList<Integer> getVotes() {
        int x;
        int y;
        do {
            x = (int) (Math.random() * 100);
            y = (int) (Math.random() * 100);
        } while (x < y);
        ArrayList<Integer> ar = new ArrayList<>();
        ar.add(x); // 0
        ar.add(y); // 1

        return ar;
    }

    private <T> void out(T... x) {
        System.out.println(Arrays.toString(x));
    }
}
