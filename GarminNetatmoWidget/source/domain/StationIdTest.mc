import Toybox.Lang;
import Toybox.Test;

class StationIdTest {

    (:test)
    public static function shouldBeEqual(logger as Logger) as Boolean {
        var id1 = new StationId("123");
        var id2 = new StationId("123");
        return id1.equals(id2);
    }

    (:test)
    public static function shouldNotBeEqual(logger as Logger) as Boolean {
        var id1 = new StationId("123");
        var id2 = new StationId("456");
        return !id1.equals(id2);
    }

    (:test)
    public static function shouldNotBeEqualToNull(logger as Logger) as Boolean {
        var id1 = new StationId("123");
        return !id1.equals(null);
    }
}