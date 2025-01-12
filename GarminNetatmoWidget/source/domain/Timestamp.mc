import Toybox.Lang;
import Toybox.Time;

class Timestamp {

    public static function inSecondsFromNow(secondsFromNow as Number) as Timestamp {
        var now = Time.now() as Time.Moment;
        var durationFromSeconds = new Time.Duration(secondsFromNow);
        var futureTimestamp = now.add(durationFromSeconds) as Time.Moment;
        return new Timestamp(futureTimestamp.value());
    }

    private var _value as Moment?;
    
    public function initialize(secondsInEpoch as Number?) {
        if (secondsInEpoch != null) {
            self._value = new Moment(secondsInEpoch);
        }
    }

    public function value() as Number {
        if (self._value != null) {
            return self._value.value();
        }
        return -1; // TODO what to do here?
    }

    public function inFuture() as Boolean {
        if (self._value == null) { return false; }
        if (Time.now().lessThan(self._value)) {
            return true;
        }
        return false;
    }

    public function toString() as String {
        if (self._value == null) { return "n/a"; }

        var gregorian = Gregorian.info(self._value, Time.FORMAT_SHORT);
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




}