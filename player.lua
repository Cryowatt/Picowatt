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
			x = 64,
			y = 64,
			dx = 0,
			dy = -5,
			a_go = 0.5,
			a_stop = 0.25,
			xv_max = 2,
			yv_max = 5,
			height = 5,
			width = 5,
			run_multiple = 1.5,
			freefall = false,
			h_flip = false
		},
		player
	)
end

function player:tl()
	return point.new(self.x, self.y)
end

function player:tr()
	return point.new(self.x + self.width, self.y)
end

function player:bl()
	return point.new(self.x, self.y + self.height)
end

function player:br()
	return point.new(self.x + self.width, self.y + self.height)
end

function truncate(value, bits)
	return shl(flr(shr(value, bits)), bits)
end

function movequad(v, size)
	rect(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, time() * 60)
	local angle = v:angle()
	local best_hit = vector.new(v.point + v.magnitude, point.new(0, 0))
	local best_impulse = point.new(0, 0)
	local best_distance = v.magnitude:length()

	printh("dir:" .. tostr(v.magnitude) .. "|" .. v.magnitude:length())

	--Check Horizontal Lines
	if angle ~= 0.0 and angle ~= 0.5 then
		local atan = -1 / (sin(angle) / cos(angle))
		local ray

		if angle < 0.5 then
			-- up
			local ry = truncate(v.point.y, 3) - 1
			line(0, ry, 128, ry, time() * 15)
			local yo = -8
			ray = vector.new(
				point.new((v.point.y - ry) * atan + v.point.x, ry),
				point.new(-yo * atan, yo)
			)
		elseif angle > 0.5 then
			-- down
			local ry = truncate(v.point.y + size.y, 3) + 8
			local yo = 8
			ray = vector.new(
				point.new((v.point.y + size.y - ry) * atan + v.point.x, ry),
				point.new(-yo * atan, yo)
			)
		end

		local d = (ray.point - v.point):length()
		local hit = castbeam(ray, point.new(size.x, 0), d, v.magnitude:length())
		if hit ~= nil then
			if v.magnitude.y >= 0 then
				hit.y -= size.y
			end
			local hit_direction = hit - v.point
			rectfill(hit.x, hit.y, hit.x + size.x, hit.y + size.y, 8)
			local hit_v = vector.new(
				hit,
				point.new(v.magnitude.x - hit_direction.x, 0)
			)
			printh("hdir:" .. tostr(hit_direction) .. "|" .. hit_direction:length())

			if hit_direction:length() <= best_distance then
				best_hit = hit_v
				best_impulse = v.magnitude - hit_v.magnitude
				best_distance = hit_direction:length()
			end
		end
	end

	--Check Vertical Lines
	if angle ~= 0.25 and angle ~= 0.75 then
		local ntan = -sin(angle) / cos(angle)
		local ray

		if 0.25 < angle and angle < 0.75 then
			-- left
			local rx = truncate(v.point.x, 3) - 1
			local xo = -8
			ray = vector.new(
				point.new(rx, (v.point.x - rx) * ntan + v.point.y),
				point.new(xo, -xo * ntan)
			)
		elseif angle < 0.25 or angle > 0.75 then
			-- right
			local rx = truncate(v.point.x + size.x, 3) + 8
			line(rx, 0, rx, 128, time() * 15)
			local xo = 8
			ray = vector.new(
				point.new(rx, (v.point.x + size.x - rx) * ntan + v.point.y),
				point.new(xo, -xo * ntan)
			)
		end

		local d = (ray.point - v.point):length()
		local hit = castbeam(ray, point.new(0, size.y), d, v.magnitude:length())
		if hit ~= nil then
			if v.magnitude.x >= 0 then
				hit.x -= size.x
			end
			local hit_direction = hit - v.point
			rectfill(hit.x, hit.y, hit.x + size.x, hit.y + size.y, 9)
			local hit_v = vector.new(
				hit,
				point.new(0, v.magnitude.y - hit_direction.y)
			)
			printh("vdir:" .. tostr(hit_direction) .. "|" .. hit_direction:length())

			if hit_direction:length() <= best_distance then
				best_hit = hit_v
				best_impulse = v.magnitude - hit_v.magnitude
				best_distance = hit_direction:length()
			end
		end
	end

	printh("impulse: " .. tostr(best_impulse))
	return best_hit, best_impulse
