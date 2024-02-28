---
title: "ASP.NET Core 6 - transparent WebSockets"
date: "2021-12-17"
categories: 
  - "net"
  - "csharp"
  - "code-tips"
tags: 
  - "asp-net-core"
  - "c#"
  - "productivity"
  - "websockets"
---

Lets face it; I'm a framework builder. In the sense that I build stuff for other developers to use. The goal when doing so is that the developer using what's built should feel empowered by its capabilities. Developers should have lovable APIs that put them in the pit of success and lets them focus on delivering the business value for their business. These are the thoughts that goes into what we do at work when building reusable components. This post represents some of these reusable components we build.

## TL;DR

All the things discussed is documented [here](https://github.com/aksio-system/Foundation/blob/main/Documentation/queries.md). Its backend implementation [here](https://github.com/aksio-system/Foundation/tree/main/Source/CQRS/Queries), frontend [here](https://github.com/aksio-system/Foundation/tree/main/Source/Frontend/queries). Concrete backend example of this [here](https://github.com/aksio-system/Foundation/blob/0100ceac840a096e1897ca8f1d339d9cddf435be/Sample/Read/Accounts/Debit/Accounts.cs) and frontend [here](https://github.com/aksio-system/Foundation/blob/main/Sample/Web/Accounts/Debit/DebitAccounts.tsx). Recommend reading my post on our [proxy generation tool](https://ingebrigtsen.blog/2021/11/02/proxy-generation-of-c-asp-net-controller-actions-using-roslyn/) for more context.

## Introduction

WebSocket support for ASP.NET and ASP.NET Core has been around forever. At its core it is very simple but at the same time [crude](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/websockets?view=aspnetcore-6.0) and not as elegant or structured IMO as your average Controller. We started thinking about how we could simplify this. Sure there is the [SignalR approach](https://docs.microsoft.com/en-us/aspnet/core/signalr/introduction?view=aspnetcore-6.0) - which is a viable option (and I've written a couple of books about it a few years back [here](https://www.amazon.co.uk/SignalR-Real-time-Application-Development-Second/dp/1785285459/ref=sr_1_2?keywords=einar+ingebrigtsen&qid=1639679495&sr=8-2) and [here](https://www.amazon.co.uk/SignalR-Blueprints-Einar-Ingebrigtsen/dp/1783983124/ref=sr_1_1?keywords=einar+ingebrigtsen&qid=1639679495&sr=8-1)). But we wanted something that wouldn't involve changing the programming model too much from a regular Controller.

One of the reasons we wanted to add some sparkling reactiveness into our software was that we are building software that is all focused on CQRS and Event Sourcing. With this we get into an eventual consistency game real quick for the read side. Once an action - or command in our case - is performed, the read side only updates as a consequence of an event being handled. Since we don't really know when it is done and ready, we want to be able to notify the frontend with any changes as they become available.

## Queries

One of the things that we do is to encapsulate the result of a query into a well known structure. Much like GraphQL does with not just relying on HTTP error codes as the means of communication success or not, we want to capture it in a well known structure that holds the details of whether or not the query was successful and eventually we'll also put validation results, exception messages and such as well. Along side this, the actual result of the query is also kept on it. For now it looks like the following:

```csharp
public record QueryResult(object Data, bool IsSuccess);
```

You'll see this type used throughout this post.

## Observables

We're very fond of the concept of observables and use [Reactive Extensions](https://github.com/dotnet/reactive) throughout our solution for different purposes. Our first construct is therefor a special kind of observable we call the `ClientObservable`. It is the encapsulation we will be using from our Controllers. Its responsibility is to do the heavy lifting of handling the WebSocket "dance" and also expose a clean API for us to provide data to it as things change. It also needs to deal with client closing connection and cleaning up after itself and all.

The basic implementation of looks like below:

```csharp
public class ClientObservable<T> : IClientObservable
{
    readonly ReplaySubject<T> _subject = new();

    public ClientObservable(Action? clientDisconnected = default)
    {
        ClientDisconnected = clientDisconnected;
    }

    public Action? ClientDisconnected { get; set; }

    public void OnNext(T next) => _subject.OnNext(next);

    public async Task HandleConnection(ActionExecutingContext context, JsonOptions jsonOptions)
    {
        using var webSocket = await context.HttpContext.WebSockets.AcceptWebSocketAsync();
        var subscription = _subject.Subscribe(_ =>
        {
            var queryResult = new QueryResult(_!, true);
            var json = JsonSerializer.Serialize(queryResult, jsonOptions.JsonSerializerOptions);
            var message = Encoding.UTF8.GetBytes(json);

            webSocket.SendAsync(new ArraySegment<byte>(message, 0, message.Length), WebSocketMessageType.Text, true, CancellationToken.None);
        });

        var buffer = new byte[1024 * 4];
        var received = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);

        while (!received.CloseStatus.HasValue)
        {
            received = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
        }

        await webSocket.CloseAsync(received.CloseStatus.Value, received.CloseStatusDescription, CancellationToken.None);
        subscription.Dispose();

        ClientDisconnected?.Invoke();
    }
}
```

Since the class is generic, there is a non-generic interface that specifies the functionality that will be used by the next building block.

```csharp
public interface IClientObservable
{
    Task HandleConnection(ActionExecutingContext context, JsonOptions jsonOptions);

    object GetAsynchronousEnumerator(CancellationToken cancellationToken = default);
}
```

## Action Filters

Our design goal was that **Controller** actions could just create `ClientObservable` instances and return these and then add some magic to the mix for it to automatically be hooked up properly.

For this to happen we can leverage [Filters in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/mvc/controllers/filters). They run within the invocation pipeline of ASP.NET and can wrap itself around calls and perform tasks. We need a filter that will recognize the `IClientObservable` return type and make sure to handle the connection correctly.

```csharp
public class QueryActionFilter : IAsyncActionFilter
{
    readonly JsonOptions _options;

    public QueryActionFilter(IOptions<JsonOptions> options)
    {
        _options = options.Value;
    }

    public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        if (context.HttpContext.Request.Method == HttpMethod.Get.Method
            && context.ActionDescriptor is ControllerActionDescriptor)
        {
            var result = await next();
            if (result.Result is ObjectResult objectResult)
            {
                switch (objectResult.Value)
                {
                    case IClientObservable clientObservable:
                        {
                            if (context.HttpContext.WebSockets.IsWebSocketRequest)
                            {
                                await clientObservable.HandleConnection(context, _options);
                                result.Result = null;
                            }
                        }
                        break;

                    default:
                        {
                            result.Result = new ObjectResult(new QueryResult(objectResult.Value!, true));
                        }
                        break;
                }
            }
        }
        else
        {
            await next();
        }
    }
}
```

With the filter in place, you typically add these during the configuration of your controllers e.g. in your `Startup.cs` during `ConfigureServices` - or using the minimal APIs:

```csharp
services.AddControllers(_ => _.Filters.Add<QueryActionFilter>());
```

## Client abstraction

We also built a client abstraction in TypeScript for this to provide a simple way to leverage this. It is built in layers starting off with a representation of the connection.

```typescript
export type DataReceived<TDataType> = (data: TDataType) => void;

export class ObservableQueryConnection<TDataType> {

    private _socket!: WebSocket;
    private _disconnected = false;

    constructor(private readonly _route: string) {
    }

    connect(dataReceived: DataReceived<TDataType>) {
        const secure = document.location.protocol.indexOf('https') === 0;
        const url = `${secure ? 'wss' : 'ws'}://${document.location.host}${this._route}`;
        let timeToWait = 500;
        const timeExponent = 500;
        const retries = 100;
        let currentAttempt = 0;

        const connectSocket = () => {
            const retry = () => {
                currentAttempt++;
                if (currentAttempt > retries) {
                    console.log(`Attempted ${retries} retries for route '${this._route}'. Abandoning.`);
                    return;
                }
                console.log(`Attempting to reconnect for '${this._route}' (#${currentAttempt})`);

                setTimeout(connectSocket, timeToWait);
                timeToWait += (timeExponent * currentAttempt);
            };

            this._socket = new WebSocket(url);
            this._socket.onopen = (ev) => {
                console.log(`Connection for '${this._route}' established`);
                timeToWait = 500;
                currentAttempt = 0;
            };
            this._socket.onclose = (ev) => {
                if (this._disconnected) return;
                console.log(`Unexpected connection closed for route '${this._route}`);
                retry();
            };
            this._socket.onerror = (error) => {
                console.log(`Error with connection for '${this._route} - ${error}`);
                retry();
            };
            this._socket.onmessage = (ev) => {
                dataReceived(JSON.parse(ev.data));
            };
        };

        connectSocket();
    }

    disconnect() {
        console.log(`Disconnecting '${this._route}'`);
        this._disconnected = true;
        this._socket?.close();
    }
}
```

On top of this we then have a `ObservableQueryFor` construct which leverages this and provides a way to subscribe for changes.

```typescript
export abstract class ObservableQueryFor<TDataType, TArguments = {}> implements IObservableQueryFor<TDataType, TArguments> {
    abstract readonly route: string;
    abstract readonly routeTemplate: Handlebars.TemplateDelegate<any>;

