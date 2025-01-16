using Toybox.Application.Storage;
import Toybox.System;

class NetatmoService {
    private var _clientAuth as NetatmoClientAuth;
    private var _cache as StationsDataCache;

    public function initialize(clientAuth as NetatmoClientAuth) {
        self._clientAuth = clientAuth;
        self._cache = new StationsDataCache();
    }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        new NetatmoAdapter(self._clientAuth, dataConsumer, notificationConsumer).loadStationData();
    }

    public function dropAuthenticationData() as Void {
        Storage.deleteValue(REFRESH_TOKEN);
        Storage.deleteValue(ACCESS_TOKEN);
        Storage.deleteValue(ACCESS_TOKEN_VALID_UNTIL);
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