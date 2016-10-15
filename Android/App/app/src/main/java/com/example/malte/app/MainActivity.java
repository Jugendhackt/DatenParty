package com.example.malte.app;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.mindorks.placeholderview.PlaceHolderView;

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

        for (int i = 0; i < 100; i++) {
            mGalleryView
                    .addView(new Item(this.getApplicationContext(), mGalleryView, "lalalaa" + i, "test", "@Bild", "10.01.16"));
        }
    }
}
