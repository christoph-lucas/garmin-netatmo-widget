import Toybox.Graphics;

class NetatmoStationDrawer {

    public static function draw(dc as Dc, data as NetatmoStationData) as Void {
        dc.drawText(dc.getWidth() / 2, 0.25 * dc.getHeight(), Graphics.FONT_SMALL, data.name(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        var time = data.measurementTimestamp();
        dc.drawText(dc.getWidth() / 2, 0.4 * dc.getHeight(), Graphics.FONT_TINY, time, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        var temp = data.temperature().toLongString();
        dc.drawText(dc.getWidth() / 2, 0.5 * dc.getHeight(), Graphics.FONT_TINY, temp, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var co2 = data.co2().toLongString();
        dc.drawText(dc.getWidth() / 2, 0.6 * dc.getHeight(), Graphics.FONT_TINY, co2, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}