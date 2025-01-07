import Toybox.Lang;

class NetatmoClientAuth {
    private var _id as String;
    private var _secret as String;

    public function initialize(id as String, secret as String) {
        self._id = id;
        self._secret = secret;
    }

    public function id() as String { return self._id; }
    public function secret() as String { return self._secret; }
}