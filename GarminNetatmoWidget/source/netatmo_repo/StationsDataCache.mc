import Toybox.Lang;
using Toybox.Application.Storage;

const NETATMO_DEFAULT_UPDATE_INTERVAL_IN_SECONDS as Number = 10*60; // 10 minutes

(:glance, :background)
public class StationsDataCache {

    public function initialize() { }

    public function store(data as NetatmoStationsData) as Void {
        var mappedValue = data.toDict() as NetatmoStationsDataDict;
        Storage.setValue(STATIONS_DATA_CACHE, mappedValue);

        var validUntil = self._computeValidUntil(data) as Timestamp;
        Storage.setValue(STATIONS_DATA_CACHE_VALID_UNTIL, validUntil.value());
    }

    public function get() as NetatmoStationsDataWithValidity? {
        var mappedValue = Storage.getValue(STATIONS_DATA_CACHE) as Dictionary?;
        if (mappedValue != null) {
            var validUntil = Storage.getValue(STATIONS_DATA_CACHE_VALID_UNTIL) as Number?;
            if (validUntil != null) {
                return new NetatmoStationsDataWithValidity(
                    NetatmoStationsData.fromDict(mappedValue),
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

    private function _computeValidUntil(data as NetatmoStationsData) as Timestamp {
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
public class NetatmoStationsDataWithValidity {
    private var _data as NetatmoStationsData;
    private var _validUntil as Timestamp;

    public function initialize(data as NetatmoStationsData, validUntil as Timestamp) {
        self._data = data;
        self._validUntil = validUntil;
    }

    public function data() as NetatmoStationsData { return self._data; }
    public function isValid() as Boolean { return self._validUntil.inFuture(); }
}
