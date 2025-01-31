using Toybox.Application.Storage;
import Toybox.System;

(:glance, :background)
typedef WeatherStationRepository as interface {
    function loadStationData(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void;
    function loadStationDataInBackground(dataConsumer as DataConsumer, notificationConsumer as NotificationConsumer) as Void;
    function dropAuthenticationData() as Void;
    function clearCache() as Void;
};