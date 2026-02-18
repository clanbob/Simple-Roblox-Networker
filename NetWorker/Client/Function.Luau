local Client = {}
Client.__index = Client

local Type = require(script.Parent.Parent.Parent.Type)

function Client.New(remote : RemoteFunction) : Type.ClientFunction
	local self = setmetatable({
		remote = remote;
		remote_type = "RemoteFunction"
	}, Client)
	
	function self:Invoke(player : Player, ...)
		return remote:InvokeServer(...)
	end

	return self :: Type.ClientFunction
end

function Client.NewBindable(remote : BindableFunction): Type.ClientBindableFunction
	local self = setmetatable({
		remote = remote;
		remote_type = "BindableFunction"
	}, Client)
	
	function self:Invoke(...)
		return remote:Invoke(...)
	end

	return self :: Type.ClientBindableFunction
end

function Client:OnInvoke(CallBack : (...any) -> any)
	if self.remote_type == 'BindableFunction' then
		self.remote.OnInvoke = CallBack
	else
		self.remote.OnClientInvoke = CallBack
	end
end

function Client:Destroy()
	self.remote:Destroy()
	self = nil
end

return Client


