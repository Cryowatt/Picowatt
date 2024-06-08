
player={
	x=16,
	y=16,
	xv=0,
    yv=0,
	a_go=1.0,
	a_stop=0.5,
	xv_max=5,
	yv_max=5,
	height=8,
	width=8,
	run_multiple=1.5,
	freefall=false,
	h_flip=false,
}

function player:new()
    o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function player:update()
	--move right
	if	btn(0) then 
		self.xv = self.xv - self.a_go
	elseif self.xv < 0 then
		self.xv = max(self.xv + self.a_stop, 0)
	end
	
	--move left
	if	btn(1) then 
		self.xv = self.xv + self.a_go
	elseif self.xv > 0 then
		self.xv = min(self.xv + self.a_stop, 0)
	end

	--move right
	if	btn(2) then 
		self.yv = self.yv - self.a_go
	elseif self.yv < 0 then
		self.yv = max(self.yv + self.a_stop, 0)
	end
	
	--move left
	if	btn(3) then 
		self.yv = self.yv + self.a_go
	elseif self.yv > 0 then
		self.yv = min(self.yv + self.a_stop, 0)
	end

    --collisions
    if self.xv != 0 then
        -- if abs(self.xv) > abs(self.yv) then
            --step horizontal
        step = sgn(self.xv) * self.width
        start = self.xv % self.width
        printh("for "..start..", "..self.xv..", "..step)
        for ix=start, self.xv, step do
            iy = self.yv * ix / self.xv
            printh("check"..(self.x+ix))
            if fget(mget((self.x + ix) / 8, (self.y + iy) / 8), tile_flag.solid) then
                if sgn(self.xv) > 0 then
                    printh("right collide")
                    self.x = (ceil((self.x + ix) / 8) * 8)-self.width
                    printh("right collide "..self.x)
                else
                    printh("left collide "..((self.x + ix) / 8))
                    self.x = ((flr((self.x + ix) / 8) + 1) * 8)
                end
                -- printh("OUCH! "..self.x)
                self.xv = 0
                break
            end
        end
    end

    -- if self.xv != 0 and fget(mget((self.x + self.xv) / 8, (self.y + self.yv) / 8), tile_flag.solid) then 
    --     if sgn(self.xv) > 0 then
    --         printh("right collide2")
    --         self.x = (ceil((self.x + self.xv) / 8) * 8)-self.width-1
    --     else
    --         printh("left collide2 "..ceil((self.x + self.xv) / 8))
    --         self.x = ((flr((self.x + self.xv) / 8) + 1) * 8)
    --     end
    --     -- printh("OUCH!! "..self.x)
    --     self.xv = 0
    -- end
    -- else
    --     --step vertical
    --     -- for iy=self.y,self.y+self.yv,8 do
    --     -- end
    -- end

    if self.xv < 0 then
        -- printh("velocity:"..self.xv)
    end
    self.x += self.xv
    -- printh("OUCH?? "..self.x)



    -- if self.xv < 0 then
    --     self.x = mid(0, self.x + mid(-self.xv_max, self.xv, self.xv_max), 127)
    -- else
    --     self.x = mid(0, self.x + mid(-self.xv_max, self.xv, self.xv_max), 127)
    -- end

    -- if self.yv < 0 then
    --     self.y = mid(0, self.y + mid(-self.yv_max, self.yv, self.yv_max), 127)
    -- else
    --     self.y = mid(0, self.y + mid(-self.yv_max, self.yv, self.yv_max), 127)
    -- end

	-- --gravity
	-- 	self.yv = min(self.yv + g, self.v_max * 4)
	-- 	self.y += self.yv
	-- --check ceiling
	-- if is_solid(self.x, self.y-self.height) then
	-- 	self.y = shl(ceil(map_y), 3)+self.height
	-- 	self.yv = 0
	-- end
	-- --check floor
	-- if is_solid(self.x, self.y+1) or is_solid(self.x + self.width, self.y+1) then
	-- 	self.y = shl(flr(map_y), 3)
	-- 	self.yv = 0
	-- 	if self.freefall then
	-- 		self.freefall=false
	-- 		sfx(0)
	-- 	end
	-- 	--jump
	-- 	if btn(2) then
	-- 		self.yv = -4
	-- 		sfx(1)
	-- 	end
	-- else
	-- 	floor=false
	-- 	self.freefall=true
    -- end

	
	-- --collision
	-- if self.xv > 0 then
	-- 	self.h_flip=false
	-- 	self.x += ceil(self.xv)
	-- 	if is_solid(self.x+self.width, self.y-1) or is_solid(self.x+self.width, self.y-self.height) then
	-- 		self.x	= shl(flr(map_x), 3) - self.width - 1
	-- 	end
	-- elseif self.xv < 0 then
	-- 	self.h_flip=true
	-- 	self.x += flr(self.xv)
	-- 	if is_solid(self.x-1, self.y-1) or is_solid(self.x-1, self.y-self.height) then
	-- 		self.x	= shl(ceil(map_x), 3)
	-- 	end
	-- end
		
	-- self.x = band(self.x, 127)
	-- self.y = band(self.y, 127)
end

function player:draw()
	spr(2, self.x, self.y-self.height, 1, 1, self.h_flip)
    pset(self.x, self.y, 3)
--	pset(self.x + self.width, self.y, 3)
end
