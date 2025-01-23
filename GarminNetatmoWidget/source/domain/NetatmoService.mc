using Toybox.Application.Storage;
import Toybox.System;

class NetatmoService {
    private var _clientAuth as NetatmoClientAuth;
    private var _config as Config;
    private var _cache as StationsDataCache;

    public function initialize(clientAuth as NetatmoClientAuth, config as Config) {
        self._clientAuth = clientAuth;
        self._config = config;
        self._cache = new StationsDataCache();
    }

    public function config() as Config { return self._config; }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        new NetatmoAdapter(self._clientAuth, dataConsumer, notificationConsumer).loadStationData();
    }

    public function dropAuthenticationData() as Void {
        if (System.getDeviceSettings().connectionAvailable) {
            Storage.deleteValue(REFRESH_TOKEN);
            Storage.deleteValue(ACCESS_TOKEN);
            Storage.deleteValue(ACCESS_TOKEN_VALID_UNTIL);
        }
        self.clearCacheIfConnected();
    }

    public function clearCacheIfConnected() as Void {
        if (System.getDeviceSettings().connectionAvailable) {
            self._cache.clear();
        }
    }

    public function setDefaultStation(data as NetatmoStationData) as Void {
        Storage.setValue(DEFAULT_STATION_ID, data.id().value());
    }

    public function getDefaultStationId() as StationId? {
        var rawId = Storage.getValue(DEFAULT_STATION_ID);
        if (notEmpty(rawId)) { return new StationId(rawId); }
        return null;
    }

    public function clearDefaultStationId() as Void {
        Storage.deleteValue(DEFAULT_STATION_ID);
    }

}