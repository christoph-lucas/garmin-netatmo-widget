import Toybox.Lang;
import Toybox.Time;

class NetatmoDataRetriever {

    // FIXME cache retrieved data from netatmo for e.g. 5 minutes in persistent storage

    private var _dataConsumer as Method;

    public function initialize(dataConsumer as Method) {
        self._dataConsumer = dataConsumer;
    }

    public function loadData(accessToken as String) as Void {
        new StationsDataEndpoint(accessToken, method(:processHomesData))
            .callAndThen(method(:processHomesData));
    }

    public function processHomesData(data as NetatmoStationsData) as Void {
        // TODO hand back all data and pick the right data to be displayed somewhere else
        self._dataConsumer.invoke(data.device(0).mainStation(), null);
    }

}

//! see https://dev.netatmo.com/apidocumentation/weather#getstationsdata
class StationsDataEndpoint {
    private var _accessToken as String;
    private var _handler as Method?;
    private var _errorHandler as Method;

    public function initialize(accessToken as String, errorHandler as Method) {
        self._accessToken = accessToken;
        self._errorHandler = errorHandler;
    }

    public function callAndThen(homesDataHandler as Method) {
        if (self._handler != null) {return;} // FIXME throw exception
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
            self._handler.invoke(self._mapResponseToMainStationData(data));
        } else {
            var typedData = data as Dictionary<String, Dictionary<String, String or Number>>;
            var error = typedData["error"];
            self._errorHandler.invoke(new NetatmoError("onReceiveHomesData: Response code " + responseCode + ", error: " + error));
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
        var dashboardData = dict["dashboard_data"] as Dictionary;

        // NB: if a value is missing in the dict, it will be null, even after applying some constructor, i.e. `CO2(null) == null`
        var name = dict["module_name"] as String;
        var measurementTimestamp = dashboardData["time_utc"] as Number;
        var temp = dashboardData["Temperature"] as Float;
        var co2 = dashboardData["CO2"] as Number;

        return new NetatmoStationData(name, new Moment(measurementTimestamp), new Temperature(temp), new CO2(co2));
    }

}