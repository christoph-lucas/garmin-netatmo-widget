import Toybox.Lang;
import Toybox.Time;

class ExpirationTimestamp {

    public static function expiresIn(secondsFromNow as Number) as ExpirationTimestamp {
        var now = Time.now() as Time.Moment;
        var expirationDuration = new Time.Duration(secondsFromNow);
        var validUntil = now.add(expirationDuration) as Time.Moment;
        return new ExpirationTimestamp(validUntil);
    }

    public static function from(secondsInEpoch as Number?) as ExpirationTimestamp {
        if (secondsInEpoch != null) {
            return new ExpirationTimestamp(new Time.Moment(secondsInEpoch));
        }
        return new ExpirationTimestamp(null);
    }

    private var _timestamp as Moment?;

    private function initialize(timestamp as Moment?) {
        self._timestamp = timestamp;
    }

    public function value() as Number {
        if (self._timestamp != null) {
            return self._timestamp.value();
        }
        return -1; // TODO what to do here?
    }

    public function isValid() as Boolean {
        if (self._timestamp == null) { return false; }
        if (Time.now().lessThan(self._timestamp)) {
            return true;
        }
        return false;
    }

}