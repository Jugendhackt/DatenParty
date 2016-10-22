package com.example.malte.app;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.akexorcist.roundcornerprogressbar.RoundCornerProgressBar;
import com.bumptech.glide.Glide;
import com.hanuor.pearl.Pearl;
import com.mindorks.placeholderview.Animation;
import com.mindorks.placeholderview.PlaceHolderView;
import com.mindorks.placeholderview.annotations.Animate;
import com.mindorks.placeholderview.annotations.Click;
import com.mindorks.placeholderview.annotations.Layout;
import com.mindorks.placeholderview.annotations.LongClick;
import com.mindorks.placeholderview.annotations.NonReusable;
import com.mindorks.placeholderview.annotations.Resolve;
import com.mindorks.placeholderview.annotations.View;
import com.mindorks.placeholderview.annotations.infinite.LoadMore;

import org.json.JSONArray;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Array;
import java.util.ArrayList;

@Animate(Animation.FADE_IN_ASC)
@NonReusable
@Layout(R.layout.item_in_list)

public class Item {


    @View(R.id.title)
    private TextView title;

    @View(R.id.descripton)
    private TextView descripton;

    @View(R.id.datetv)
    private TextView timeTextView;

    @View(R.id.srctv)
    private TextView srcTextView;

    @View(R.id.activity_photo)
    private ImageView imageView;


    @View(R.id.progressBar123)
    private RoundCornerProgressBar progressBar;

    @View(R.id.textProgress)
    private TextView textToShowTheProgress;


    private String mtextTitle;
    private String mtextContext;
    private String mdate;
    private String msrc;
    private Context mContext;
    private PlaceHolderView mPlaceHolderView;
    private String murl;
    private ArrayList<Integer> mar ;
    private PlaceHolderView mView;

    public Item(Context context, PlaceHolderView placeHolderView, String url, String text, String contexttext, String srcText, String dateText,ArrayList<Integer> ar, PlaceHolderView view) {
        mContext = context;
        mPlaceHolderView = placeHolderView;
        mtextTitle = text;
        mtextContext = contexttext;
        mdate = dateText;
        msrc = srcText;

        murl = url;
        mar = ar;
        mView = view;
    }

    @Resolve
    private void onResolved() {
        Pearl.imageLoader(mContext,murl,imageView, R.drawable.logo);
        srcTextView.setText(msrc);
        title.setText(mtextTitle);
        descripton.setText(mtextContext);
        timeTextView.setText(mdate);

        progressBar.setMax(mar.get(0));
        progressBar.setProgress(mar.get(1));
        textToShowTheProgress.setText(mar.get(1) + " / " + mar.get(0));
    }



    @LoadMore
    private void loadMore(){

    }

    @LongClick(R.id.title)
    private void onLongClick(){
        mPlaceHolderView.removeView(this);
    }

    @Click(R.id.buttonYes)
    private void onClickYes(){
        mar.set(1, mar.get(1)+1);
        mar.set(0, mar.get(0)+1);
        mView.refresh();
    }


    @Click(R.id.buttonNo)
    private void onClickNo(){
        mar.set(0, mar.get(0)+1);
        mView.refresh();
    }

}
