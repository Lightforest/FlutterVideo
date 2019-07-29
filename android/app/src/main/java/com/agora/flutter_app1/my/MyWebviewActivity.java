package com.agora.flutter_app1.my;

import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.LinearLayout;

import com.agora.flutter_app1.my.channel.MyChannelUtil;
import com.agora.flutter_app1.my.channel.MyMethodUtil;
import com.agora.flutter_app1.utils.MyWebViewUtil;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MyWebviewActivity extends Activity {

  private WebView webView;
  String  webUri;
  MethodChannel methodChannel;
  BinaryMessenger messenger;


  public MyWebviewActivity(BinaryMessenger messenger) {
    this.messenger = messenger;
  }
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.MATCH_PARENT);
    LinearLayout lineLayout = new LinearLayout(this);
    lineLayout.setOrientation(LinearLayout.VERTICAL);
    lineLayout.setLayoutParams(params);
    lineLayout.setGravity(Gravity.TOP );
    addView(lineLayout);
    setContentView(lineLayout);
    creatMethodChannel();
  }
  private void addView(final LinearLayout lineLayout){
    webView = new WebView(this);
    //添加文本到主布局
    lineLayout.addView(webView );
  }
  private void setWebView(){
    MyWebViewUtil myWebView = new MyWebViewUtil();
    myWebView.setWebview(webView);
    webView.addJavascriptInterface(new JsInteraction(), "android");
    webView.loadUrl(webUri);
  }
  /**
   * JS交互的类
   */
  public class JsInteraction {

    //供Js调用的方法:在第一层HTML中返回到APP
    @JavascriptInterface
    public void returnApp(){
      // finish();
    }
    @JavascriptInterface
    public void startIdentifyFace(String idcardPic){
      methodChannel.invokeMethod(MyMethodUtil.toFlutterFace,idcardPic);
    }
    @JavascriptInterface
    public void startIdentifyQRcode(String jsonStr){
      methodChannel.invokeMethod(MyMethodUtil.toFlutterQRCode,jsonStr);
    }
    @JavascriptInterface
    public void startIdentifyIDCard(){
      methodChannel.invokeMethod(MyMethodUtil.toFlutterIDCard,null);
    }
  }
  private void creatMethodChannel(){
    // 直接 new MethodChannel，然后设置一个Callback来处理Flutter端调用
    methodChannel = new MethodChannel(messenger, MyChannelUtil.CHANNEL_start_custom_jpush);
    methodChannel.setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                // 在这个回调里处理从Flutter来的调用
                String method = methodCall.method;
                switch (method){
                  case MyMethodUtil.getFlutterFaceResult:
                    try {
                      String result1 = (String) methodCall.arguments;
                    } catch (Exception e) {
                      e.printStackTrace();
                    }
                    break;
                  case MyMethodUtil.getFlutterIDCardResult:
                    try {
                      Map<String,String> result2 = (Map<String, String>) methodCall.arguments;
                      idcardResult(result2.get("idCard"),result2.get("name"),result2.get("idCardUrl"));
                    } catch (Exception e) {
                      e.printStackTrace();
                    }
                    break;
                }
              }
            });
  }
  private void idcardResult(String idcard_num,String idcard_name,String idcard_url){
    webView.loadUrl("javascript: identifyIDCardResult('" + idcard_num + "','" + idcard_name + "','" + idcard_url + "')");
  }
  private void faceResult(String result){
    webView.loadUrl("javascript: ScanFaceWebs('" + result + "')");
  }
}
