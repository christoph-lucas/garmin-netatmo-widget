import Toybox.WatchUi;
import Toybox.Lang;


class NotificationViewDelegate extends BehaviorDelegate {

    private var _service as WeatherStationService;

    public function initialize(service as WeatherStationService) {
        BehaviorDelegate.initialize();
        self._service = service;
    }

    public function onSelect() as Boolean {
        var menu = new WatchUi.Menu2({:title => "Menu"});

        menu.addItem(new WatchUi.MenuItem("Reload", "Clear cache and reload.", "reload", null));
        menu.addItem(new WatchUi.MenuItem("Reauth", "Reauthenticate with Netatmo.", "reauth", null));
        WatchUi.pushView(menu, new GenericMenuDelegate(method(:onMenuItemSelected)), WatchUi.SLIDE_UP);
        return true;
    }

    public function onMenuItemSelected(item as MenuItem) as Void {
        switch(item.getId() as String) {
            case "reload":
                self._service.clearCacheIfConnected();
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                navigateToLoadingView(self._service);
                break;
            case "reauth":
                self._service.dropAuthenticationDataIfConnected();
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                navigateToLoadingView(self._service);
                break;
        }

    }
}

