import Toybox.Lang;
import Toybox.System;

typedef DataConsumer as Method(data as NetatmoStationsData) as Void;
typedef NotificationConsumer as Method(notification as Notification) as Void;

class NetatmoAdapter {

    private var _authenticator as NetatmoAuthenticator;
    private var _retriever as NetatmoDataRetriever;
    private var _dataConsumer as DataConsumer;
    private var _notificationConsumer as NotificationConsumer;

    public function initialize(clientAuth as NetatmoClientAuth, dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) {
        self._dataConsumer = dataConsumer;
        self._notificationConsumer = notificationConsumer;
        self._authenticator = new NetatmoAuthenticator(clientAuth, method(:loadDataGivenToken), notificationConsumer);
        self._retriever = new NetatmoDataRetriever(method(:returnLoadedData));
    }

    public function loadStationData() as Void {
        if (!System.getDeviceSettings().connectionAvailable) {
            self._notificationConsumer.invoke(new Status("No connection"));
            return;
        }
        self._notificationConsumer.invoke(new Status("Authenticating..."));
        self._authenticator.requestAccessToken();
    }

    public function loadDataGivenToken(accessToken as String) as Void {
        self._notificationConsumer.invoke(new Status("Loading..."));
        self._retriever.loadData(accessToken);
    }

    public function returnLoadedData(data as NetatmoStationsData?, error as NetatmoError?) as Void {
        if (error != null) {
            self._notificationConsumer.invoke(error);
        } else if (data != null) {
            self._dataConsumer.invoke(data);
        } else {
            self._notificationConsumer.invoke(new NetatmoError("loadDataGivenToken: Neither Access Token nor Error given."));
        }
    }

}