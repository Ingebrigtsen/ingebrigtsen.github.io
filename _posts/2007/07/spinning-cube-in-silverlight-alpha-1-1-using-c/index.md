---
title: "Spinning cube in Silverlight Alpha 1.1 using C#"
date: "2007-07-19"
---

Silverlight represents a subset of WPF and it's features, one of the features that aren't part of the subset is 3D. When the Silverlight 1.1 Alpha with the support for managed code came out earlier this year, I couldn't wait to get my hands dirty and try to get some 3D content on it even though it didn't support it. I got very happy when I saw they left the Polygon visual in there, that means you have some optimized way of drawing triangles. Anywho, the purpose of this tutorial is to show how little code you can get away with if you just want to have a simple spinning cube.

The sample is very basic and does not involve any heavy geometry math. If you want a sample using Matrix math and more advanced geomtry stuff, take a look at the Balder project : [http://www.codeplex.com/Balder](http://www.codeplex.com/Balder)

**The main loop**

The first thing we need before we do anything else is a main loop. This can be achieved by using the animation system in Silverlight. By creating a storyboard and hook up the Completed event we can achieve a steady callback. In our Page.xaml we create our own Canvas for the spinning cube and add a storyboard inside it :

```xml
  <Canvas x:Name="spinningCubeCanvas">
    <Canvas.Resources>
      <Storyboard x:Name="spinningCubeStorybard" Completed="spinningCubeCanvas_Render"/>
    </Canvas.Resources>
  </Canvas>
```

That's in fact all the XAML we will be needing to achieve a spinning cube. Now for the code-behind. In the Page\_Loaded event we add the following code to start our mainloop.

```csharp
this.spinningCubeStorybard.Begin();
```

Then we need to implement the Completed event for the Storyboard :

```csharp
public void spinningCubeCanvas_Render(object sender, EventArgs e)
{
   this.spinningCubeStorybard.Begin();
}
```

## Our Cube

To define our cube we need points in 3D space, these are called Vertices (one vertex, several vertices). We therefor create a simple class to represent a vertex. The class represents the original vertex before we have done any calculations on it and also contains the finished calculated vertex ready to be used on our 2D screen.

```csharp
private class Vertex
{
  public  double X, Y, Z;
  public double RotatedX, RotatedY, RotatedZ;
  public int TranslatedX, TranslatedY;
}
```

As you can see, the vertex contains an X,Y and Z representing the coordinate in 3D space. In addition it contains the rotated version and the translated 
(2D) version. Now that we have the definition of a vertex, we need the definition of a triangle that hooks  itself on 3 vertices, we call these Faces. A face 
contains 3 integers representing an index into the array of vertices for the object we are rotating.

```csharp
private class Face
{
  public int VertexA, VertexB, VertexC;
}
```

Now we need to create the array of vertices for the object :

```charp
private Vertex[] _vertices = new Vertex[] {
                  new Vertex() { X=-150, Y=-150, Z=-150},
                  new Vertex() { X=150, Y=-150, Z=-150},
                  new Vertex() { X=-150, Y=150, Z=-150},
                  new Vertex() { X=150, Y=150, Z=-150},
                  new Vertex() { X=-150, Y=-150, Z=150},
                  new Vertex() { X=150, Y=-150, Z=150},
                  new Vertex() { X=-150, Y=150, Z=150},
                  new Vertex() { X=150, Y=150, Z=150},
                };                  
```

And we need an array of faces that hooks up to these vertices :

```csharp
private Face[] _faces = new Face[] {
                new Face() { VertexA=2, VertexB=1, VertexC=0},
                new Face() { VertexA=1, VertexB=2, VertexC=3},
                new Face() { VertexA=4, VertexB=5, VertexC=6},
                new Face() { VertexA=7, VertexB=6, VertexC=5},
                new Face() { VertexA=0, VertexB=4, VertexC=6},
                new Face() { VertexA=0, VertexB=6, VertexC=2},
                new Face() { VertexA=7, VertexB=5, VertexC=1},
                new Face() { VertexA=3, VertexB=7, VertexC=1},
                new Face() { VertexA=5, VertexB=4, VertexC=0},
                new Face() { VertexA=1, VertexB=5, VertexC=0},
                new Face() { VertexA=2, VertexB=6, VertexC=7},
                new Face() { VertexA=2, VertexB=7, VertexC=3},
              };
```

## The "Magic"

Now we are good to go to implement all the rendering to make this into a spinning cube. First we need to rotate all the vertices around the 
X,Y and Z axis. We do this very simple, no matrix math involved, very very basic geometry stuff involving sin and cos.

```csharp
// Calculate all the vertices
foreach (Vertex vertex in this._vertices)
{
  // Rotate the vertex around the Z axis
  tempY1 = (vertex.X * Math.Sin(this._zRotation)) + 
            (vertex.Y * Math.Cos(this._zRotation));
  tempX1 = (vertex.X * Math.Cos(this._zRotation)) - 
            (vertex.Y * Math.Sin(this._zRotation));

  // Rotate the vertex around the Y axis
  vertex.RotatedX = (vertex.Z * Math.Sin(this._yRotation)) + 
                    (tempX1 * Math.Cos(this._yRotation));
  tempZ1 = (vertex.Z * Math.Cos(this._yRotation)) - 
            (tempX1 * Math.Sin(this._yRotation));

  // Rotate the vertex around the X axis
  vertex.RotatedZ = (tempY1 * Math.Sin(this._xRotation)) + 
                    (tempZ1 * Math.Cos(this._xRotation));
  vertex.RotatedY = (tempY1 * Math.Cos(this._xRotation)) - 
                    (tempZ1 * Math.Sin(this._xRotation));

  // Translate the vertex into a 2D coordinate
  vertex.TranslatedX = ((int) ((vertex.RotatedX * focalLength) / 
                              (vertex.RotatedZ + zoom)))+xoffset;
  vertex.TranslatedY = ((int) ((vertex.RotatedY * focalLength) / 
                              (vertex.RotatedZ + zoom)))+yoffset;
}
```

This gives us all the vertices rotated and translated. Great, we can finally get our cube up and running. The next part gets the vertices based upon the 
index of the vertices in each face and creates a Polygon visual that we add to the rendering pipeline of Silverlight, in our case we add it to the Canvas 
we have created for our spinning cube. Before we add anything to it we clear it. The loop also does a hidden surface removal, we do not need to render 
polygons that aren't really visible. We want to know which polygons are facing away, this involves doing a mixed product of the 3 vertices. 

The result of the mixed product can also be used for our purpose to give the polygon a color, you'll see some strange color magic in the loop. :

```csharp
// Create polygons for Silverlight to work with from the newly 
// calculated vertices
this.spinningCubeCanvas.Children.Clear();
foreach (Face face in this._faces)
{
  Vertex vertexA = this._vertices[face.VertexA];
  Vertex vertexB = this._vertices[face.VertexB];
  Vertex vertexC = this._vertices[face.VertexC];

  // Do a mixedproduct of all vertices for hidden surface removal
  double mixedProduct = (vertexB.TranslatedX - vertexA.TranslatedX) *
               (vertexC.TranslatedY - vertexA.TranslatedY) -
               (vertexC.TranslatedX - vertexA.TranslatedX) *
               (vertexB.TranslatedY - vertexA.TranslatedY);
  bool visible = mixedProduct < 0;
  if (!visible)
  {
    continue;
  }

  // Use the mixed product for "shading". 
  // The larger the face, the brighter it is.
  double shade = -mixedProduct; // *512;
  shade /= 1024;




  int color = (int)shade;
  color += 128;
  if (color >= 250)
  {
    color = 250;
  }
  if (color < 30)
  {
    color = 30;
  }

  byte red = (byte)(color >> 3);
  byte green = (byte)(color >> 1);
  byte blue = (byte)(color);

  // Create the polygon and initialize the point and the color
  Polygon polygon = new Polygon();
  polygon.Points = new Point[] {
    new Point(vertexA.TranslatedX,vertexA.TranslatedY),
    new Point(vertexB.TranslatedX,vertexB.TranslatedY),
    new Point(vertexC.TranslatedX,vertexC.TranslatedY)
  };
  polygon.Fill = new SolidColorBrush(Color.FromRgb(red, green, blue));
  this.spinningCubeCanvas.Children.Add(polygon);
}
```
 
That's pretty much it...  Now you just need to rotate it. :)

Download the sourcecode attached to this post for a working version.

Update 12th of August 2007 : 
I've updated the attachment to work with Siliverlight 1.1 Alpha Refresh
