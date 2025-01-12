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
        self._drawStationData(dc);
    }

    private function _drawStationData(dc as Dc) as Void {
        dc.drawText(dc.getWidth() / 2, 0.25 * dc.getHeight(), Graphics.FONT_SMALL, self._data.name(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        var time = self._data.measurementTimestamp().toString();
        dc.drawText(dc.getWidth() / 2, 0.4 * dc.getHeight(), Graphics.FONT_TINY, time, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        var temp = self._data.temperature().toLongString();
        dc.drawText(dc.getWidth() / 2, 0.5 * dc.getHeight(), Graphics.FONT_TINY, temp, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var co2 = self._data.co2().toLongString();
        dc.drawText(dc.getWidth() / 2, 0.6 * dc.getHeight(), Graphics.FONT_TINY, co2, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
