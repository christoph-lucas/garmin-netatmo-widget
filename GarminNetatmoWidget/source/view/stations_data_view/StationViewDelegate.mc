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
