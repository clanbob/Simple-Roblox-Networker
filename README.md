# Simple Roblox Networker

Simple Roblox Networker is a Luau module that wraps Roblox networking objects with a small, consistent API for server/client communication.

It gives you helpers for:

- `RemoteEvent`
- `RemoteFunction`
- `BindableEvent`
- `BindableFunction`

## Installation

1. Put the `NetWorker` module tree and `Type.Luau` in your game (for example in `ReplicatedStorage`).
2. Require the root module (`NetWorker.Luau`) from server and client scripts.
3. Use the same remote names on both sides.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)
```

When required, the module creates a `Comms` folder under the module with folders for events/functions.

## API Overview

### Create sessions

From the root module:

- `NetWorker.Server` → server-side constructors
- `NetWorker.Client` → client-side constructors

Server constructors:

- `RemoteEvent(name)`
- `UnreliableRemoteEvent(name)`
- `BindableEvent(name)`
- `RemoteFunction(name)`
- `BindableFunction(name)`

Client constructors:

- `RemoteEvent(name)`
- `UnreliableRemoteEvent(name)`
- `BindableEvent(name)`
- `RemoteFunction(name)`
- `BindableFunction(name)`

## Event usage

### Server: `RemoteEvent`

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)

local ChatEvent = NetWorker.Server:RemoteEvent("ChatMessage")

ChatEvent:Connect(function(player, message)
	print(player.Name, message)
end)

-- Fire all clients
ChatEvent:Fire({true}, "Welcome!")

-- Fire one client
ChatEvent:Fire({false, game.Players:GetPlayers()[1]}, "Private message")
```

`ServerEvent:Fire` expects a config table as first argument:

- `{true}` → send to all clients
- `{false, player}` → send to one player

### Client: `RemoteEvent`

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)

local ChatEvent = NetWorker.Client:RemoteEvent("ChatMessage")

ChatEvent:Connect(function(message)
	print("Server says:", message)
end)

ChatEvent:Fire("Hello from client")
```

### Condition helpers

Both server/client event sessions include:

- `ConnectIfCondition(expectedCondition, callback)`
- `OnceIfCondition(expectedCondition, callback)`

These only run the callback when the first payload value after player (server) or first payload value (client) equals `expectedCondition`.

## Function usage

### Server: `RemoteFunction`

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)

local ProfileFn = NetWorker.Server:RemoteFunction("GetProfile")

ProfileFn:OnInvoke(function(player)
	return {
		name = player.Name,
		level = 10,
	}
end)
```

### Client: `RemoteFunction`

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)

local ProfileFn = NetWorker.Client:RemoteFunction("GetProfile")
local data = ProfileFn:Invoke()
print(data.name, data.level)
```

## Bindable usage

Use bindables for same-environment communication.

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)

local LocalEvent = NetWorker.Server:BindableEvent("ServerOnlySignal")
LocalEvent:Connect(function(value)
	print("Bindable event value", value)
end)
LocalEvent:Fire(123)
```

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetWorker = require(ReplicatedStorage.NetWorker)

local LocalFn = NetWorker.Server:BindableFunction("ComputeValue")
LocalFn:OnInvoke(function(a, b)
	return a + b
end)

print(LocalFn:Invoke(2, 3)) -- 5
```

## Notes

- Remote names are strings and must match between caller/listener.
- `Client:RemoteEvent(name)` waits for server-created remotes if they are missing.
- `Destroy()` exists on sessions if you need to clean up the underlying instance.

## Optimization tips

If you want better runtime performance and fewer networking issues, these are the best wins:

- Prefer `UnreliableRemoteEvent` for high-frequency, non-critical updates (for example camera/FX snapshots).
- Use `RemoteFunction` only when you need a direct response; otherwise use `RemoteEvent` to avoid yielding.
- Reuse session objects (`NetWorker.Server:RemoteEvent("Name")`) instead of recreating them repeatedly in hot paths.
- Use bindables (`BindableEvent`/`BindableFunction`) for same-side communication to avoid network serialization cost.
- Keep payloads compact (numbers, short strings, IDs) and avoid sending large tables every frame.
- Use `ConnectForPlayer` / condition helpers to filter early and reduce callback work.
- Call `Destroy()` on sessions you no longer need to prevent stale remotes/connections.

The module now also includes small internal optimizations:

- caches internal module requires for sessions
- uses `WaitForChild` for simpler remote lookup waits
- avoids redundant `FindFirstChild` checks during remote creation
- fixes event config forwarding so only payload is forwarded to clients
