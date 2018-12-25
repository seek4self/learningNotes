
print("lua test")
---------------BubbleSort-------------------
function BubbleSort(arr)
    for i = 1, #arr -1 do  --#arr表示table总长度   
        for j = 1, #arr - i -1 do   --table从1开始计数   arr[0]=nil
            if arr[j] > arr[j + 1] then
                arr[j], arr[j + 1] = arr[j + 1], arr[j]  -- x,y = y,x   swap 'x' for 'y'
            end
        end
        -- print(a)
    end
end
-- debug.debug("begin")  --开始调试
function printTable(tabl)
    for i, a in ipairs(tabl) do
        -- print(a)
        io.write(a..' ')
    end
    print()
end
array = {2,7,4,2,1,6,9}
print("befor BubbleSort")
printTable(array)

BubbleSort(array)
print ("after BubbleSort")
printTable(array)
print("BubbleSort end")

------------------add--------------------------
function add( a, b )
    assert(type(a) == "number", "a 不是数字")
    assert(type(b) == "number", "b 不是数字")
    if a > 0 then
        return a+b
    else 
        return a-b
    end
end
local c = add(0,6)  --local局部变量
print("c=",c)
c = nil

print(add(-1,5))
-- print(add(a,5))

print("this".." is".." a".." test for string")

local str = "hello"
print("str length is :"..string.len(str))
print("#str is "..#str)  --#一元运算符，返回字符串或表的长度

----------------spilt1---------------------------
function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w ) --正则表达式：查找非reps字符，并且多次匹配   w：参数就是分割后的一个子字符串
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

----------------spilt2---------------------------
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

----------------spilt3---------------------------
function getSplitStr(logStr,breakpointsStr,t)
    local i = 0
    local j = 1
    local z = string.len(breakpointsStr)
    while true do
        i = string.find(logStr, breakpointsStr, i + 1)  -- 查找下一行
        if i == nil then
            table.insert(t, string.sub(logStr,j,-1))
            break 
        end
        table.insert(t, string.sub(logStr,j,i - 1))
        j = i + z
    end 
    return t
end

local str = "asd,fss,123,wer,"

print(string.gsub( str,'[^'..'123'..']+', function (W)
print(W)
end))
print(string.find(str,","))
local strList = split(str, ",")
print("------split-----")
printTable(strList)
strList = nil
strList = string.split(str,",")
print("------string.split-----")
printTable(strList)
strList = nil
-- getSplitStr(str,",",strList)
-- print("------split-----")
-- printTable(strList)


