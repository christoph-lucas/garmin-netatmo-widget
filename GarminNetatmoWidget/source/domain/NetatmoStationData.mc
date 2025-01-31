import Toybox.Lang;

typedef NetatmoStationDataDict as Dictionary<String, String or Number or Float or Null>;

(:glance, :background)
class NetatmoStationData {

    public static function fromDict(dict as NetatmoStationDataDict) as NetatmoStationData {
        return new NetatmoStationData(
            new StationId(dict["id"] as String),
            dict["name"] as String,
            new Timestamp(dict["measurementTimestamp"] as Number?),
            new Temperature(dict["temperature"] as Float?),
            new CO2(dict["co2"] as Number?),
            new Humidity(dict["humidity"] as Number?),
            new Pressure(dict["pressure"] as Float?),
            new Noise(dict["noise"] as Number?)
        );
    }

    private var _id as StationId;
    private var _name as String;
    private var _measurementTimestamp as Timestamp;
    private var _temperature as Temperature;
    private var _co2 as CO2;
    private var _humidity as Humidity;
    private var _pressure as Pressure;
    private var _noise as Noise;

    public function initialize(id as StationId, name as String, measurementTimestamp as Timestamp, 
        temperature as Temperature, co2 as CO2, humidity as Humidity, pressure as Pressure, noise as Noise) {
        self._id = id;
        self._name = name;
        self._measurementTimestamp = measurementTimestamp;
        self._temperature = temperature;
        self._co2 = co2;
        self._humidity = humidity;
        self._pressure = pressure;
        self._noise = noise;
    }

    public function id() as StationId { return self._id; }
    public function name() as String { return self._name; }
    public function measurementTimestamp() as Timestamp { return self._measurementTimestamp; }
    public function temperature() as Temperature { return self._temperature; }
    public function co2() as CO2 { return self._co2; }
    public function humidity() as Humidity { return self._humidity; }
    public function pressure() as Pressure { return self._pressure; }
    public function noise() as Noise { return self._noise; }

    public function toDict() as NetatmoStationDataDict {
        return {
            "id" => self._id.value(),
            "name" => self._name,
            "measurementTimestamp" => self._measurementTimestamp.value(),
            "temperature" => self._temperature.value(),
            "co2" => self._co2.value(),
            "humidity" => self._humidity.value(),
            "pressure" => self._pressure.value(),
            "noise" => self._noise.value()
        };
    }

}