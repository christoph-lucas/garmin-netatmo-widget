import Toybox.Lang;

(:glance, :background)
class Config {
    private var _showTemp as Boolean;
    private var _showCO2 as Boolean;
    private var _showHumidity as Boolean;
    private var _showPressure as Boolean;
    private var _showNoise as Boolean;
    private var _showRain as Boolean;
    private var _showRain1h as Boolean;
    private var _showRain24h as Boolean;
    private var _showWind as Boolean;
    private var _showGust as Boolean;
    private var _glanceField1 as Number;
    private var _glanceField2 as Number;
    private var _activateBackgroundLoading as Boolean;
    private var _backgroundRefreshInterval as Number;

    public function initialize(showTemp as Boolean, showCO2 as Boolean, showHumidity as Boolean, showPressure as Boolean, showNoise as Boolean,
            showRain as Boolean, showRain1h as Boolean, showRain24h as Boolean, showWind as Boolean, showGust as Boolean,
            glanceField1 as Number, glanceField2 as Number,
            activateBackgroundLoading as Boolean, backgroundRefreshInterval as Number) {
        self._showTemp = showTemp;
        self._showCO2 = showCO2;
        self._showHumidity = showHumidity;
        self._showPressure = showPressure;
        self._showNoise = showNoise;
        self._showRain = showRain;
        self._showRain1h = showRain1h;
        self._showRain24h = showRain24h;
        self._showWind = showWind;
        self._showGust = showGust;
        self._glanceField1 = glanceField1;
        self._glanceField2 = glanceField2;
        self._activateBackgroundLoading = activateBackgroundLoading;
        self._backgroundRefreshInterval = backgroundRefreshInterval;
    }

    public function showTemp() as Boolean { return self._showTemp; }
    public function showCO2() as Boolean { return self._showCO2; }
    public function showHumidity() as Boolean { return self._showHumidity; }
    public function showPressure() as Boolean { return self._showPressure; }
    public function showNoise() as Boolean { return self._showNoise; }
    public function showRain() as Boolean { return self._showRain; }
    public function showRain1h() as Boolean { return self._showRain1h; }
    public function showRain24h() as Boolean { return self._showRain24h; }
    public function showWind() as Boolean { return self._showWind; }
    public function showGust() as Boolean { return self._showGust; }
    public function glanceField1() as Number { return self._glanceField1; }
    public function glanceField2() as Number { return self._glanceField2; }
    public function activateBackgroundLoading() as Boolean { return self._activateBackgroundLoading; }
    public function backgroundRefreshInterval() as Number { return self._backgroundRefreshInterval; }
}