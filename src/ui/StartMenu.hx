package ui;

import hxd.Window;
import hxd.res.DefaultFont;
import h2d.Text;

class StartMenu {

    var txt : Text;
    public var menuScene : h2d.Scene;
    var i : h2d.Interactive;
    var g : h2d.Graphics;

    var w : Float;
    var h : Float;

    public function new() {

        // create menu scene and text
        w = Window.getInstance().width;
        h = Window.getInstance().height;

        menuScene = new h2d.Scene();

        //specify a color we want to draw with
        var g = new h2d.Graphics(menuScene);
        g.beginFill(0xEA8220);
        g.drawRect(0, 0, w, h);
        g.endFill();

        hxd.Window.getInstance().addResizeEvent(resizeMenu);      

        var play = new h2d.Text(DefaultFont.get(), menuScene);
        play.text = "Play";
        play.x = w / 10;
        play.y = h / 4;
        play.color.setColor(Utils.RGBToCol(0, 0, 0, 255));
        play.scale(6);

        var txt = new h2d.Text(DefaultFont.get(), menuScene);
        txt.text = "Controls: WASD to move; R to reset level";
        txt.x = w / 10;
        txt.y = h / 4 + h / 8;
        txt.color.setColor(Utils.RGBToCol(0, 0, 0, 255));
        txt.scale(3);

        var txt = new h2d.Text(DefaultFont.get(), menuScene);
        txt.text = "Objective: Reach the green container after collecting all the coins";
        txt.x = w / 10;
        txt.y = h / 4 + 2 * h / 8;
        txt.color.setColor(Utils.RGBToCol(0, 0, 0, 255));
        txt.scale(3);

        var txt = new h2d.Text(DefaultFont.get(), menuScene);
        txt.text = "A game by Arachnid56";
        txt.x = w / 10;
        txt.y = h / 4 + h / 2;
        txt.color.setColor(Utils.RGBToCol(0, 0, 0, 255));
        txt.scale(3);

        // create interactive box around text
        var i = new h2d.Interactive(play.textWidth, play.textHeight, play);
        i.onClick = function(_) {
            Main.ME.enterGame();
        }

    }

    function resizeMenu() {
        w = hxd.Window.getInstance().width;
        h = hxd.Window.getInstance().height;
    }

}