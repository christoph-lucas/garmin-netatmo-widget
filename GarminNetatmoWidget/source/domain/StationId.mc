import Toybox.Lang;

class StationId {
    private var _value as String?;

    public function initialize(id as String?) {
        self._value = id;
    }

    public function isPresent() as Boolean {
        return self._value != null;
    }

    public function id() as String {
        if (self._value != null) {
            return self._value;
        }
        throw new OperationNotAllowedException("Method not allowed if value not present.");
    }

    public function equals(other as StationId) as Boolean {
        if (!self.isPresent() or !other.isPresent()) { return false; }
        return self.id().equals(other.id());
    }

}