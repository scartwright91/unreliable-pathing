class Tile {

    public var id : Int;
    public var obj : h3d.scene.Mesh;

    public var stepCounter : Int = 0;
    public var finishTile : Bool;

    var falling : Bool = false;

    public function new(gridX:Int,
                        gridY:Int,
                        finish:Bool,
                        strong:Bool) {

        finishTile = finish;

        var tileTexture = hxd.Res.container.toTexture();
        var tileMaterial = h3d.mat.Material.create(tileTexture);

        var prim = new h3d.prim.Cube();
        prim.unindex();
        prim.addNormals();
        prim.addUVs();

        obj = new h3d.scene.Mesh(prim, Main.ME.gameScene3d);

        // set the second cube color

        obj.material = tileMaterial;

        if (!strong) {
            stepCounter = 1;
            obj.material.color.setColor(Utils.RGBToCol(150, 0, 0, 255));
        }

        if (finish) {
            obj.material.color.setColor(Utils.RGBToCol(0, 255, 0, 255));
        }

        obj.material.shadows = false;
        obj.material.mainPass.enableLights = true;

        obj.scale(0.8);
        obj.x = gridX;
        obj.y = gridY;
        obj.z = 0;

    }

    public function update() {
        if (falling) {
            obj.z -= 0.02;
            if ((obj.x == Game.ME.player.gridX) && (obj.y == Game.ME.player.gridY)) {
                Game.ME.player.fall();
            }
            if (obj.z < -1) {
                destroy();
            }
        }
    }

    public function fall() {
        falling = true;
    }

    public function destroy() {
        Main.ME.gameScene3d.removeChild(obj);
    }

}
