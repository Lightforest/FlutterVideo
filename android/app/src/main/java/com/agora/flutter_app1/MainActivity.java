package com.agora.flutter_app1;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.TextView;

import com.agora.flutter_app1.my.channel.MyChannelUtil;
import com.agora.flutter_app1.my.channel.MyMethodUtil;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Iterator;

import cn.jpush.android.api.CustomPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP)
        {//API>21,设置状态栏颜色透明
            getWindow().setStatusBarColor(0);
        }
        GeneratedPluginRegistrant.registerWith(this);
        creatJpushChannel(this.registrarFor(MyChannelUtil.CHANNEL_start_custom_jpush));
        createReceiver();
        creatJpushChanne2(this.registrarFor(MyChannelUtil.CHANNEL_start_play_bell));
    }
    /*----------------------------------jpush-------------------------------------------*/
    private void creatJpushChannel(PluginRegistry.Registrar registrar){
        // 直接 new MethodChannel，然后设置一个Callback来处理Flutter端调用
        MethodChannel methodChannel = new MethodChannel(getFlutterView(), MyChannelUtil.CHANNEL_start_custom_jpush);
        methodChannel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        // 在这个回调里处理从Flutter来的调用
                        //String method = methodCall.method;
                        startJpushSetting();
                    }
                });
    }
    TextView time;
    private void startJpushSetting(){
        //JPushInterface.init(this);
        // 指定定制的 Notification Layout
        CustomPushNotificationBuilder builder = new
                CustomPushNotificationBuilder(MainActivity.this,
                R.layout.view_notification_test,
                R.id.iv_notice_logo,
                R.id.tv_notice_title,
                R.id.tv_notice_content);
       /* View v = LayoutInflater.from(this).inflate(builder.layout,null);
         time = v.findViewById(R.id.time);*/
        //设置起始时间和时间格式，然后开始计时
        // 指定最顶层状态栏小图标
        // builder.statusBarDrawable = R.drawable.your_notification_icon;
        // 指定下拉状态栏时显示的通知图标
        //builder.layoutIconDrawable = R.drawable.your_2_notification_icon;
        JPushInterface.setPushNotificationBuilder(2, builder);
    }
    private void createReceiver(){
        IntentFilter filter = new IntentFilter();
        filter.addAction("cn.jpush.android.intent.REGISTRATION");
        filter.addAction("cn.jpush.android.intent.MESSAGE_RECEIVED");
        filter.addAction("cn.jpush.android.intent.NOTIFICATION_RECEIVED");
        filter.addAction("cn.jpush.android.intent.NOTIFICATION_OPENED");
        filter.addAction("cn.jpush.android.intent.CONNECTION");
        filter.addCategory("com.agora.flutter_app");
        MyJpushReceiver receiver = new MyJpushReceiver();
        //注册广播接收
        registerReceiver(receiver,filter);
    }
    class MyJpushReceiver extends BroadcastReceiver {
        private static final String TAG = "JIGUANG-Example";

        @Override
        public void onReceive(Context context, Intent intent) {
            try {
                Bundle bundle = intent.getExtras();
                //Logger.d(TAG, "[MyReceiver] onReceive - " + intent.getAction() + ", extras: " + printBundle(bundle));

                if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
                    String regId = bundle.getString(JPushInterface.EXTRA_REGISTRATION_ID);
                    //Logger.d(TAG, "[MyReceiver] 接收Registration Id : " + regId);
                    //send the Registration Id to your server...

                } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
                    //Logger.d(TAG, "[MyReceiver] 接收到推送下来的自定义消息: " + bundle.getString(JPushInterface.EXTRA_MESSAGE));
                    processCustomMessage(context, bundle);

                } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
                    //Logger.d(TAG, "[MyReceiver] 接收到推送下来的通知");
                    int notifactionId = bundle.getInt(JPushInterface.EXTRA_NOTIFICATION_ID);
                    //Logger.d(TAG, "[MyReceiver] 接收到推送下来的通知的ID: " + notifactionId);

                } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
                    //Logger.d(TAG, "[MyReceiver] 用户点击打开了通知");

                    //打开自定义的Activity
