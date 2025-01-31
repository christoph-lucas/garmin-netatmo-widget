import Toybox.Lang;
import Toybox.Time;

typedef DeviceDict as Dictionary<String, WeatherStationDataDict or Array<WeatherStationDataDict>>;
typedef WeatherStationsDataDict as Dictionary<String, Array<DeviceDict>>;

(:glance, :background)
class WeatherStationsData {

    public static function fromDict(dict as WeatherStationsDataDict) as WeatherStationsData {
        return new WeatherStationsData(
            WeatherStationsData._devicesFromArray(dict["devices"] as Array<DeviceDict>)
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
        self._devices = [] as Array<Device>;
        self._devices.addAll(devices);
    }

    public function numberOfDevices() as Number {
        return self._devices.size();
    }

    public function device(index as Number) as Device {
        return self._devices[index];
    }

    public function allStations() as Array<WeatherStationData> {
        var allStations = [] as Array<WeatherStationData>;
        for (var i = 0; i<self._devices.size(); i++) {
            allStations.add(self._devices[i].mainStation());
            allStations.addAll(self._devices[i].allModules());
        }
        return allStations;
    }

    public function toDict() as WeatherStationsDataDict {
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


(:glance, :background)
class Device {

    public static function fromDict(dict as DeviceDict) as Device {
        return new Device(
            WeatherStationData.fromDict(dict["mainStation"] as WeatherStationDataDict),
            Device._modulesFromArray(dict["modules"] as Array<WeatherStationDataDict>)
        );
    }

    private static function _modulesFromArray(dataArray as Array<WeatherStationDataDict>) as Array<WeatherStationData> {
        var result = new[dataArray.size()] as Array<WeatherStationData>;
        for (var i = 0; i < dataArray.size(); i++) {
            result[i] = WeatherStationData.fromDict(dataArray[i]);
        }
        return result;
    }

    private var _mainStation as WeatherStationData;
    private var _modules as Array<WeatherStationData>;

    public function initialize(mainStation as WeatherStationData, modules as Array<WeatherStationData>) {
        self._mainStation = mainStation;
        self._modules = [] as Array<WeatherStationData>;
        self._modules.addAll(modules);
    }

    public function mainStation() as WeatherStationData {
        return self._mainStation;
    }

    public function numberOfModules() as Number {
        return self._modules.size();
    }

    public function getModule(index as Number) as WeatherStationData {
        return self._modules[index];
    }

    public function allModules() as Array<WeatherStationData> {
        var result = [] as Array<WeatherStationData>;
        result.addAll(self._modules);
        return result;
    }

    public function toDict() as DeviceDict {
        return {
            "mainStation" => self._mainStation.toDict(),
            "modules" => self._modulesToDict()
        };
    }

    private function _modulesToDict() as Array<WeatherStationDataDict> {
        var result = new[self._modules.size()] as Array<WeatherStationDataDict>;
        for (var i = 0; i < self._modules.size(); i++) {
            result[i] = self._modules[i].toDict();
        }
        return result;
    }
}
