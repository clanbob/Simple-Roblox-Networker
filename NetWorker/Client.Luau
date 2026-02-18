local net_worker = {}
local Type = require(script.Parent.Parent.Type)

net_worker.EventTypes = {
	RemoteEvent = "RemoteEvent",
	UnreliableRemoteEvent = "UnreliableRemoteEvent",
	BindableEvent = "BindableEvent",
}

net_worker.FunctionTypes = {
	RemoteFunction = "RemoteFunction",
	BindableFunction = "BindableFunction",
}

local event_session = require(script.Event)
local function_session = require(script.Function)

local REMOTE_WAIT_TIMEOUT = 5

local function wait_for_remote(name: string, folder: Folder)
	local remote = folder:WaitForChild(name, REMOTE_WAIT_TIMEOUT)
	if not remote then
		warn(`[{script.Name}]: {name} remote infinite yield possible`)
	end

	return remote
end

local function new_com(info: { name: string, remote_type: string, folder: Folder, on_server: boolean })
	local remote = info.folder:FindFirstChild(info.name)
	if remote then
		return remote
	end

	if info.on_server or info.remote_type == net_worker.EventTypes.BindableEvent then
		remote = Instance.new(info.remote_type)
		remote.Name = info.name
		remote.Parent = info.folder
		return remote
	end

	return wait_for_remote(info.name, info.folder)
end

function net_worker:RemoteEvent(Name: string): Type.ClientEvent
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.EventTypes.RemoteEvent
	local folder: Folder = script.Parent.Comms.Events.RemoteEvent

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = false,
	})
	if not remote then return end

	return (event_session.New(remote)) :: Type.ClientEvent
end

function net_worker:UnreliableRemoteEvent(Name: string): Type.ClientEvent
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.EventTypes.UnreliableRemoteEvent
	local folder: Folder = script.Parent.Comms.Events.UnreliableRemoteEvent

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = false,
	})
	if not remote then return end

	return (event_session.New(remote)) :: Type.ClientEvent
end

function net_worker:BindableEvent(Name: string): Type.ClientEvent
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.EventTypes.BindableEvent
	local folder: Folder = script.Parent.Comms.Events.BindableEvent

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = false,
	})

	return (event_session.NewBindable(remote)) :: Type.ClientEvent
end

function net_worker:RemoteFunction(Name: string): Type.ClientFunction
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.FunctionTypes.RemoteFunction
	local folder: Folder = script.Parent.Comms.Functions.RemoteFunction

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = false,
	})
	if not remote then return end

	return (function_session.New(remote)) :: Type.ClientFunction
end

function net_worker:BindableFunction(Name: string): Type.ClientBindableFunction
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.FunctionTypes.BindableFunction
	local folder: Folder = script.Parent.Comms.Functions.BindableFunction

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = false,
	})

	return (function_session.NewBindable(remote)) :: Type.ClientBindableFunction
end

return net_worker :: typeof(net_worker)
