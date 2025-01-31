import Toybox.Lang;

(:glance, :background)
class Status { // implements Notification
    private var _status as String;

    public function initialize(status as String) {
        self._status = status;
    }

    public function short() as String {return self._status; }
    public function long() as String {return self._status; }
}