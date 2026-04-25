using Godot;
using System;
using System.Collections.Generic;

public partial class TerrainTileUi : Panel
{

    public static Dictionary<TerrainType, string> terrainTypeStrings = new Dictionary<TerrainType, string>
    {
        { TerrainType.PLAINS, "Plains" }, 
        { TerrainType.BEACH, "Beach" }, 
        { TerrainType.DESERT, "Desert" }, 
        { TerrainType.MOUNTAIN, "Mountain" }, 
        { TerrainType.ICE, "Ice" }, 
        { TerrainType.WATER, "Water" }, 
        { TerrainType.SHALLOW_WATER, "Shallow Water" }, 
        { TerrainType.FOREST, "Forest" } 
    };

    public static Dictionary<TerrainType, Texture2D> terrainTypeImages = new();
    public static void LoadTerrainImages()
    {
        Texture2D plains = ResourceLoader.Load("res://Assets/plains.jpg") as Texture2D;
        Texture2D beach = ResourceLoader.Load("res://Assets/beach.jpg") as Texture2D;
        Texture2D desert = ResourceLoader.Load("res://Assets/desert.jpg") as Texture2D;
        Texture2D mountain = ResourceLoader.Load("res://Assets/mountain.jpg") as Texture2D;
        Texture2D ice = ResourceLoader.Load("res://Assets/ice.jpg") as Texture2D;
        Texture2D water = ResourceLoader.Load("res://Assets/ocean.jpg") as Texture2D;
        Texture2D shallow_water = ResourceLoader.Load("res://Assets/shallow.jpg") as Texture2D;
        Texture2D forest = ResourceLoader.Load("res://Assets/forest.jpg") as Texture2D;

        terrainTypeImages = new Dictionary<TerrainType, Texture2D>
        {
            { TerrainType.PLAINS, plains },
            { TerrainType.BEACH, beach },
            { TerrainType.DESERT, desert },
            { TerrainType.MOUNTAIN, mountain },
            { TerrainType.ICE, ice },
            { TerrainType.WATER, water },
            { TerrainType.SHALLOW_WATER, shallow_water },
            { TerrainType.FOREST, forest }
        };
    }

    Hex h = null;
    TextureRect terrainImage;
    Label terrainLabel, foodLabel, productionLabel;

	public override void _Ready()
    {
        terrainLabel = GetNode<Label>("TerrainLabel");
        foodLabel = GetNode<Label>("FoodLabel");
        productionLabel = GetNode<Label>("ProductionLabel");
        terrainImage = GetNode<TextureRect>("TerrainImage");
    }

    public void SetHex(Hex h)
    {
        this.h = h;
        foodLabel.Text = $"Food: {h.food}";
        productionLabel.Text = $"Production: {h.production}";
        terrainLabel.Text = $"Terrain: {terrainTypeStrings[h.terrainType]}";
        terrainImage.Texture = terrainTypeImages[h.terrainType];
    }
}
