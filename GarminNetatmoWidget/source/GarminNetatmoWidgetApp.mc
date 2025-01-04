import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class GarminNetatmoWidgetApp extends Application.AppBase {

    private var _netatmo as NetatmoAdapter;
    private var _initialView as GarminNetatmoWidgetView;

    function initialize() {
        AppBase.initialize();
        var netatmoClientAuth = Application.loadResource(Rez.JsonData.netatmoClientAuth) as Dictionary<String, String>;
        self._netatmo = new NetatmoAdapter(netatmoClientAuth["id"], netatmoClientAuth["secret"], method(:onDataLoaded));
        self._initialView = new GarminNetatmoWidgetView();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        self._netatmo.loadStationData();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ self._initialView ];
    }

    public function onDataLoaded(data as NetatmoStationData?, error as NetatmoError?) {
        self._initialView.setData(data, error);
    }
}

function getApp() as GarminNetatmoWidgetApp {
    return Application.getApp() as GarminNetatmoWidgetApp;
}