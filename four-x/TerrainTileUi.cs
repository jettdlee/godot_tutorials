using Godot;
using System;

public partial class TerrainTileUi : Panel
{
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
    }
}
