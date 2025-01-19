import Toybox.Lang;

class Humidity {
    private var _value as Number?;

    public function initialize(value as Number?) {
        self._value = value;
    }

    public function isPresent() as Boolean { return self._value != null; }

    public function toShortString() as String {
        if (self._value != null) {
            return self._value + "%";
        }
        return "n/a";
    }

    public function toLongString() as String {
        return "Humidity: " + self.toShortString();
    }

    public function value() as Number? { return self._value; }
}