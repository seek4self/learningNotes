-- 作者：qufangliu
-- 链接：https://www.jianshu.com/p/ea1aaede9772
-- 來源：简书
-- 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
--[[
print_dump是一个用于调试输出数据的函数，能够打印出nil,boolean,number,string,table类型的数据，以及table类型值的元表
参数data表示要输出的数据
参数showMetatable表示是否要输出元表
参数lastCount用于格式控制，用户请勿使用该变量
]]
function print_dump(data, showMetatable, lastCount)
    if type(data) ~= "table" then
        --Value
        if type(data) == "string" then
            io.write("\"", data, "\"")
        else
            io.write(tostring(data))
        end
    else
        --Format
        local count = lastCount or 0
        count = count + 1
        io.write("{\n")
        --Metatable
        if showMetatable then
            for i = 1,count do io.write("\t") end
            local mt = getmetatable(data)
            io.write("\"__metatable\" = ")
            print_dump(mt, showMetatable, count)    -- 如果不想看到元表的元表，可将showMetatable处填nil
            io.write(",\n")     --如果不想在元表后加逗号，可以删除这里的逗号
        end
        --Key
        for key,value in pairs(data) do
            for i = 1,count do io.write("\t") end
            if type(key) == "string" then
                io.write("\"", key, "\" = ")
            elseif type(key) == "number" then
                io.write("[", key, "] = ")
            else
                io.write(tostring(key))
            end
            print_dump(value, showMetatable, count) -- 如果不想看到子table的元表，可将showMetatable处填nil
            io.write(",\n")     --如果不想在table的每一个item后加逗号，可以删除这里的逗号
        end
        --Format
        for i = 1,lastCount or 0 do io.write("\t") end
        io.write("}")
    end
    --Format
    if not lastCount then
        io.write("\n")
    end
end


print("---------------Test---------------")
local myData = nil
print_dump(myData)
print("-------------------")
myData = true
print_dump(myData)
print("-------------------")
myData = 10086
print_dump(myData)
print("-------------------")
myData = "your name"
print_dump(myData)
print("-------------------")
myData = {
    null = nil,
    bool = true,
    num = 20,
    str = "abc",
    subTab = {"111", "222"},
    func = print_dump,
    sunTab = {"sun_a", {"sun_1", "sun_2"}, {you = "god", i = "man"}}
}
local mt = {}
mt.__add = function(op1, op2) return 1000 end
mt.__index = {1,2}
setmetatable(myData, mt)
print_dump(myData, 1) -- 第二个参数不为空则打印元表
print("---------------End---------------")

