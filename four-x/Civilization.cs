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

    public void SetRandomColor()
    {
        Random r = new Random();
        territoryColor = new Godot.Color(r.Next(255)/255.0f, r.Next(255)/255.0f, r.Next(255)/255.0f);
    }
}