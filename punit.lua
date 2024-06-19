printh("test-name, result", "test", true)
printh("## Running tests")

function test(name, f)
    printh("")
    printh("### Test " .. name)
    c = cocreate(f)
    local status, sert = coresume(c)
    local result = "pass"
    local is_success = true
    local error = ""
    while costatus(c) ~= "dead" do
        if not sert.cond then
            is_success = false
            result = "fail"
            error ..= sert.msg .. "\n"
            -- break
        end

        status, sert = coresume(c)
    end

    -- printh(costatus(c))
    if sert != nil then
        -- printh("FAIL!")
        printh("Exception: " .. sert)
        is_success = false
        result = "exception"
        error ..= sert .. "\n"
    end

    if is_success then
        printh(name .. " PASS")
    else
        printh(name .. " FAIL -- " .. error)
    end
    printh(name .. ", " .. result, "test")
end

function asserteq(actual, expected, msg)
    if actual == expected then
        yield({ cond = true, msg = msg })
    else
        yield({ cond = false, msg = "expected `" .. expected .. "` == `" .. actual .. "` " .. msg })
    end
end