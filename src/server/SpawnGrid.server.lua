local TileGrid = require(script.Parent:WaitForChild("TileGrid"))
local arena = workspace:WaitForChild("GameArena") --Game Arena created so that all the tiles created goes in here instead of the workspace, making the workspace less messy.

--creating the tiles on the user interface
local tiles = TileGrid.BuildGrid(arena, 7, 7, 12, 5, Vector3.new(1000, 0, 0))
TileGrid.PaintRandom(tiles)

print(("SpawnGrid script spawned %d tiles."):format(#tiles))
