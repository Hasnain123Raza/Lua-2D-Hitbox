local CLASS = {}

--// SERVICES //--



--// CONSTANTS //--



--// VARIABLES //--



--// CONSTRUCTOR //--

function CLASS.new(position, size)
	assert(position ~= nil, "Hitbox Argument Error: Argument 1 nil or missing")
	assert(typeof(position) == "Vector2", "Hitbox Argument Error: Vector2 expected, got " .. typeof(position))
	assert(size ~= nil, "Hitbox Argument Error: Argument 2 nil or missing")
	assert(typeof(size) == "Vector2", "Hitbox Argument Error: Vector2 expected, got " .. typeof(size))
	
	local dataTable = setmetatable(
		{
			ClassName = "Hitbox",
			Position = position,
			Size = size
		},
		CLASS
	)
	local proxyTable = setmetatable(
		{
			DataTable = dataTable,
		},
		{
			__index = function(self, index)
				if (index == "Corners") then
					return self.__corners
				elseif (index == "P1") then
					return self.__corners[1]
				elseif (index == "P2") then
					return self.__corners[2]
				elseif (index == "P3") then
					return self.__corners[3]
				elseif (index == "P4") then
					return self.__corners[4]
				elseif(index == "Top") then
					return self.__corners[1].Y
				elseif(index == "Right") then
					return self.__corners[1].X
				elseif(index == "Bottom") then
					return self.__corners[3].Y
				elseif(index == "Left") then
					return self.__corners[3].X
				else
					return dataTable[index]
				end
			end,
			__newindex = function(self, index, newValue)
				dataTable[index] = newValue
				
				if (index == "Position") or (index == "Size") then
					self.__corners = self:GetCorners()
				end	
			end
		}
	)
	
	proxyTable:Initialize()
	proxyTable:DebugVisualize()
	
	return proxyTable
end

--// FUNCTIONS //--



--// METHODS //--

function CLASS:Initialize()
	self.__corners = self:GetCorners()
end

function CLASS:Destroy()
	
end

function CLASS:GetCorners()
	local position, size = self.Position, self.Size
	return {
		position + Vector2.new(-1, 1) * size/2,
		position + Vector2.new(1, 1) * size/2,
		position + Vector2.new(1, -1) * size/2,
		position + Vector2.new(-1, -1) * size/2,
	}
end

function CLASS:ContainsPosition(position)
	assert(position ~= nil, "Hitbox Argument Error: Argument 1 nil or missing")
	assert(typeof(position) == "Vector2", "Hitbox Argument Error: Vector2 expected, got " .. typeof(position))
	
	return (position.Y < self.Top) and
		(position.X > self.Right) and
		(position.Y > self.Bottom) and
		(position.X < self.Left)
end

function CLASS:Intersects(hitboxes)
	assert(hitboxes ~= nil, "Hitbox Argument Error: Argument 1 nil or missing")
	assert(typeof(hitboxes) == "table", "Hitbox Argument Error: table expected, got " .. typeof(hitboxes))
	if (hitboxes.ClassName ~= nil) then
		hitboxes = {hitboxes}
	end
	for _, hitbox in pairs(hitboxes) do
		assert(hitbox.ClassName ~= nil, "Hitbox Argument Error: Hitbox expected, got table")
		assert(hitbox.ClassName == "Hitbox", "Hitbox Argument Error: Hitbox expected, got " .. hitbox.ClassName)
	end
	
	for _, hitbox in pairs(hitboxes) do
		if (hitbox ~= self) then
			if (self.Top > hitbox.Bottom) and
				(self.Right < hitbox.Left) and
				(self.Bottom < hitbox.Top) and
				(self.Left > hitbox.Right)
			then
				return true
			end
		end
	end
	return false
end

--// INSTRUCTIONS //--

CLASS.__index = CLASS

return CLASS
