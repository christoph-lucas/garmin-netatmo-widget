using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class GarminNetatmoWidgetGlanceView extends Ui.GlanceView {
    
    private var _data as NetatmoStationData?;

    public function initialize() {
      GlanceView.initialize();
    }
    
    public function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var justification = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;
        if (self._data != null) {
            dc.drawText(0, 0.33 * dc.getHeight(), Graphics.FONT_SMALL, self._data.name(), justification);
            var temp = self._data.temperature().format("%.1f") + "°C";
            var co2 = self._data.co2() + "ppm";
            dc.drawText(0, 0.75 * dc.getHeight(), Graphics.FONT_TINY, temp + " / " + co2, justification);
        } else {
            dc.drawText(0, dc.getHeight() / 2, Graphics.FONT_SMALL, "Loading...", justification);
        }
    }

    public function setData(data as NetatmoStationData?) as Void {
        if (data != null) {
            self._data = data;
            WatchUi.requestUpdate();    
        }
    }

}
