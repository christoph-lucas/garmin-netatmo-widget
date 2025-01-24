import Toybox.Lang;

// FIXME Is there a better way to have an Interface?
(:glance)
class Notification {

    public function initialize() { }

    public function short() as String {
        throw new OperationNotAllowedException("Not implemented.^");
    }

    public function long() as String {
        throw new OperationNotAllowedException("Not implemented.^");
    }

}