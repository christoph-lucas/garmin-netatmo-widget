import Toybox.Graphics;
import Toybox.WatchUi;

function navigateToNotificationView(service as WeatherStationService, notification as Notification) as Void {
    WatchUi.switchToView(new NotificationView(notification), new NotificationViewDelegate(service), WatchUi.SLIDE_RIGHT);
}

class NotificationView extends WatchUi.View {

    private var _notification as Notification;

    function initialize(notification as Notification) {
        View.initialize();
        self._notification = notification;
    }

    function onLayout(dc as Dc) as Void { }
    function onShow() as Void { }
    function onHide() as Void { }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        self._drawNotification(dc, self._notification);
    }

    private function _drawNotification(dc as Dc, notification as Notification) as Void {
        var text = "";
        if (self._notification instanceof NetatmoError) { text += "😟\n"; }
        text += notification.long();
        var notificationTextArea = new WatchUi.TextArea({
            :text => text,
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

}
