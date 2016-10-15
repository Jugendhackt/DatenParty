package com.example.malte.app;

import android.graphics.drawable.Drawable;
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

            mGalleryView
                    .addView(new Item(this.getApplicationContext(), mGalleryView, getResources().getDrawable(R.drawable.bild), "Trump lästerte über Sex mit Lindsay Lohan" , "„Sie ist vermutlich in einer Krise und darum super im Bett“", "@bild", "15.10.16"));

    }
}
