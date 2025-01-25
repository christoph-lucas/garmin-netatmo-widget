import Toybox.Lang;

(:glance, :background)
class WebRequestError extends NetatmoError {

    public function initialize(endpoint as String, responseCode as Number, errorMsg as String?, errorCode as Number or String or Null) {
        NetatmoError.initialize(WebRequestError.getString(endpoint, responseCode, errorMsg, errorCode));
    }

    private static function getString(endpoint as String, responseCode as Number, errorMsg as String?, errorCode as Number or String or Null) as String {
        var result = endpoint + " " + responseCode + ": ";
        if (errorCode != null) { result += errorCode; }
        if (errorMsg != null) { result += " (" + errorMsg + ")"; }
        return result;
    }
}