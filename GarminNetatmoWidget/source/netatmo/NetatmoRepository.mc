using Toybox.Application.Storage;
import Toybox.System;

(:glance, :background)
public class NetatmoRepository { // implements WeatherStationRepository

    private var _cache as StationsDataCache;
    private var _connectionsFactory as NetatmoConnectionsOrchastratorFactory;

    public function initialize(cache as StationsDataCache, connectionsFactory as NetatmoConnectionsOrchastratorFactory) {
        self._cache = cache;
        self._connectionsFactory = connectionsFactory;
    }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        self._connectionsFactory.get(dataConsumer, notificationConsumer).loadStationData();
    }

    public function loadStationDataInBackground(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        self._connectionsFactory.get(dataConsumer, notificationConsumer).loadStationDataInBackground();
    }

    public function dropAuthenticationData() as Void {
        Storage.deleteValue(REFRESH_TOKEN);
        Storage.deleteValue(ACCESS_TOKEN);
        Storage.deleteValue(ACCESS_TOKEN_VALID_UNTIL);
        self.clearCache();
    }

    public function clearCache() as Void {
        self._cache.clear();
    }

}