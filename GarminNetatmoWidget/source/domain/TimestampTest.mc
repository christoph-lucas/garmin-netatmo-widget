import Toybox.Lang;
import Toybox.Test;
import Toybox.Time;

public class TimestampTest {

    public class InitializeTest {
        (:test)
        public static function shouldSucceed(logger as Logger) as Boolean {
            new Timestamp(123);
            return true;
        }

        (:test)
        public static function shouldSucceedOnNull(logger as Logger) as Boolean {
            new Timestamp(null);
            return true;
        }

        (:test)
        public static function shouldFailOnNegativeValue(logger as Logger) as Boolean {
            try {
                new Timestamp(-1);
            } catch(ex) {
                return true;
            }
            return false;
        }
    }

    public class MinTest {
        (:test)
        public static function shouldUseEarlierTimestamp(logger as Logger) as Boolean {
            var time1 = new Timestamp(14);
            var time2 = new Timestamp(15);

            var result = time1.min(time2);

            return result.equals(time1);
        }

        (:test)
        public static function shouldUseAnyTimestampOverNull(logger as Logger) as Boolean {
            var time = new Timestamp(14);

            var result = time.min(null);

            return result.equals(time);
        }

        (:test)
        public static function shouldUseAnyTimestampOverEmptyTimestamp(logger as Logger) as Boolean {
            var time = new Timestamp(14);
            var timeEmpty = new Timestamp(null);

            var result = time.min(timeEmpty);

            return result.equals(time);
        }
    }

    public class InFutureTest {
        (:test)
        public static function shouldCorrectlyDetectFutureTimestamps(logger as Logger) as Boolean {
            var time = Timestamp.now().addSeconds(100);

            var result = time.inFuture();

            return result.equals(true);
        }

        (:test)
        public static function shouldCorrectlyDetectPastTimestamps(logger as Logger) as Boolean {
            var time = new Timestamp(Time.now().value() - 100);

            var result = time.inFuture();

            return result.equals(false);
        }

    }

    public class SerialisationTest {
        (:test)
        public static function shouldSerialiseAndDesarialiseToSame(logger as Logger) as Boolean {
            var time = new Timestamp(123);

            var result = new Timestamp(time.value());

            return result.equals(time);
        }

        (:test)
        public static function shouldNotThrowForNull(logger as Logger) as Boolean {
            var time = new Timestamp(null);
            new Timestamp(time.value());
            return true;
        }
    }

    public class EqualityTest {
        (:test)
        public static function shouldBeEqualIfBothValuesPresent(logger as Logger) as Boolean {
            var time1 = new Timestamp(123);
            var time2 = new Timestamp(123);
            return time1.equals(time2);
        }

        (:test)
        public static function shouldNotBeEqualIfOtherIsNull(logger as Logger) as Boolean {
            var time1 = new Timestamp(123);
            return !time1.equals(null);
        }

        (:test)
        public static function shouldNotBeEqualIfOtherIsEmpty(logger as Logger) as Boolean {
            var time1 = new Timestamp(123);
            var time2 = new Timestamp(null);
            return !time1.equals(time2);
        }

        (:test)
        public static function shouldNotBeEqualIfThisIsEmpty(logger as Logger) as Boolean {
            var time1 = new Timestamp(null);
            var time2 = new Timestamp(123);
            return !time1.equals(time2);
        }

        (:test)
        public static function shouldNotBeEqualIfBothAreEmpty(logger as Logger) as Boolean {
            var time1 = new Timestamp(null);
            var time2 = new Timestamp(null);
            return !time1.equals(time2);
        }

    }

}