import Toybox.Lang;

class NetatmoError {
    private var _message as String;

    public function initialize(message as String) {
        self._message = message;
    }

    public function message() as String {
        return self._message;
    }
}