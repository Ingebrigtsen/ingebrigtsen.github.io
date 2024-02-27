---
title: "Missing Enum.GetValues() when doing Silverlight for instance ?"
date: "2008-01-13"
categories: 
  - "net"
  - "csharp"
---

In some implementations of the .net framework, convience methods such as the static method GetValues() on the Enum class has been stripped away. This turned out to be true in the Silverlight subset of the framework. A method I've grown attached to over the years..   

There is a way of getting the values from an Enum through reflection; by using the GetFields() method on the type of the enum you wish to get the values from.

The GetFields() method returns an array of FieldInfo. An enum will have an array of all it's values represented as fields. In addition it will return elements that are not values on the enum. Within FieldInfo you'll find a set of Is\*() methods, one of them are very interesting in this case; IsLiteral. All values are marked as true. The solution is then pure and simple (C# 3.0 syntax, requires LINQ) :

```
public static class EnumHelper
{
    public static T[] GetValues<T>()
    {
        Type enumType = typeof(T);

        if (!enumType.IsEnum)
        {
            throw new ArgumentException("Type '" + enumType.Name + "' is not an enum");
        }

        List<T> values = new List<T>();

        var fields = from field in enumType.GetFields()
                     where field.IsLiteral
                     select field;

        foreach (FieldInfo field in fields)
        {
            object value = field.GetValue(enumType);
            values.Add((T)value);
        }

        return values.ToArray();
    }

    public static object[] GetValues(Type enumType)
    {
        if (!enumType.IsEnum)
        {
            throw new ArgumentException("Type '" + enumType.Name + "' is not an enum");
        }

        List<object> values = new List<object>();

        var fields = from field in enumType.GetFields()
                     where field.IsLiteral
                     select field;

        foreach (FieldInfo field in fields)
        {
            object value = field.GetValue(enumType);
            values.Add(value);
        }

        return values.ToArray();
    }

}

```

[](http://11011.net/software/vspaste)
