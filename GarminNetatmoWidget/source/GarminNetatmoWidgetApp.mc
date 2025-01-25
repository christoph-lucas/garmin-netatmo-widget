import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Background;
import Toybox.Time;

typedef DataLoader as Method(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void;

(:glance, :background)
class GarminNetatmoWidgetApp extends Application.AppBase {

    private var _service as NetatmoService;

    public function initialize() {
        AppBase.initialize();
        var netatmoClientAuthRaw = Application.loadResource(Rez.JsonData.netatmoClientAuth) as Dictionary<String, String>;
        var netatmoClientAuth = new NetatmoClientAuth(netatmoClientAuthRaw["id"], netatmoClientAuthRaw["secret"]);
        var config = new Config(
            Properties.getValue("showTemp"),
            Properties.getValue("showCO2"),
            Properties.getValue("showHumidity"),
            Properties.getValue("showPressure"),
            Properties.getValue("showNoise")
        );

        // Dependency Injection
        var cache = new StationsDataCache();
        var connectionsFactory = new NetatmoConnectionsOrchastratorFactory(netatmoClientAuth, cache);
        var repo = new NetatmoRepository(cache, connectionsFactory);
        self._service = new NetatmoService(config, repo);

        // Backgrounding: https://developer.garmin.com/connect-iq/core-topics/backgrounding/
        // TODO: make configurable via properties: activate background at all -> use Background.deleteTemporalEvent() otherwise
        // TODO: make configurable via properties: refresh period
        Background.registerForTemporalEvent(new Time.Duration(10 * 60));
    }

    public function onStart(state as Dictionary?) as Void { }

    public function onStop(state as Dictionary?) as Void { }

    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return getLoadingView(self._service);
    }

    public function  getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView, WatchUi.GlanceViewDelegate ] or Null {
        // https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getGlanceView-instance_function
        return getNetatmoGlanceView(self._service);
    }

    public function getServiceDelegate() as [System.ServiceDelegate] {
        return [new BackgroundDelegate(self._service)];
    }
}

(:background)
class BackgroundDelegate extends System.ServiceDelegate {

    private var _service as NetatmoService;

    public function initialize(service as NetatmoService) {
        System.ServiceDelegate.initialize();
        self._service = service;
    }

    public function onTemporalEvent() as Void {
        self._service.loadStationDataInBackground(method(:onDataReceived), method(:onNotificationReceived));
    }

    // DataConsumer
    public function onDataReceived(data as NetatmoStationsData) as Void {
        // TODO trigger display update in Glance View and StationsDataView
        Background.exit(true);
    }

    // NotificationConsumer
    public function onNotificationReceived(notification as Notification) as Void {
        if (notification instanceof NetatmoError) {
            // cannot load data for some reason
            Background.exit(false);
        }
        // ignore other notifications
    }
}

function getApp() as GarminNetatmoWidgetApp {
    return Application.getApp() as GarminNetatmoWidgetApp;
}