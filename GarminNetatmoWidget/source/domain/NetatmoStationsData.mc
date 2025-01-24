import Toybox.Lang;
import Toybox.Time;

typedef DeviceDict as Dictionary<String, NetatmoStationDataDict or Array<NetatmoStationDataDict>>;
typedef NetatmoStationsDataDict as Dictionary<String, Array<DeviceDict>>;

(:glance)
class NetatmoStationsData {

    public static function fromDict(dict as NetatmoStationsDataDict) as NetatmoStationsData {
        return new NetatmoStationsData(
            NetatmoStationsData._devicesFromArray(dict["devices"])
        );
    }

    private static function _devicesFromArray(dataArray as Array<DeviceDict>) as Array<Device> {
        var result = new[dataArray.size()] as Array<Device>;
        for (var i = 0; i < dataArray.size(); i++) {
            result[i] = Device.fromDict(dataArray[i]);
        }
        return result;
    }

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

    public function toDict() as NetatmoStationsDataDict {
        return {"devices" => self._devicesToDict()};
    }

    private function _devicesToDict() as Array<DeviceDict> {
        var result = new[self._devices.size()] as Array<DeviceDict>;
        for (var i = 0; i < self._devices.size(); i++) {
            result[i] = self._devices[i].toDict();
        }
        return result;
    }
}


(:glance)
class Device {

    public static function fromDict(dict as DeviceDict) as Device {
        return new Device(
            NetatmoStationData.fromDict(dict["mainStation"]),
            Device._modulesFromArray(dict["modules"])
        );
    }

    private static function _modulesFromArray(dataArray as Array<NetatmoStationDataDict>) as Array<NetatmoStationData> {
        var result = new[dataArray.size()] as Array<NetatmoStationData>;
        for (var i = 0; i < dataArray.size(); i++) {
            result[i] = NetatmoStationData.fromDict(dataArray[i]);
        }
        return result;
    }

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

    public function toDict() as DeviceDict {
        return {
            "mainStation" => self._mainStation.toDict(),
            "modules" => self._modulesToDict()
        };
    }

    private function _modulesToDict() as Array<NetatmoStationDataDict> {
        var result = new[self._modules.size()] as Array<NetatmoStationDataDict>;
        for (var i = 0; i < self._modules.size(); i++) {
            result[i] = self._modules[i].toDict();
        }
        return result;
    }
}
