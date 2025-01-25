import Toybox.Lang;

(:glance, :background)
class NetatmoError extends Notification {
    private var _message as String;

    public function initialize(message as String) {
        Notification.initialize();
        self._message = message;
    }

    public function short() as String {
        return "Error!";
    }

    public function long() as String {
        return self._message;
    }
}