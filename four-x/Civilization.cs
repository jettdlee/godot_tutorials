using System;
using System.Collections.Generic;
using System.Drawing;

public class Civilization
{
    public int id;
    public List<City> cities;
    public List<Unit> units;
    public Godot.Color territoryColor;
    public int territoryColorAltTileId;
    public string name;
    public bool playerCiv;

    public Civilization()
    {
        cities = new List<City>();
        units = new List<Unit>();
    }

    public void SetRandomColor()
    {
        Random r = new Random();
        territoryColor = new Godot.Color(r.Next(255)/255.0f, r.Next(255)/255.0f, r.Next(255)/255.0f);
    }

    public void ProcessTurn()
    {
        foreach (City c in cities)
            c.ProcessTurn();
    }
}