import Toybox.Graphics;
import Toybox.WatchUi;

class GarminNetatmoWidgetView extends WatchUi.View {

    private var _data as NetatmoStationData?;
    private var _error as NetatmoError?;
    private var _dataLoader as DataLoader;

    function initialize(dataLoader as DataLoader) {
        View.initialize();
        self._dataLoader = dataLoader;
    }

    function onLayout(dc as Dc) as Void { }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        self._dataLoader.invoke(method(:onDataLoaded));
    }

    public function onDataLoaded(data as NetatmoStationsData?, error as NetatmoError?) as Void {
        if (error != null) {
           self._error = error;
            WatchUi.requestUpdate();
        } else if (data != null) {
            var loop = new ViewLoop(new NetatmoStationsViewFactory(data), null);
            WatchUi.switchToView(loop, new ViewLoopDelegate(loop), WatchUi.SLIDE_LEFT);        
        } else {
           self._error = new NetatmoError("No data");
            WatchUi.requestUpdate();
        }
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        if (self._data != null) {
            NetatmoStationDrawer.draw(dc, self._data);
        } else if (self._error != null) {
            self._drawError(dc, self._error);
        } else {
            self._drawLoading(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { }

    private function _drawError(dc as Dc, error as NetatmoError) as Void {
        var errorTextArea = new WatchUi.TextArea({
            :text => error.message(),
            :color => Graphics.COLOR_WHITE,
            :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=> WatchUi.LAYOUT_VALIGN_CENTER,
            :width => dc.getWidth(),
            :height => dc.getHeight(),
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        });
        errorTextArea.draw(dc);
    }

    private function _drawLoading(dc as Dc) as Void {
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Loading...", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}
