local Type = require(script.Parent.Type)

local function create_comms()
	if script:FindFirstChild('Comms') then return end
	
	local comms_folder = Instance.new("Folder")
	comms_folder.Name = "Comms"
	comms_folder.Parent = script
	
	local event_folder = Instance.new("Folder")
	event_folder.Name = "Events"
	event_folder.Parent = comms_folder
	
	local function_folder = Instance.new("Folder")
	function_folder.Name = "Functions"
	function_folder.Parent = comms_folder
	
	local remote_event = Instance.new("Folder")
	remote_event.Name = "RemoteEvent"
	remote_event.Parent = event_folder
	
	local BindableEvent = Instance.new("Folder")
	BindableEvent.Name = "BindableEvent"
	BindableEvent.Parent = event_folder
	
	local remote_function = Instance.new("Folder")
	remote_function.Name = "RemoteFunction"
	remote_function.Parent = function_folder
	
	local BindableFunction = Instance.new("Folder")
	BindableFunction.Name = "BindableFunction"
	BindableFunction.Parent = function_folder
end

create_comms()

return {
	Server = require(script.Server);
	Client = require(script.Client)
} :: {
	Server : Type.ServerSessionFunctions;
	Client : Type.ClientSessionFunctions;
}