    abstract readonly defaultValue: TDataType;
    abstract readonly requiresArguments: boolean;

    /** @inheritdoc */
    subscribe(callback: OnNextResult, args?: TArguments): ObservableQuerySubscription<TDataType> {
        let actualRoute = this.route;
        if (args && Object.keys(args).length > 0) {
            actualRoute = this.routeTemplate(args);
        }

        const connection = new ObservableQueryConnection<TDataType>(actualRoute);
        const subscriber = new ObservableQuerySubscription(connection);
        connection.connect(callback);
        return subscriber;
    }
}
```

The subscription being returned:

```typescript
export class ObservableQuerySubscription<TDataType> {
    constructor(private _connection: ObservableQueryConnection<TDataType>) {
    }

    unsubscribe() {
        this._connection.disconnect();
        this._connection = undefined!;
    }
}
```

We build our frontends using React and added a wrapper for this to make it even easier:

```typescript
export function useObservableQuery<TDataType, TQuery extends IObservableQueryFor<TDataType>, TArguments = {}>(query: Constructor<TQuery>, args?: TArguments): [QueryResult<TDataType>] {
    const queryInstance = new query() as TQuery;
    const [result, setResult] = useState<QueryResult<TDataType>>(new QueryResult(queryInstance.defaultValue, true));

    useEffect(() => {
        if (queryInstance.requiresArguments && !args) {
            console.log(`Warning: Query '${query.name}' requires arguments. Will not perform the query.`);
            return;
        }

        const subscription = queryInstance.subscribe(_ => {
            setResult(_ as unknown as QueryResult<TDataType>);
        }, args);

        return () => subscription.unsubscribe();
    }, []);

    return [result];
}
```

The entire frontend abstraction can be found [here](https://github.com/aksio-system/Foundation/tree/main/Source/Frontend/queries).

## Usage

To get WebSockets working, we will need to add the default ASP.NET Core middleware that handles it (read more [here](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/websockets?view=aspnetcore-6.0#configure-the-middleware)). Basically in your `Startup.cs` or your app builder add the following:

```csharp
app.UseWebSockets()
```

With all of this we can now create a controller that watches a MongoDB collection:

```csharp
public class Accounts : Controller
{
    readonly IMongoCollection<DebitAccount> _collection;

