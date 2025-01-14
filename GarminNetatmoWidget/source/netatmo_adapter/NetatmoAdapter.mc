import Toybox.Lang;
import Toybox.System;

typedef DataConsumer as Method(data as NetatmoStationsData) as Void;
typedef NotificationConsumer as Method(notification as Notification) as Void;

class NetatmoAdapter {

    private var _authenticator as NetatmoAuthenticator;
    private var _retriever as NetatmoDataRetriever;
    private var _notificationConsumer as NotificationConsumer;
    private var _dataConsumer as DataConsumer;
    private var _cache as StationsDataCache;

    public function initialize(clientAuth as NetatmoClientAuth, dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) {
        self._notificationConsumer = notificationConsumer;
        self._dataConsumer = dataConsumer;
        self._authenticator = new NetatmoAuthenticator(clientAuth, method(:loadDataGivenToken), notificationConsumer);
        self._retriever = new NetatmoDataRetriever(method(:cachingDataConsumer), notificationConsumer);
        self._cache = new StationsDataCache();
    }

    public function loadStationData() as Void {
        var cachedData = self._cache.get() as NetatmoStationsDataWithValidity?;
        if (cachedData != null && cachedData.isValid()) {
            self._dataConsumer.invoke(cachedData.data());
            return;
        }

        if (!System.getDeviceSettings().connectionAvailable) {
            self._notificationConsumer.invoke(new Status("No connection"));
            if (cachedData != null) {
                self._dataConsumer.invoke(cachedData.data()); // show cached data even if out-of-date
            }
            return;
        }

        self._notificationConsumer.invoke(new Status("Authenticating..."));
        self._authenticator.requestAccessToken();
    }

    public function loadDataGivenToken(accessToken as String) as Void {
        self._notificationConsumer.invoke(new Status("Loading..."));
        self._retriever.loadData(accessToken);
    }

    public function cachingDataConsumer(data as NetatmoStationsData) as Void {
        self._cache.store(data);
        self._dataConsumer.invoke(data);
    }

}