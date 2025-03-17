local placeid = game.PlaceId

if placeid == 6961824067 then
  print("loading ftap...")
  loadstring(game:HttpGet('https://raw.githubusercontent.com/wploits/critclhub/refs/heads/main/ftap.lua'))()
else
  warn("unsupported game")
  loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end
