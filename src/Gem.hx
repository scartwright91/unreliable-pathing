class Gem {

    public var obj : h3d.scene.Object;

    public var gridX : Int;
    public var gridY : Int;

    public function new(x:Int, y:Int) {

        var cache = new h3d.prim.ModelCache();
        obj = cache.loadModel(hxd.Res.coin);
        Main.ME.gameScene3d.addChild(obj);

        gridX = x;
        gridY = y;

        obj.scale(0.3);
        obj.x = gridX + 0.5;
        obj.y = gridY + 0.5;
        obj.z = 1.0;

    }

    public function update(dt:Float) {
        obj.rotate(0, 0, dt);
    }

    public function destroy() {
        Main.ME.gameScene3d.removeChild(obj);
    }
}