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

function raycast(v)
	printh("CAST" .. tostr(v))
	-- local length = v.magnitude:length()
	local x = v.point.x
	local y = v.point.y
	local dx = v.magnitude.x
	local dy = v.magnitude.y
	local hhit
	local vhit
	local hlength
	local vlength
	-- circ(vhit.x, vhit.y, 1, time() * 30)
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
				-- printh("p:" .. x .. "," .. y .. " mp:" .. shr(x, 3) .. "," .. shr(y, 3))
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
				-- hit.y = flr(hit.y - direction)
				hit.y = hit.y - direction
				local length = (v.point - hit):length()
				printh("Horizontal HIT!" .. tostr(hit) .. "|" .. length .. " post-correct " .. hit:length())
				line(hit.x - 4, hit.y, hit.x + 4, hit.y, 11)
				return hit, length
			end
		end

		if angle < 0.5 then
			-- up
			hhit, hlength = horzontal_check(-0.0001, -1) -- or v.point + v.magnitude, v.magnitude:length()
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
			local hit = cast(ray, v.magnitude)
			if hit ~= nil then
				-- hit.x = flr(hit.x - direction)
				hit.x = hit.x - direction
				local length = (v.point - hit):length()
				printh("Vertical HIT!" .. tostr(hit) .. "|" .. length .. " post-correct " .. hit:length())
				line(hit.x, hit.y - 4, hit.x, hit.y + 4, 12)
				return hit, length
			end
		end

		if 0.25 < angle and angle < 0.75 then
			-- left
			vhit, vlength = vertical_check(-0.0001, -1) -- or v.point + v.magnitude, v.magnitude:length()
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

	printh("len check:" .. tostr(hlength) .. "|" .. tostr(vlength) .. "vmag:" .. v.magnitude:length())
	if (hlength or 0x7fff.ffff) < (vlength or 0x7fff.ffff) then
		dv = hhit - v.point
		return vector.new(hhit, point.new(v.magnitude.x - dv.x, 0))
	else
		dv = vhit - v.point
		return vector.new(vhit, point.new(0, v.magnitude.y - dv.y))
	end
end

function player:update()
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
	local corners = { point.new(0, 0) }
	--, point.new(self.width, 0), point.new(0, self.height), point.new(self.width, self.height) }
	-- local corners = { self:tl(), self:tr(), self:bl(), self:br() }
	local p = point.new(self.x, self.y)
	local v = point.new(self.dx, self.dy)
	local min_l = v:length()
	local ep = point.new(self.x + self.dx, self.y + self.dy)
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
				ep = hit.point - corners[i]
				line(x, y, hit.point.x, hit.point.y, i * 4 + time() * 60)
				-- r = vector.new(corners[i], v)
				printh("NEW BEST" .. tostr(ep))
			end
		end
	end

	-- Where did I end up?
	spr(2, ep.x, ep.y, 1, 1, self.h_flip)

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