import Toybox.WatchUi;
import Toybox.Lang;

function navigateToStationsDataView(data as NetatmoStationsData, service as NetatmoService) as Void {
    var loop = new ViewLoop(new NetatmoStationsViewFactory(data, service), null);
    WatchUi.switchToView(loop, new ViewLoopDelegate(loop), WatchUi.SLIDE_LEFT);
}

class NetatmoStationsViewFactory extends ViewLoopFactory {

    private var _allViews as Array<StationView>;
    private var _service as NetatmoService;

    public function initialize(stationsData as NetatmoStationsData, service as NetatmoService) {
        ViewLoopFactory.initialize();

        self._service = service;

        var allStations = stationsData.allStations();
        self._allViews = new[allStations.size()] as Array<StationView>;
        for (var i = 0; i < allStations.size(); i++) {
            self._allViews[i] = new StationView(allStations[i]);
        }
    }

    public function getSize() as Number {
        return self._allViews.size();
    }

    public function getView(page as Number) as [ View ] or [ View, BehaviorDelegate ]  {
        return [self._allViews[page], new StationsViewDelegate(self._service)];
    }
}

class StationsViewDelegate extends BehaviorDelegate {
    // see https://forums.garmin.com/developer/connect-iq/f/discussion/371941/switching-between-views
    // some Delegate is needed in the getView() call above, otherwise an Array out of Bounds error is thrown

    private var _service;

    public function initialize(service as NetatmoService) {
        BehaviorDelegate.initialize();
        self._service = service;
    }

    public function onSelect() as Boolean {
        var menu = new WatchUi.Menu2({:title => "Menu"});

        menu.addItem(new WatchUi.MenuItem("Reload", "Reload stations data.", "reload", null));
        menu.addItem(new WatchUi.MenuItem("Reauth", "Reauthenticate with Netatmo.", "reauth", null));
        WatchUi.pushView(menu, new GenericMenuDelegate(method(:onMenuItemSelected)), WatchUi.SLIDE_UP);
        return true;
    }

    public function onMenuItemSelected(item as MenuItem) as Void {
        switch(item.getId()) {
            case "reload":
                // FIXME when we have a cache, then we would have to call "clear cache" on the service
                break;
            case "reauth":
                self._service.dropAuthenticationData();
                break;
        }
        WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
        navigateToLoadingView(self._service);
    }
}
