import Toybox.Lang;

(:glance)
class Temperature {
    private var _value as Float?;

    public function initialize(value as Float?) {
        self._value = value;
    }

    public function isPresent() as Boolean { return self._value != null; }

    public function toShortString() as String {
        if (self._value != null) {
            return self._value.format("%.1f") + "°C";
        }
        return "n/a";
    }

    public function toLongString() as String {
        return "Temp: " + self.toShortString();
    }

    public function value() as Float? { return self._value; }
}