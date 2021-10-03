@:access(h2d.Scene)
class Main extends hxd.App {

    public static var ME : Main;
    public var game : Game;
    public var menu : ui.StartMenu;
    public var end : ui.EndMenu;
    public var menuRunning : Bool;
    public var gameFinished : Bool = false;
    public var delta : Float;
    public var windowWidth : Float;
    public var windowHeight : Float;

    // scenes
    public var gameScene2d : h2d.Scene;
    public var gameScene3d : h3d.scene.Scene;


    override function init() {
        ME = this;

        gameScene2d = s2d;
        gameScene3d = s3d;

        // Create menu and set the scene
        menu = new ui.StartMenu();
        end = new ui.EndMenu();

        hxd.Window.getInstance().addResizeEvent(resizeWindow);

        windowWidth = hxd.Window.getInstance().width;
        windowHeight = hxd.Window.getInstance().height;
        
        menuRunning = true;
        setScene(menu.menuScene);

        game = new Game();

    }

    override function update(dt:Float) {
        delta = dt;
        if (!menuRunning) {
            game.update(dt);
        }
    }

    public function enterGame() {
        menuRunning = false;
        //s2d.events.defaultCursor = hxd.Cursor.Hide;
        setScene(gameScene2d, false);
    }

    public function enterMenu() {
        menuRunning = true;
        s2d.events.defaultCursor = hxd.Cursor.Default;
        setScene(menu.menuScene, false);
    }

    public function completeGame() {
        menuRunning = true;
        gameFinished = true;
        s2d.events.defaultCursor = hxd.Cursor.Default;
        setScene(end.menuScene, false);
    }

    function resizeWindow() {
        windowWidth = hxd.Window.getInstance().width;
        windowHeight = hxd.Window.getInstance().height;
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}
