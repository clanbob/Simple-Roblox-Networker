local module = {}

export type ServerEvent = {
	remote : RemoteEvent;
	remote_type : string;
	Connect : (self : ServerEvent, CallBack : (player : Player, ...any) -> ()) -> RBXScriptConnection;
	Once : (self : ServerEvent, CallBack : (player : Player, ...any) -> ()) -> RBXScriptConnection;
	ConnectForPlayer : (self : ServerEvent, player : Player, CallBack : (player : Player, ...any) -> ()) -> RBXScriptConnection;
	OnceForPlayer : (self : ServerEvent, player : Player, CallBack : (player : Player, ...any) -> ()) -> RBXScriptConnection;
	ConnectIfCondition : <Condition>(self: ServerEvent, initial_condition : Condition, CallBack : (Player : Player, conditon : Condition, ...any) -> ()) -> RBXScriptConnection;
	OnceIfCondition : <Condition>(self: ServerEvent, initial_condition : Condition, CallBack : (Player : Player, conditon : Condition, ...any) -> ()) -> RBXScriptConnection;
	Fire : (self : ServerEvent, conf : {AllClients : boolean, player : Player}, ...any) -> ();
	Destroy : (self : ServerEvent) -> ();
}

export type ServerBindableEvent = {
	remote : RemoteEvent;
	remote_type : string;
	Connect : (self : ServerBindableEvent, CallBack : (...any) -> ()) -> RBXScriptConnection;
	Once : (self : ServerBindableEvent, CallBack : (...any) -> ()) -> RBXScriptConnection;
	ConnectIfCondition : <Condition>(self: ServerBindableEvent, initial_condition : Condition, CallBack : (Player : Player, conditon : Condition, ...any) -> ()) -> RBXScriptConnection;
	OnceIfCondition : <Condition>(self: ServerBindableEvent, initial_condition : Condition, CallBack : (Player : Player, conditon : Condition, ...any) -> ()) -> RBXScriptConnection;
	Fire : (self : ServerBindableEvent, ...any) -> ();
	Destroy : (self : ServerBindableEvent) -> ();
}

export type ServerFunction = {
	Invoke : (self : ServerFunction, Player : Player, ...any) -> any;
	OnInvoke : (self : ServerFunction, CallBack : (...any) -> any) -> ();
	Destroy : (self : ServerFunction) -> ();
}

export type ServerBindableFunction = {
	Invoke : (self : ServerFunction, ...any) -> any;
	OnInvoke : (self : ServerFunction, CallBack : (...any) -> any) -> ();
	Destroy : (self : ServerFunction) -> ();
}

export type ClientEvent = {
	remote : RemoteEvent;
	remote_type : string;
	Connect : (self : ClientEvent, CallBack : (...any) -> ()) -> RBXScriptConnection;
	Once : (self : ClientEvent, CallBack : (...any) -> ()) -> RBXScriptConnection;
	ConnectIfCondition : <Condition>(self: ClientEvent, initial_condition : Condition, CallBack : (conditon : Condition, ...any) -> ()) -> RBXScriptConnection;
	OnceIfCondition : <Condition>(self: ClientEvent, initial_condition : Condition, CallBack : (conditon : Condition, ...any) -> ()) -> RBXScriptConnection;
	Fire : (self : ClientEvent, ...any) -> ();
	Destroy : (self : ClientEvent) -> ();
}

export type ClientFunction = {
	Invoke : (self : ServerFunction, Player : Player, ...any) -> any;
	OnInvoke : (self : ServerFunction, CallBack : (...any) -> any) -> ();
	Destroy : (self : ServerFunction) -> ();
}

export type ClientBindableFunction = {
	Invoke : (self : ServerFunction, ...any) -> any;
	OnInvoke : (self : ServerFunction, CallBack : (...any) -> any) -> ();
	Destroy : (self : ServerFunction) -> ();
}

export type ServerSessionFunctions = {
	RemoteEvent : (self : ServerSessionFunctions, Name : string) -> ServerEvent;
	UnreliableRemoteEvent : (self : ServerSessionFunctions, Name : string) -> ServerEvent;
	BindableEvent : (self : ServerSessionFunctions, Name : string) -> ServerBindableEvent;
	RemoteFunction : (self : ServerSessionFunctions, Name : string) -> ServerFunction;
	BindableFunction : (self : ServerSessionFunctions, Name : string) -> ServerBindableFunction;
}

export type ClientSessionFunctions = {
	RemoteEvent : (self : ClientSessionFunctions, Name : string) -> ClientEvent;
	UnreliableRemoteEvent : (self : ClientSessionFunctions, Name : string) -> ClientEvent;
	BindableEvent : (self : ClientSessionFunctions, Name : string) -> ClientEvent;
	RemoteFunction : (self : ClientSessionFunctions, Name : string) -> ClientFunction;
	BindableFunction : (self : ClientSessionFunctions, Name : string) -> ClientBindableFunction;
}


return module