    public Accounts(IMongoCollection<DebitAccount> collection) => _collection = collection;

    [HttpGet]
    public ClientObservable<IEnumerable<DebitAccount>> AllAccounts()
    {
        var observable = new ClientObservable<IEnumerable<DebitAccount>>();
        var accounts = _accountsCollection.Find(_ => true).ToList();
        observable.OnNext(accounts);
        var cursor = _accountsCollection.Watch();

        Task.Run(() =>
        {
            while (cursor.MoveNext())
            {
                if (!cursor.Current.Any()) continue;
                observable.OnNext(_accountsCollection.Find(_ => true).ToList());
            }
        });

        observable.ClientDisconnected = () => cursor.Dispose();

        return observable;
    }
}
```

Notice the usage of the `ClientObservable` and how it can be used with anything.

## MongoDB simplification - extension

The code in the controller above is typically a thing that will be copy/pasted around as it is a very common pattern. We figured that we will be pretty much doing the same for most of our queries and added convenience methods for MongoDB. They can be found [here](https://github.com/aksio-system/Foundation/blob/main/Source/CQRS.MongoDB/MongoDBCollectionExtensions.cs).

We can therefor package what we had in the controller into an extension API and make it more generalized.

```csharp
public static class MongoDBCollectionExtensions
{
    public static async Task<ClientObservable<IEnumerable<TDocument>>> Observe<TDocument>(
        this IMongoCollection<TDocument> collection,
        Expression<Func<TDocument, bool>>? filter,
        FindOptions<TDocument, TDocument>? options = null)
    {
        filter ??= _ => true;
        return await collection.Observe(() => collection.FindAsync(filter, options));
    }

