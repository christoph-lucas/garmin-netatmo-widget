import Toybox.Lang;

(:glance)
class Status extends Notification {
    private var _status as String;

    public function initialize(status as String) {
        Notification.initialize();
        self._status = status;
    }

    public function short() as String {return self._status; } // TODO remove line breaks
    public function long() as String {return self._status; }
}