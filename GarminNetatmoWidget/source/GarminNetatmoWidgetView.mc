import Toybox.Graphics;
import Toybox.WatchUi;

class GarminNetatmoWidgetView extends WatchUi.View {

    private var _data as NetatmoStationData;
    private var _labelName as Text?;
    private var _labelTemp as Text?;
    private var _labelCo2 as Text?;

    function initialize(data as NetatmoStationData) {
        View.initialize();
        self._data = data;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
        _labelName = View.findDrawableById("name") as Text;
        _labelTemp = View.findDrawableById("temperature") as Text;
        _labelCo2 = View.findDrawableById("co2") as Text;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        if (self._labelName != null) {
            _labelName.setText(self._data.name());
        }
        if (self._labelTemp != null) {
            _labelTemp.setText("Temp: " + self._data.temperature().format("%.1f") + "°C");
        }
        if (self._labelCo2 != null) {
            _labelCo2.setText("CO2: " + self._data.co2() + "ppm");
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
