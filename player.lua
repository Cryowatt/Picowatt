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
			dx = 24,
			dy = -48,
			a_go = 1.0,
			a_stop = 0.5,
			xv_max = 5,
			yv_max = 5,
			height = 8,
			width = 8,
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
	printh(size.x)
	rect(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, time() * 60)
	local h_hit
	local v_hit
	local angle = v:angle()
	--Check Horizontal Lines
	if angle ~= 0.0 and angle ~= 0.5 then
		local atan = -1 / (sin(angle) / cos(angle))

		if angle < 0.5 then
			-- up
			local ry = truncate(v.point.y, 3) - 1
			local yo = -8
			local ray = vector.new(
				point.new((v.point.y - ry) * atan + v.point.x, ry),
				point.new(-yo * atan, yo)
			)

			-- rect(ray.point.x, ray.point.y, ray.point.x + size.x, ray.point.y + size.y, 6)
			local fk = v.magnitude - (ray.point - v.point)
			line(ray.point.x, ray.point.y, ray.point.x + fk.x, ray.point.y + fk.y, 12)
			local d = (ray.point - v.point):length()
			h_hit = castbeam(ray, point.new(size.x, 0), d, v.magnitude:length() - d)
		elseif angle > 0.5 then
			-- down
			local ry = truncate(v.point.y + size.y, 3) + 8
			local yo = 8
			local ray = vector.new(
				point.new((v.point.y + size.y - ry) * atan + v.point.x, ry),
				point.new(-yo * atan, yo)
			)

			-- rect(ray.point.x, ray.point.y, ray.point.x + size.x, ray.point.y + size.y, 6)
			local fk = v.magnitude - (ray.point - v.point)
			-- line(ray.point.x, ray.point.y, ray.point.x + fk.x, ray.point.y + fk.y, 12)
			-- h_hit = castbeam(ray, point.new(size.x, 0), (v.magnitude - (ray.point - v.point)):length())
		end
	end

	--Check Vertical Lines
	if angle ~= 0.25 and angle ~= 0.75 then
		local ntan = -sin(angle) / cos(angle)

		if 0.25 < angle and angle < 0.75 then
			-- left
			printh("v-left")
			local rx = truncate(v.point.x, 3) - 1
			local xo = -8
			local ray = vector.new(
				point.new(rx, (v.point.x - rx) * ntan + v.point.y),
				point.new(xo, -xo * ntan)
			)

			-- rect(v.point.x + size.x, ray.point.y, ray.point.x, ray.point.y + size.y, 6)
			local fk = v.magnitude - (ray.point - v.point)
			-- line(ray.point.x, ray.point.y, ray.point.x + fk.x, ray.point.y + fk.y, 12)
			-- v_hit = castbeam(ray, point.new(0, size.y), (v.magnitude - (ray.point - v.point)):length())
		elseif angle < 0.25 or angle > 0.75 then
			-- right
			printh("v-right")
			local rx = truncate(v.point.x + size.x, 3) + 8
			local xo = 8
			local ray = vector.new(
				point.new(rx, (v.point.x + size.x - rx) * ntan + v.point.y),
				point.new(xo, -xo * ntan)
			)

			-- rect(v.point.x + size.x, ray.point.y, ray.point.x, ray.point.y + size.y, 6)
			local fk = v.magnitude - (ray.point - v.point)
			-- line(ray.point.x, ray.point.y, ray.point.x + fk.x, ray.point.y + fk.y, 12)
			-- v_hit = castbeam(ray, point.new(0, size.y), (v.magnitude - (ray.point - v.point)):length())
		end
	end
end

function notsolid(p)
	return not fget(mget(flr(shr(p.x, 3)), flr(shr(p.y, 3))), tile_flag.solid)
end

function castbeam(v, size, d, max_d)
	line(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, 6)
	-- local d = 0
	for i = d, max_d, v.magnitude:length() do
		-- while d < max_d do
		local next = v.point + v.magnitude
		-- d += v.magnitude:length()

		if notsolid(next) and notsolid(next + size) then
			v.point = next
			line(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, 6)
		end
	end

	line(v.point.x, v.point.y, v.point.x + size.x, v.point.y + size.y, 11)
	return v.point
end