    public static async Task<ClientObservable<IEnumerable<TDocument>>> Observe<TDocument>(
        this IMongoCollection<TDocument> collection,
        FilterDefinition<TDocument>? filter = null,
        FindOptions<TDocument, TDocument>? options = null)
    {
        filter ??= FilterDefinition<TDocument>.Empty;
        return await collection.Observe(() => collection.FindAsync(filter, options));
    }

    static async Task<ClientObservable<IEnumerable<TDocument>>> Observe<TDocument>(
            this IMongoCollection<TDocument> collection,
            Func<Task<IAsyncCursor<TDocument>>> findCall)
    {
        var observable = new ClientObservable<IEnumerable<TDocument>>();
        var response = await findCall();
        observable.OnNext(response.ToList());
        var cursor = collection.Watch();

        _ = Task.Run(async () =>
        {
            while (await cursor.MoveNextAsync())
            {
                if (!cursor.Current.Any()) continue;
                var response = await findCall();
                observable.OnNext(response.ToList());
            }
        });

        observable.ClientDisconnected = () => cursor.Dispose();

        return observable;
    }
}
```

With this glue in place, we now have something that makes it very easy to create something that observes a collection and sends any changes to the frontend:

```csharp
[Route("/api/accounts/debit")]
public class Accounts : Controller
{
    readonly IMongoCollection<DebitAccount> _accountsCollection;

    public Accounts(
        IMongoCollection<DebitAccount> accountsCollection)
    {
        _accountsCollection = accountsCollection;
    }

