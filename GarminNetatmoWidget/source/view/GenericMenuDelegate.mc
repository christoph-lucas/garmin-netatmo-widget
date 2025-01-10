import Toybox.WatchUi;

class GenericMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _selectCallback as Method(item as MenuItem) as Void;

    function initialize(selectCallback as Method(item as MenuItem) as Void) {
        Menu2InputDelegate.initialize();
        self._selectCallback = selectCallback;
    }

    function onSelect(item as MenuItem) as Void {
        self._selectCallback.invoke(item);
    }

    public function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }

}