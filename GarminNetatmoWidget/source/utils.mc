import Toybox.Lang;
using Toybox.Math;

(:glance, :background)
function notEmpty(val as String) as Boolean {
    return val != null and val.length() > 0;
}

(:glance)
function randomString(len as Number) as String {
    if (len <= 0 or len > 100) { throw new InvalidValueException("The random string length must be between 1 and 100."); }

    // NB: some symbols in "$%&()+*#-" lead to "invalid client" errors from Netatmo -> sticking to alphanumeric
    var allowed_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray() as Array<Char>;
    var number_allowed = allowed_chars.size();

    var result = "";
    for (var i = 0; i < len; i++) {
        var index = Math.rand() % number_allowed;
        result += allowed_chars[index];
    }
    return result;
}

