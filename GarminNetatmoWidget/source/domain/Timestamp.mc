import Toybox.Lang;
import Toybox.Time;

(:glance, :background)
class Timestamp {

    public static function now() as Timestamp {
        return new Timestamp(Time.now().value());
    }

    public static function inSecondsFromNow(secondsFromNow as Number) as Timestamp {
        var now = Time.now() as Time.Moment;
        var durationFromSeconds = new Time.Duration(secondsFromNow);
        var futureTimestamp = now.add(durationFromSeconds) as Time.Moment;
        return new Timestamp(futureTimestamp.value());
    }

    private var _value as Moment?;
    
    public function initialize(secondsInEpoch as Number?) {
        if (secondsInEpoch != null and secondsInEpoch < 0) {
            throw new ValueOutOfBoundsException("Value must be >= 0.");
        }
        if (secondsInEpoch != null and secondsInEpoch >= 0) {
            self._value = new Moment(secondsInEpoch);
        }
    }

    public function value() as Number {
        if (self._value != null) {
            return (self._value as Moment).value();
        }
        return -1;
    }

    public function inFuture() as Boolean {
        if (self._value == null) { return false; }
        if (Time.now().lessThan(self._value as Moment)) {
            return true;
        }
        return false;
    }

    public function min(other as Timestamp?) as Timestamp {
        if (other == null) { return self; }
        if (other.value() < 0 ) { return self; }
        if (other.value() < self.value()) { return other; }
        return self;
    }

    public function addSeconds(seconds as Number) as Timestamp {
        var durationFromSeconds = new Time.Duration(seconds);
        var newValue = (self._value as Moment).add(durationFromSeconds) as Time.Moment;
        return new Timestamp(newValue.value());
    }

    (:typecheck(false)) // I do not understand the error message
    public function toString() as String {
        if (self._value == null) { return "n/a"; }

        var gregorian = Gregorian.info(self._value as Moment, Time.FORMAT_SHORT);
        return Lang.format(
            "$1$.$2$.$3$ $4$:$5$:$6$",
            [
                gregorian.day.format("%02d"),
                gregorian.month.format("%02d"),
                gregorian.year,
                gregorian.hour.format("%02d"),
                gregorian.min.format("%02d"),
                gregorian.sec.format("%02d")
            ]
        );
    }

    public function equals(other as Object?) as Boolean {
        if (other == null) { return false; }
        if (other instanceof Timestamp) {
            return self.value().equals(other.value());
        }
        return false;
    }

}