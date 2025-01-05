import Toybox.Lang;
import Toybox.Time;

class NetatmoStationsData {
    private var _devices as Array<Device>;

    public function initialize(devices as Array<Device>) {
        self._devices = devices; // TODO copy array
    }

    public function numberOfDevices() as Number {
        return self._devices.size();
    }

    public function device(index as Number) as Device {
        return self._devices[index];
    }
}

class Device {
    private var _mainStation as NetatmoStationData;
    private var _modules as Array<NetatmoStationData>;

    public function initialize(mainStation as NetatmoStationData, modules as Array<NetatmoStationData>) {
        self._mainStation = mainStation;
        self._modules = modules; // TODO copy array
    }

    public function mainStation() as NetatmoStationData {
        return self._mainStation;
    }

    public function numberOfModules() as Number {
        return self._modules.size();
    }

    public function getModule(index as Number) as NetatmoStationData {
        return self._modules[index];
    }

}
