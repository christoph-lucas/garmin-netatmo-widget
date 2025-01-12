import Toybox.Lang;

class NetatmoStationData {
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

}