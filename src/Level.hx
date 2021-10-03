class Level {

    public var gridLengthX : Int;
    public var gridLengthY : Int;
    public var offsetX : Float;
    public var offsetY : Float;

    public var grid : Array<Array<Dynamic>>;

    public var tiles : Array<Tile> = [];

	public var level : World.World_Level;

    public var playerStartX : Int;
    public var playerStartY : Int;
    public var finishX : Int;
    public var finishY : Int;
    public var gems : Array<Gem> = [];
    public var nGems : Int;

    public function new(l:World.World_Level) {

		level = l;

        gridLengthX = level.l_StrongTiles.cWid;
        gridLengthY = level.l_StrongTiles.cHei;

        Main.ME.gameScene3d.camera.target.set(gridLengthY/2, gridLengthX/2, -5);
        Main.ME.gameScene3d.camera.pos.set(gridLengthY/2, gridLengthX/2, 28);

        createLevel();
        create3DScene();

    }

    public function destroy() {

        for (tile in tiles)
            tile.destroy();

        for (gem in gems) {
            gem.destroy();
        }
    }

    public function updateTile(gridX:Int, gridY:Int) {

        // update tile
        var t : Tile;
        t = grid[gridX][gridY];

        if (t.finishTile) {
            return;
        }

        t.stepCounter++;

        if (t.stepCounter == 1) {
            t.obj.material.color.setColor(Utils.RGBToCol(150, 0, 0, 255));
        } else if (t.stepCounter == 2) {
            t.fall();
            grid[gridX][gridY] = null;
        }

        for (gem in gems) {
            if ((gridX == gem.gridX) && (gridY == gem.gridY)) {
                gem.destroy();
                Game.ME.player.nGems += 1;
            }
        }

    }

    function createLevel() {
        
        grid = [for (x in 0...gridLengthX) [for (y in 0...gridLengthY) null]];

        // extract player
        var playerPosition = level.l_Entities.all_Player[0];
        playerStartX = playerPosition.cx;
        playerStartY = playerPosition.cy;

        // extract finish
        var finishPosition = level.l_Entities.all_Finish[0];
        finishX = finishPosition.cx;
        finishY = finishPosition.cy;

        for (x in 0...gridLengthX) {
            for (y in 0...gridLengthY) {

                // strong tile
                var sv = level.l_StrongTiles.hasValue(x, y);
                if (sv) {
                    var strongTile : Tile;
                    if ((x == finishX) && (y == finishY)) {
                        strongTile = new Tile(x, y, true, true);
                    } else {
                        strongTile = new Tile(x, y, false, true);
                    }
                    grid[x][y] = strongTile;
                    tiles.push(strongTile);
                }
                // weak tile
                var wv = level.l_WeakTiles.hasValue(x, y);
                if (wv) {
                    var weakTile : Tile;
                    if ((x == finishX) && (y == finishY)) {
                        weakTile = new Tile(x, y, true, false);
                    } else {
                        weakTile = new Tile(x, y, false, false);
                    }
                    grid[x][y] = weakTile;
                    tiles.push(weakTile);
                }
            }
        }

        // extract gems
        gems = [];
        for (g in level.l_Entities.all_Gems) {
            var gem = new Gem(g.cx, g.cy);
            gems.push(gem);
        }
        nGems = gems.length;

    }

    function create3DScene() {

        var bonesBitmap = hxd.Res.bonesTexture.toBitmap();
        var bonesTexture = new h3d.mat.Texture(bonesBitmap.width, bonesBitmap.height, [MipMapped]);
        bonesTexture.uploadBitmap(bonesBitmap);
        bonesTexture.wrap = Repeat;
        bonesTexture.mipMap = Linear;
        var bonesMaterial = h3d.mat.Material.create(bonesTexture);
        var brickMaterial = h3d.mat.Material.create(bonesTexture);

        var h = 25;

        // floordddsss
        var prim = new h3d.prim.Cube(gridLengthX, gridLengthY, 0.1);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        var floor = new h3d.scene.Mesh(prim, Main.ME.gameScene3d);
        floor.material = bonesMaterial; 
        floor.material.shadows = false;
        floor.material.mainPass.enableLights = false;
        floor.x = 0;
        floor.y = 0;
        floor.z = -10;

        // wall front
        var prim = new h3d.prim.Cube(gridLengthX, 0.1, h);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        var wallOne = new h3d.scene.Mesh(prim, Main.ME.gameScene3d);
        wallOne.material = brickMaterial; 
        wallOne.material.shadows = false;
        wallOne.material.mainPass.enableLights = true;
        wallOne.x = 0;
        wallOne.y = 0;
        wallOne.z = -10;

        // wall back
        var prim = new h3d.prim.Cube(gridLengthX, 0.1, h);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        var wallOne = new h3d.scene.Mesh(prim, Main.ME.gameScene3d); 
        wallOne.material = brickMaterial; 
        wallOne.material.shadows = false;
        wallOne.material.mainPass.enableLights = true;
        wallOne.x = 0;
        wallOne.y = gridLengthY;
        wallOne.z = -10;

        // wall left
        var prim = new h3d.prim.Cube(gridLengthY, 0.1, h);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        var wallOne = new h3d.scene.Mesh(prim, Main.ME.gameScene3d);
        wallOne.rotate(0, 0, hxd.Math.degToRad(90));
        wallOne.material = brickMaterial; 
        wallOne.material.shadows = false;
        wallOne.material.mainPass.enableLights = true;
        wallOne.x = 0;
        wallOne.y = 0;
        wallOne.z = -10;

        // wall right
        var prim = new h3d.prim.Cube(gridLengthY, 0.1, h);
        prim.unindex();
        prim.addNormals();
        prim.addUVs();
        var wallOne = new h3d.scene.Mesh(prim, Main.ME.gameScene3d);
        wallOne.rotate(0, 0, hxd.Math.degToRad(90));
        wallOne.material = brickMaterial; 
        wallOne.material.shadows = false;
        wallOne.material.mainPass.enableLights = true;
        wallOne.x = gridLengthX;
        wallOne.y = 0;
        wallOne.z = -10;

    }

}