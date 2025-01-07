import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

typedef DataLoader as Method(handler as DataConsumer) as Void;

class GarminNetatmoWidgetApp extends Application.AppBase {

    private var _netatmoClientAuth as NetatmoClientAuth;
    private var _initialView as GarminNetatmoWidgetView;
    private var _glanceView as GarminNetatmoWidgetGlanceView;

    public function initialize() {
        AppBase.initialize();
        var netatmoClientAuthRaw = Application.loadResource(Rez.JsonData.netatmoClientAuth) as Dictionary<String, String>;
        self._netatmoClientAuth = new NetatmoClientAuth(netatmoClientAuthRaw["id"], netatmoClientAuthRaw["secret"]);
        self._initialView = new GarminNetatmoWidgetView(method(:loadData));
        self._glanceView = new GarminNetatmoWidgetGlanceView(method(:loadData));
    }

    public function onStart(state as Dictionary?) as Void { }

    public function onStop(state as Dictionary?) as Void { }

    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ self._initialView ];
    }

    public function  getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView, WatchUi.GlanceViewDelegate ] or Null {
        // https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getGlanceView-instance_function
        return [ self._glanceView ];
    }

    public function loadData(handler as DataConsumer) as Void {
        new NetatmoAdapter(self._netatmoClientAuth, handler).loadStationData();
    }

}

function getApp() as GarminNetatmoWidgetApp {
    return Application.getApp() as GarminNetatmoWidgetApp;
}