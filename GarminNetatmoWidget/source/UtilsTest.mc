import Toybox.Lang;
import Toybox.Test;

class UtilsRandomStringTest {

    (:test)
    public static function shouldReturnStringOfCorrectLength(logger as Logger) as Boolean {
        var len = 17;

        var result = randomString(len);

        return result.length() == len;
    }

    (:test)
    public static function shouldReturnDifferentStringsOnMultipleInvocations(logger as Logger) as Boolean {
        var len = 17;

        var result1 = randomString(len);
        var result2 = randomString(len);

        return !result1.equals(result2);
    }

}