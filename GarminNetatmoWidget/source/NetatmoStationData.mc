import Toybox.Lang;

class NetatmoStationData {
    private var _name as String;
    private var _temperature as Double;
    private var _co2 as Number;

    public function initialize(name as String, temperature as Double, co2 as Number) {
        me._name = name;
        me._temperature = temperature;
        me._co2 = co2;
    }

    public function name() as String {
        return self._name;
    }

    public function temperature() as Double {
        return self._temperature;
    }

    public function co2() as Number {
        return self._co2;
    }

}