local net_worker = {}
local Type = require(script.Parent.Parent.Type)

local RunService = game:GetService('RunService')

net_worker.EventTypes = {
	RemoteEvent = 'RemoteEvent';
	UnreliableRemoteEvent = 'UnreliableRemoteEvent';
	BindableEvent = 'BindableEvent';
}

net_worker.FunctionTypes = {
	RemoteFunction = 'RemoteFunction';
	BindableFunction = 'BindableFunction';
}

local function wait_for_remote(Name : string, folder : Folder)
	local remote
	repeat task.wait()
		remote = folder:FindFirstChild(Name)
	until remote
	
	return remote
end

local function new_com(info : {name : string, remote_type : string, folder : Folder, on_server : boolean})
	local remote
	if info.on_server then
		if not info.folder:FindFirstChild(info.name) then
			remote = Instance.new(info.remote_type)
			remote.Name = info.name
			remote.Parent = info.folder
		else
			remote = info.folder:FindFirstChild(info.name)
		end
	else
		if not info.folder:FindFirstChild( info.name) and info.remote_type ~= net_worker.EventTypes.BindableEvent then
			remote = wait_for_remote( info.name, info.folder)
		else
			if info.remote_type == net_worker.EventTypes.BindableEvent then
				remote = Instance.new(info.remote_type)
				remote.Name =  info.name
				remote.Parent = info.folder
			else
				remote = wait_for_remote( info.name, info.folder)
			end
		end
	end
	
	return remote
end

function net_worker:RemoteEvent(Name : string): Type.ServerEvent
	if type(Name) ~= 'string' then error("Name is not a string") end
	
	local on_server = RunService:IsServer()
	local RemoteType = net_worker.EventTypes.RemoteEvent	
	local folder : Folder = script.Parent.Comms.Events.RemoteEvent
	
	local remote = new_com({
		name = Name;
		remote_type = RemoteType;
		folder = folder;
		on_server = on_server
	})	
	local session = require(script.Event)

	return (session.New(remote)) :: Type.ServerEvent
end

function net_worker:UnreliableRemoteEvent(Name : string): Type.ServerEvent
	if type(Name) ~= 'string' then error("Name is not a string") end
	
	local on_server = RunService:IsServer()
	local RemoteType = net_worker.EventTypes.UnreliableRemoteEvent	
	local folder : Folder = script.Parent.Comms.Events.UnreliableRemoteEvent

	local remote = new_com({
		name = Name;
		remote_type = RemoteType;
		folder = folder;
		on_server = on_server
	})	
	local session = require(script.Event)

	return (session.New(remote)) :: Type.ServerEvent
end

function net_worker:BindableEvent(Name : string): Type.ServerBindableEvent
	if type(Name) ~= 'string' then error("Name is not a string") end
	
	local on_server = RunService:IsServer()
	local RemoteType = net_worker.EventTypes.bindableEvent	
	local folder : Folder = script.Parent.Comms.Events.BindableEvent

	local remote = new_com({
		name = Name;
		remote_type = RemoteType;
		folder = folder;
		on_server = on_server
	})	
	local session = require(script.Event)

	return (session.NewBindable(remote)) :: Type.ServerBindableEvent
end

function net_worker:RemoteFunction(Name : string): Type.ServerFunction
	if type(Name) ~= 'string' then error("Name is not a string") end
	
	local on_server = RunService:IsServer()
	local RemoteType = net_worker.FunctionTypes.RemoteFunction
	local folder : Folder = script.Parent.Comms.Functions.RemoteFunction

	local remote = new_com({
		name = Name;
		remote_type = RemoteType;
		folder = folder;
		on_server = on_server
	})	
	local session = require(script.Function)
	
	return (session.New(remote)) :: Type.ServerFunction
end

function net_worker:BindableFunction(Name : string): Type.ServerBindableFunction
	if type(Name) ~= 'string' then error("Name is not a string") end
	
	local on_server = RunService:IsServer()
	local RemoteType = net_worker.FunctionTypes.BindableFunction
	local folder : Folder = script.Parent.Comms.Functions.BindableFunction

	local remote = new_com({
		name = Name;
		remote_type = RemoteType;
		folder = folder;
		on_server = on_server
	})	
	local session = require(script.Function)

	return (session.NewBindable(remote)) :: Type.ServerBindableFunction
end

return net_worker :: typeof(net_worker)
