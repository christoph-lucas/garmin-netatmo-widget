import Toybox.Graphics;
import Toybox.WatchUi;

function getLoadingView(service as WeatherStationService) as [Views] {
    return [ new LoadingView(service) ];
}

function navigateToLoadingView(service as WeatherStationService) as Void {
    // NB if needed, we could accept some options here that influence how the data is loaded
    // -> currently the view will always load data in the same way when switched to it
    // is it wrong to load the data in onShow()? should we load the data in initialize?
    WatchUi.switchToView(getLoadingView(service)[0], null, WatchUi.SLIDE_RIGHT);
}

class LoadingView extends WatchUi.View {

    private var _service as WeatherStationService;
    private var _busyIndicator as ProgressBar;

    function initialize(service as WeatherStationService) {
        View.initialize();
        self._service = service;

        self._busyIndicator = new WatchUi.ProgressBar("Loading...", null);
    }

    function onLayout(dc as Dc) as Void { }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        WatchUi.pushView(self._busyIndicator, new BusyIndicatorDelegate(), WatchUi.SLIDE_DOWN);
        self._service.loadStationData(method(:onDataLoaded), method(:onNotification));
    }

    public function onDataLoaded(data as NetatmoStationsData) as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        navigateToStationsDataView(data, self._service);
    }

    public function onNotification(notification as Notification) as Void {
        if (notification instanceof NetatmoError) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            navigateToNotificationView(self._service, notification);
        } else {
            self._busyIndicator.setDisplayString(notification.long());
        }
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        self._drawStarting(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void { }

    private function _drawStarting(dc as Dc) as Void {
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "Starting...", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

}

public class BusyIndicatorDelegate extends BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // pop progress bar
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // pop loading view itself -> exit app
        return true;
    }
}