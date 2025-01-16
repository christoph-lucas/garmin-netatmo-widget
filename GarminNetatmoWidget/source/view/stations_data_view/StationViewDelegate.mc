import Toybox.Lang;
import Toybox.WatchUi;

class StationViewDelegate extends BehaviorDelegate {
    // see https://forums.garmin.com/developer/connect-iq/f/discussion/371941/switching-between-views
    // some Delegate is needed in the getView() call above, otherwise an Array out of Bounds error is thrown

    private var _service;
    private var _view as StationView;

    public function initialize(service as NetatmoService, view as StationView) {
        BehaviorDelegate.initialize();
        self._service = service;
        self._view = view;
    }

    public function onSelect() as Boolean {
        var menu = new WatchUi.Menu2({:title => "Menu"});

        var selectedId = self._service.getDefaultStationId() as StationId?;
        if (selectedId != null && selectedId.equals(self._view.data().id())) {
            menu.addItem(new WatchUi.MenuItem("Clear default.", "Clear default station selection.", "clearDefault", null));
        } else {
            menu.addItem(new WatchUi.MenuItem("Default", "Select as default.", "default", null));
        }
        menu.addItem(new WatchUi.MenuItem("Reload", "Clear cache and reload.", "reload", null));
        menu.addItem(new WatchUi.MenuItem("Reauth", "Reauthenticate with Netatmo.", "reauth", null));

        WatchUi.pushView(menu, new GenericMenuDelegate(method(:onMenuItemSelected)), WatchUi.SLIDE_UP);
        return true;
    }

    public function onMenuItemSelected(item as MenuItem) as Void {
        switch(item.getId()) {
            case "default":
                self._service.setDefaultStation(self._view.data());
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                break;
            case "clearDefault":
                self._service.clearDefaultStationId();
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                break;
            case "reload":
                self._service.clearCacheIfConnected();
                WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
                navigateToLoadingView(self._service);
                break;
            case "reauth":
                self._pushReauthConfirmDialog();
                break;
        }
    }

    private function _pushReauthConfirmDialog() as Void {
        var dialog = new WatchUi.Confirmation("Drop all authentication data?");
        WatchUi.pushView(dialog, new GenericConfirmationDialogDelegate(method(:onReauthResponse)), WatchUi.SLIDE_IMMEDIATE);
    }

    public function onReauthResponse(value as Confirm) as Boolean {
        if (value == WatchUi.CONFIRM_YES) {
            self._service.dropAuthenticationData();
            WatchUi.popView(WatchUi.SLIDE_DOWN); // pops MenuView
            // NB: the following line should switch stations data for loading view, but does not
            // probably some race condition when which view command is executed -> using a work around
            // navigateToLoadingView(self._service);
            self._view.setReloadPending();
        }
        return true;
    }

}
