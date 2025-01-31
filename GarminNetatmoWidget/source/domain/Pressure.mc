import Toybox.Lang;

(:glance, :background)
class Pressure {
    private var _value as Float?;

    public function initialize(value as Float?) {
        self._value = value;
    }

    public function isPresent() as Boolean { return self._value != null; }

    public function toShortString() as String {
        if (self._value != null) {
            return (self._value as Float).format("%.1f") + "mbar";
        }
        return "n/a";
    }

    public function toLongString() as String {
        return "Pressure: " + self.toShortString();
    }

    public function value() as Float? { return self._value; }
}