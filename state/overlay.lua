overlay = {}

local buttons = {}
local labels = {}
local fields = {}

local ui_square = {}
local background = {}

local equations = {}
local fromState = {}

function overlay:init()
  ui_square = HC.rectangle(SW*.1, SW*.1, SW*.8, SW*.6)
  background = HC.rectangle(0,0,SW,SH)
  mousePos = HC.point(love.mouse.getX(), love.mouse.getY())
  self:initializeButtons()
  self:initializeLabels()
  self:initializeFields()
end

function overlay:enter(from, expressions)
  fromState = from
  equations = {}
  for i = 1, 20 do
    labels[i] = nil
  end
  
  if from == game then
    for i, expression in ipairs(expressions) do
      equations[i] = i .. ". " .. expression
      labels[i] = Label(equations[i], .3, .18+(i*.02), "left", CLR.WHITE)
    end
  else
    for i, expression in ipairs(expressions) do
      equations[i] = expression
      labels[i] = Label(equations[i], .3, .18+(i*.02), "left", CLR.WHITE)
    end
  end
end

function overlay:update(dt)
  self:handleMouse()
end

function overlay:keypressed(key)
  for pos, field in pairs(fields) do
    field:keypressed(key)
  end
end

function overlay:textinput(text)
  for pos, field in pairs(fields) do
    field:textinput(text)
  end
end

function overlay:mousepressed(mousex, mousey, mouseButton)
  mousePos = HC.point(mousex, mousey)
  
  if mouseButton == 1 then
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

function overlay:draw()
  fromState:draw()
  love.graphics.setColor(0,0,0,160)
  background:draw("fill")
  love.graphics.setColor(CLR.BLACK)
  ui_square:draw("fill")
  for key, button in pairs(buttons) do
    button:draw()
  end
  for pos, field in pairs(fields) do
    field:draw()
  end
  for pos, label in pairs(labels) do
    label:draw()
  end
end

function overlay:initializeButtons()
  
end

function overlay:initializeLabels()
  labels.title = Label("Equations used", .5, .13, "center", CLR.WHITE, FNT.SCORE)
end

function overlay:initializeFields()
end

function overlay:keypressed(key)
  if key == "tab" or key == "escape" then
    Gamestate.pop()
  end
end

function overlay:handleMouse()
  mousePos:moveTo(love.mouse.getX(), love.mouse.getY())
  local highlightButton = false
  local highlightField = false
  
  for key, button in pairs(buttons) do
    if button:highlight(mousePos) then
      highlightButton = true
    end
  end
  
  for key, field in pairs(fields) do
    if field:highlight(mousePos) then
      highlightField = true
    end
  end
  
  if highlightButton then
    love.mouse.setCursor(CUR.H)
  elseif highlightField then
    love.mouse.setCursor(CUR.I)
  else
    love.mouse.setCursor()
  end
end

function overlay:quit()
  
end