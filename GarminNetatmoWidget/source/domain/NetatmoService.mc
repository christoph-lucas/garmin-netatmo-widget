using Toybox.Application.Storage;

class NetatmoService {
    private var _clientAuth as NetatmoClientAuth;

    public function initialize(clientAuth as NetatmoClientAuth) {
        self._clientAuth = clientAuth;
    }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        new NetatmoAdapter(self._clientAuth, dataConsumer, notificationConsumer).loadStationData();
    }

    public function dropAuthenticationData() as Void {
        Storage.deleteValue(REFRESH_TOKEN);
        Storage.deleteValue(ACCESS_TOKEN);
        Storage.deleteValue(ACCESS_TOKEN_VALID_UNTIL);
    }
}