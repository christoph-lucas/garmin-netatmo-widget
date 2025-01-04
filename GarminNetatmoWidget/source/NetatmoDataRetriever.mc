import Toybox.Lang;

class NetatmoDataRetriever {

    // FIXME cache retrieved data from netatmo for e.g. 5 minutes in persistent storage

    private var _dataConsumer as Method;

    public function initialize(dataConsumer as Method) {
        self._dataConsumer = dataConsumer;
    }

    public function loadData(accessToken as String) as Void {
        // TODO load real data using the Access Token
        new StationsDataEndpoint(accessToken, method(:processHomesData))
            .callAndThen(method(:processHomesData));
    }

    public function processHomesData(data as NetatmoStationData) as Void {
        self._dataConsumer.invoke(data, null);
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
        if (self._handler != null) {return;} // TODO throw exception
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

    private function _mapResponseToMainStationData(data as Dictionary<String, String or Dictionary>) as  NetatmoStationData {
        var body = data["body"] as Dictionary<String, Array or Dictionary>;
        var devices = body["devices"] as Array<Dictionary>;
        var firstDevice = devices[0] as Dictionary;
        var firstDeviceDashboardData = firstDevice["dashboard_data"] as Dictionary;

        var name = firstDevice["module_name"] as String;
        var temp = firstDeviceDashboardData["Temperature"] as Float;
        var co2 = firstDeviceDashboardData["CO2"] as Number;

        return new NetatmoStationData(name, temp, co2);

        // NB: other modules are in body.devices[i].modules
    }
}