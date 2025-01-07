import Toybox.WatchUi;
import Toybox.Lang;

class NetatmoStationsViewFactory extends ViewLoopFactory {

    private var _allViews as Array<StationView>;

    public function initialize(stationsData as NetatmoStationsData) {
        ViewLoopFactory.initialize();

        var allStations = stationsData.allStations();
        self._allViews = new[allStations.size()] as Array<StationView>;
        for (var i = 0; i < allStations.size(); i++) {
            self._allViews[i] = new StationView(allStations[i]);
        }
    }

    public function getSize() as Number {
        return self._allViews.size();
    }

    public function getView(page as Number) as [ View ] or [ View, BehaviorDelegate ]  {
        return [self._allViews[page], new DummyBehaviorDelegate()];
    }
}

class DummyBehaviorDelegate extends BehaviorDelegate {
    // see https://forums.garmin.com/developer/connect-iq/f/discussion/371941/switching-between-views
    // some Delegate is needed in the getView() call above, otherwise an Array out of Bounds error is thrown

    public function initialize() {
        BehaviorDelegate.initialize();
    }
}