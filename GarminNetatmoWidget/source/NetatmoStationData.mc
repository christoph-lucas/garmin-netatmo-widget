import Toybox.Lang;

class NetatmoStationData {
    private var _name as String;
    private var _temperature as Float; // FIXME model as Domain Primitive Temperature
    private var _co2 as Number; // FIXME model as Domain Primitive CO2

    public function initialize(name as String, temperature as Float, co2 as Number) {
        me._name = name;
        me._temperature = temperature;
        me._co2 = co2;
    }

    public function name() as String {
        return self._name;
    }

    public function temperature() as Float {
        return self._temperature;
    }

    public function co2() as Number {
        return self._co2;
    }

}