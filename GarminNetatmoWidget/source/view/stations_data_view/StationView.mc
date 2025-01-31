import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class StationView extends WatchUi.View {

    private var _data as NetatmoStationData;
    private var _service as WeatherStationService;
    private var _reloadPending as Boolean;
    private var _config as Config;

    function initialize(data as NetatmoStationData, service as WeatherStationService) {
        View.initialize();
        self._data = data;
        self._service = service;
        self._reloadPending = false;
        self._config = service.config();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        self._drawStationData(dc);
    }

    private function _drawStationData(dc as Dc) as Void {
        dc.drawText(dc.getWidth() / 2, 0.2 * dc.getHeight(), Graphics.FONT_SMALL, self._data.name(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var displayString = self._data.measurementTimestamp().toString();

        if (self._config.showTemp() and self._data.temperature().isPresent()) {
            displayString += "\n" + self._data.temperature().toLongString();
        }
        if (self._config.showCO2() and self._data.co2().isPresent()) {
            displayString += "\n" + self._data.co2().toLongString();
        }
        if (self._config.showHumidity() and self._data.humidity().isPresent()) {
            displayString += "\n" + self._data.humidity().toLongString();
        }
        if (self._config.showPressure() and self._data.pressure().isPresent()) {
            displayString += "\n" + self._data.pressure().toLongString();
        }
        if (self._config.showNoise() and self._data.noise().isPresent()) {
            displayString += "\n" + self._data.noise().toLongString();
        }
        
        var textArea = new WatchUi.TextArea({
            :text => displayString,
            :color => Graphics.COLOR_WHITE,
            :font => [Graphics.FONT_TINY],
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=> 0.3 * dc.getHeight(),
            :width => dc.getWidth(),
            :height => dc.getHeight(),
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });
        textArea.draw(dc);
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

    public function data() as NetatmoStationData { return self._data; }

}
