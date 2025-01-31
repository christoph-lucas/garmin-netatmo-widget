import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Background;
import Toybox.Time;

typedef DataLoader as Method(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void;

(:glance, :background)
class GarminNetatmoWidgetApp extends Application.AppBase {

    private var _service as WeatherStationService;

    public function initialize() {
        AppBase.initialize();
        var netatmoClientAuthRaw = Application.loadResource(Rez.JsonData.netatmoClientAuth) as Dictionary<String, String>;
        var netatmoClientAuth = new NetatmoClientAuth(netatmoClientAuthRaw["id"] as String, netatmoClientAuthRaw["secret"] as String);
        var config = new Config(
            Properties.getValue("showTemp") as Boolean,
            Properties.getValue("showCO2") as Boolean,
            Properties.getValue("showHumidity") as Boolean,
            Properties.getValue("showPressure") as Boolean,
            Properties.getValue("showNoise") as Boolean,
            Properties.getValue("activateBackgroundLoading") as Boolean,
            Properties.getValue("backgroundRefreshInterval") as Number
        );

        // Dependency Injection
        var cache = new StationsDataCache();
        var connectionsFactory = new NetatmoConnectionsOrchastratorFactory(netatmoClientAuth, cache);
        var repo = new NetatmoRepository(cache, connectionsFactory);
        self._service = new WeatherStationService(config, repo);

        // Backgrounding: https://developer.garmin.com/connect-iq/core-topics/backgrounding/
        if (config.activateBackgroundLoading()) {
            Background.registerForTemporalEvent(new Time.Duration(config.backgroundRefreshInterval() * 60));
        } else {
            Background.deleteTemporalEvent();
        }
    }

    public function onStart(state as Dictionary?) as Void { }

    public function onStop(state as Dictionary?) as Void { }

    (:typecheck([disableBackgroundCheck, disableGlanceCheck]))
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        return getLoadingView(self._service);
    }

    (:typecheck(disableBackgroundCheck))
    public function  getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView, WatchUi.GlanceViewDelegate ] or Null {
        // https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getGlanceView-instance_function
        return getNetatmoGlanceView(self._service);
    }

    (:typecheck(disableGlanceCheck))
    public function getServiceDelegate() as [System.ServiceDelegate] {
        return [new BackgroundDelegate(self._service)];
    }
}

(:background)
class BackgroundDelegate extends System.ServiceDelegate {

    private var _service as WeatherStationService;

    public function initialize(service as WeatherStationService) {
        System.ServiceDelegate.initialize();
        self._service = service;
    }

    public function onTemporalEvent() as Void {
        self._service.loadStationDataInBackground(method(:onDataReceived), method(:onNotificationReceived));
    }

    // DataConsumer
    public function onDataReceived(data as NetatmoStationsData) as Void {
        // FIXME trigger display update in Glance View and StationsDataView
        // -> not so easy since it does not exist in the app, would require a publisher observer, probably in the Service (the views register themselves as observer, services publishes "new data" events)
        // -> not sure if it is worth it, since most people will not keep the app open
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