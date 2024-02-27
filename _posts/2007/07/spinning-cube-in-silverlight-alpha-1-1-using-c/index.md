---
title: "Spinning cube in Silverlight Alpha 1.1 using C#"
date: "2007-07-19"
---

Silverlight represents a subset of WPF and it's features, one of the features that aren't part of the subset is 3D. When the Silverlight 1.1 Alpha with the support for managed code came out earlier this year, I couldn't wait to get my hands dirty and try to get some 3D content on it even though it didn't support it. I got very happy when I saw they left the Polygon visual in there, that means you have some optimized way of drawing triangles. Anywho, the purpose of this tutorial is to show how little code you can get away with if you just want to have a simple spinning cube.

The sample is very basic and does not involve any heavy geometry math. If you want a sample using Matrix math and more advanced geomtry stuff, take a look at the Balder project : [http://www.codeplex.com/Balder](http://www.codeplex.com/Balder)

**The main loop**

The first thing we need before we do anything else is a main loop. This can be achieved by using the animation system in Silverlight. By creating a storyboard and hook up the Completed event we can achieve a steady callback. In our Page.xaml we create our own Canvas for the spinning cube and add a storyboard inside it :

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;">  <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">&lt;</span><span style="font-weight:normal;font-size:11px;color:maroon;font-family:courier new;background-color:transparent;">Canvas</span> <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">x:Name</span><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">="spinningCubeCanvas"</span><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">&gt;</span>
    &lt;Canvas.Resources&gt;
      <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">&lt;</span><span style="font-weight:normal;font-size:11px;color:maroon;font-family:courier new;background-color:transparent;">Storyboard</span> <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">x:Name</span><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">="spinningCubeStorybard"</span> 
<span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">Completed</span><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">="spinningCubeCanvas_Render"</span><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">/&gt;</span>
    &lt;/Canvas.Resources&gt;
  <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">&lt;/</span><span style="font-weight:normal;font-size:11px;color:maroon;font-family:courier new;background-color:transparent;">Canvas</span><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">&gt;</span></span></pre></td></tr></tbody></table>

That's in fact all the XAML we will be needing to achieve a spinning cube. Now for the code-behind. In the Page\_Loaded event we add the following code to start our mainloop.

```
this.spinningCubeStorybard.Begin();
```

```
Then we need to implement the Completed event for the Storyboard : 
```

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;"><span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">void</span> spinningCubeCanvas_Render(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">object</span> sender, EventArgs e)
{
   <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>.spinningCubeStorybard.Begin();
}</span></pre></td></tr></tbody></table>

 

**Our Cube**

To define our cube we need points in 3D space, these are called Vertices (one vertex, several vertices). We therefor create a simple class to represent a vertex. The class represents the original vertex before we have done any calculations on it and also contains the finished calculated vertex ready to be used on our 2D screen.

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;">&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">private</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">class</span> Vertex
&nbsp;&nbsp;&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">public</span>&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">double</span> X, Y, Z;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">double</span> RotatedX, RotatedY, RotatedZ;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">int</span> TranslatedX, TranslatedY;
&nbsp;&nbsp;&nbsp;&nbsp;}</span></pre></td></tr></tbody></table>

```
As you can see, the vertex contains an X,Y and Z representing the coordinate in 3D space. In addition it contains the rotated version and the translated 
(2D) version. Now that we have the definition of a vertex, we need the definition of a triangle that hooks  itself on 3 vertices, we call these Faces. A face 
contains 3 integers representing an index into the array of vertices for the object we are rotating.
```

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;">&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">private</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">class</span> Face
&nbsp;&nbsp;&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">int</span> VertexA, VertexB, VertexC;
&nbsp;&nbsp;&nbsp;&nbsp;}</span></pre></td></tr></tbody></table>

Now we need to create the array of vertices for the object :

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8
9
10
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;">&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">private</span> Vertex[] _vertices <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex[] {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=-150, Y=-150, Z=-150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=150, Y=-150, Z=-150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=-150, Y=150, Z=-150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=150, Y=150, Z=-150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=-150, Y=-150, Z=150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=150, Y=-150, Z=150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=-150, Y=150, Z=150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Vertex() { X=150, Y=150, Z=150},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; };</span></pre></td></tr></tbody></table>

And we need an array of faces that hooks up to these vertices :

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8
9
10
11
12
13
14
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;">&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">private</span> Face[] _faces <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face[] {
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=2, VertexB=1, VertexC=0},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=1, VertexB=2, VertexC=3},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=4, VertexB=5, VertexC=6},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=7, VertexB=6, VertexC=5},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=0, VertexB=4, VertexC=6},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=0, VertexB=6, VertexC=2},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=7, VertexB=5, VertexC=1},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=3, VertexB=7, VertexC=1},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=5, VertexB=4, VertexC=0},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=1, VertexB=5, VertexC=0},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=2, VertexB=6, VertexC=7},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Face() { VertexA=2, VertexB=7, VertexC=3},
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;};</span></pre></td></tr></tbody></table>

```
The "Magic"
```

