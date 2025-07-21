using Toybox.Application.Storage;
import Toybox.System;
import Toybox.Lang;

(:glance, :background)
class WeatherStationService {
    private var _config as Config;
    private var _repo as WeatherStationRepository;

    public function initialize(config as Config, repo as WeatherStationRepository) {
        self._config = config;
        self._repo = repo;
    }

    public function config() as Config { return self._config; }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        try {
            self._repo.loadStationData(dataConsumer, notificationConsumer);        
        } catch (ex) {
            notificationConsumer.invoke(new WeatherStationError("Msg: " + ex.getErrorMessage()));
        }
    }

    public function loadStationDataInBackground(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        try {
            self._repo.loadStationDataInBackground(dataConsumer, notificationConsumer);
        } catch (ex) {
            notificationConsumer.invoke(new WeatherStationError("Msg: " + ex.getErrorMessage()));
        }
    }

    public function dropAuthenticationDataIfConnected() as Void {
        if (System.getDeviceSettings().connectionAvailable) {
            self._repo.dropAuthenticationData();
        }
    }

    public function clearCacheIfConnected() as Void {
        if (System.getDeviceSettings().connectionAvailable) {
            self._repo.clearCache();
        }
    }

    public function setDefaultStation(data as WeatherStationData) as Void {
        Storage.setValue(DEFAULT_STATION_ID, data.id().value());
    }

    public function getDefaultStationId() as StationId? {
        var rawId = Storage.getValue(DEFAULT_STATION_ID) as String;
        if (notEmpty(rawId)) { return new StationId(rawId); }
        return null;
    }

    public function clearDefaultStationId() as Void {
        Storage.deleteValue(DEFAULT_STATION_ID);
    }

}