import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

typedef DataLoader as Method(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void;

class GarminNetatmoWidgetApp extends Application.AppBase {

    private var _service as NetatmoService;

    public function initialize() {
        AppBase.initialize();
        var netatmoClientAuthRaw = Application.loadResource(Rez.JsonData.netatmoClientAuth) as Dictionary<String, String>;
        var netatmoClientAuth = new NetatmoClientAuth(netatmoClientAuthRaw["id"], netatmoClientAuthRaw["secret"]);

        self._service = new NetatmoService(netatmoClientAuth);
    }

    public function onStart(state as Dictionary?) as Void { }

    public function onStop(state as Dictionary?) as Void { }

    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new InitialView(self._service), new InitialViewDelegate(self._service) ];
    }

    public function  getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView, WatchUi.GlanceViewDelegate ] or Null {
        // https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getGlanceView-instance_function
        return [ new GlanceView(self._service) ];
    }

}

function getApp() as GarminNetatmoWidgetApp {
    return Application.getApp() as GarminNetatmoWidgetApp;
}