local list = [[
A Y
B X
C Z
]]
local lines = {}
for line in string.gmatch(list, "([^\n]*)\n?") do
  lines[#lines + 1] = line
end
local function sumEachLineByFunction(operatorFunction)
    local sum = 0;
    for _, line in ipairs(lines) do
        local plays = {}
        for pair in line:gmatch("%S+") do
            table.insert(plays, pair)
        end
        local left, right = table.unpack(plays)
        sum = sum + operatorFunction(left, right)
    end
    return sum
end

local mapPlayToSign = {
    A = "R",
    B = "P",
    C = "S",
    X = "R",
    Y = "P",
    Z = "S",
}
local resultScores = {
    win = 6,
    lose = 0,
    draw = 3,
}
local signScoreMap = {
    R = 1,
    P = 2,
    S = 3,
}
local signToLosingSignMap = {
    R = "S",
    P = "R",
    S = "P",
}
local function signsToMatchResult(opponentSign, playerSign)
    if playerSign == opponentSign then
        return resultScores.draw
    end

    if signToLosingSignMap[playerSign] == opponentSign then
        return resultScores.win
    else
        return resultScores.lose
    end
end
local function playsToMatchResult(opponentPlay, playerPlay)
    local opponentSign = mapPlayToSign[opponentPlay]
    local playerSign = mapPlayToSign[playerPlay]
    return signsToMatchResult(opponentSign, playerSign)
end

local function matchResultWithSignScore(opponentPlay, playerPlay)
    return playsToMatchResult(opponentPlay, playerPlay) + signScoreMap[mapPlayToSign[playerPlay]]
end

assert(matchResultWithSignScore("A", "Y") == 8, 'A Y should be win(6) + 2(sign)')
assert(matchResultWithSignScore("B", "X") == 1, "B X should be lose(0) + 1(sign)" )
assert(matchResultWithSignScore("C", "Z") == 6, 'C Z should be draw(3) + 3(sign)' )

local sumOfResultsOfAllMatches = sumEachLineByFunction(matchResultWithSignScore)
print("result of part1:", sumOfResultsOfAllMatches)
assert(sumOfResultsOfAllMatches == 15)


-- part 2

local function winningSignForSign(opponentSign)
    for winningSign, losingSign in pairs(signToLosingSignMap) do
        if losingSign == opponentSign then
            return winningSign
        end
    end
end
assert(winningSignForSign("R") == "P", "P should win over R")
assert(winningSignForSign("P") == "S", "S should win over P")
assert(winningSignForSign("S") == "R", "R should win over S")

local resultSignToResultMap = {
    X = resultScores.lose,
    Y = resultScores.draw,
    Z = resultScores.win,
}
local function opponentPlayAndResultSignToPlayerSign(opponentPlay, resultSign)
    local opponentSign = mapPlayToSign[opponentPlay]
    local desiredResult = resultSignToResultMap[resultSign]

    if desiredResult == resultScores.draw then
        return opponentSign
    end
    if desiredResult == resultScores.lose then
        return signToLosingSignMap[opponentSign]
    end
    if desiredResult == resultScores.win then
        return winningSignForSign(opponentSign)
    end
end
assert(opponentPlayAndResultSignToPlayerSign("A", "Y") == "R", "Player should win")
assert(opponentPlayAndResultSignToPlayerSign("B", "X") == "R", "Player should lose")
assert(opponentPlayAndResultSignToPlayerSign("C", "Z") == "R", "Match should draw")

local function scoreForOpponentPlayAndResultSign(opponentPlay, resultSign)
    local opponentSign = mapPlayToSign[opponentPlay]
    local playerSign = opponentPlayAndResultSignToPlayerSign(opponentPlay, resultSign)
    return signsToMatchResult(opponentSign, playerSign) + signScoreMap[playerSign]
end
assert(scoreForOpponentPlayAndResultSign("A", "Y") == 4)
assert(scoreForOpponentPlayAndResultSign("B", "X") == 1)
assert(scoreForOpponentPlayAndResultSign("C", "Z") == 7)

sumOfResultsOfAllMatches = sumEachLineByFunction(scoreForOpponentPlayAndResultSign)
print("result of part2:", sumOfResultsOfAllMatches)
assert(sumOfResultsOfAllMatches == 12)
