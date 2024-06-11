pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
g=0.5
tile_flag={
	solid=0
}

#include player.lua

function is_solid(x, y)
	map_x = shr(x, 3)
	map_y = shr(y, 3)
 return	fget(mget(map_x, map_y), tile_flag.solid)
end


function _init()
	printh("**reset**")
	p = player.new()
end

function _update60()
	cls()
	map()
	printh("**update**")
 p:update()
end

function _draw()
--	cls()
	p:draw()
end
__gfx__
00000000066666600009990050505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000665665650099cc0000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700656656550999cc0050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000665666650999990000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000666656650999990050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700656666550099990000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000665656650090090050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555500090090005050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66606000600000006060066066606060000066606600660000006600066000006660600066606060000066606660606066600660000066606660666006600000
60606000600000006060606060606060000060606060606000006060606000006060600060606060000066606060606060006000000060006060060060000000
66606000600000006060606066006600000066606060606000006060606000006660600066606660000060606660660066006660000066006600060060000000
60606000600000006660606060606060000060606060606000006060606000006000600060600060000060606060606060000060000060006060060060000000
60606660666000006660660060606060000060606060666000006060660000006000666060606660000060606060606066606600000066606060666006600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000660060606000600000006660066060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66600000606060606000600000006600606066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000606060606000600000006060606000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60600000666006606660666000006660660066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030101010103030101010103030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030301010103030101010303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101030303010103030101030303010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010303030103030103030301010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010103030103030103030101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010103030101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030303030303030303030303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010103030101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010103030103030103030101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010303030103030103030301010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101030303010103030101030303010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030301010103030101010303030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0103030101010103030101010103030100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0000000000020246402f6443164432654306572d6461d6351962415624136230d631276011d6010d6040360500605006030060300603006060060200602006040060200604006020060400600006000060000600
000100000335006350093500a3500c3500e3500f350103501235015350183501c350213502435026350273401f3001f3001e3001e3001e3002030024300243000330002300003000030000300003000030000300
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002000001885000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
