local Server = {}
Server.__index = Server

local Type = require(script.Parent.Parent.Parent.Type)

function Server.New(remote : RemoteFunction) : Type.ServerFunction
	local self = setmetatable({
		remote = remote;
		remote_type = "RemoteFunction"
	}, Server)
	
	function self:Invoke(player : Player, ...)
		return remote:InvokeClient(player, ...)
	end

	return self :: Type.ServerFunction
end

function Server.NewBindable(remote : BindableFunction): Type.ServerBindableFunction
	local self = setmetatable({
		remote = remote;
		remote_type = "BindableFunction"
	}, Server)
	
	function self:Invoke(...)
		return remote:Invoke(...)
	end

	return self :: Type.ServerBindableFunction
end

function Server:OnInvoke(CallBack : (...any) -> any)
	if self.remote_type == 'BindableFunction' then
		self.remote.OnInvoke = CallBack
	else
		self.remote.OnServerInvoke = CallBack
	end
end

function Server:Destroy()
	self.remote:Destroy()
	self = nil
end

return Server


