import Toybox.WatchUi;
import Toybox.Lang;

function navigateToStationsDataView(data as NetatmoStationsData, service as WeatherStationService) as Void {
    var loop = new ViewLoop(new NetatmoStationsViewFactory(data, service), null);
    WatchUi.switchToView(loop, new ViewLoopDelegate(loop), WatchUi.SLIDE_LEFT);
}

class NetatmoStationsViewFactory extends ViewLoopFactory {

    private var _allLoopItems as Array<LoopItem>;

    public function initialize(stationsData as NetatmoStationsData, service as WeatherStationService) {
        ViewLoopFactory.initialize();

        var allStations = stationsData.allStations();
        self._allLoopItems = new[allStations.size()] as Array<LoopItem>;
        for (var i = 0; i < allStations.size(); i++) {
            self._allLoopItems[i] = new LoopItem(allStations[i], service);
        }
    }

    public function getSize() as Number {
        return self._allLoopItems.size();
    }

    public function getView(page as Number) as [ View ] or [ View, BehaviorDelegate ]  {
        var loopItem = self._allLoopItems[page];
        return [loopItem.view(), loopItem.delegate()];
    }
}

class LoopItem {
    private var _data as NetatmoStationData;
    private var _view as StationView;
    private var _delegate as StationViewDelegate;

    public function initialize(data as NetatmoStationData, service as WeatherStationService) {
        self._data = data;
        self._view = new StationView(data, service);
        self._delegate = new StationViewDelegate(service, self._view);
    }

    public function data() as NetatmoStationData { return self._data; }
    public function view() as StationView { return self._view; }
    public function delegate() as StationViewDelegate { return self._delegate; }
}