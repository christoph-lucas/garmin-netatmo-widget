using Toybox.Application.Storage;
import Toybox.System;

(:glance)
class NetatmoService {
    private var _config as Config;
    private var _cache as StationsDataCache;
    private var _adapterFactory as NetatmoAdapterFactory;

    public function initialize(config as Config, cache as StationsDataCache, adapterFactory as NetatmoAdapterFactory) {
        self._config = config;
        self._cache = cache;
        self._adapterFactory = adapterFactory;
    }

    public function config() as Config { return self._config; }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        self._adapterFactory.get(dataConsumer, notificationConsumer).loadStationData();
    }

    public function dropAuthenticationData() as Void {
        if (System.getDeviceSettings().connectionAvailable) {
            // FIXME introduce NetatmoAuthenticationStorage -> used here and by the Authenticator
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