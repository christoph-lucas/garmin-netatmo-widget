import Toybox.Graphics;
import Toybox.WatchUi;

function getLoadingViewWithDelegate(service as NetatmoService) as [Views, InputDelegates] {
    return [ new LoadingView(service), new LoadingViewDelegate(service) ];
}

function navigateToLoadingView(service as NetatmoService) as Void {
    // FIXME if needed, we could accept some options here that influence how the data is loaded
    // -> currently the view will always load data in the same way when switched to it
    // is it wrong to load the data in onShow()? should we load the data in initialize?
    var viewWithDelegate = getLoadingViewWithDelegate(service);
    WatchUi.switchToView(viewWithDelegate[0], viewWithDelegate[1], WatchUi.SLIDE_RIGHT);
}

class LoadingView extends WatchUi.View {

    private var _notification as Notification?;
    private var _service as NetatmoService;

    function initialize(service as NetatmoService) {
        View.initialize();
        self._service = service;
    }

    function onLayout(dc as Dc) as Void { }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        self._service.loadStationData(method(:onDataLoaded), method(:onNotification));
    }

    public function onDataLoaded(data as NetatmoStationsData) as Void {
        navigateToStationsDataView(data, self._service);
    }

    public function onNotification(notification as Notification) as Void {
        self._notification = notification;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        if (self._notification != null) {
            self._drawNotification(dc, self._notification);
        } else {
            self._drawStarting(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { }

    private function _drawNotification(dc as Dc, notification as Notification) as Void {
        var notificationTextArea = new WatchUi.TextArea({
            :text => notification.long(),
            :color => Graphics.COLOR_WHITE,
            :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_XTINY],
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=> WatchUi.LAYOUT_VALIGN_CENTER,
            :width => dc.getWidth(),
            :height => dc.getHeight(),
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        });
        notificationTextArea.draw(dc);
    }

    private function _drawStarting(dc as Dc) as Void {
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Starting...", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}
