```lua
local Ratelimit = Ratelimiter.new({
  Flowrate = 1/4
})

local Wrapped = Ratelimiter:WrapSignal(SomeRemote.OnServerEvent)

Wrapped:Wait()

Wrapped:Connect(function(Player, ...)
  print(Player.Name)
  print("if this was spammed it would only print every 1/4 seconds")
end)

```
