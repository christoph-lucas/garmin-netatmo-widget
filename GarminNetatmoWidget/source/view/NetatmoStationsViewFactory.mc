import Toybox.WatchUi;
import Toybox.Lang;

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
        WatchUi.pushView(menu, new StationsViewMenuDelegate(method(:onMenuItemSelected)), WatchUi.SLIDE_UP);
        return true;
    }

    public function onMenuItemSelected(item as MenuItem) as Void {
        // TODO conceptually, here we want to trigger any action on the service and then show the result
        // coincidentally the final action can always be to switch to the default view and reload the data
        // yet that would not have to be this way necessarily -> how would one do that without duplicating the default view
        // e.g. when the action should be to load data in a special way 
        // -> the default view will always load data in the same way when switched to it
        // is it wrong to load the data in onShow()? should we load the data in initialize?

        switch(item.getId()) {
            case "reload":
                // FIXME when we have a cache, then we would have to call "clear cache" on the service
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                WatchUi.popView(WatchUi.SLIDE_RIGHT); // pops LoopView
                break;
            case "reauth":
                self._service.dropAuthenticationData();
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                WatchUi.popView(WatchUi.SLIDE_RIGHT); // pops LoopView
                break;
        }

    }
}

class StationsViewMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _selectCallback as Method(item as MenuItem) as Void;

    function initialize(selectCallback as Method(item as MenuItem) as Void) {
        Menu2InputDelegate.initialize();
        self._selectCallback = selectCallback;
    }

    function onSelect(item as MenuItem) as Void {
        self._selectCallback.invoke(item);
    }

    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

}