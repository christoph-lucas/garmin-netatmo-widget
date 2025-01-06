import Toybox.Lang;

typedef DataConsumer as Method(data as NetatmoStationsData?, error as NetatmoError?) as Void;

class NetatmoAdapter {

    private var _authenticator as NetatmoAuthenticator;
    private var _retriever as NetatmoDataRetriever;
    private var _dataConsumer as DataConsumer;

    public function initialize(client_id as String, client_secret as String, dataConsumer as DataConsumer) {
        self._dataConsumer = dataConsumer;

        self._authenticator = new NetatmoAuthenticator(client_id, client_secret, method(:loadDataGivenToken));
        self._retriever = new NetatmoDataRetriever(method(:returnLoadedData));
    }

    public function loadStationData() as Void {
        self._authenticator.requestAccessToken();
    }

    public function loadDataGivenToken(accessToken as String?, error as NetatmoError?) as Void {
        if (error != null) {
            self._dataConsumer.invoke(null, error);
        } else if (accessToken != null) {
            self._retriever.loadData(accessToken);
        } else {
            self._dataConsumer.invoke(null, new NetatmoError("loadDataGivenToken: Neither Access Token nor Error given."));
        }
    }

    public function returnLoadedData(data as NetatmoStationsData?, error as NetatmoError?) as Void {
        self._dataConsumer.invoke(data, error);
    }

}