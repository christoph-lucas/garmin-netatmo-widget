class NetatmoService {
    private var _clientAuth as NetatmoClientAuth;

    public function initialize(clientAuth as NetatmoClientAuth) {
        self._clientAuth = clientAuth;
    }

    public function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void {
        new NetatmoAdapter(self._clientAuth, dataConsumer, notificationConsumer).loadStationData();
    }
}