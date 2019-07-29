package com.agora.flutter_app1.my.channel;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;

public class AndroidToFlutterPlugins implements EventChannel.StreamHandler {

    private FlutterActivity activity;

    private AndroidToFlutterPlugins(FlutterActivity activity) {
        this.activity = activity;
    }

    public static void registerWith(FlutterActivity activity) {
        AndroidToFlutterPlugins instance = new AndroidToFlutterPlugins(activity);
        //原生调用flutter
        EventChannel eventChannel = new EventChannel(activity.registrarFor(DealMethodCall.channels_native_to_flutter)
                .messenger(), DealMethodCall.channels_native_to_flutter);
        eventChannel.setStreamHandler(instance);
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        DealMethodCall.onListen(activity, o, eventSink);
    }

    @Override
    public void onCancel(Object o) {
        DealMethodCall.onCancel(activity, o);
    }
}
