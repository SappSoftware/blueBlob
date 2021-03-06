main_menu = {}

local buttons = {}
local labels = {}
local fields = {}

function main_menu:init()
  mousePos = HC.point(love.mouse.getX(), love.mouse.getY())
  self:initializeButtons()
  self:initializeLabels()
  self:initializeFields()
end

function main_menu:enter(from)
  love.graphics.setBackgroundColor(CLR.BLACK)
end

function main_menu:update(dt)
  self:handleMouse()
end

function main_menu:keypressed(key)
  for pos, field in pairs(fields) do
    field:keypressed(key)
  end
end

function main_menu:textinput(text)
  for pos, field in pairs(fields) do
    field:textinput(text)
  end
end

function main_menu:mousepressed(mousex, mousey, mouseButton)
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

function main_menu:draw()
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

function main_menu:initializeButtons()
  buttons.startGame = Button(.5, .5, .15, .06, "Start Game")
  buttons.options = Button(.5, .7, .15, .06, "Options")
  buttons.quitGame = Button(.5, .8, .15, .06, "Quit Game")
  
  buttons.options.isSelectable = false
  
  buttons.startGame.action = function()
    love.mouse.setCursor()
    currentseed = toSeed(fields.seed:getvalue())
    Gamestate.switch(game)
  end
  
  buttons.options.action = function()
    love.mouse.setCursor()
    Gamestate.push(main_menu_options)
  end
  
  buttons.quitGame.action = function()
    love.event.quit()
  end
end

function main_menu:initializeLabels()
  labels.title = Label("Main Menu", .5, .1, "center", CLR.WHITE)
end

function main_menu:initializeFields()
  fields.seed = FillableField(.5, .4, .15, .03, "Level Seed", false, true, 16)
end

function main_menu:handleMouse()
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

function main_menu:quit()
  
end