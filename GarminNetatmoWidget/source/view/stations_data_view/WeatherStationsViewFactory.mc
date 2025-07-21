import Toybox.WatchUi;
import Toybox.Lang;

function navigateToStationsDataView(data as WeatherStationsData, service as WeatherStationService) as Void {
    try {
        var loop = new ViewLoop(new WeatherStationsViewFactory(data, service), null);
        WatchUi.switchToView(loop, new ViewLoopDelegate(loop), WatchUi.SLIDE_LEFT);
    } catch (ex) {
        navigateToNotificationView(service, new WeatherStationError("Msg: " + ex.getErrorMessage()));
    }
}

class WeatherStationsViewFactory extends ViewLoopFactory {

    private var _allLoopItems as Array<LoopItem>;

    public function initialize(stationsData as WeatherStationsData, service as WeatherStationService) {
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

    public function getView(page as Number) {
        var loopItem = self._allLoopItems[page];
        return [loopItem.view(), loopItem.delegate()];
    }
}

class LoopItem {
    private var _data as WeatherStationData;
    private var _view as StationView;
    private var _delegate as StationViewDelegate;

    public function initialize(data as WeatherStationData, service as WeatherStationService) {
        self._data = data;
        self._view = new StationView(data, service);
        self._delegate = new StationViewDelegate(service, self._view);
    }

    public function data() as WeatherStationData { return self._data; }
    public function view() as StationView { return self._view; }
    public function delegate() as StationViewDelegate { return self._delegate; }
}