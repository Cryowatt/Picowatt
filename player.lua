local point = {}
point.__index = point

function point.new(x, y)
	return setmetatable({ x = x, y = y }, point)
end

function point:__add(p)
	return point.new(self.x + p.x, self.y + p.y)
end

function point:__sub(p)
	return point.new(self.x - p.x, self.y - p.y)
end

function point:__tostring()
	return "{" .. self.x .. ", " .. self.y .. "}"
end

function point:length()
	return sqrt(abs(self.x * self.x + self.y * self.y))
end

local vector = {}
vector.__index = vector
function vector.new(origin, magnitude)
	return setmetatable({ point = origin, magnitude = magnitude }, vector)
end

function vector:__tostring()
	return tostr(self.point) .. "->" .. tostr(self.magnitude)
end

function vector:angle()
	return atan2(self.magnitude.x, self.magnitude.y)
end

local player = {}
player.__index = player
function player.new()
	return setmetatable(
		{
			x = 60,
			y = 60,
			dx = 0,
			dy = 0,
			a_go = 1.0,
			a_stop = 0.5,
			xv_max = 5,
			yv_max = 5,
			height = 8,
			width = 5,
			run_multiple = 1.5,
			freefall = false,
			h_flip = false
		},
		player
	)
end

function player:tl()
	return self.x, self.y
end

function player:tr()
	return self.x + self.width, self.y
end

function player:bl()
	return self.x, self.y + self.height
end

function player:br()
	return self.x + self.width, self.y + self.height
end

function truncate(value, bits)
	return shl(flr(shr(value, bits)), bits)
end

function raycast(v)
	printh("CAST" .. tostr(v))
	-- local length = v.magnitude:length()
	local x = v.point.x
	local y = v.point.y
	local dx = v.magnitude.x
	local dy = v.magnitude.y
	local hhit = v.point + v.magnitude
	local vhit = v.point + v.magnitude
	circ(vhit.x, vhit.y, 1, time() * 30)
	-- distanceH = length
	-- distanceV = length
	local hx = x + dx
	local hy = y + dy
	local vx = x + dx
	local vy = y + dy
	local angle = v:angle()

	local function cast(ray, max_magnitude)
		printh("cast::" .. tostr(ray))
		local x = ray.point.x
		local y = ray.point.y
		local max_length = max_magnitude:length()
		local length = ray.magnitude:length()
		-- printh("cast ray x:" .. ray.point.x .. " y:" .. ray.point.y .. " dx:" .. ray.magnitude.x .. " dy:" .. ray.magnitude.y .. " length:" .. length)
		local dof = 0
		while dof < max_length do
			-- printh("cast iteration" .. dof .. " max_len:" .. max_length)
			pset(x, y, 6)
			if fget(mget(shr(x, 3), shr(y, 3)), tile_flag.solid) then
				-- hx = rx - x
				-- hy = ry - y
				-- distanceH = sqrt(hx * hx + hy * hy)
				-- circfill(x, y, 1, 8)
				-- line(x, y, rx, ry, 9)
				printh("p:" .. x .. "," .. y .. " mp:" .. shr(x, 3) .. "," .. shr(y, 3))
				return point.new(x, y)
			else
				x += ray.magnitude.x
				y += ray.magnitude.y
				-- rx += xo
				-- ry += yo
				dof += length
			end
		end
	end

	--Check Horizontal Lines
	if angle ~= 0.0 and angle ~= 0.5 then
		local atan = -1 / (sin(angle) / cos(angle))

		local function horzontal_check(correction, direction)
			local ry = truncate(y, 3) + correction
			local yo = 8 * direction
			local ray = vector.new(
				point.new((y - ry) * atan + x, ry),
				point.new(-yo * atan, yo)
			)
			-- hhit.y -= sgn(yo)
			local hit = cast(ray, v.magnitude)
			if hit ~= nil then
				hit.y -= direction
				printh("Horizontal HIT!" .. tostr(hit) .. "|" .. hit:length())
				line(hit.x - 4, hit.y, hit.x + 4, hit.y, 9)
				return hit
			end
		end

		if angle < 0.5 then
			-- up
			hhit = horzontal_check(-0.0001, -1) or v.point + v.magnitude
		elseif angle > 0.5 then
			-- down
			hhit = horzontal_check(8, 1) or v.point + v.magnitude
		end
	end

	--Check Vertical Lines
	if angle ~= 0.25 and angle ~= 0.75 then
		local ntan = -sin(angle) / cos(angle)

		local function vertical_check(correction, direction)
			rx = truncate(x, 3) + correction
			xo = 8 * direction
			local ray = vector.new(
				point.new(rx, (x - rx) * ntan + y),
				point.new(xo, -xo * ntan)
			)
			-- hhit.y -= sgn(yo)
			local hit = cast(ray, v.magnitude)
			if hit ~= nil then
				hit.y -= direction
				printh("Horizontal HIT!" .. tostr(hit) .. "|" .. hit:length())
				line(hit.x, hit.y - 4, hit.x, hit.y + 4, 9)
				return hit
			end
		end

		if 0.25 < angle and angle < 0.75 then
			-- left
			vhit = vertical_check(-0.0001, -1) or v.point + v.magnitude
		elseif angle < 0.25 or angle > 0.75 then
			-- right
			vhit = vertical_check(8, 1) or v.point + v.magnitude
		end
	end

	-- Move collision point to playerspace
	local hdv = hhit - v.point
	local vdv = vhit - v.point

	if hdv:length() < vdv:length() then
		dv = hhit - v.point
		return vector.new(hhit, point.new(v.magnitude.x - dv.x, 0))
	else
		dv = vhit - v.point
		return vector.new(vhit, point.new(0, v.magnitude.y - dv.y))
	end

	-- if hhit ~= nil then
	-- 	printh("hhit:" .. tostr(hhit))
	-- 	if vhit ~= nil then
	-- 		-- printh("x:" .. tostr(xhit) .. "|y:" .. tostr(yhit))
	-- 		if (hhit - v.point):length() < (vhit - v.point):length() then
	-- 			printh("Two hits, h is better")
	-- 			hitv = hhit - v.point
	-- 			return vector.new(hhit, point.new(v.magnitude.x - hitv.x, 0))
	-- 		else
	-- 			printh("Two hits, v is better")
	-- 			hitv = vhit - v.point
	-- 			return vector.new(vhit, point.new(0, v.magnitude.y - hitv.y))
	-- 		end
	-- 	else
	-- 		printh("hhit")
	-- 		hitv = hhit - v.point
	-- 		return vector.new(hhit, point.new(v.magnitude.x - hitv.x, 0))
	-- 	end
	-- elseif vhit ~= nil then
	-- 	printh("vhit:" .. tostr(vhit))
	-- 	hitv = vhit - v.point
	-- 	return vector.new(vhit, point.new(0, v.magnitude.y - hitv.y))
	-- end

	-- while dof < distanceV do
	-- 	circ(rx, ry, 1, 9)
	-- 	mx = shr(rx, 3)
	-- 	my = shr(ry, 3)
	-- 	if fget(mget(mx, my), tile_flag.solid) then
	-- 		vx = rx - x
	-- 		vy = ry - y
	-- 		distanceV = sqrt(vx * vx + vy * vy)
	-- 		-- line(x, y, rx, ry, 9)
	-- 		break
	-- 	else
	-- 		rx += xo
	-- 		ry += yo
	-- 		dof += 8
	-- 	end
	-- end

	-- if distanceH < distanceV and distanceH < length then
	-- 	line(x, y, x + hx, y + hy, 9)
	-- 	circfill(x + hx, y + hy, 2, 11)
	-- 	printh("horizontal hit")
	-- 	--Roof or floor, kill y momentum
	-- 	return x + hx, y + hy, dx - hx, 0
	-- elseif distanceV < distanceH and distanceV < length then
	-- 	line(x, y, x + vx, y + vy, 10)
	-- 	circfill(x + vx, y + vy, 2, 11)
	-- 	printh("vertical hit")
	-- 	--Wall, kill x momentum
	-- 	return hx, hy, 0,
	-- 		--dy - hy
	-- 		0
	-- else
	-- 	line(x, y, x + dx, y + dy, 10)
	-- 	circfill(x + dx, y + dy, 2, 11)
	-- 	printh("no hit")
	-- 	return hx, hy, 0, 0
	-- end
