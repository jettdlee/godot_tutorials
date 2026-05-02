using Godot;
using System;

public partial class UIManager : Node2D
{
    PackedScene terrainUiScene;
    PackedScene cityUiScene;
    TerrainTileUi terrainUi = null;
    CityUI cityUi = null;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        terrainUiScene = ResourceLoader.Load<PackedScene>("TerrainTileUI.tscn");
        cityUiScene = ResourceLoader.Load<PackedScene>("CityUi.tscn");
    }

    public void HideAllPopups()
    {
        if (terrainUi is not null)
        {
            terrainUi.QueueFree();
            terrainUi = null;
        }

        if (cityUi is not null)
        {
            cityUi.QueueFree();
            cityUi = null;
        }
    }
    public void SetTerrainUi(Hex h)
    {
        HideAllPopups();
        terrainUi = (TerrainTileUi) terrainUiScene.Instantiate();
        AddChild(terrainUi);
        terrainUi.SetHex(h);
    }

    public void SetCityUI(City c)
    {
        HideAllPopups();
        cityUi = cityUiScene.Instantiate() as CityUI;
        AddChild(cityUi);
        cityUi.SetCityUI(c);
    }
}