using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

(:glance)
function getNetatmoGlanceView(service as NetatmoService) as [GlanceView] {
        return [ new GlanceView(service) ];
}

(:glance)
class GlanceView extends Ui.GlanceView {
    
    private var _data as NetatmoStationData?;
    private var _notification as Notification?;
    private var _service as NetatmoService;

    public function initialize(service as NetatmoService) {
        GlanceView.initialize();
        self._service = service;
    }

    public function onShow() as Void {
        self._service.loadStationData(method(:onDataLoaded), method(:onNotification));
    }

    public function onDataLoaded(data as NetatmoStationsData) as Void {
        if (data.numberOfDevices() > 0) {
            self._data = self._getSelectedStationData(data);
        } else {
           self._notification = new NetatmoError("No data");
        }
        WatchUi.requestUpdate();    
    }

    public function onNotification(notification as Notification) as Void {
        self._notification = notification;
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
        } else if (self._notification != null) {
            dc.drawText(0, dc.getHeight() / 2, Graphics.FONT_TINY, self._notification.short(), justification);
        } else {
            dc.drawText(0, dc.getHeight() / 2, Graphics.FONT_SMALL, "Starting...", justification);
        }
    }

    private function _getSelectedStationData(data as NetatmoStationsData) as NetatmoStationData {
        var selectedId = self._service.getDefaultStationId() as StationId?;
        if (selectedId != null) {
            var allStations = data.allStations();
            for (var i = 0; i < allStations.size(); i++) {
                if (selectedId.equals(allStations[i].id())) {
                    return allStations[i];
                }
            }
        }
        return data.device(0).mainStation();
    }

}
