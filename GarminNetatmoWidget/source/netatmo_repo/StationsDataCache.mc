import Toybox.Lang;
import Toybox.Application;
using Toybox.Application.Storage;

(:glance, :background)
const NETATMO_DEFAULT_UPDATE_INTERVAL_IN_SECONDS as Number = 10*60; // 10 minutes

(:glance, :background)
public class StationsDataCache {

    public function initialize() { }

    public function store(data as WeatherStationsData) as Void {
        var mappedValue = data.toDict() as WeatherStationsDataDict;
        Storage.setValue(STATIONS_DATA_CACHE, mappedValue as Dictionary<PropertyKeyType, PropertyValueType>);

        var validUntil = self._computeValidUntil(data) as Timestamp;
        Storage.setValue(STATIONS_DATA_CACHE_VALID_UNTIL, validUntil.value());
    }

    public function get() as WeatherStationsDataWithValidity? {
        var mappedValue = Storage.getValue(STATIONS_DATA_CACHE) as Dictionary?;
        if (mappedValue != null) {
            var validUntil = Storage.getValue(STATIONS_DATA_CACHE_VALID_UNTIL) as Number?;
            if (validUntil != null) {
                return new WeatherStationsDataWithValidity(
                    WeatherStationsData.fromDict(mappedValue as WeatherStationsDataDict),
                    new Timestamp(validUntil)
                );
            }
        }
        return null;
    }

    public function clear() as Void {
        Storage.deleteValue(STATIONS_DATA_CACHE);
        Storage.deleteValue(STATIONS_DATA_CACHE_VALID_UNTIL);
    }

    private function _computeValidUntil(data as WeatherStationsData) as Timestamp {
        var now = Timestamp.now();
        var stations = data.allStations();
        var oldestMeasurement = now;
        for (var i = 0; i < stations.size(); i++) {
            oldestMeasurement = oldestMeasurement.min(stations[i].measurementTimestamp());
        }
        return oldestMeasurement.addSeconds(NETATMO_DEFAULT_UPDATE_INTERVAL_IN_SECONDS);
    }
}

(:glance, :background)
public class WeatherStationsDataWithValidity {
    private var _data as WeatherStationsData;
    private var _validUntil as Timestamp;

    public function initialize(data as WeatherStationsData, validUntil as Timestamp) {
        self._data = data;
        self._validUntil = validUntil;
    }

    public function data() as WeatherStationsData { return self._data; }
    public function isValid() as Boolean { return self._validUntil.inFuture(); }
}
