using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class GarminNetatmoWidgetGlanceView extends Ui.GlanceView {
    
    private var _data as NetatmoStationData?;
    private var _error as NetatmoError?;
    private var _dataLoader as DataLoader;

    public function initialize(dataLoader as DataLoader) {
        GlanceView.initialize();
        self._dataLoader = dataLoader;
    }

    public function onShow() as Void {
        self._dataLoader.invoke(method(:onDataLoaded));
    }

    public function onDataLoaded(data as NetatmoStationsData?, error as NetatmoError?) as Void {
        if (error != null) {
            self._error = error;
        } else if (data != null && data.numberOfDevices() > 0) {
            self._data = data.device(0).mainStation();
        } else {
           self._error = new NetatmoError("No data");
        }
        WatchUi.requestUpdate();    
    }

    public function onUpdate(dc) {
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var justification = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;
        if (self._data != null) {
            dc.drawText(0, 0.33 * dc.getHeight(), Graphics.FONT_SMALL, self._data.name(), justification);
            var temp = self._data.temperature().toShortString();
            var co2 = self._data.co2().toShortString();
            dc.drawText(0, 0.75 * dc.getHeight(), Graphics.FONT_TINY, temp + " / " + co2, justification);
        } else if (self._error != null) {
            dc.drawText(0, dc.getHeight() / 2, Graphics.FONT_SMALL, "Error!", justification);
        } else {
            dc.drawText(0, dc.getHeight() / 2, Graphics.FONT_SMALL, "Loading...", justification);
        }
    }

}
