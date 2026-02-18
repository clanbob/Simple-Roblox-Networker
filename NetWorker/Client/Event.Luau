local Client = {}
Client.__index = Client

local Type = require(script.Parent.Parent.Parent.Type)

function Client.New(remote : RemoteEvent): Type.ClientEvent
	local self = setmetatable({
		remote = remote;
		remote_type = "RemoteEvent"
	}, Client)

	return self :: Type.ClientEvent
end

function Client.NewBindable(remote : BindableEvent): Type.ClientEvent
	local self = setmetatable({
		remote = remote;
		remote_type = "BindableEvent"
	}, Client)

	return self :: Type.ClientEvent
end

function Client:Connect(CallBack : (...any) -> ())
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Connect(CallBack)) :: RBXScriptConnection
	else
		return (self.remote.OnClientEvent:Connect(CallBack)) :: RBXScriptConnection
	end	
end

function Client:Once(CallBack : (...any) -> ()): RBXScriptConnection
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Once(CallBack)) :: RBXScriptConnection
	else
		return (self.remote.OnClientEvent:Once(CallBack)) :: RBXScriptConnection
	end	
end

function Client:ConnectIfCondition<Condition>(initial_condition : Condition, CallBack : (condition : Condition,  ...any) -> ())
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Connect(function(Condition : Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(Condition, ...)
		end)) :: RBXScriptConnection
	else
		return (self.remote.OnClientEvent:Connect(function(Condition : Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(Condition, ...)
		end)) :: RBXScriptConnection
	end	 
end

function Client:OnceIfCondition<Condition>(initial_condition : Condition, CallBack : (condition : Condition,  ...any) -> ()): RBXScriptConnection
	local connection : RBXScriptConnection
	if self.remote_type == "BindableEvent" then
		connection = self.remote.Event:Connect(function(Condition : Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(Condition, ...)

			connection:Disconnect()
		end)

		return connection :: RBXScriptConnection
	else
		connection = self.remote.OnClientEvent:Connect(function(Condition : Condition, ...)
			if initial_condition ~= Condition then return end
			CallBack(Condition, ...)

			connection:Disconnect()
		end)

		return connection :: RBXScriptConnection
	end	 
end

function Client:Fire(...)
	if self.remote_type == "BindableEvent" then
		return (self.remote.Event:Fire(...)) :: RBXScriptConnection
	else
		return (self.remote:FireServer(...)) :: RBXScriptConnection
	end
end

function Client:Destroy(): ()
	self.remote:Destroy()
	self = nil
end

return Client


