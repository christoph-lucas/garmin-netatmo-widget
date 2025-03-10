import Toybox.Lang;

(:glance, :background)
public enum RainType {
    RAIN_TYPE_NOW = "RAIN_TYPE_NOW",
    RAIN_TYPE_LAST_1H = "RAIN_TYPE_LAST_1H",
    RAIN_TYPE_LAST_24H = "RAIN_TYPE_LAST_24H"
}

(:glance, :background)
class Rain {
    private var _value as Float?;
    private var _type as RainType;

    public function initialize(value as Float?, type as RainType) {
        self._value = value;
        self._type = type;
    }

    public function isPresent() as Boolean { return self._value != null; }

    public function toShortString() as String {
        if (self._value != null) {
            return (self._value as Float).format("%.1f") + "mm";
        }
        return "n/a";
    }

    public function toLongString() as String {
        return self._label() + self.toShortString();
    }

    private function _label() as String {
        switch (self._type) {
            case RAIN_TYPE_NOW:
                return "Rain: ";
            case RAIN_TYPE_LAST_1H:
                return "Rain (1h): ";
            case RAIN_TYPE_LAST_24H:
                return "Rain (24h): ";
        }
        return "n/a";
    }

    public function value() as Float? { return self._value; }
}