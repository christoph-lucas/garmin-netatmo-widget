import Toybox.Lang;
import Toybox.Time;

class Timestamp {

    private var _value as Moment?;
    
    public function initialize(secondsInEpoch as Number?) {
        if (secondsInEpoch != null) {
            self._value = new Moment(secondsInEpoch);
        }
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