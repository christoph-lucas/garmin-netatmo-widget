import Toybox.Lang;

// FIXME Is there a better way to have an Interface?
class Notification {

    public function initialize() { }

    public function short() as String {
        throw new OperationNotAllowedException("Not implemented.^");
    }

    public function long() as String {
        throw new OperationNotAllowedException("Not implemented.^");
    }

}