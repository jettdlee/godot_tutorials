using Godot;
using System;

public partial class UIManager : Node2D
{
    PackedScene terrainUiScene;
    PackedScene cityUiScene;
    PackedScene unitUiScene;
    TerrainTileUi terrainUi = null;
    CityUI cityUi = null;
    GeneralUI generalUi;
    UnitUI unitUi;

    [Signal]
    public delegate void EndTurnEventHandler();

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        terrainUiScene = ResourceLoader.Load<PackedScene>("TerrainTileUI.tscn");
        cityUiScene = ResourceLoader.Load<PackedScene>("CityUi.tscn");
        unitUiScene = ResourceLoader.Load<PackedScene>("UnitUI.tscn");
        generalUi = GetNode<Panel>("GeneralUi") as GeneralUI;

        Button endTurnButton = generalUi.GetNode<Button>("EndTurnButton");
        endTurnButton.Pressed += SignalEndTurn;
    }

    public void SignalEndTurn()
    {
        EmitSignal(SignalName.EndTurn);
        generalUi.IncrementTurnCounter();
        RefreshUI();
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

        if (unitUi is not null)
        {
            unitUi.QueueFree();
            unitUi = null;
        }
    }
    public void SetTerrainUi(Hex h)
    {
        HideAllPopups();
        terrainUi = (TerrainTileUi) terrainUiScene.Instantiate();
        AddChild(terrainUi);
        terrainUi.SetHex(h);
    }

    public void RefreshUI()
    {
        if (cityUi is not null)
            cityUi.Refresh();
        if (unitUi is not null)
            unitUi.Refresh();
    }

    public void SetCityUI(City c)
    {
        HideAllPopups();
        cityUi = cityUiScene.Instantiate() as CityUI;
        AddChild(cityUi);
        cityUi.SetCityUI(c);
    }

    public void SetUnitUI(Unit u)
    {
        HideAllPopups();
        unitUi = unitUiScene.Instantiate() as UnitUI;
        AddChild(unitUi);
        unitUi.SetUnit(u);
    }
}