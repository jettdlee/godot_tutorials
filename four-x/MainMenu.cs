using Godot;
using System;

public partial class MainMenu : Node2D
{
    public void Start()
    {
        Game g = ResourceLoader.Load<PackedScene> ("Game.tscn").Instantiate() as Game;
        HexTileMap map = g.GetNode<HexTileMap>("HexTileMap");

        map.width = (int) this.GetNode<SpinBox>("VBoxContainer/HBoxContainer/SpinBox").Value;
        map.height = (int) this.GetNode<SpinBox>("VBoxContainer/HBoxContainer/SpinBox2").Value;

        map.num_ai_civs = (int) this.GetNode<SpinBox>("VBoxContainer/HBoxContainer2/SpinBox").Value;
        map.player_color = this.GetNode<ColorPickerButton>("VBoxContainer/HBoxContainer3/ColorPickerButton").Color;
        GetNode("/root/MainMenu").QueueFree();
        GetTree().Root.AddChild(g);
    }

    public void Quit()
    {
        GetTree().Quit();
    }
}
