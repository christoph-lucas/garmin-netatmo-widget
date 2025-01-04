import Toybox.Graphics;
import Toybox.WatchUi;

class GarminNetatmoWidgetView extends WatchUi.View {

    private var _data as NetatmoStationData?;
    private var _error as NetatmoError?;

    function initialize() {
        View.initialize();
    }

    public function setData(data as NetatmoStationData?, error as NetatmoError?) as Void {
        self._data = data;
        self._error = error;
        WatchUi.requestUpdate();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        if (self._data != null) {
            self._drawData(dc);
        } else if (self._error != null) {
            self._drawError(dc);
        } else {
            self._drawLoading(dc);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    private function _drawData(dc as Dc) as Void {
        if (self._data == null) {return;}

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 3, Graphics.FONT_MEDIUM, self._data.name(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        var temp = "Temp: " + self._data.temperature().format("%.1f") + "°C";
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, temp, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var co2 = "CO2: " + self._data.co2() + "ppm";
        dc.drawText(dc.getWidth() / 2, 2 * dc.getHeight() / 3, Graphics.FONT_MEDIUM, co2, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function _drawError(dc as Dc) as Void {
        if (self._error == null) {return;}
        // FIXME use textarea so as much as possible of the error message fits on screen
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SMALL, self._error.message(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function _drawLoading(dc as Dc) as Void {
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Loading...", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}
