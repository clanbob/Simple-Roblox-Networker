local Type = require(script.Parent.Type)

return {
	Server = require(script.Server);
	Client = require(script.Client)
} :: {
	Server : Type.ServerSessionFunctions;
	Client : Type.ClientSessionFunctions;
}
