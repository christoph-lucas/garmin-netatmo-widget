import Toybox.Lang;

typedef NetatmoStationDataDict as Dictionary<String, String or Number>;

class NetatmoStationData {

    public static function fromDict(dict as NetatmoStationDataDict) as NetatmoStationData {
        return new NetatmoStationData(
            dict["name"],
            new Timestamp(dict["measurementTimestamp"]),
            new Temperature(dict["temperature"]),
            new CO2(dict["co2"])
        );
    }

    private var _name as String;
    private var _measurementTimestamp as Timestamp;
    private var _temperature as Temperature;
    private var _co2 as CO2;

    public function initialize(name as String, measurementTimestamp as Timestamp, temperature as Temperature, co2 as CO2) {
        self._name = name;
        self._measurementTimestamp = measurementTimestamp;
        self._temperature = temperature;
        self._co2 = co2;
    }

    public function name() as String {
        return self._name;
    }

    public function measurementTimestamp() as Timestamp {
        return self._measurementTimestamp;
    }

    public function temperature() as Temperature {
        return self._temperature;
    }

    public function co2() as CO2 {
        return self._co2;
    }

    public function toDict() as NetatmoStationDataDict {
        return {
            "name" => self._name,
            "measurementTimestamp" => self._measurementTimestamp.value(),
            "temperature" => self._temperature.value(),
            "co2" => self._co2.value()
        };
    }

}