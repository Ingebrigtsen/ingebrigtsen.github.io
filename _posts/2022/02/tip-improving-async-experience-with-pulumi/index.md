---
title: "Tip: Improving async experience with Pulumi"
date: "2022-02-21"
categories: 
  - "net"
  - "csharp"
  - "code-tips"
tags: 
  - "c"
  - "productivity"
---

Recently we've been working a lot with [Pulumi](https://www.pulumi.com) for automating our cloud environments. We're building out our own management tool and creating Pulumi stack definitions in C#. One thing that quickly became a pain was working with the [Inputs and Output](https://www.pulumi.com/docs/intro/concepts/inputs-outputs/) and running into code that became way too nested, looking a lot like the old [TPL](https://docs.microsoft.com/en-us/dotnet/standard/parallel-programming/task-parallel-library-tpl) or [JavaScript Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) with `.ContinueWith()` or `.then()`.

We're building our stacks using the Pulumi function:

```csharp
PulumiFn.Create(async () =>
{
    // Automate things...
});
```

Within the `Action` we set up the things we want to automate. A scenario we have, is to create a configuration object that contain the connection string from a MongoDB Cluster running with Atlas. The file generated is stored in an Azure file share we create with Pulumi.

```csharp
// Storage is an object being passed along with information about the Azure storage being used.
var getFileShareResult = GetFileShare.Invoke(new()
{
    AccountName = storage.AccountName,
    ResourceGroupName = resourceGroupName,
    ShareName = storage.ShareName
});

// Cluster is an object holding the MongoDB cluster information.
var getClusterResult = GetCluster.Invoke(new()
{
    Name = cluster.Name,
    ProjectId = cluster.ProjectId
});

// Get the values we need to be able to write the connection string
getFileShareResult.Apply(fileShare =>
{
    getClusterResult.Apply(clusterInfo =>
    {
        // Write the file with the connection string
        return clusterInfo;
    });

    return fileShare;
});
```

In this sample we're just interested in 2 values and still its quite a few lines of code and nested scopes.

To improve on this, we ended up creating a couple of extension methods that helps us write regular [async/await](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/await) based code.

```csharp
public static class OutputExtensionMethods
{
    public static Task<T> GetValue<T>(this Output<T> output) => output.GetValue(_ => _);

    public static Task<TResult> GetValue<T, TResult>(this Output<T> output, Func<T, TResult> valueResolver)
    {
        var tcs = new TaskCompletionSource<TResult>();
        output.Apply(_ =>
        {
            var result = valueResolver(_);
            tcs.SetResult(result);
            return result;
        });
        return tcs.Task;
    }
}
```

And for `Input` it would be the same:

```csharp
public static class InputExtensionMethods
{
    public static Task<T> GetValue<T>(this Input<T> input) => input.GetValue(_ => _);

    public static Task<TResult> GetValue<T, TResult>(this Input<T> input, Func<T, TResult> valueResolver)
    {
        var tcs = new TaskCompletionSource<TResult>();
        input.Apply(_ =>
        {
            var result = valueResolver(_);
            tcs.SetResult(result);
            return result;
        });
        return tcs.Task;
    }
}
```

With these we can now simplify the whole thing down to two lines of code:

```csharp
// Get the values we need to be able to write the connection string
var fileShareResult = await getFileShareResult.GetValue(_ => _);
var clusterInfo = await getClusterResult.GetValue(_ => _);

// Write the file with the connection string
...
```

We're interested to hear if there are better ways already with the Pulumi SDK or if we're going about this in the wrong way. Please leave a comment with any input, much appreciated.
