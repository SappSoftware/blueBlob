results = {}

local buttons = {}
local text_lines = {}
local fields = {}

local ui_square = {}

local equations = {}

local score = 0

function results:init()
  mousePos = HC.point(love.mouse.getX(), love.mouse.getY())
  ui_square = HC.rectangle(0, SW, SW, SH-SW)
  self:initializeButtons()
  self:initializeTextLines()
  self:initializeFields()
end

function results:enter(from, expressions, points)
  for i, expression in ipairs(expressions) do
    equations[i] = i .. ". " .. expression
    text_lines[i] = TextLine(equations[i], .3, .922+(i*.02), "left", CLR.WHITE)
  end
  score = points
  text_lines.score:settext("Score: " .. score)
end

function results:update(dt)
  self:handleMouse()
end

function results:keypressed(key)
  for pos, field in pairs(fields) do
    field:keypressed(key)
  end
end

function results:textinput(text)
  for pos, field in pairs(fields) do
    field:textinput(text)
  end
end

function results:mousepressed(mousex, mousey, mouseButton)
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

function results:draw()
  game:draw()
  self:drawUI()
  for key, button in pairs(buttons) do
    button:draw()
  end
  for pos, field in pairs(fields) do
    field:draw()
  end
  for pos, text_line in pairs(text_lines) do
    text_line:draw()
  end
end

function results:drawUI()
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

function results:initializeButtons()
  buttons.confirm = Button(.85, .95, .15, .025, "Return to Menu")
  buttons.retry = Button(.85, .98, .15, .025, "Retry Level")
  
  buttons.confirm.action = function()
    love.mouse.setCursor()
    Gamestate.switch(main_menu)
  end
  
  buttons.retry.action = function()
    love.mouse.setCursor()
    Gamestate.switch(game)
  end
end

function results:initializeTextLines()
  text_lines.score = TextLine("Score: " .. score, .07, .955, "left", CLR.WHITE)
end

function results:initializeFields()
end

function results:handleMouse()
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
    love.mouse.setCursor(cur_highlight)
  elseif highlightField then
    love.mouse.setCursor(cur_field)
  else
    love.mouse.setCursor()
  end
end

function results:quit()
  
end