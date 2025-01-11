import Toybox.Lang;
import Toybox.WatchUi;

class GenericConfirmationDialogDelegate extends WatchUi.ConfirmationDelegate {

    private var _responseCallback as Method(value as Confirm) as Boolean;

    public function initialize(responseCallback as Method(value as Confirm) as Boolean) {
        ConfirmationDelegate.initialize();
        _responseCallback = responseCallback;
    }

    public function onResponse(value as Confirm) as Boolean {
        return self._responseCallback.invoke(value);
    }
}
