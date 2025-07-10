import Toybox.Lang;

(:glance, :background)
public enum WindType {
    WIND_TYPE_WIND = "WIND_TYPE_WIND",
    WIND_TYPE_GUST = "WIND_TYPE_GUST",
}

(:glance, :background)
class Wind {
    private var _strength as Float?;
    private var _angle as Float?;
    private var _type as WindType;

    public function initialize(strength as Float?, angle as Float?, type as WindType) {
        self._strength = strength;
        self._angle = angle;
        self._type = type;
    }

    public function isPresent() as Boolean { return self._strength != null; }

    public function toShortString() as String {
        if (self._strength != null) {
            return (self._strength as Float).format("%.1f") + "km/h";
        }
        return "n/a";
    }

    public function toLongString() as String {
        var result = self._label() + self.toShortString();
        if (self._angle != null) {
            result = result + " / " + (self._angle as Float).format("%.1f") + " degrees";
        }
        return result;
    }

    private function _label() as String {
        switch (self._type) {
            case WIND_TYPE_WIND:
                return "Wind: ";
            case WIND_TYPE_GUST:
                return "Gust: ";
        }
        return "n/a";
    }

    public function strength() as Float? { return self._strength; }
    public function angle() as Float? { return self._angle; }
}