```
Now we are good to go to implement all the rendering to make this into a spinning cube. First we need to rotate all the vertices around the 
X,Y and Z axis. We do this very simple, no matrix math involved, very very basic geometry stuff involving sin and cos.
```

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Calculate all the vertices</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">foreach</span> (Vertex vertex <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">in</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._vertices)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Rotate the vertex around the Z axis</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tempY1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (vertex.X <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Sin(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._zRotation)) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">+</span> 
                 (vertex.Y <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Cos(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._zRotation));
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tempX1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (vertex.X <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Cos(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._zRotation)) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> 
                 (vertex.Y <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Sin(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._zRotation));
<div></div>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Rotate the vertex around the Y axis</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vertex.RotatedX <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (vertex.Z <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Sin(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._yRotation)) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">+</span> 
                          (tempX1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Cos(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._yRotation));
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tempZ1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (vertex.Z <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Cos(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._yRotation)) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> 
                 (tempX1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Sin(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._yRotation));
<div></div>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Rotate the vertex around the X axis</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vertex.RotatedZ <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (tempY1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Sin(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._xRotation)) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">+</span> 
                          (tempZ1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Cos(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._xRotation));
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vertex.RotatedY <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (tempY1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Cos(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._xRotation)) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> 
                          (tempZ1 <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> Math.Sin(<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._xRotation));
<div></div>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Translate the vertex into a 2D coordinate</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vertex.TranslatedX =</span> ((<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">int</span>) ((vertex.RotatedX <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> focalLength) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">/</span> 
                                    (vertex.RotatedZ <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">+</span> zoom)))+xoffset;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vertex.TranslatedY <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> ((<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">int</span>) ((vertex.RotatedY <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span> focalLength) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">/</span> 
                                    (vertex.RotatedZ <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">+</span> zoom)))+yoffset;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}</pre></td></tr></tbody></table>

```
This gives us all the vertices rotated and translated. Great, we can finally get our cube up and running. The next part gets the vertices based upon the 
index of the vertices in each face and creates a Polygon visual that we add to the rendering pipeline of Silverlight, in our case we add it to the Canvas 
we have created for our spinning cube. Before we add anything to it we clear it. The loop also does a hidden surface removal, we do not need to render 
polygons that aren't really visible. We want to know which polygons are facing away, this involves doing a mixed product of the 3 vertices. 
```

```
The result of the mixed product can also be used for our purpose to give the polygon a color, you'll see some strange color magic in the loop. :) 
```

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:courier new;background-color:transparent;"><span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Create polygons for Silverlight to work with from the newly </span>
<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// calculated vertices</span>
<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>.spinningCubeCanvas.Children.Clear();
<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">foreach</span> (Face face <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">in</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._faces)
{
&nbsp;&nbsp;Vertex vertexA <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._vertices[face.VertexA];
&nbsp;&nbsp;Vertex vertexB <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._vertices[face.VertexB];
&nbsp;&nbsp;Vertex vertexC <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>._vertices[face.VertexC];
<div></div>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Do a mixedproduct of all vertices for hidden surface removal</span>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">double</span> mixedProduct <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (vertexB.TranslatedX <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> vertexA.TranslatedX) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   (vertexC.TranslatedY <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> vertexA.TranslatedY) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   (vertexC.TranslatedX <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> vertexA.TranslatedX) <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">*</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   (vertexB.TranslatedY <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">-</span> vertexA.TranslatedY);
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">bool</span> visible <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> mixedProduct &lt; 0;
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">if</span> (!visible)
&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">continue</span>;
&nbsp;&nbsp;}
<div></div>

&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Use the mixed product for "shading". </span>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// The larger the face, the brighter it is.</span>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">double</span> shade <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> -mixedProduct; <span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// *512;</span>
&nbsp;&nbsp;shade /= 1024;
<div></div>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">int</span> color <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">int</span>)shade;
&nbsp;&nbsp;color += 128;
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">if</span> (color &gt;= 250)
&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;color <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> 250;
&nbsp;&nbsp;}
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">if</span> (color &lt; 30)
&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;color <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> 30;
&nbsp;&nbsp;}
<div></div>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">byte</span> red <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">byte</span>)(color &gt;&gt; 3);
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">byte</span> green <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">byte</span>)(color &gt;&gt; 1);
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">byte</span> blue <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">byte</span>)(color);
<div></div>

&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:courier new;background-color:transparent;">// Create the polygon and initialize the point and the color</span>
&nbsp;&nbsp;Polygon polygon <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Polygon();
&nbsp;&nbsp;polygon.Points <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Point[] {
       <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Point(vertexA.TranslatedX,vertexA.TranslatedY),
       <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Point(vertexB.TranslatedX,vertexB.TranslatedY),
       <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> Point(vertexC.TranslatedX,vertexC.TranslatedY)
     };
&nbsp;&nbsp;polygon.Fill <span style="font-weight:normal;font-size:11px;color:red;font-family:courier new;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">new</span> SolidColorBrush(Color.FromRgb(red, green, blue));
<div></div>
&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:courier new;background-color:transparent;">this</span>.spinningCubeCanvas.Children.Add(polygon);
}</span></pre></td></tr></tbody></table>

 

```
That's pretty much it...  Now you just need to rotate it. :) 
```

```

```

```
Download the sourcecode attached to this post for a working version.
```

```
Update 12th of August 2007 : 
I've updated the attachment to work with Siliverlight 1.1 Alpha Refresh
```
