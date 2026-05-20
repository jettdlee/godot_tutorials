using Godot;
using System;
using System.ComponentModel;

public partial class UnitUI : Panel
{
    TextureRect unitImage;
    Label unitType, moves, hp;
    Unit u;

	public override void _Ready()
    {
        unitImage = GetNode<TextureRect>("TextureRect");
        unitType = GetNode<Label>("UnitTypeLabel");
        hp = GetNode<Label>("HealthLabel");
        moves = GetNode<Label>("MovesLabel");
    }

    public void SetUnit(Unit u)
    {
        this.u = u;

        Refresh();
    }

    public void Refresh()
    {
        unitImage.Texture = Unit.uiImages[u.GetType()];
        unitType.Text = $"Unit Type: {u.unitName}";
        moves.Text = $"Moves: {u.movePoints}/{u.maxMovePoints}";
        hp.Text = $"HP: {u.hp}/{u.maxHp}";
    }
}