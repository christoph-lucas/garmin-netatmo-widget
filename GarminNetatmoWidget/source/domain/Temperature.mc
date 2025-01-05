import Toybox.Lang;

class Temperature {
    private var _value as Float;

    public function initialize(value as Float) {
        self._value = value;
    }

    public function toShortString() as String {
        return self._value.format("%.1f") + "°C";
    }

    public function toLongString() as String {
        return "Temp: " + self.toShortString();
    }
}