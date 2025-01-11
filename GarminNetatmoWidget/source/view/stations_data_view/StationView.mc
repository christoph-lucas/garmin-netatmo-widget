import Toybox.Graphics;
import Toybox.WatchUi;

class StationView extends WatchUi.View {

    private var _data as NetatmoStationData?;

    function initialize(data as NetatmoStationData) {
        View.initialize();
        self._data = data;
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        NetatmoStationDrawer.draw(dc, self._data);
    }

    function onLayout(dc as Dc) as Void { }
    function onShow() as Void { }
    function onHide() as Void { }

}