//				Intent i = new Intent(context, TestActivity.class);
//				i.putExtras(bundle);
//				//i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//				i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP );
//				context.startActivity(i);

                } else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
                    //Logger.d(TAG, "[MyReceiver] 用户收到到RICH PUSH CALLBACK: " + bundle.getString(JPushInterface.EXTRA_EXTRA));
                    //在这里根据 JPushInterface.EXTRA_EXTRA 的内容处理代码，比如打开新的Activity， 打开一个网页等..

                } else if(JPushInterface.ACTION_CONNECTION_CHANGE.equals(intent.getAction())) {
                    boolean connected = intent.getBooleanExtra(JPushInterface.EXTRA_CONNECTION_CHANGE, false);
                    //Logger.w(TAG, "[MyReceiver]" + intent.getAction() +" connected state change to "+connected);
                } else {
                    //Logger.d(TAG, "[MyReceiver] Unhandled intent - " + intent.getAction());
                }
            } catch (Exception e){

            }

        }

        // 打印所有的 intent extra 数据
        private  String printBundle(Bundle bundle) {
            StringBuilder sb = new StringBuilder();
            for (String key : bundle.keySet()) {
                if (key.equals(JPushInterface.EXTRA_NOTIFICATION_ID)) {
                    sb.append("\nkey:" + key + ", value:" + bundle.getInt(key));
                }else if(key.equals(JPushInterface.EXTRA_CONNECTION_CHANGE)){
                    sb.append("\nkey:" + key + ", value:" + bundle.getBoolean(key));
                } else if (key.equals(JPushInterface.EXTRA_EXTRA)) {
                    if (TextUtils.isEmpty(bundle.getString(JPushInterface.EXTRA_EXTRA))) {
                        //Logger.i(TAG, "This message has no Extra data");
                        continue;
                    }

                    try {
                        JSONObject json = new JSONObject(bundle.getString(JPushInterface.EXTRA_EXTRA));
                        Iterator<String> it =  json.keys();

                        while (it.hasNext()) {
                            String myKey = it.next();
                            sb.append("\nkey:" + key + ", value: [" +
                                    myKey + " - " +json.optString(myKey) + "]");
                        }
                    } catch (JSONException e) {
                        //Logger.e(TAG, "Get message extra JSON error!");
                    }

                } else {
                    sb.append("\nkey:" + key + ", value:" + bundle.get(key));
                }
            }
            return sb.toString();
        }

        //send msg to MainActivity
        private void processCustomMessage(Context context, Bundle bundle) {
		/*if (MainActivity.isForeground) {
			String message = bundle.getString(JPushInterface.EXTRA_MESSAGE);
			String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
			Intent msgIntent = new Intent(MainActivity.MESSAGE_RECEIVED_ACTION);
			msgIntent.putExtra(MainActivity.KEY_MESSAGE, message);
			if (!ExampleUtil.isEmpty(extras)) {
				try {
					JSONObject extraJson = new JSONObject(extras);
					if (extraJson.length() > 0) {
						msgIntent.putExtra(MainActivity.KEY_EXTRAS, extras);
					}
				} catch (JSONException e) {

				}

			}
			LocalBroadcastManager.getInstance(context).sendBroadcast(msgIntent);
		}*/
        }
    }
    /*--------------------------------系统铃声----------------------------------*/
    private void creatJpushChanne2(PluginRegistry.Registrar registrar){
        // 直接 new MethodChannel，然后设置一个Callback来处理Flutter端调用
        MethodChannel methodChannel = new MethodChannel(getFlutterView(), MyChannelUtil.CHANNEL_start_play_bell);
        methodChannel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        // 在这个回调里处理从Flutter来的调用
                        String method = methodCall.method;
                        if(!TextUtils.isEmpty(method)){
                            if(method.equals(MyMethodUtil.startPlayBell)){
                                startPlayBell2();
                            }else if(method.equals(MyMethodUtil.stopPlayBell)){
                                stopPlayBell();
                            }
                        }
                    }
                });
    }
    MediaPlayer mediaPlayer;
    private  float BEEP_VOLUME = 9.10f;
    MediaPlayer.OnCompletionListener beepListener;
    Ringtone ringtone;
    private void startPlayBell(){
        try {
            Uri uri = RingtoneManager.getActualDefaultRingtoneUri(this,RingtoneManager.TYPE_ALL);
            ringtone = RingtoneManager.getRingtone(MainActivity.this, uri);
            ringtone.play();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private void startPlayBell2(){
        if(beepListener == null){
            beepListener = new MediaPlayer.OnCompletionListener() {
                // 声音
                public void onCompletion(MediaPlayer mediaPlayer) {
                    mediaPlayer.seekTo(0);
                }
            };
        }

            mediaPlayer = new MediaPlayer();
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mediaPlayer.setOnCompletionListener(beepListener);
            mediaPlayer.setLooping(true);

            AssetFileDescriptor file = getResources().openRawResourceFd(R.raw.wechat_video);
            try {
                mediaPlayer.setDataSource(file.getFileDescriptor(), file.getStartOffset(), file.getLength());
                file.close();
                mediaPlayer.setVolume(BEEP_VOLUME, BEEP_VOLUME);
                mediaPlayer.prepare();
            } catch (IOException e) {
                mediaPlayer = null;
            }
       // }
        if(mediaPlayer != null){
            mediaPlayer.start();
        }
    }
    private void stopPlayBell(){
        if(mediaPlayer != null){
            mediaPlayer.stop();
            mediaPlayer.release();
        }
        if(ringtone != null){
            ringtone.stop();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(mediaPlayer != null){
            mediaPlayer.release();
        }
    }
}
