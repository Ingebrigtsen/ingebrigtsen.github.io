---
title: "A realtime light-weight StateMachine"
date: "2008-01-23"
categories: 
  - "csharp"
  - "gamedevelopment"
---

I've been working the last week with a game for me to contribute with in the [European Silverlight Challenge](http://www.silverlightchallenge.eu/) and figured I had to make a simple StateMachine "runtime" to undertake the the tasks I needed for the game.

The StateMachine concept I came up with is a very leightweight thingy that uses some reflection magic to accomplish a simple way of working with a StateMachine. All you need is an enum with all your states and then a class that implements the abstract generic StateMachine class. The generic type you specify is the actual enum that contains the states. Through reflection the StateMachine then looks for public instance methods in your class that is named in a special manner containing the name of the state. The collected information will then be used in the execution of the StateMachine.

You can download the entire implementation of the StateMachine

[here](http://www.dolittle.com/blogs/einar/WindowsLiveWriter/ArealtimelightweightStateMachine_C5A9/StateMachine_1.zip)

A sample StateMachine implementation using the system :

public enum SimpleStateMachineStates  
{  
    Idle=1,  
    DoSomething,  
    Die  
}  
  
public classSimpleStateMachine : StateMachine<SimpleStateMachineStates>  
{  
    public voidOnIdleEnter()  
    {  
        Console.WriteLine("Entering idle mode - press spacebar to continue");  
    }  
  
    public voidOnIdleRun()  
    {  
        ConsoleKeyInfo keys = Console.ReadKey();  
        if(keys.Key == ConsoleKey.Spacebar)  
        {  
            this.ChangeState(SimpleStateMachineStates.DoSomething);  
        }  
    }  
  
    public voidOnIdleLeave()  
    {  
        Console.WriteLine("Leaving idle mode");  
    }  
  
  
    public voidOnDoSomethingEnter()  
    {  
        Console.WriteLine("DoSomething - Enter phase");  
        Console.WriteLine("---");  
        Console.WriteLine("Press enter to kill the process");  
    }  
  
    public voidOnDoSomethingRun()  
    {  
        ConsoleKeyInfo keys = Console.ReadKey();  
        if(keys.Key == ConsoleKey.Enter)  
        {  
            this.ChangeState(SimpleStateMachineStates.Die);  
        }  
    }  
  
    public voidOnDoSomethingLeave()  
    {  
        Console.WriteLine("DoSomething - Leave");  
    }  
  
  
    public voidOnDieEnter()  
    {  
        Console.WriteLine("Killing");  
        System.Diagnostics.Process.GetCurrentProcess().Kill();  
    }  
  
  
    public overrideSimpleStateMachineStates DefaultState  
    {  
        get{ returnSimpleStateMachineStates.Idle; }  
    }  
}  

[](http://11011.net/software/vspaste)
