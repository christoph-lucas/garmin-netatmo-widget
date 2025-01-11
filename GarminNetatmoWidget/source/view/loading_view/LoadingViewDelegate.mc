import Toybox.WatchUi;
import Toybox.Lang;

class LoadingViewDelegate extends BehaviorDelegate {
    // see https://forums.garmin.com/developer/connect-iq/f/discussion/371941/switching-between-views
    // some Delegate is needed in the getView() call above, otherwise an Array out of Bounds error is thrown

    private var _service;

    public function initialize(service as NetatmoService) {
        BehaviorDelegate.initialize();
        self._service = service;
    }

    public function onSelect() as Boolean {
        var menu = new WatchUi.Menu2({:title => "Menu"});

        // FIXME these menu items and the handling below should be DRYed
        menu.addItem(new WatchUi.MenuItem("Reload", "Reload stations data.", "reload", null));
        menu.addItem(new WatchUi.MenuItem("Reauth", "Reauthenticate with Netatmo.", "reauth", null));
        WatchUi.pushView(menu, new GenericMenuDelegate(method(:onMenuItemSelected)), WatchUi.SLIDE_UP);
        return true;
    }

    public function onMenuItemSelected(item as MenuItem) as Void {
        switch(item.getId()) {
            case "reload":
                // FIXME when we have a cache, then we would have to call "clear cache" on the service
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                WatchUi.requestUpdate(); // we are already in the initial view, just update it
                break;
            case "reauth":
                self._service.dropAuthenticationData();
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                WatchUi.requestUpdate(); // we are already in the initial view, just update it
                break;
        }

    }
}

