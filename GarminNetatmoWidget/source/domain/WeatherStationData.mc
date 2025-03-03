import Toybox.Lang;

typedef WeatherStationDataDict as Dictionary<String, String or Number or Float or Null>;

(:glance, :background)
class WeatherStationData {

    public static function fromDict(dict as WeatherStationDataDict) as WeatherStationData {
        return new WeatherStationData(
            new StationId(dict["id"] as String),
            dict["name"] as String,
            new Timestamp(dict["measurementTimestamp"] as Number?),
            new Temperature(dict["temperature"] as Float?),
            new CO2(dict["co2"] as Number?),
            new Humidity(dict["humidity"] as Number?),
            new Pressure(dict["pressure"] as Float?),
            new Noise(dict["noise"] as Number?),
            new Rain(dict["rain"] as Number?, RAIN_TYPE_NOW),
            new Rain(dict["rain1h"] as Number?, RAIN_TYPE_LAST_1H),
            new Rain(dict["rain24h"] as Number?, RAIN_TYPE_LAST_24H)
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
    private var _rain as Rain;
    private var _rain1h as Rain;
    private var _rain24h as Rain;

    public function initialize(id as StationId, name as String, measurementTimestamp as Timestamp, 
        temperature as Temperature, co2 as CO2, humidity as Humidity, pressure as Pressure, noise as Noise,
        rain as Rain, rain1h as Rain, rain24h as Rain) {
        self._id = id;
        self._name = name;
        self._measurementTimestamp = measurementTimestamp;
        self._temperature = temperature;
        self._co2 = co2;
        self._humidity = humidity;
        self._pressure = pressure;
        self._noise = noise;
        self._rain = rain;
        self._rain1h = rain1h;
        self._rain24h = rain24h;
    }

    public function id() as StationId { return self._id; }
    public function name() as String { return self._name; }
    public function measurementTimestamp() as Timestamp { return self._measurementTimestamp; }
    public function temperature() as Temperature { return self._temperature; }
    public function co2() as CO2 { return self._co2; }
    public function humidity() as Humidity { return self._humidity; }
    public function pressure() as Pressure { return self._pressure; }
    public function noise() as Noise { return self._noise; }
    public function rain() as Rain { return self._rain; }
    public function rain1h() as Rain { return self._rain1h; }
    public function rain24h() as Rain { return self._rain24h; }

    public function toDict() as WeatherStationDataDict {
        return {
            "id" => self._id.value(),
            "name" => self._name,
            "measurementTimestamp" => self._measurementTimestamp.value(),
            "temperature" => self._temperature.value(),
            "co2" => self._co2.value(),
            "humidity" => self._humidity.value(),
            "pressure" => self._pressure.value(),
            "noise" => self._noise.value(),
            "rain" => self._rain.value(),
            "rain1h" => self._rain1h.value(),
            "rain24h" => self._rain24h.value(),
        };
    }

}