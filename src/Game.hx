
import hxd.Key;
import hxd.res.DefaultFont;



class Game {

    // settings
    public var gridSize = 80;

    public static var ME : Game;

    public var world : World;
    public var nLevels : Int;
    public var levelCounter : Int = 0;
    public var level : Level;
    public var player : Player;

    // fps
    var fps : h2d.Text;

    public function new() {

        ME = this;

        // render fps
        fps = new h2d.Text(DefaultFont.get(), Main.ME.gameScene2d);
        fps.text = "";
        fps.scale(2);

        // create level
        world = new World();
        level = new Level(world.levels[levelCounter]);
        player = new Player(level.playerStartX, level.playerStartY);

        new h3d.scene.CameraController(Main.ME.gameScene3d).loadFromCamera();
        Main.ME.gameScene3d.setRotationAxis(0, 0, 1, -Math.PI/2);
        Main.ME.gameScene3d.x = 0;
        Main.ME.gameScene3d.y = 15;

        new h3d.scene.fwd.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), Main.ME.gameScene3d);
        Main.ME.gameScene3d.lightSystem.ambientLight.setColor(0x909090);

    }

    public function createLevel(counter:Int) {

        level.destroy();
        player.destroy();

        level = new Level(world.levels[counter]);
        player = new Player(level.playerStartX, level.playerStartY);

    }

    public function update(dt:Float) {

        player.update();

        for (tile in level.tiles) {
            tile.update();
        }

        for (gem in level.gems) {
            gem.update(dt);
        }

        if (player.onFinishTile()) {
            if (levelCounter == world.levels.length - 1) {
                Main.ME.completeGame();
            } else {
                levelCounter += 1;
                createLevel(levelCounter);
            }
        }

        // reset level
        if (Key.isReleased(Key.R)) {
            createLevel(levelCounter);
        }

    }

}