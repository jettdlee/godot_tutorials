using Godot;
using System;
using System.Collections.Generic;
using System.ComponentModel;

public partial class City : Node2D
{
    public static Dictionary<Hex, City> invalidTiles = new Dictionary<Hex, City>();

    public HexTileMap map;
    public Vector2 centerCoordinates;
    public List<Hex> territory;
    public List<Hex> borderTilePool;
    public Civilization civ;

    public string name;

    public int population = 1;
    public int totalFood;
    public int totalProduction;

    public int populationGrowthThreshold;
    public int populationGrowthTracker;

    public static int POPULATION_THRESHOLD_INCREASE = 15;

    Label label;
    Sprite2D sprite;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        label = GetNode<Label>("Label");
        sprite = GetNode<Sprite2D>("Sprite2D");    

        label.Text = name;

        territory = new List<Hex>();
        borderTilePool = new List<Hex>();
    }

    public void ProcessTurn()
    {
        CleanUpBorderPool();

        populationGrowthTracker += totalFood;
        if (populationGrowthTracker > populationGrowthThreshold)
        {
            population++;
            populationGrowthTracker = 0;
            populationGrowthThreshold += POPULATION_THRESHOLD_INCREASE;

            AddRandomNewTile();
            map.UpdateCivTerritoryMap(civ);
        }
    }

    public void CleanUpBorderPool()
    {
        List<Hex> toRemove = new List<Hex>();
        foreach (Hex b in borderTilePool)
        {
            if (invalidTiles.ContainsKey(b) && invalidTiles[b] != this)
                toRemove.Add(b);
        }

        foreach (Hex b in toRemove)
            borderTilePool.Remove(b);
    }

    public void AddRandomNewTile()
    {
        if (borderTilePool.Count > 0)
        {
            Random r = new Random();
            int index = r.Next(borderTilePool.Count);
            this.AddTerritory(new List<Hex>{borderTilePool[index]});
            borderTilePool.RemoveAt(index);
        }
    }

    public void AddTerritory(List<Hex> territoryToAdd)
    {
        foreach (Hex h in territoryToAdd)
        {
            h.ownerCity = this;
            AddValidNeighboursToBorderPool(h);
        }
        territory.AddRange(territoryToAdd);
        CalculateTerritoryResourceTotals();
    }

    public void AddValidNeighboursToBorderPool(Hex h)
    {
        List<Hex> neighbors = map.GetSurroundingHexes(h.coordinates);
        foreach (Hex n in neighbors)
        {
            if (IsValidNeighborTile(n)) borderTilePool.Add(n);
            invalidTiles[n] = this;
        }
    }

    public bool IsValidNeighborTile(Hex n)
    {
        if (n.terrainType == TerrainType.WATER || n.terrainType == TerrainType.ICE || n.terrainType == TerrainType.SHALLOW_WATER || n.terrainType == TerrainType.MOUNTAIN)
            return false;
        
        if (n.ownerCity != null && n.ownerCity.civ != null)
            return false;
        
        if (invalidTiles.ContainsKey(n) && invalidTiles[n] != this)
            return false;
        return true;
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