local list = [[
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
]]

local lines = {}
for line in string.gmatch(list, "([^\n]*)\n?") do
  lines[#lines + 1] = line
end

local sums = {}
for index, line in pairs(lines) do
  if line == "" then
    sums[#sums + 1] = 0
  else
    sums[#sums] = ( sums[#sums] or 0 ) + tonumber(line)
  end
end

print(table.concat(sums, "\n"))

local result1 = math.max(table.unpack(sums))
print("part 1 result", result1)


-- part 2

table.sort(sums, function(a, b) return a > b end)
local topSums = table.pack(table.unpack(sums, 1, 3))
print(table.concat(topSums, "\n"))

local sumOfTopSums = 0
for i, sum in ipairs(topSums) do
  sumOfTopSums = sumOfTopSums + sum
end
print("part 2 result", sumOfTopSums)
