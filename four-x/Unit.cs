using Godot;
using System;
using System.Collections.Generic;

public partial class Unit : Node2D
{
    public static Dictionary<Type, PackedScene> unitSceneResources;
    public static Dictionary<Type, Texture2D> uiImages;
    public static void LoadUnitScenes()
    {
        unitSceneResources = new Dictionary<Type, PackedScene>
        {
            { typeof(Settler), ResourceLoader.Load<PackedScene>("res://Settler.tscn")},
            { typeof(Warrior), ResourceLoader.Load<PackedScene>("res://Warrior.tscn")}
        };
    }

    public static void LoadTextures()
    {
        uiImages = new Dictionary<Type, Texture2D>
        {
            { typeof(Settler), (Texture2D) ResourceLoader.Load("res://Assets/settler_image.png")},
            { typeof(Warrior), (Texture2D) ResourceLoader.Load("res://Assets/warrior_image.jpg")},
        };
    }

    public string unitName = "DEFAULT";
    public int productionRequired;
    public Civilization civ;
    public Vector2I coords = new Vector2I();

    public int maxHp;
    public int hp;
    public int maxMovePoints;
    public int movePoints;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

    public void SetCiv(Civilization civ)
    {
        this.civ = civ;
        GetNode<Sprite2D>("Sprite2D").Modulate = civ.territoryColor;
        this.civ.units.Add(this);
    }
}