end

function notsolid(p)
	return not fget(mget(flr(shr(p.x, 3)), flr(shr(p.y, 3))), tile_flag.solid)
end

function castbeam(v, size, d, max_d)
	for i = 0, max_d, v.magnitude:length() do
		if notsolid(v.point) and notsolid(v.point + size) then
			v.point += v.magnitude
			line(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, 6)
		else
			-- Do wall backoff here
			v.point.x -= v.magnitude.x / 8
			v.point.y -= v.magnitude.y / 8
			line(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, 11)
			return v.point
		end
	end
end

function player:update()
	-- self.dx = sin(time() / 30) * 8
	-- self.width = (sin(time()) + 1) * 4
	-- self.height = (sin(time() + 0.25) + 1) * 4
	local function dir_input(bid_minus, bid_plus, v, a, f)
		if btn(bid_minus) then
			v -= a
		elseif v < 0 then
			v = min(v + f, 0)
		end

		if btn(bid_plus) then
			v += a
		elseif v > 0 then
			v = max(v - f, 0)
		end

		return v
	end

	self.dx = dir_input(0, 1, self.dx, self.a_go, self.a_stop)
	if btn(2) then
		if not notsolid(point.new(self.x, self.y + self.height + 1)) or not notsolid(point.new(self.x + self.width, self.y + self.height + 1)) then
			self.dy = -16
		end
	end
	-- self.dy = dir_input(2, 3, self.dy, self.a_go, 0)
	-- gravity
	self.dy += 0.5

	self.dx = mid(-self.xv_max, self.dx, self.xv_max)
	self.dy = mid(-self.yv_max, self.dy, self.yv_max)

	-- self.dx = dir_input(1, self.dx, self.a_go, -self.a_stop)
	-- self.dy = dir_input(2, self.dy, -self.a_go, self.a_stop)
	-- self.dy = dir_input(3, self.dy, self.a_go, -self.a_stop)

	-- x, y, dx, dy = raycast(table.unpack(self:tl()), self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- for i = 1, 50 do
	-- local corners = { self:tl(), self:tr(), self:bl(), self:br() }
	local p = point.new(self.x, self.y)
	local v = point.new(self.dx, self.dy)

	line(p.x, p.y, (p + v).x, (p + v).y, time() * 12.1)
	line(p.x, p.y + self.height, (p + v).x, (p + v).y + self.height, time() * 11.9)
	line(p.x + self.width, p.y, (p + v).x + self.width, (p + v).y, time() * 12)
	line(p.x + self.width, p.y + self.height, (p + v).x + self.width, (p + v).y + self.height, time() * 12.2)

	if v:length() > 0.001 then
		local physics_vector = vector.new(p, v)
		local size = point.new(self.width, self.height)
		local impulse
		repeat
			printh("x:" .. physics_vector.point.x .. " y:" .. physics_vector.point.x)
			physics_vector, impulse = movequad(physics_vector, size)
			rect(physics_vector.point.x, physics_vector.point.y, physics_vector.point.x + self.width, physics_vector.point.y + self.height, time() * 60)
			printh(physics_vector.magnitude)
			-- break
		until physics_vector.magnitude:length() < 1

		self.x = flr(physics_vector.point.x)
		self.y = flr(physics_vector.point.y)

		self.dx -= impulse.x
		self.dy -= impulse.y
	else
		self.dx = 0
		self.dy = 0
		self.x = flr(self.x)
		self.y = flr(self.y)
	end
end

function player:draw()
	spr(2, self.x, self.y, 1, 1, self.h_flip)
	circ(self.x + self.dx, self.y + self.dy, 2, 14)
end