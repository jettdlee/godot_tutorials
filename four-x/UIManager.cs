using Godot;
using System;

public partial class UIManager : Node2D
{
    PackedScene terrainUiScene;

    TerrainTileUi terrainUi;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        terrainUiScene = ResourceLoader.Load<PackedScene>("TerrainTileUI.tscn");
    }

    public void HideAllPopups()
    {
        if (terrainUi is not null)
        {
            terrainUi.QueueFree();
            terrainUi = null;
        }
    }
    public void SetTerrainUi(Hex h)
    {
        if (terrainUi is not null) terrainUi.QueueFree();

        terrainUi = (TerrainTileUi) terrainUiScene.Instantiate();
        AddChild(terrainUi);
        terrainUi.SetHex(h);
    }
}