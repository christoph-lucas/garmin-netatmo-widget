import Toybox.Lang;

class CO2 {
    private var _value as Number;

    public function initialize(value as Number) {
        self._value = value;
    }

    public function toShortString() as String {
        return self._value + "ppm";
    }

    public function toLongString() as String {
        return "CO2: " + self.toShortString();
    }
}