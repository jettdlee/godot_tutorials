using System;
using System.Collections.Generic;
using System.Drawing;

public class Civilization
{
    public int id;
    public List<City> cities;
    public Godot.Color territoryColor;
    public int territoryColorAltTileId;
    public string name;
    public bool playerCiv;

    public Civilization()
    {
        cities = new List<City>();
    }
}