function raycast(v)
	local x = v.point.x
	local y = v.point.y
	local hhit
	local vhit
	local hlength
	local vlength
	local angle = v:angle()

	local function cast(ray, map_offset, max_magnitude)
		local p = point.new(ray.point.x, ray.point.y)
		local dof = 0
		while dof < max_magnitude:length() do
			if fget(mget(flr(shr(p.x + map_offset.x, 3)), flr(shr(p.y + map_offset.y, 3))), tile_flag.solid) then
				return p
			else
				p += ray.magnitude
				dof += ray.magnitude:length()
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
			local hit = cast(ray, point.new(0, 0), v.magnitude)
			if hit ~= nil then
				local length = (v.point - hit):length()
				hit.y -= direction
				line(hit.x - 4, hit.y, hit.x + 4, hit.y, 11)
				return hit, length
			end
		end

		if angle < 0.5 then
			-- up
			hhit, hlength = horzontal_check(-0.5, -1) -- or v.point + v.magnitude, v.magnitude:length()
		elseif angle > 0.5 then
			-- down
			hhit, hlength = horzontal_check(8, 1) -- or v.point + v.magnitude, v.magnitude:length()
		end
	end
	if hhit == nil then
		hhit = v.point + v.magnitude
		hlength = v.magnitude:length()
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
			local hit = cast(ray, point.new(0, 0), v.magnitude)
			if hit ~= nil then
				-- hit.x = flr(hit.x - direction)
				local length = (v.point - hit):length()
				hit.x -= direction
				line(hit.x, hit.y - 4, hit.x, hit.y + 4, 12)
				return hit, length
			end
		end

		if 0.25 < angle and angle < 0.75 then
			-- left
			vhit, vlength = vertical_check(-0.5, -1) -- or v.point + v.magnitude, v.magnitude:length()
		elseif angle < 0.25 or angle > 0.75 then
			-- right
			vhit, vlength = vertical_check(8, 1) -- or v.point + v.magnitude, v.magnitude:length()
		end
	end

	if vhit == nil then
		vhit = v.point + v.magnitude
		vlength = v.magnitude:length()
	end

	-- Move collision point to playerspace
	-- local hdv = hhit - v.point
	-- local vdv = vhit - v.point

	if (hlength or 0x7fff.ffff) < (vlength or 0x7fff.ffff) then
		dv = hhit - v.point
		return vector.new(hhit, point.new(v.magnitude.x - dv.x, 0))
	else
		dv = vhit - v.point
		return vector.new(vhit, point.new(0, v.magnitude.y - dv.y))
	end
end

function player:update()
	-- self.width = (sin(time()) + 1) * 4
	-- self.height = (sin(time() + 0.25) + 1) * 4
	local function dir_input(bid, v, a, f)
		if btn(bid) then
			return v + a
			-- elseif v != 0 then
			-- 	return v
			-- 	-- return max(p - v, 0)
		else
			return v
		end
	end

	self.dx = dir_input(0, self.dx, -self.a_go, self.a_stop)
	self.dx = dir_input(1, self.dx, self.a_go, -self.a_stop)
	self.dy = dir_input(2, self.dy, -self.a_go, self.a_stop)
	self.dy = dir_input(3, self.dy, self.a_go, -self.a_stop)

	-- x, y, dx, dy = raycast(table.unpack(self:tl()), self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	-- for i = 1, 50 do
	-- local corners = { self:tl(), self:tr(), self:bl(), self:br() }
	local p = point.new(self.x, self.y)
	local v = point.new(self.dx, self.dy)

	line(p.x, p.y, (p + v).x, (p + v).y, time() * 60)
	line(p.x, p.y + self.height, (p + v).x, (p + v).y + self.height, time() * 60)
	line(p.x + self.width, p.y, (p + v).x + self.width, (p + v).y, time() * 60)
	line(p.x + self.width, p.y + self.height, (p + v).x + self.width, (p + v).y + self.height, time() * 60)

	movequad(vector.new(p, v), point.new(self.width, self.height))

	-- Debug abort
	if true then return end

	local corners = { point.new(0, 0), point.new(self.width, 0), point.new(0, self.height), point.new(self.width, self.height) }
	while v:length() > 3 do
		-- line(p.x, p.y, p.x + v.x, p.y + v.y, time() * 60)
		local min_l = v:length()
		local best_hit = vector.new(p + v, point.new(0, 0))
		-- local r = vector.new(corners[0], v)
		for i = 1, #corners do
			local x = p.x + corners[i].x
			local y = p.y + corners[i].y
			local hit = raycast(vector.new(p + corners[i], v))
			if hit != nil then
				-- local dp = p -hit.point - corners[i]
				local hit_length = (hit.point - p - corners[i]):length()
				if min_l > hit_length then
					min_l = hit_length
					best_hit = hit
					best_hit.point -= corners[i]
					-- line(p.x + corners[i].x, p.y + corners[i].y, best_hit.point.x + corners[i].x, best_hit.point.y + corners[i].y, i * 4 + time() * 60)
					-- r = vector.new(corners[i], v)
					printh("NEW BEST" .. tostr(best_hit))
				end
			end
		end

		spr(2, best_hit.point.x, best_hit.point.y, 1, 1, self.h_flip)
		p = best_hit.point
		v = best_hit.magnitude
		printh("ENDPOINT" .. tostr(p))
		printh("ENDVEL" .. tostr(v))
	end

	-- v = v -
	-- p = ep

	-- Where did I end up?

	-- Debug abort
	if true then return end

	local v = vector.new(point.new(self:tl()), point.new(self.dx, self.dy))
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
			break
		else
			break
		end
	end
	-- end

	if hit ~= nil then
		printh("HiT?" .. tostr(hit))
	end
end

function player:draw()
	-- spr(2, self.x, self.y, 1, 1, self.h_flip)
	circ(self.x + self.dx, self.y + self.dy, 2, 14)
end