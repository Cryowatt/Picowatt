function cage_map()
    reset_map()
    fset(1, 0, true)
    mset(7, 7, 1)
    mset(7, 8, 1)
    mset(7, 9, 1)
    mset(8, 7, 1)
    mset(8, 8, 0)
    mset(8, 9, 1)
    mset(9, 7, 1)
    mset(9, 8, 1)
    mset(9, 9, 1)
end

function reset_map()
    -- clear map
    for x = 0, 127 do
        for y = 0, 64 do
            mset(x, y, 0)
        end
    end

    -- clear flags
    for s = 0, 255 do
        for f = 0, 7 do
            fset(s, f, false)
        end
    end
end

test(
    "movequad", function()
        cage_map()
        for x = -1, 0 do
            local v = vector.new(point.new(64, 64), point.new(x / 10, -1))
            local hit, impulse = movequad(v, point.new(4, 4))
            asserteq(v.point.x + x / 10, hit.point.x, "x-drift " .. x / 10)
            asserteq(64, hit.point.y, "y-drift")
        end
    end
)

-- test(
--     "errortest", function()
--         local foo = {}
--         foo.y = foo.x + 9
--         printh("FAIL!")
--         -- asserteq(1, 1, "cool")
--         -- asserteq(1, 1, "Sick")
--     end
-- )

-- test(
--     "passtest", function()
--         printh("?")
--         -- asserteq(1, 1, "cool")
--         -- asserteq(1, 1, "Sick")
--     end
-- )