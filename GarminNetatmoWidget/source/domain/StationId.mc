import Toybox.Lang;

class StationId {
    private var _value as String;

    public function initialize(id as String) {
        self._value = id;
    }

    public function value() as String? { return self._value; }

    public function equals(other as Object?) as Boolean {
        if (other == null) { return false; }
        if (other instanceof StationId) {
            return self.value().equals(other.value());
        }
        return false;
    }

}