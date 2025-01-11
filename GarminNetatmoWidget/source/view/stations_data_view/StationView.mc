import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class StationView extends WatchUi.View {

    private var _data as NetatmoStationData;
    private var _service as NetatmoService;
    private var _reloadPending as Boolean;

    function initialize(data as NetatmoStationData, service as NetatmoService) {
        View.initialize();
        self._data = data;
        self._service = service;
        self._reloadPending = false;
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        NetatmoStationDrawer.draw(dc, self._data);
    }

    function onLayout(dc as Dc) as Void { }
    function onShow() as Void {
        if (self._reloadPending) {
            navigateToLoadingView(self._service);
        }
    }
    function onHide() as Void { }

    public function setReloadPending() as Void {
        self._reloadPending = true;
    }

}