end

function player:update()
	-- self.x = 60+sin(time())*8
	-- self.y = 60+cos(time())*8

	--move right
	if btn(0) then
		self.dx = self.dx - self.a_go
	elseif self.dx < 0 then
		-- self.dx = max(self.dx + self.a_stop, 0)
	end

	--move left
	if btn(1) then
		self.dx = self.dx + self.a_go
	elseif self.dx > 0 then
		-- self.dx = min(self.dx + self.a_stop, 0)
	end

	--move right
	if btn(2) then
		self.dy = self.dy - self.a_go
	elseif self.dy < 0 then
		-- self.dy = max(self.dy + self.a_stop, 0)
	end

	--move left
	if btn(3) then
		self.dy = self.dy + self.a_go
	elseif self.dy > 0 then
		-- self.dy = min(self.dy + self.a_stop, 0)
	end

	-- x, y, dx, dy = raycast(table.unpack(self:tl()), self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- for i = 1, 50 do
	local v = vector.new(point.new(self.x, self.y), point.new(self.dx, self.dy))
	while v.magnitude:length() > 0 do
		local x = v.point.x
		local y = v.point.y
		local hit = raycast(v)
		if hit ~= nil then
			line(x, y, hit.point.x, hit.point.y, time() * 60)
			-- line(x, y, hit.magnitude.x, hit.magnitude.y, 13)
			-- line(hit.point.x, hit.point.y, hit.point.x + hit.magnitude.x, hit.point.y + hit.magnitude.y, 11)
			-- line(hit.point.x, hit.point.y, hit.point.x + hit.magnitude.x, hit.point.y + hit.magnitude.y, 11)
			-- more momentum to burn, maybe
			v = hit
		else
			break
		end
	end
	-- end

	if hit ~= nil then
		-- hit = hit.point
		printh("HiT?" .. tostr(hit))
		-- line(self.x, self.y, hit.point.x, hit.point.y, 12)
		-- pset(hit.x, hit.y, 11)
		-- circ(hit.x, hit.y, 3, 3)
	end
end

function player:draw()
	spr(2, self.x, self.y, 1, 1, self.h_flip)
	circ(self.x + self.dx, self.y + self.dy, 2, 14)
	-- spr(2, self.x + self.dx, self.y + self.dy, 1, 1, self.h_flip)
end