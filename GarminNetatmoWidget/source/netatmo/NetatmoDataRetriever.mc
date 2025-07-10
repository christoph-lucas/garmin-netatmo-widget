import Toybox.Lang;
import Toybox.Time;

typedef StationsDataConsumer as Method(data as WeatherStationsData) as Void;

(:glance, :background)
class NetatmoDataRetriever {

    private var _dataConsumer as StationsDataConsumer;
    private var _notificationConsumer as NotificationConsumer;

    public function initialize(dataConsumer as StationsDataConsumer, notificationConsumer as NotificationConsumer) {
        self._dataConsumer = dataConsumer;
        self._notificationConsumer = notificationConsumer;
    }

    public function loadData(accessToken as String) as Void {
        new StationsDataEndpoint(accessToken, self._notificationConsumer)
            .callAndThen(self._dataConsumer);
    }

}

//! see https://dev.netatmo.com/apidocumentation/weather#getstationsdata
(:glance, :background)
class StationsDataEndpoint {
    private var _accessToken as String;
    private var _handler as StationsDataConsumer?;
    private var _notificationConsumer as NotificationConsumer;

    public function initialize(accessToken as String, notificationConsumer as NotificationConsumer) {
        self._accessToken = accessToken;
        self._notificationConsumer = notificationConsumer;
    }

    public function callAndThen(homesDataHandler as StationsDataConsumer) as Void {
        if (self._handler != null) {throw new OperationNotAllowedException("Handler already defined.");}
        self._handler = homesDataHandler;
        self._requestHomesData();
    }

    private function _requestHomesData() as Void {
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {"Authorization" => ("Bearer " + self._accessToken)},
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON            
        };

        var responseCallback = method(:onReceiveHomesData);

        Communications.makeWebRequest(
            "https://api.netatmo.com/api/getstationsdata",
            null,
            options,
            responseCallback
        );
    }

    public function onReceiveHomesData(responseCode as Number, data as Dictionary or String or Null) as Void {
        if (responseCode == 200) {
            self._notificationConsumer.invoke(new Status("Data received, processing..."));
            if (self._handler != null) {
                (self._handler as StationsDataConsumer).invoke(self._mapResponseToMainStationData((data as Dictionary<String, String or Dictionary>)));
            } else {
                self._notificationConsumer.invoke(new WeatherStationError("No StationsDataConsumer defined."));
            }
        } else {
            var typedData = data as Dictionary<String, Dictionary<String, String or Number>>;
            var error = typedData["error"] as Dictionary<String, String or Number>;
            var error_code = error["code"] as Number;
            var error_msg = error["message"] as String;
            self._notificationConsumer.invoke(new WebRequestError("StationsData", responseCode, error_msg, error_code));
        }
    }

    private function _mapResponseToMainStationData(data as Dictionary<String, String or Dictionary>) as  WeatherStationsData {
        var body = data["body"] as Dictionary<String, Array or Dictionary>;
        var rawDevices = body["devices"] as Array<Dictionary<String, String or Number or Dictionary>>;

        var numberOfDevices = rawDevices.size();
        var devices = new Array[numberOfDevices] as Array<Device>;
        for (var i = 0; i<numberOfDevices; i++) {
            devices[i] = self._mapDevice(rawDevices[i]);
        }

        return new WeatherStationsData(devices);
    }

    private function _mapDevice(device as Dictionary<String, String or Number or Dictionary>) as Device {
        var mainStation = self._mapToWeatherStationData(device);

        var rawModules = device["modules"] as Array<Dictionary<String, String or Number or Dictionary>>;
        var numberOfModules = rawModules.size();
        var modules = new Array[numberOfModules] as Array<WeatherStationData>;
        for (var i = 0; i<numberOfModules; i++) {
            modules[i] = self._mapToWeatherStationData(rawModules[i]);
        }

        return new Device(mainStation, modules);
    }

    private function _mapToWeatherStationData(dict as Dictionary<String, String or Number or Dictionary>) as WeatherStationData {
        // the device and each module share the same structure in the response
        var dashboardData = dict["dashboard_data"] as Dictionary?;

        var id = new StationId(dict["_id"] as String);
        var name = dict["module_name"] as String;
        if (dashboardData != null) {
            var measurementTimestamp = dashboardData["time_utc"] as Number?;
            var temp = dashboardData["Temperature"] as Float?;
            var co2 = dashboardData["CO2"] as Number?;
            var humidity = dashboardData["Humidity"] as Number?;
            var pressure = dashboardData["Pressure"] as Float?;
            var noise = dashboardData["Noise"] as Number?;
            var rain = dashboardData["Rain"] as Float?;
            var rain1h = dashboardData["sum_rain_1"] as Float?;
            var rain24h = dashboardData["sum_rain_24"] as Float?;
            var windStrength = dashboardData["WindStrength"] as Float?;
            var windAngle = dashboardData["WindAngle"] as Float?;
            var gustStrength = dashboardData["GustStrength"] as Float?;
            var gustAngle = dashboardData["GustAngle"] as Float?;
            return new WeatherStationData(id, name, new Timestamp(measurementTimestamp), 
                new Temperature(temp), new CO2(co2), new Humidity(humidity), new Pressure(pressure), new Noise(noise),
                new Rain(rain, RAIN_TYPE_NOW), new Rain(rain1h, RAIN_TYPE_LAST_1H), new Rain(rain24h, RAIN_TYPE_LAST_24H),
                new Wind(windStrength, windAngle, WIND_TYPE_WIND), new Wind(gustStrength, gustAngle, WIND_TYPE_GUST));
        }

        // if station is not connected, there is no dashboard data
        return new WeatherStationData(id, name, new Timestamp(null), new Temperature(null), new CO2(null), new Humidity(null), new Pressure(null), new Noise(null),
            new Rain(null, RAIN_TYPE_NOW), new Rain(null, RAIN_TYPE_LAST_1H), new Rain(null, RAIN_TYPE_LAST_24H),
            new Wind(null, null, WIND_TYPE_WIND), new Wind(null, null, WIND_TYPE_GUST));
    }

}