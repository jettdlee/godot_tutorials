using Godot;
using System;

public partial class UnitBuildButton : Button
{
    public Unit u;

    [Signal]
    public delegate void OnPressedEventHandler(Unit u);

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
    {
        Pressed += SendUnitData;
    }

    public void SendUnitData()
    {
        EmitSignal(SignalName.OnPressed, u);
    }
}
