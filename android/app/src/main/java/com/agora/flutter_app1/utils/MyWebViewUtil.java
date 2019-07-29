package com.agora.flutter_app1.utils;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;


import static android.content.ContentValues.TAG;

/**
 * Created by Administrator on 2018-09-06.
 */

public class MyWebViewUtil {

    MyWebViewUtil myWebView;
    String APP_CACAHE_DIRNAME = "cache";



    public  MyWebViewUtil getInstance(){
        if(myWebView == null){
            myWebView = new MyWebViewUtil();
        }
        return myWebView;
    }

    /**
     * webview的相关设置
     * @param webview
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void setWebview(WebView webview){

        webview.setHorizontalScrollBarEnabled(false);//水平滚动条不显示
        webview.setVerticalScrollBarEnabled(false); //垂直滚动条不显示

        webview.getSettings().setJavaScriptEnabled(true);//启用JavaScript
        webview.getSettings().setBlockNetworkImage(false);//解决图片不显示
        webview.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        //加载H5页面时，添加对一些标签的支持
        webview.getSettings().setLoadWithOverviewMode(true); //缩放至屏幕大小
        webview.getSettings().setUseWideViewPort(true); //将图片调整到适合webview的大小
        webview.getSettings().setSupportZoom(false);            //是否支持缩放，默认为true。是下面那个的前提。
        webview.getSettings().setBuiltInZoomControls(false);    //设置内置的缩放控件。若为false，则该WebView不可缩放
        webview.getSettings().setDisplayZoomControls(true);     //隐藏原生缩放控件
        webview.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);      //支持通过JS打开新窗口
        webview.getSettings().setAllowFileAccess(true);     //设置可以访问文件
        webview.getSettings().setDomStorageEnabled(true);
        if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP) {
            webview.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }
        webview.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return super.shouldOverrideUrlLoading(view, url);
            }

        });
    }

    @TargetApi(Build.VERSION_CODES.ECLAIR_MR1)
    public void setWebviewCache(WebView webview, Context context){
        /*---------------------------------缓存的相关设置-----------------------------*/
        webview.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT); //设置 缓存模式
        // 开启 DOM storage API 功能
        webview.getSettings().setDomStorageEnabled(true);
        //开启 database storage API 功能
        webview.getSettings().setDatabaseEnabled(true);
        String cacheDirPath = FileUtils.getBasePath(context)+APP_CACAHE_DIRNAME;
        // String cacheDirPath = getCacheDir().getAbsolutePath()+Constant.APP_DB_DIRNAME;
        Log.i(TAG, "cacheDirPath="+cacheDirPath);
        //设置数据库缓存路径 webview.getSettings().setDatabasePath(cacheDirPath);
        //设置 Application Caches 缓存目录
        webview.getSettings().setAppCachePath(cacheDirPath);
        //开启 Application Caches 功能
        webview.getSettings().setAppCacheEnabled(true);
    }
    public void clearWebCache(WebView webView,Context context){

        try {
            CookieSyncManager.createInstance(context);  //Create a singleton CookieSyncManager within a context
            CookieManager cookieManager = CookieManager.getInstance(); // the singleton CookieManager instance
            cookieManager.removeAllCookie();// Removes all cookies.
            CookieSyncManager.getInstance().sync(); // forces sync manager to sync now

            webView.setWebChromeClient(null);
            webView.setWebViewClient(null);
            webView.getSettings().setJavaScriptEnabled(false);
            webView.clearCache(true);
            webView.stopLoading();
            webView.clearHistory();
            webView.loadUrl("about:blank");
            webView.pauseTimers();
            webView = null;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
