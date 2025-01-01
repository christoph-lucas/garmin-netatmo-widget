import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class GarminNetatmoWidgetApp extends Application.AppBase {

    private var netatmo as NetatmoAdapter;

    function initialize() {
        AppBase.initialize();
        self.netatmo = new NetatmoAdapter();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        self.netatmo.ensureAuthenticated();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new GarminNetatmoWidgetView(self.netatmo.getDefaultStation()) ];
        // TODO return data for all stations 
        //var data = self.netatmo.getAllStations();
        //var views = new [data.size()] as [Views];
        //for (var i = 0; i<data.size(); i++) {
        //    views[i] = new GarminNetatmoWidgetView(data[i]);
        //}
        //return views;
    }

}

function getApp() as GarminNetatmoWidgetApp {
    return Application.getApp() as GarminNetatmoWidgetApp;
}