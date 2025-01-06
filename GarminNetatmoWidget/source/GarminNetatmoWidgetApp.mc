import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class GarminNetatmoWidgetApp extends Application.AppBase {

    private var _netatmo as NetatmoAdapter;
    private var _initialView as GarminNetatmoWidgetView;
    private var _glanceView as GarminNetatmoWidgetGlanceView;

    function initialize() {
        AppBase.initialize();
        var netatmoClientAuth = Application.loadResource(Rez.JsonData.netatmoClientAuth) as Dictionary<String, String>;
        self._netatmo = new NetatmoAdapter(netatmoClientAuth["id"], netatmoClientAuth["secret"], method(:onDataLoaded));
        self._initialView = new GarminNetatmoWidgetView();
        self._glanceView = new GarminNetatmoWidgetGlanceView();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        self._netatmo.loadStationData();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ self._initialView ];
    }

    function  getGlanceView() as [ WatchUi.GlanceView ] or [ WatchUi.GlanceView, WatchUi.GlanceViewDelegate ] or Null {
        // https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getGlanceView-instance_function
        return [ self._glanceView ];
    }

    public function onDataLoaded(data as NetatmoStationsData?, error as NetatmoError?) as Void {
        var mainStation = null as NetatmoStationData?;
        if (data != null) {mainStation = data.device(0).mainStation();}
        self._initialView.setData(mainStation, error);
        self._glanceView.setData(mainStation);
    }
}

function getApp() as GarminNetatmoWidgetApp {
    return Application.getApp() as GarminNetatmoWidgetApp;
}