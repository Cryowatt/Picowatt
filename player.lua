player = {
	x = 59.2113,
	y = 68.934221,
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
}

function player:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function raycast(x, y, dx, dy)
	length = sqrt(dx * dx + dy * dy)
	distanceH = length
	distanceV = length
	hx = x + dx
	hy = y + dy
	vx = x + dx
	vy = y + dy
	angle = atan2(dx, dy)
	--Check Horizontal Lines
	dof = 0
	atan = -1 / (sin(angle) / cos(angle))
	if angle < 0.5 then
		ry = shl(flr(shr(y, 3)), 3) - 0.0001
		rx = (y - ry) * atan + x
		yo = -8
		xo = -yo * atan
	elseif angle > 0.5 then
		ry = shl(flr(shr(y, 3)), 3) + 8
		rx = (y - ry) * atan + x
		yo = 8
		xo = -yo * atan
	else
		rx = x
		ry = y
		dof = 8
	end

	while dof < distanceH do
		circ(rx, ry, 1, 8)
		mx = shr(rx, 3)
		my = shr(ry, 3)
		if fget(mget(mx, my), tile_flag.solid) then
			hx = rx - x
			hy = ry - y
			distanceH = sqrt(hx * hx + hy * hy)
			circ(rx, ry, 2, 8)
			-- line(x, y, rx, ry, 9)
			break
		else
			rx += xo
			ry += yo
			dof += 8
		end
	end

	--Check Vertical Lines
	dof = 0
	ntan = -sin(angle) / cos(angle)
	if 0.25 < angle and angle < 0.75 then
		rx = shl(flr(shr(x, 3)), 3) - 0.0001
		ry = (x - rx) * ntan + y
		xo = -8
		yo = -xo * ntan
	elseif angle < 0.25 or angle > 0.75 then
		rx = shl(flr(shr(x, 3)), 3) + 8
		ry = (x - rx) * ntan + y
		xo = 8
		yo = -xo * ntan
	else
		rx = x
		ry = y
		dof = 8
	end

	while dof < distanceV do
		circ(rx, ry, 1, 9)
		mx = shr(rx, 3)
		my = shr(ry, 3)
		if fget(mget(mx, my), tile_flag.solid) then
			vx = rx - x
			vy = ry - y
			distanceV = sqrt(vx * vx + vy * vy)
			-- line(x, y, rx, ry, 9)
			break
		else
			rx += xo
			ry += yo
			dof += 8
		end
	end

	if distanceH < distanceV and distanceH < length then
		line(x, y, x + hx, y + hy, 9)
		circfill(x + hx, y + hy, 2, 11)
		printh("horizontal hit")
		--Roof or floor, kill y momentum
		return x + hx, y + hy, dx - hx, 0
	elseif distanceV < distanceH and distanceV < length then
		line(x, y, x + vx, y + vy, 10)
		circfill(x + vx, y + vy, 2, 11)
		printh("vertical hit")
		--Wall, kill x momentum
		return hx, hy, 0,
			--dy - hy
			0
	else
		line(x, y, x + dx, y + dy, 10)
		circfill(x + dx, y + dy, 2, 11)
		printh("no hit")
		return hx, hy, 0, 0
	end
end

