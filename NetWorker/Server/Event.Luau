local Server = {}
Server.__index = Server

local Type = require(script.Parent.Parent.Parent.Type)

function Server.New(remote: RemoteEvent | UnreliableRemoteEvent): Type.ServerEvent
	local self = setmetatable({
		remote = remote,
		remote_type = "RemoteEvent",
	}, Server)

	return self :: Type.ServerEvent
end

function Server.NewBindable(remote: BindableEvent): Type.ServerBindableEvent
	local self = setmetatable({
		remote = remote,
		remote_type = "BindableEvent",
	}, Server)

	return self :: Type.ServerBindableEvent
end

function Server:Connect(CallBack: (player: Player, ...any) -> ())
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Connect(CallBack)) :: RBXScriptConnection
	else
		return (self.remote.OnServerEvent:Connect(CallBack)) :: RBXScriptConnection
	end
end

function Server:Once(CallBack: (player: Player, ...any) -> ()): RBXScriptConnection
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Once(CallBack)) :: RBXScriptConnection
	else
		return (self.remote.OnServerEvent:Once(CallBack)) :: RBXScriptConnection
	end
end

function Server:ConnectForPlayer(player: Player, CallBack: (player: Player, ...any) -> ()): RBXScriptConnection
	if self.remote_type == "BindableEvent" then
		error("ConnectForPlayer method is not supported for BindableEvent")
	end

	return (self.remote.OnServerEvent:Connect(function(player_who_fired: Player, ...)
		if player_who_fired ~= player then return end
		CallBack(player_who_fired, ...)
	end)) :: RBXScriptConnection
end

function Server:ConnectIfCondition<Condition>(initial_condition: Condition, CallBack: (player: Player, condition: Condition, ...any) -> ())
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Connect(function(player: Player, Condition: Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(player, Condition, ...)
		end)) :: RBXScriptConnection
	else
		return (self.remote.OnServerEvent:Connect(function(player: Player, Condition: Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(player, Condition, ...)
		end)) :: RBXScriptConnection
	end
end

function Server:OnceIfCondition<Condition>(initial_condition: Condition, CallBack: (player: Player, condition: Condition, ...any) -> ()): RBXScriptConnection
	local connection: RBXScriptConnection
	if self.remote_type == "BindableEvent" then
		connection = self.remote.Event:Connect(function(player: Player, Condition: Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(player, Condition, ...)

			connection:Disconnect()
		end)

		return connection :: RBXScriptConnection
	else
		connection = self.remote.OnServerEvent:Connect(function(player: Player, Condition: Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(player, Condition, ...)

			connection:Disconnect()
		end)

		return connection :: RBXScriptConnection
	end
end

function Server:OnceForPlayer(player: Player, CallBack: (player: Player, ...any) -> ()): RBXScriptConnection
	if self.remote_type == "BindableEvent" then
		error("OnceForPlayer method is not supported for BindableEvent")
	end

	local connection: RBXScriptConnection
	connection = self.remote.OnServerEvent:Connect(function(player_who_fired: Player, ...)
		if player_who_fired ~= player then return end
		CallBack(player_who_fired, ...)

		connection:Disconnect()
	end)

	return connection :: RBXScriptConnection
end

function Server:Wait()
	if self.remote_type == "BindableEvent" then
		self.remote.Event:Wait()
	else
		self.remote.OnServerEvent:Wait()
	end
end

function Server:Fire(...)
	local self = self :: Type.ServerEvent
	if self.remote_type == "BindableEvent" then
		self.remote:Fire(...)
		return
	end

	local conf = select(1, ...) :: config
	if typeof(conf) ~= "table" then
		error("config table is missing or not passed")
	end

	if typeof(conf[1]) ~= "boolean" then
		error("invalid config values " .. tostring(conf[1]) .. " " .. tostring(conf[2]))
	end

	if conf[1] then
		self.remote:FireAllClients(select(2, ...))
	else
		self.remote:FireClient(conf[2], select(2, ...))
	end
end

function Server:Destroy(): ()
	self.remote:Destroy()
	self = nil
end

type config = {
	AllClients: boolean,
	player: Player,
}

return Server
