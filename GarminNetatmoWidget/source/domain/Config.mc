import Toybox.Lang;

(:glance, :background)
class Config {
    private var _showTemp as Boolean;
    private var _showCO2 as Boolean;
    private var _showHumidity as Boolean;
    private var _showPressure as Boolean;
    private var _showNoise as Boolean;

    public function initialize(showTemp as Boolean, showCO2 as Boolean, showHumidity as Boolean, showPressure as Boolean, showNoise as Boolean) {
        self._showTemp = showTemp;
        self._showCO2 = showCO2;
        self._showHumidity = showHumidity;
        self._showPressure = showPressure;
        self._showNoise = showNoise;
    }

    public function showTemp() as Boolean { return self._showTemp; }
    public function showCO2() as Boolean { return self._showCO2; }
    public function showHumidity() as Boolean { return self._showHumidity; }
    public function showPressure() as Boolean { return self._showPressure; }
    public function showNoise() as Boolean { return self._showNoise; }
}