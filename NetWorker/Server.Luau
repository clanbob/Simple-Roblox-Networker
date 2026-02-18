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

local function wait_for_remote(name: string, folder: Folder)
	return folder:WaitForChild(name)
end

local function is_bindable_type(remote_type: string): boolean
	return remote_type == net_worker.EventTypes.BindableEvent or remote_type == net_worker.FunctionTypes.BindableFunction
end

local function new_com(info: { name: string, remote_type: string, folder: Folder, on_server: boolean })
	local remote = info.folder:FindFirstChild(info.name)
	if remote then
		return remote
	end

	if info.on_server or is_bindable_type(info.remote_type) then
		remote = Instance.new(info.remote_type)
		remote.Name = info.name
		remote.Parent = info.folder
		return remote
	end

	return wait_for_remote(info.name, info.folder)
end

function net_worker:RemoteEvent(Name: string): Type.ServerEvent
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.EventTypes.RemoteEvent
	local folder: Folder = script.Parent.Comms.Events.RemoteEvent

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = true,
	})

	return (event_session.New(remote)) :: Type.ServerEvent
end

function net_worker:UnreliableRemoteEvent(Name: string): Type.ServerEvent
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.EventTypes.UnreliableRemoteEvent
	local folder: Folder = script.Parent.Comms.Events.UnreliableRemoteEvent

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = true,
	})

	return (event_session.New(remote)) :: Type.ServerEvent
end

function net_worker:BindableEvent(Name: string): Type.ServerBindableEvent
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.EventTypes.BindableEvent
	local folder: Folder = script.Parent.Comms.Events.BindableEvent

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = true,
	})

	return (event_session.NewBindable(remote)) :: Type.ServerBindableEvent
end

function net_worker:RemoteFunction(Name: string): Type.ServerFunction
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.FunctionTypes.RemoteFunction
	local folder: Folder = script.Parent.Comms.Functions.RemoteFunction

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = true,
	})

	return (function_session.New(remote)) :: Type.ServerFunction
end

function net_worker:BindableFunction(Name: string): Type.ServerBindableFunction
	if type(Name) ~= "string" then error("Name is not a string") end

	local remote_type = net_worker.FunctionTypes.BindableFunction
	local folder: Folder = script.Parent.Comms.Functions.BindableFunction

	local remote = new_com({
		name = Name,
		remote_type = remote_type,
		folder = folder,
		on_server = true,
	})

	return (function_session.NewBindable(remote)) :: Type.ServerBindableFunction
end

return net_worker :: typeof(net_worker)
