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

    public function allStations() as Array<NetatmoStationData> {
        var allStations = [] as Array<NetatmoStationData>;
        for (var i = 0; i<self._devices.size(); i++) {
            allStations.add(self._devices[i].mainStation());
            allStations.addAll(self._devices[i].allModules());
        }
        return allStations;
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

    public function allModules() as Array<NetatmoStationData> {
        return self._modules; // TODO return copy
    }

}
