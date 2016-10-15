package com.example.malte.app;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;

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

/**
 * Created by blackpython on 10/15/16.
 */
@Animate(Animation.ENTER_LEFT_DESC)
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

    private String mtextTitle;
    private String mtextContext;
    private String mdate;
    private String msrc;
    private Context mContext;
    private PlaceHolderView mPlaceHolderView;
    private Drawable mlogo;

    public Item(Context context, PlaceHolderView placeHolderView, Drawable logo, String text, String contexttext, String srcText, String dateText) {
        mContext = context;
        mPlaceHolderView = placeHolderView;
        mtextTitle = text;
        mtextContext = contexttext;
        mdate = dateText;
        msrc = srcText;
        mlogo = logo;
    }

    @Resolve
    private void onResolved() {
      //  Glide.with(mContext).load(mUlr).into(imageView);
        srcTextView.setText(msrc);
        title.setText(mtextTitle);
        descripton.setText(mtextContext);
        timeTextView.setText(mdate);
        imageView.setImageDrawable(mlogo);
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
        Log.i("yes", "yes");
    }

    @Click(R.id.buttonNo)
    private void onClickNo(){
        Log.i("No", "No");
//        mPlaceHolderView.removeView(Item.this);
    }

}
