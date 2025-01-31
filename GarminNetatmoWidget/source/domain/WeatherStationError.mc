import Toybox.Lang;

(:glance, :background)
class WeatherStationError { // implements Notification
    private var _message as String;

    public function initialize(message as String) {
        self._message = message;
    }

    public function short() as String {
        return "Error!";
    }

    public function long() as String {
        return self._message;
    }
}