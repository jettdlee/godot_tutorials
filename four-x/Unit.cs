using Godot;
using System;
using System.Collections.Generic;

public partial class Unit : Node2D
{
    [Signal]
    public delegate void UnitClickedEventHandler(Unit u);
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
    public bool selected = false;
    public Area2D collider;
    public HexTileMap map;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        collider = GetNode<Area2D>("Sprite2D/Area2D");
        UIManager manager = GetNode<UIManager>("/root/Game/CanvasLayer/UiManager");
        this.UnitClicked += manager.SetUnitUI;

        // map = GetNode<HexTileMap>("root/Game/HexTileMap");
        map = GetParent<HexTileMap>();
        this.UnitClicked += map.DeselectCurrentCell;
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

    public void SetSelected()
    {
        if (!selected)
        {
            selected = true;
            Sprite2D sprite = GetNode<Sprite2D>("Sprite2D");
            Color c = new Color(sprite.Modulate);
            c.V = c.V - 0.25f;
            sprite.Modulate = c;
        }
    }

    public void SetDeselected()
    {
        selected = false;
        Sprite2D sprite = GetNode<Sprite2D>("Sprite2D");
        sprite.Modulate = civ.territoryColor;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event is InputEventMouseButton mouse && mouse.ButtonMask == MouseButtonMask.Left)
        {
            var spaceState = GetWorld2D().DirectSpaceState;
            var point = new PhysicsPointQueryParameters2D();
            point.CollideWithAreas = true;
            point.Position = GetGlobalMousePosition();
            var result = spaceState.IntersectPoint(point);
            if (result.Count > 0 && (Area2D) result[0]["collider"] == collider)
            {
                EmitSignal(SignalName.UnitClicked, this);
                SetSelected();
                GetViewport().SetInputAsHandled();
            } else
            {
                SetDeselected();
            }
        }
    }

}