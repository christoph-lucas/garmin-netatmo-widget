import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// draws the system hint indicating which button opens the menu,
// the layout is empty on products without such a hint
function drawMenuHint(dc as Dc) as Void {
    var drawables = Rez.Layouts.MenuHint(dc);
    for (var i = 0; i < drawables.size(); i++) {
        (drawables[i] as Drawable).draw(dc);
    }
}