function collide(x, y, dx, dy)
	circfill(x, y, 1, 11)
	--determine velocity vector direction
	angle = atan2(dx, dy)
	if dx != 0 or dy != 0 then
		printh("dx:" .. dx)

		if angle <= 0.125 or 0.375 < angle and angle <= 0.625 or 0.875 < angle then
			step = abs(dx) / 8
		else
			step = abs(dy) / 8
		end
		dx = dx / step
		dy = dy / step
		-- if angle < 0.125 or angle >= 0.875 then
		-- 	-- offsetx = (self.x % 8) - dx
		-- 	-- offsety = (dy / 8) * offsetx
		-- elseif angle < 0.375 then
		-- 	step = abs(self.dy) / 8
		-- 	dx = self.dx / step
		-- 	dy = self.dy / step
		-- 	-- offsety = (self.y % 8)
		-- 	-- offsetx = -(dx / 8) * offsety
		-- elseif angle < 0.625 then
		-- 	step = abs(self.dx) / 8
		-- 	dx = self.dx / step
		-- 	dy = self.dy / step
		-- 	-- offsetx = (self.x % 8)
		-- 	-- offsety = -(dy / 8) * offsetx
		-- else
		-- 	step = abs(self.dy) / 8
		-- 	dx = self.dx / step
		-- 	dy = self.dy / step
		-- 	-- offsety = (self.y % 8) - dy
		-- 	-- offsetx = (dx / 8) * offsety
		-- end

		-- printh("angle" .. angle .. " x:" .. self.x .. " y:" .. self.y--.." offsetx"..offsetx.." y"..offsety))

		-- line(self.x, self.y, self.x - offsetx, self.y - offsety,14)
		-- x = self.x -- offsetx
		-- y = self.y -- offsety
		i = 0

		while i <= step do
			printh("x" .. x .. " y" .. y)
			if fget(mget(x / 8, y / 8), tile_flag.solid) then
				circfill(x, y, 4, 8)
				-- self.x +=
				break
			else
				circ(x, y, 2, 7)
			end
			-- putpixel(x, y, 5)
			line(x, y, x + dx, y + dy, 2)
			x = x + dx
			y = y + dy
			i = i + 1
		end

		-- self.x = x
		-- self.y = y
	end
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

	angle = atan2(self.dx, self.dy)
	length = sqrt(self.dx * self.dx + self.dy * self.dy)
	printh(self.x)
	printh(self.y)
	x, y, dx, dy = raycast(self.x, self.y, self.dx, self.dy)
	printh(x)
	printh(y)
	printh(dx)
	printh(dy)
	-- self.x = x
	-- self.y = y
	-- self.dx = dx
	-- self.dy = dy

	-- collide(self.x, self.y, self.dx, self.dy)
	-- collide(self.x, self.y + self.height, self.dx, self.dy)
	-- collide(self.x + self.width, self.y, self.dx, self.dy)
	-- collide(self.x + self.width, self.y + self.height, self.dx, self.dy)

	-- circfill(self.x, self.y, 1, 11)
	-- --determine velocity vector direction
	-- angle = atan2(self.dx, self.dy)
	-- -- tx = ceil(self.x)
	-- -- ty = floor(self.y)
	-- -- step =

	-- -- if abs(self.dx) >= abs(self.dy) then
	-- -- 	step = abs(self.dx)/8
	-- -- 	dx = self.dx / step
	-- -- 	dy = self.dy / step
	-- -- 	offsetx = (self.x % 8)
	-- -- 	offsety = dy / 8 * offsetx
	-- -- else
	-- -- 	step = abs(self.dy)/8
	-- -- 	dx = self.dx / step
	-- -- 	dy = self.dy / step
	-- -- 	offsety = (self.y % 8)
	-- -- 	offsetx =  dx / 8 * offsety
	-- -- end
	-- if self.dx != 0 or self.dy != 0 then
	-- 	printh("dx:" .. self.dx)
	-- 	if angle < 0.125 or angle >= 0.875 then
	-- 		step = abs(self.dx) / 8
	-- 		dx = self.dx / step
	-- 		dy = self.dy / step
	-- 		-- offsetx = (self.x % 8) - dx
	-- 		-- offsety = (dy / 8) * offsetx
	-- 	elseif angle < 0.375 then
	-- 		step = abs(self.dy) / 8
	-- 		dx = self.dx / step
	-- 		dy = self.dy / step
	-- 		-- offsety = (self.y % 8)
	-- 		-- offsetx = -(dx / 8) * offsety
	-- 	elseif angle < 0.625 then
	-- 		step = abs(self.dx) / 8
	-- 		dx = self.dx / step
	-- 		dy = self.dy / step
	-- 		-- offsetx = (self.x % 8)
	-- 		-- offsety = -(dy / 8) * offsetx
	-- 	else
	-- 		step = abs(self.dy) / 8
	-- 		dx = self.dx / step
	-- 		dy = self.dy / step
	-- 		-- offsety = (self.y % 8) - dy
	-- 		-- offsetx = (dx / 8) * offsety
	-- 	end

	-- 	-- printh("angle" .. angle .. " x:" .. self.x .. " y:" .. self.y--.." offsetx"..offsetx.." y"..offsety))

	-- 	-- line(self.x, self.y, self.x - offsetx, self.y - offsety,14)
	-- 	x = self.x -- offsetx
	-- 	y = self.y -- offsety
	-- 	i = 0

	-- 	while i <= step do
	-- 		printh("x" .. x .. " y" .. y)
	-- 		if fget(mget(x / 8, y / 8), tile_flag.solid) then
	-- 			circfill(x, y, 4, 8)
	-- 			-- self.x +=
	-- 			break
	-- 		else
	-- 			circ(x, y, 2, 7)
	-- 		end
	-- 		-- putpixel(x, y, 5)
	-- 		line(x, y, x + dx, y + dy, 2)
	-- 		x = x + dx
	-- 		y = y + dy
	-- 		i = i + 1
	-- 	end

	-- 	-- self.x = x
	-- 	-- self.y = y
	-- end

	-- elseif angle < 0.5 then
	-- elseif angle < 0.75 then
	-- else
	-- end

	--collisions
	-- if self.dx != 0 then
	--     -- if abs(self.dx) > abs(self.dy) then
	--         --step horizontal
	--     step = sgn(self.dx) * self.width
	--     start = self.dx % self.width
	--     printh("for "..start..", "..self.dx..", "..step)
	--     for ix=start, self.dx, step do
	--         iy = self.dy * ix / self.dx
	--         printh("check"..(self.x+ix))
	--         if fget(mget((self.x + ix) / 8, (self.y + iy) / 8), tile_flag.solid) then
	--             if sgn(self.dx) > 0 then
	--                 printh("right collide")
	--                 self.x = (ceil((self.x + ix) / 8) * 8)-self.width
	--                 printh("right collide "..self.x)
	--             else
	--                 printh("left collide "..((self.x + ix) / 8))
	--                 self.x = ((flr((self.x + ix) / 8) + 1) * 8)
	--             end
	--             -- printh("OUCH! "..self.x)
	--             self.dx = 0
	--             break
	--         end
	--     end
	-- end

	-- if self.dx != 0 and fget(mget((self.x + self.dx) / 8, (self.y + self.dy) / 8), tile_flag.solid) then
	--     if sgn(self.dx) > 0 then
	--         printh("right collide2")
	--         self.x = (ceil((self.x + self.dx) / 8) * 8)-self.width-1
	--     else
	--         printh("left collide2 "..ceil((self.x + self.dx) / 8))
	--         self.x = ((flr((self.x + self.dx) / 8) + 1) * 8)
	--     end
	--     -- printh("OUCH!! "..self.x)
	--     self.dx = 0
	-- end
	-- else
	--     --step vertical
	--     -- for iy=self.y,self.y+self.dy,8 do
	--     -- end
	-- end

	if self.dx < 0 then
		-- printh("velocity:"..self.dx)
	end
	-- self.x += self.dx
	-- self.y += self.dy
	-- printh("OUCH?? "..self.x)

	-- if self.dx < 0 then
	--     self.x = mid(0, self.x + mid(-self.dx_max, self.dx, self.dx_max), 127)
	-- else
	--     self.x = mid(0, self.x + mid(-self.dx_max, self.dx, self.dx_max), 127)
	-- end

	-- if self.dy < 0 then
	--     self.y = mid(0, self.y + mid(-self.dy_max, self.dy, self.dy_max), 127)
	-- else
	--     self.y = mid(0, self.y + mid(-self.dy_max, self.dy, self.dy_max), 127)
	-- end

	-- --gravity
	-- 	self.dy = min(self.dy + g, self.v_max * 4)
	-- 	self.y += self.dy
	-- --check ceiling
	-- if is_solid(self.x, self.y-self.height) then
	-- 	self.y = shl(ceil(map_y), 3)+self.height
	-- 	self.dy = 0
	-- end
	-- --check floor
	-- if is_solid(self.x, self.y+1) or is_solid(self.x + self.width, self.y+1) then
	-- 	self.y = shl(flr(map_y), 3)
	-- 	self.dy = 0
	-- 	if self.freefall then
	-- 		self.freefall=false
	-- 		sfx(0)
	-- 	end
	-- 	--jump
	-- 	if btn(2) then
	-- 		self.dy = -4
	-- 		sfx(1)
	-- 	end
	-- else
	-- 	floor=false
	-- 	self.freefall=true
	-- end

	-- --collision
	-- if self.dx > 0 then
	-- 	self.h_flip=false
	-- 	self.x += ceil(self.dx)
	-- 	if is_solid(self.x+self.width, self.y-1) or is_solid(self.x+self.width, self.y-self.height) then
	-- 		self.x	= shl(flr(map_x), 3) - self.width - 1
	-- 	end
	-- elseif self.dx < 0 then
	-- 	self.h_flip=true
	-- 	self.x += flr(self.dx)
	-- 	if is_solid(self.x-1, self.y-1) or is_solid(self.x-1, self.y-self.height) then
	-- 		self.x	= shl(ceil(map_x), 3)
	-- 	end
	-- end

	-- self.x = band(self.x, 127)
	-- self.y = band(self.y, 127)
end

function player:draw()
	spr(2, self.x, self.y, 1, 1, self.h_flip)
	spr(2, self.x + self.dx, self.y + self.dy, 1, 1, self.h_flip)
	-- line(self.x, self.y, self.x+self.dx, self.y+self.dy, 3)
	-- line(self.x+self.width, self.y, self.x+self.width+self.dx, self.y+self.dy, 4)
	-- line(self.x, self.y+self.height, self.x+self.dx, self.y+self.dy+self.height, 5)
	-- line(self.x+self.width, self.y+self.height, self.x+self.dx+self.width, self.y+self.dy+self.height, 6)
	pset(self.x, self.y, 3)
	--	pset(self.x + self.width, self.y, 3)
end