import Toybox.Lang;

class WebRequestError extends NetatmoError {

    public function initialize(endpoint as String, responseCode as Number, errorMsg as String, errorCode as Number or String) {
        NetatmoError.initialize(endpoint + " " + responseCode + ": " + errorCode + " (" + errorMsg + ").");
    }
}