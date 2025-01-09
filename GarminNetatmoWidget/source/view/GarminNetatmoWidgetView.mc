import Toybox.Graphics;
import Toybox.WatchUi;

class GarminNetatmoWidgetView extends WatchUi.View {

    private var _notification as Notification?;
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
        self._dataLoader.invoke(method(:onDataLoaded), method(:onNotification));
    }

    public function onDataLoaded(data as NetatmoStationsData) as Void {
        var loop = new ViewLoop(new NetatmoStationsViewFactory(data), null);
        WatchUi.switchToView(loop, new ViewLoopDelegate(loop), WatchUi.SLIDE_LEFT);        
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
