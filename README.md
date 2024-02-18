```lua
local Ratelimit = Ratelimiter.new({
  Flowrate = 1/4
})

Ratelimiter:WrapSignal(SomeRemote.OnServerEvent):Connect(function()
  print("if this was spammed it would only print every 1/4 seconds")
end)

```
