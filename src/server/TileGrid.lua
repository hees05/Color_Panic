local Constants = require(game:GetService("ReplicatedStorage"):WaitForChild("Constants"))

local TileGrid = {}

--code for creating a grid filled with colours.
function TileGrid.BuildGrid(parent, sizeX, sizeZ, tileSize, y, offset) -- sizeX is the number of tiles that will be generated in the x direction and sizeZ being the number of tiles genearted in Y direction(in a X-Y graph format)
    local tiles = {}
    offset = offset or Vector3.new(0,0,0) --offset used to move the colour tiles to a different place. 
    --I only have to change the vector of x and z. Y can be set to a constant value to make it stay on the ground.
    --For the improved version y value can be changed (the user can go up a level to compete in a higher level tiles maybe)
    local origin = offset + Vector3.new(-((sizeX-1)*tileSize)/2, y, -((sizeZ-1)*tileSize)/2)
    for x = 1, sizeX do
        for z = 1, sizeZ do
            local p = Instance.new("Part")
            p.Name = ("Tile_%d_%d"):format(x, z)
            p.Size = Vector3.new(tileSize, 2, tileSize)
            p.Anchored = true
            --I want the tiles to have smooth surface instead of bumps
            p.TopSurface = Enum.SurfaceType.Smooth 
            p.BottomSurface = Enum.SurfaceType.Smooth

            --adjusting position of the current tile based on the origin. 
            p.Position = origin + Vector3.new((x-1)*tileSize, 0, (z-1)*tileSize)
            p.Parent = parent

            table.insert(tiles, p)

            --creating the spawn points of the players once they're stepped on the JoinPad.
            if x == math.ceil(sizeX/2) and z == math.ceil(sizeZ/2) then 
                local marker = Instance.new("Part")
                marker.Name = "ArenaSpawn"
                marker.Size = Vector3.new(2, 1, 2)
                marker.Position = p.Position + Vector3.new(0, 1.5, 0)
                marker.Anchored = true
                marker.CanCollide = false
                marker.Transparency = 0.5
                marker.Color = Color3.fromRGB(255, 255, 255)
                marker.Parent = parent
            end
        end
    end
    return tiles
end

--Allocating colours to all the created tiles.
function TileGrid.PaintRandom(tiles)
    for _, tile in ipairs(tiles) do
        local num = math.random(1, 4)
        local c = Constants.COLORS[num]
        tile.Color = c.Color
        tile:SetAttribute("ColorName", c.Name) --using this for convenience to allocate scores to the users at the end of the round based on the colour that they're stepped on.
        tile.CanCollide = true
        tile.Transparency = 0
    end
end

--Destroying all the existing tiles
function TileGrid.clear(parent)
    for _, inst in ipairs(parent:GetChildren()) do
        if inst:IsA("BasePart") and inst.Name:match("^Tile_") then
            inst:Destroy()
        end
    end
end

return TileGrid
