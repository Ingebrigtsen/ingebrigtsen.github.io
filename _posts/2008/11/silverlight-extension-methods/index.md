---
title: "Silverlight Extension Methods"
date: "2008-11-24"
---

Every so often I find myself needing some helpers to make my development experience better when dealing with different Silverlight related objects, and every now and then I gather these into extensions methods - as I find that convienient.  
  
Lately I've been doing quite a bit of control development, both custom controls and user controls, during this development I deal a lot with storyboards and visual states. Here's the source for a couple of extension methods I find handy.  
  
**Finding a storyboard for a specific visual state  
**When dealing with visual states, I tend to want to modify content of the storyboard programatically or I want on occasion to hook up to the completed event to be notified when the transition to the new state is finished. To do this, we need to get the storyboard. The below code is something I use for UserControls and is relying on the existense of a Control called "LayoutRoot". This could be rewritten  to extend Control and you could work the layoutroot instead of the UserControl.  
  
\[code:c#\]  
        public static Storyboard GetStoryboardForState(this UserControl control, string stateName)  
        {  
            Storyboard stateStoryboard = null;  
  
            var root = control.FindName("LayoutRoot") as FrameworkElement;  
             
            var groups = VisualStateManager.GetVisualStateGroups(root);  
            foreach (VisualStateGroup group in groups)  
            {  
                foreach (VisualState state in group.States)  
                {  
                    if (state.Name == stateName)  
                    {  
                        stateStoryboard = state.Storyboard;  
                    }  
                }  
            }  
            return stateStoryboard;  
        }  
\[/code\]  
  
**Hooking up to the storyboard completed event for a transition for a state change  
**As mentioned above, I like to hook up to the storyboard completed event to know when a storyboard of a transition between two states is finished. This can be done by using the above code and the following:  
  
\[code:c#\]  
        public static void AddStateCompletedEventHandler(this UserControl control, string stateName, EventHandler stateChanged)  
        {  
            Storyboard stateStoryboard = control.GetStoryboardForState(stateName);  
            if (null != stateStoryboard && null != stateChanged)  
            {  
                stateStoryboard.Completed += (s, e) => stateChanged(s, new EventArgs());  
            }  
        }  
\[/code\]  
  
**Setting a value for a specific named keyframe within a storyboard  
**Storyboards within a visual state is not programatically accessible, even though you through in the x:Name="" attribute. Therefor I created a helper for setting a specific value - this one only supports doubles, seeing that was the only datatype I was using for the controls I was developing. Extending this should be fairly simple.  
  
\[code:c#\]  
        public static void SetValueForKeyFrame(this Storyboard storyboard, string keyFrameName, double value)  
        {  
            foreach (var timeline in storyboard.Children)  
            {  
                if (timeline is DoubleAnimationUsingKeyFrames)  
                {  
                    var animation = timeline as DoubleAnimationUsingKeyFrames;  
                    foreach (var keyframe in animation.KeyFrames)  
                    {  
                        string name = keyframe.GetValue(FrameworkElement.NameProperty) as string;  
                        if (null != name && name == keyFrameName)  
                        {  
                            keyframe.Value = value;  
                            return;  
                        }  
                    }  
                }  
            }             
        }  
\[/code\]  
  
**Convienience methods for changing states for a UserControl  
**Instead of working directly with the VisualStateManager, I like to do "this.GoToState(...)" on my UserControls. Again, the below code is for user controls, but could just as easily be for a custom control. Combining all of the above and the code below will give you this convience.  
\[code:c#\]  
        public static void GoToState(this UserControl control, string stateName, EventHandler stateChanged)  
        {  
            GoToState(control, stateName, true, stateChanged);  
        }  
  
        public static void GoToState(this UserControl control, string stateName, bool useTransitions, EventHandler stateChanged)  
        {  
            Storyboard stateStoryboard = control.GetStoryboardForState(stateName);  
            if (null != stateStoryboard && null != stateChanged)  
            {  
                stateStoryboard.Completed += (s, e) => stateChanged(s, new EventArgs());  
            }  
            VisualStateManager.GoToState(control, stateName, useTransitions);  
        }  
  
        public static void GoToStates(this Control control, params string\[\] stateNames)  
        {  
            GoToStates(control, true, stateNames);  
        }  
  
        public static void GoToStates(this Control control, bool useTransitions, params string\[\] stateNames)  
        {  
            foreach (string name in stateNames)  
            {  
                VisualStateManager.GoToState(control, name, useTransitions);  
            }  
        }  
\[/code\]
