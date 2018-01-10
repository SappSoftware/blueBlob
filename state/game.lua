game = {}

local buttons = {}
local fields = {}
local text_lines = {}

local ui_square = {}

local plane = {}

local camera = {}

local expression = nil

local maxShots = 3
local shotsLeft = 3

local points = 0

local isLaunching = false

function game:init()
  love.graphics.setPointSize(1)
  
  plane = Graph(-10, 10, -10, 10, 1, 1)
  
  camera = Camera(0, 0)
  
  ui_square = HC.rectangle(0, SW, SW, SH-SW)
  
  buttons.launch = Button(.9, .9647, .1, .04, "Launch")
  buttons.swap = Button(.25, .9647, .07, .03, "Swap")
  
  --buttons.launch.action = launchExpression
  buttons.launch.action = partsLaunch
  buttons.swap.action = swap
  
  
  fields.Expression = FillableField(.53, .964, .45, .03, "", false, false)
  fields.Expression.isSigned = true
  fields.Expression.textLimit = 45
  
  text_lines.score = TextLine("Score: " .. points, .07, .955, "left", CLR.WHITE)
  text_lines.y = TextLine("y = ", .29, .967, "center", CLR.WHITE)
  text_lines.shotsLeft = TextLine("Shots Remaining: " .. shotsLeft, .07, .975, "left", CLR.WHITE)
end

function game:enter(from)
  love.graphics.setBackgroundColor(CLR.WHITE)
  mousePointer = HC.point(love.mouse.getX(), love.mouse.getY())
  
  love.math.setRandomSeed(currentseed)
  
  plane:resetGraph()
  
  expression = nil
  maxShots = 3
  shotsLeft = 3
  points = 0
  isLaunching = false
  fields.Expression:setvalue("")
  
  plane:generateGlobs(10, .5)

  camera:lookAt(0, (SH-SW)/2)
  
  text_lines.score:setText("Score: " .. points)
  text_lines.shotsLeft:setText("Shots Remaining: " .. shotsLeft)
end

function game:update(dt)
  TICK = TICK + dt
  self:handleMouse()
  if TICK >= FPS then
    for pos, field in pairs(fields) do
      field:update(TICK)
    end
    if expression ~= fields.Expression:getvalue() then
      fields.Expression:setvalue(plane:errorCheck(fields.Expression:getvalue()))
      expression = fields.Expression:getvalue()
    end
    if isLaunching then
      if plane.currentIter <= plane.numIters then
        partsExpression()
      else
        isLaunching = false
        buttons.launch.isSelectable = true
        local pointsScored = plane:getScore()
        points = points + pointsScored
        shotsLeft = shotsLeft - 1
        text_lines.score:setText("Score: " .. points)
        text_lines.shotsLeft:setText("Shots Remaining: " .. shotsLeft)
        plane.currentIter = 1
        plane.currentX = -SW/2
        
        if shotsLeft == 0 then
          Gamestate.push(results, plane.expression, points)
        end
      end
    end
    TICK = 0
  end
end

function game:keypressed(key)
  for pos, field in pairs(fields) do
    field:keypressed(key)
  end
  if key == "escape" then
    Gamestate.switch(main_menu)
  end
end

function game:textinput(text)
  for pos, field in pairs(fields) do
    field:textinput(text)
  end
end

function game:mousepressed(mousex, mousey, mouseButton)
  mousePos = HC.point(mousex, mousey)
  
  if mouseButton == 1 then
    if ui_square:contains(mousex, mousey) then
      for pos, field in pairs(fields) do
        field:highlight(mousePos)
        field:mousepressed(mouseButton)
      end
      
      for pos, button in pairs(buttons) do
        button:highlight(mousePos)
        button:mousepressed(mouseButton)
      end
    end
  end
end


function game:draw()
  camera:draw(self.drawGraph)

  self:drawUI()
  
  self:drawDebug()
end

function game:drawGraph()
  plane:draw()
end

function game:drawUI()
  love.graphics.setColor(CLR.BLACK)
  ui_square:draw("fill")
  love.graphics.setColor(CLR.WHITE)
  ui_square:draw("line")
  
  for pos, button in pairs(buttons) do
    button:draw()
  end
  for pos, field in pairs(fields) do
    field:draw()
  end
  for pos, text_line in pairs(text_lines) do
    text_line:draw()
  end
end

function game:drawDebug()
  love.graphics.setColor(CLR.BLACK)
  love.graphics.print(love.timer.getFPS(), 10, 10)
end

function game:handleMouse()
  mousePointer:moveTo(love.mouse.getX(), love.mouse.getY())
  local highlightButton = false
  local highlightField = false
  
  for key, button in pairs(buttons) do
    if button:highlight(mousePointer) then
      highlightButton = true
    end
  end
  
  for key, field in pairs(fields) do
    if field:highlight(mousePointer) then
      highlightField = true
    end
  end
  
  if highlightButton then
    love.mouse.setCursor(cur_highlight)
  elseif highlightField then
    love.mouse.setCursor(cur_field)
  else
    love.mouse.setCursor()
  end
end

function game:quit()
end

function launchExpression()
  if shotsLeft > 0 then
    local valid_expression = plane:pixelgraphExpression(fields.Expression:getvalue())
    if valid_expression == true then
      local pointsScored = plane:checkGlobCollisions()
      points = points + pointsScored
      shotsLeft = shotsLeft - 1
      text_lines.score:setText("Score: " .. points)
      text_lines.shotsLeft:setText("Shots Remaining: " .. shotsLeft)
    else
      Gamestate.push(invalid_alert)
    end
  end
end

function partsExpression()
  local valid_expression = plane:pixelpartsgraphExpression()
  
  if valid_expression == true then
    plane:checkGlobCollisions()
  else
    isLaunching = false
    buttons.launch.isSelectable = true
    Gamestate.push(invalid_alert, "There's an error in your formula!")
  end
end

function partsLaunch()
  if shotsLeft > 0 then
    buttons.launch.isSelectable = false
    table.insert(plane.expression, plane:parse(fields.Expression:getvalue()))
    local alreadyUsed = plane:checkPreviousEquations()
    
    if alreadyUsed == true then
      buttons.launch.isSelectable = true
      isLaunching = false
      Gamestate.push(invalid_alert, "You've already used that equation!")
    else
      local valid_expression = plane:pixelpartsgraphExpression()
      if valid_expression == true then
        isLaunching = true
      else
        isLaunching = false
        table.remove(plane.expression)
        buttons.launch.isSelectable = true
        Gamestate.push(invalid_alert, "There's an error in your formula!")
      end
    end
  end
end

function swap()
  plane.isOfX = not plane.isOfX
  fields.Expression:setvalue("")
  plane:setErrorSubs()
  if plane.isOfX == true then
    text_lines.y:setText("y = ")
  else
    text_lines.y:setText("x = ")
  end
end