local mazeGrid = {}
local currCoords = {x = 1, y = 1}
local currentIndex = 2
local wallThickness = 1
local steps = 0

local function chooseNearby()
  local possDir = {}

  if mazeGrid[currCoords.x + wallThickness + 1] and mazeGrid[currCoords.x + wallThickness + 1][currCoords.y] == " " then
    table.insert(possDir, "E")
  end

  if mazeGrid[currCoords.x - wallThickness - 1] and mazeGrid[currCoords.x - wallThickness - 1][currCoords.y] == " " then
    table.insert(possDir, "W")
  end

  if mazeGrid[currCoords.x][currCoords.y + wallThickness + 1] and mazeGrid[currCoords.x][currCoords.y + wallThickness + 1] == " " then
    table.insert(possDir, "S")
  end

  if mazeGrid[currCoords.x][currCoords.y - wallThickness - 1] and mazeGrid[currCoords.x][currCoords.y - wallThickness - 1] == " " then
    table.insert(possDir, "N")
  end

  if possDir[1] then
    return possDir[math.random(#possDir)]
  end

  return false
end

local function goToNearby(dir)
  if dir == "E" then
    for i=1, wallThickness do
      mazeGrid[currCoords.x + i][currCoords.y] = 0
    end

    currCoords.x = currCoords.x + wallThickness + 1

  elseif dir == "W" then
    for i=1, wallThickness do
      mazeGrid[currCoords.x - i][currCoords.y] = 0
    end

    currCoords.x = currCoords.x - wallThickness - 1

  elseif dir == "S" then
    for i=1, wallThickness do
      mazeGrid[currCoords.x][currCoords.y + i] = 0
    end

    currCoords.y = currCoords.y + wallThickness + 1

  else
    for i=1, wallThickness do
      mazeGrid[currCoords.x][currCoords.y - i] = 0
    end

    currCoords.y = currCoords.y - wallThickness - 1
  end

  mazeGrid[currCoords.x][currCoords.y] = currentIndex
  currentIndex = currentIndex + 1
  steps = steps + 1
end

local function createRoute()
  while true do
    chosenDir = chooseNearby()

    if chosenDir then
      goToNearby(chosenDir)

    else
      break
    end
  end
end

local function choosePrevious()
  local dir

  if mazeGrid[currCoords.x + wallThickness + 1] and mazeGrid[currCoords.x][currCoords.y] - 1 == mazeGrid[currCoords.x + wallThickness + 1][currCoords.y] then
    dir = "E"

  elseif mazeGrid[currCoords.x - wallThickness - 1] and mazeGrid[currCoords.x][currCoords.y] - 1 == mazeGrid[currCoords.x - wallThickness - 1][currCoords.y] then
    dir = "W"

  elseif mazeGrid[currCoords.x][currCoords.y + wallThickness + 1] and mazeGrid[currCoords.x][currCoords.y] - 1 == mazeGrid[currCoords.x][currCoords.y + wallThickness + 1] then
    dir = "S"

  elseif mazeGrid[currCoords.x][currCoords.y - wallThickness - 1] and mazeGrid[currCoords.x][currCoords.y] - 1 == mazeGrid[currCoords.x][currCoords.y - wallThickness - 1] then
    dir = "N"
  end

  return dir
end

local function goToPrevious(dir)
  if dir == "E" then
    currCoords.x = currCoords.x + wallThickness + 1

  elseif dir == "W" then
    currCoords.x = currCoords.x - wallThickness - 1

  elseif dir == "S" then
    currCoords.y = currCoords.y + wallThickness + 1

  else
    currCoords.y = currCoords.y - wallThickness - 1
  end
  steps = steps + 1
end

local function backTrack()
  while not chooseNearby() and (currCoords.x ~= 1 or currCoords.y ~= 1) do
    goToPrevious(choosePrevious())
  end
end

function createMaze(sizeX,sizeY,seed,newWallThickness)

  if seed then
    math.randomseed(seed)
  end

  if newWallThickness then
    wallThickness = newWallThickness
  end

  for x=1,sizeX do
    mazeGrid[x] = {}

    for y=1,sizeY do
      mazeGrid[x][y] = " "
    end
  end

  mazeGrid[1][1] = 1

  repeat
    createRoute()
    backTrack()
    currentIndex = mazeGrid[currCoords.x][currCoords.y] + 1
  until currCoords.x == 1 and currCoords.y == 1

  return mazeGrid
end

local startTime = os.clock()
local mazeGen = createMaze(101,101,os.time())
print("Time it took: " .. os.clock() - startTime)
o = "" for i=1,#mazeGen do for j=1,#mazeGen[i] do if type(mazeGen[i][j]) == "number" then o = o .. "█" else o = o .. " " end end o = o .. "\n" end
file = io.open("maze_grid.txt","w")
file:write(o)
file:close()
