import Toybox.Lang;

(:glance, :background)
function notEmpty(val as String) as Boolean {
    return val != null and val.length() > 0;
}
