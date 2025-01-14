import Toybox.Lang;
import Toybox.Time;

typedef StationsDataConsumer as Method(data as NetatmoStationsData) as Void;

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
class StationsDataEndpoint {
    private var _accessToken as String;
    private var _handler as StationsDataConsumer?;
    private var _notificationConsumer as NotificationConsumer;

    public function initialize(accessToken as String, notificationConsumer as NotificationConsumer) {
        self._accessToken = accessToken;
        self._notificationConsumer = notificationConsumer;
    }

    public function callAndThen(homesDataHandler as StationsDataConsumer) {
        if (self._handler != null) {throw new OperationNotAllowedException("Handler already defined.");}
        self._handler = homesDataHandler;
        self._requestHomesData();
    }

    private function _requestHomesData() {
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
            self._handler.invoke(self._mapResponseToMainStationData(data));
        } else {
            var typedData = data as Dictionary<String, Dictionary<String, String or Number>>;
            var error = typedData["error"];
            var error_code = error["code"] as Number;
            var error_msg = error["message"] as String;
            self._notificationConsumer.invoke(new WebRequestError("StationsData", responseCode, error_msg, error_code));
        }
    }

    // FIXME move to separate dedicated Mapper?

    private function _mapResponseToMainStationData(data as Dictionary<String, String or Dictionary>) as  NetatmoStationsData {
        var body = data["body"] as Dictionary<String, Array or Dictionary>;
        var rawDevices = body["devices"] as Array<Dictionary>;

        var numberOfDevices = rawDevices.size();
        var devices = new Array[numberOfDevices] as Array<Device>;
        for (var i = 0; i<numberOfDevices; i++) {
            devices[i] = self._mapDevice(rawDevices[i]);
        }

        return new NetatmoStationsData(devices);
    }

    private function _mapDevice(device as Dictionary) as Device {
        var mainStation = self._mapToNetatmoStationData(device);

        var rawModules = device["modules"] as Array<Dictionary<String, String or Number or Dictionary>>;
        var numberOfModules = rawModules.size();
        var modules = new Array[numberOfModules] as Array<NetatmoStationData>;
        for (var i = 0; i<numberOfModules; i++) {
            modules[i] = self._mapToNetatmoStationData(rawModules[i]);
        }

        return new Device(mainStation, modules);
    }

    private function _mapToNetatmoStationData(dict as Dictionary<String, String or Number or Dictionary>) as NetatmoStationData {
        // the device and each module share the same structure in the response
        var dashboardData = dict["dashboard_data"] as Dictionary?;

        var name = dict["module_name"] as String;
        if (dashboardData != null) {
            var measurementTimestamp = dashboardData["time_utc"] as Number;
            var temp = dashboardData["Temperature"] as Float;
            var co2 = dashboardData["CO2"] as Number;
            return new NetatmoStationData(name, new Timestamp(measurementTimestamp), new Temperature(temp), new CO2(co2));
        }

        // if station is not connected, there is no dashboard data
        // FIXME handle more gracefully
        return new NetatmoStationData(name, new Timestamp(null), new Temperature(null), new CO2(null));
    }

}