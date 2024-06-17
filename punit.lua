printh("test-name, result", "test", true)
printh("## Running tests")

function test(name, f)
    c = cocreate(f)
    local status, sert = coresume(c)
    local result = "pass"
    local is_success = true
    while costatus(c) ~= "dead" do
        if not sert.cond then
            is_success = false
            result = "fail"

            break
        end

        status, sert = coresume(c)
    end

    if is_success then
        printh(name .. " PASS")
    else
        printh(name .. " FAIL -- " .. sert.msg)
    end
    printh(name .. ", " .. result, "test")
end

function asserteq(actual, expected, msg)
    yield({ cond = actual == expected, msg = msg })
end