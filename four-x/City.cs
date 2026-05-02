using Godot;
using System;
using System.Collections.Generic;

public partial class City : Node2D
{

    public HexTileMap map;
    public Vector2 centerCoordinates;
    public List<Hex> territory;
    public List<Hex> borderTilePool;
    public Civilization civ;

    public string name;

    public int population = 1;
    public int totalFood;
    public int totalProduction;

    Label label;
    Sprite2D sprite;

    public City()
    {
        territory = new List<Hex>();
        borderTilePool = new List<Hex>();
    }

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        label = GetNode<Label>("Label");
        sprite = GetNode<Sprite2D>("Sprite2D");    
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

    public void AddTerritory(List<Hex> territoryToAdd)
    {
        foreach (Hex h in territoryToAdd)
        {
            h.ownerCity = this;
        }
        territory.AddRange(territoryToAdd);
        CalculateTerritoryResourceTotals();
    }

    public void SetCityName(string newName)
    {
        name = newName;
        label.Text = newName;
    }

    public void SetIconColor(Color c)
    {
        sprite.Modulate = c;
    }

    public void CalculateTerritoryResourceTotals()
    {
        totalFood = 0;
        totalProduction = 0;
        foreach (Hex h in territory)
        {
            totalFood += h.food;
            totalProduction += h.production;
        }
    }
}