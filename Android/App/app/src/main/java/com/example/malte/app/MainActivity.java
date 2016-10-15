package com.example.malte.app;

import android.graphics.drawable.Drawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.mindorks.placeholderview.PlaceHolderView;

import java.util.ArrayList;

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

        ArrayList<Integer> har = getVotes();

        mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.bild), "Trump lästerte über Sex mit Lindsay Lohan" , "„Sie ist vermutlich in einer Krise und darum super im Bett“", "@bild", "15.10.16", har));
        mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.tagesschow), "Bundesliga" , "„Köln bleibt auf Champions-League-Kurs“", "@tagesschau", "15.10.16", getVotes()));


        mGalleryView.addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.bild), "Süßlicher Geruch in der Luft" , "„Drogenplantage bei Löscharbeiten gefunden“", "@bild", "14.10.16",getVotes()));

    }
    private ArrayList<Integer> getVotes(){

        int x;
        int y;
        do{
            x = (int) (Math.random() * 100);
            y = (int) (Math.random() * 100);
        }while (x < y);
        ArrayList<Integer> ar = new ArrayList<Integer>();
        ar.add(x); // 0
        ar.add(y); // 1

        return ar;
    }
}
