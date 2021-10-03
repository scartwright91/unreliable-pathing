import hxd.Key;

class Player {

    public var obj : h3d.scene.Object;

    public var gridX : Int;
    public var gridY : Int;

    // move timer
    var moveTimer : Float = hxd.Timer.lastTimeStamp;

    // variables
    public var falling = false;
    public var nGems = 0;

    public function new (x:Int, y:Int) {

        var cache = new h3d.prim.ModelCache();
        obj = cache.loadModel(hxd.Res.character);
        Main.ME.gameScene3d.addChild(obj);

        // grid coordinates
        gridX = x;
        gridY = y;

        obj.scale(0.1);
        obj.x = gridX + 0.5;
        obj.y = gridY + 0.5;
        obj.z = 1;

        updateTile();

    }

    public function destroy() {
        Main.ME.gameScene3d.removeChild(obj);
    }

    public function update() {

        var now = hxd.Timer.lastTimeStamp;

        if (falling) {
            obj.z -= 0.02;
            if (obj.z < -1) {
                destroy();
                return;
            }
        }

        if(now - moveTimer < 0.2) {
            return;
        }

        if (Key.isDown(Key.W)) {
            obj.setRotation(0, 0, Math.PI);
            updateSprite(gridX, gridY - 1);
        }
        if (Key.isDown(Key.S)) {
            obj.setRotation(0, 0, 2 * Math.PI);
            updateSprite(gridX, gridY + 1);
        }
        if (Key.isDown(Key.A)) {
            obj.setRotation(0, 0, Math.PI/2);
            updateSprite(gridX - 1, gridY);
        }
        if (Key.isDown(Key.D)) {
            obj.setRotation(0, 0, 3 * Math.PI/2);
            updateSprite(gridX + 1, gridY);
        }

    }

    public function updateSprite(newGridX:Int, newGridY:Int) {
        // tile must be in grid
        var inGrid = (0 <= newGridX) && (newGridX < Game.ME.level.gridLengthX) &&
                     (0 <= newGridY) && (newGridY < Game.ME.level.gridLengthY);
        if (!inGrid) {
            return;
        }

        // does the tile exist
        var containsTile = Game.ME.level.grid[newGridX][newGridY] != null;
        if (containsTile) {

            gridX = newGridX;
            gridY = newGridY;

            obj.x = gridX + 0.5;
            obj.y = gridY + 0.5;

            updateTile();

            // reset timer
            moveTimer = hxd.Timer.lastTimeStamp;

            falling = false;
            obj.z = 1;

        }

    }

    public function onFinishTile() {
        var onTile = ((gridX == Game.ME.level.finishX) && (gridY == Game.ME.level.finishY));
        var enoughGems = nGems == Game.ME.level.nGems;
        return onTile && enoughGems;
    }

    public function fall() {
        falling = true;
    }

    function updateTile() {
        Game.ME.level.updateTile(gridX, gridY);
    }

}