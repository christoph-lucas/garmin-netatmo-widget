import Toybox.Lang;

class NetatmoAdapter {

    // TODO cache retrieved data from netatmo for e.g. 5 minutes


    public function initialize() {
        // TODO receive necessary config flags, e.g. client id and secret to access Netatmo API
    }

    public function ensureAuthenticated() {
        // TODO ensure Auth is done
    }

    public function getDefaultStation() as NetatmoStationData {
        // TODO make call to netatmo and retrieve the data
        return new NetatmoStationData("default", 23.5, 512);
    }

    public function getAllStations() as Array<NetatmoStationData> {
        // TODO make call to netatmo and retrieve the data
        return [
            new NetatmoStationData("default", 23.5, 512),
            new NetatmoStationData("other", 30.5, 798)
            ];
    }

}