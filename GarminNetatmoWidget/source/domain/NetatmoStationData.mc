import Toybox.Lang;
import Toybox.Time;

class NetatmoStationData {
    private var _name as String;
    private var _measurementTimestamp as Moment;
    private var _temperature as Temperature;
    private var _co2 as CO2;

    public function initialize(name as String, measurementTimestamp as Moment, temperature as Temperature, co2 as CO2) {
        self._name = name;
        self._measurementTimestamp = measurementTimestamp;
        self._temperature = temperature;
        self._co2 = co2;
    }

    public function name() as String {
        return self._name;
    }

    public function measurementTimestamp() as String {
        var gregorian = Gregorian.info(self._measurementTimestamp, Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$.$2$.$3$ $4$:$5$:$6$",
            [
                gregorian.day.format("%02d"),
                gregorian.month.format("%02d"),
                gregorian.year,
                gregorian.hour.format("%02d"),
                gregorian.min.format("%02d"),
                gregorian.sec.format("%02d")
            ]
        );
        return dateString;
    }

    public function temperature() as Temperature {
        return self._temperature;
    }

    public function co2() as CO2 {
        return self._co2;
    }

}