    [HttpGet]
    public Task<ClientObservable<IEnumerable<DebitAccount>>> AllAccounts()
    {
        return _accountsCollection.Observe();
    }
}
```

## Streaming JSON

A nice addition to ASP.NET Core 6 is the native support for `[IAsyncEnumerable<T>](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.iasyncenumerable-1?view=net-6.0)` and streaming of JSON:

https://twitter.com/davidfowl/status/1436706303586410503?ref\_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1436706303586410503%7Ctwgr%5E%7Ctwcon%5Es1\_&ref\_url=https%3A%2F%2Fanthonygiretti.com%2F2021%2F09%2F22%2Fasp-net-core-6-streaming-json-responses-with-iasyncenumerable-example-with-angular%2F

One benefit of this is you can now quite easily support both a WebSocket scenario and regular web requests. On our `ClientObservable<T>` we can then implement the `IAsyncEnumerable<T>` interface and create our own enumerator that supports this by observing the subject we have there.

```csharp
    public class ClientObservable<T> : IClientObservable, IAsyncEnumerable<T>
    {
        readonly ReplaySubject<T> _subject = new();

        public ClientObservable(Action? clientDisconnected = default)
        {
            ClientDisconnected = clientDisconnected;
        }

        public Action? ClientDisconnected { get; set; }

        public void OnNext(T next) => _subject.OnNext(next);

        public async Task HandleConnection(ActionExecutingContext context, JsonOptions jsonOptions)
        {
            using var webSocket = await context.HttpContext.WebSockets.AcceptWebSocketAsync();
            var subscription = _subject.Subscribe(_ =>
            {
                var queryResult = new QueryResult(_!, true);
                var json = JsonSerializer.Serialize(queryResult, jsonOptions.JsonSerializerOptions);
                var message = Encoding.UTF8.GetBytes(json);

                webSocket.SendAsync(new ArraySegment<byte>(message, 0, message.Length), WebSocketMessageType.Text, true, CancellationToken.None);
            });

            var buffer = new byte[1024 * 4];
            var received = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);

            while (!received.CloseStatus.HasValue)
            {
                received = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
            }

            await webSocket.CloseAsync(received.CloseStatus.Value, received.CloseStatusDescription, CancellationToken.None);
            subscription.Dispose();

            ClientDisconnected?.Invoke();
        }

        public IAsyncEnumerator<T> GetAsyncEnumerator(CancellationToken cancellationToken = default) => new ObservableAsyncEnumerator<T>(_subject, cancellationToken);

        public object GetAsynchronousEnumerator(CancellationToken cancellationToken = default) => GetAsyncEnumerator(cancellationToken);
    }
```

The return type of `ObervableAsyncEnumerator<T>` can be implemented as follows:

```csharp
public class ObservableAsyncEnumerator<T> : IAsyncEnumerator<T>
{
    readonly IDisposable _subscriber;
    readonly CancellationToken _cancellationToken;
    readonly ConcurrentQueue<T> _items = new();
    TaskCompletionSource _taskCompletionSource = new();

    public ObservableAsyncEnumerator(IObservable<T> observable, CancellationToken cancellationToken)
    {
        Current = default!;
        _subscriber = observable.Subscribe(_ =>
        {
            _items.Enqueue(_);
            if (!_taskCompletionSource.Task.IsCompletedSuccessfully)
            {
                _taskCompletionSource?.SetResult();
            }
        });
        _cancellationToken = cancellationToken;
    }

    public T Current { get; private set; }

    public ValueTask DisposeAsync()
    {
        _subscriber.Dispose();
        return ValueTask.CompletedTask;
    }

    public async ValueTask<bool> MoveNextAsync()
    {
        if (_cancellationToken.IsCancellationRequested) return false;
        await _taskCompletionSource.Task;
        _items.TryDequeue(out var item);
        Current = item!;
        _taskCompletionSource = new();
        if (!_items.IsEmpty)
        {
            _taskCompletionSource.SetResult();
        }

        return true;
    }
}
```

## Conclusion

This post we've touched on an optimization and formalization of reactive Web programming. From a perspective of covering the most common use cases, we feel that this approach achieves that. It is not a catch-all solution, but with the way we've built it you do have some flexibility in how you use this. It is not locked down to be specifically just MongoDB. The `ClientObservable` is completely agnostic, you can use it for anything - all you need is to be able to observe something else and then call the `OnNext` method on the observable whenever new things appear.

From a user perspective I think we should aim for solutions that does not require the user to hit a refresh button. In order to do that, it needs to be simple for developers to enable it in their solutions. The solution presented here is geared towards that.

If you have any feedback, good or bad, improvements or pitfalls; please leave a comment.
