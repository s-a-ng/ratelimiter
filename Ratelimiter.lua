local Ratelimiter = {}


function Ratelimiter.new(Data)
	local self = setmetatable({}, {__index = Ratelimiter})
	self.Flowrate = Data.Flowrate
	self.SignalToCallbacks = {
		
	}
	self.SignalToLastFire = {
		
	}

	self.SignalToWrapper = {
		
	}

	return self
end



function Ratelimiter:WrapSignal(Signal)
	local Wrapper = self.SignalToWrapper[Signal]
	if Wrapper then 
		return Wrapper
	end
	
	self.SignalToLastFire[Signal] = 0
	self.SignalToCallbacks[Signal] = {}
	
	
	local function Handler()
		while true do 
			local Data = {Signal:Wait()}
			
			local LastFireTime = self.SignalToLastFire[Signal]

			if LastFireTime + self.Flowrate >= os.clock() then
				continue 
			end
			
			local Callbacks = self.SignalToCallbacks[Signal]
			for _, Callback in Callbacks do 
				Callback(unpack(Data))
			end

			self.SignalToLastFire[Signal] = os.clock()
		end
	end
	
	task.spawn(Handler)

	local Wrapper = {
		Connect = function(_, callback)		
			local Callbacks = self.SignalToCallbacks[Signal]

			table.insert(Callbacks, callback)
		end,
		Wait = function()
			local Callbacks = self.SignalToCallbacks[Signal]
			local Data;
			local Callback = function(...)
				Data = {...}
			end

			table.insert(Callbacks, Callback)

			repeat task.wait() until Data  

			table.remove(Callbacks, table.find(Callbacks, Callback))

			return Data
		end,
	}

	self.SignalToWrapper[Signal] = Wrapper
	
	return Wrapper
end

return Ratelimiter
