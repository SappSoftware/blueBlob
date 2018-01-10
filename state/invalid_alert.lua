invalid_alert = {}

local buttons = {}
local fields = {}
local labels = {}

local ui_square = {}
local background = {}

function invalid_alert:init()
  ui_square = HC.rectangle(SW*.1, SW*.1, SW*.8, SW*.6)
  background = HC.rectangle(0,0,SW,SH)
  
  labels.errorMessage = Label("There's an error in your formula!", .5, .3, "center")
  
  buttons.comply = Button(.5, .5, .1, .05, "Gotcha")
  buttons.comply.action = returnToGame
end

function invalid_alert:enter(from, errorMessage)
  labels.errorMessage:settext(errorMessage)
end

function invalid_alert:update(dt)
  TICK = TICK + dt
  self:handleMouse()
  if TICK >= FPS then
    for pos, field in pairs(fields) do
      field:update(TICK)
    end
    TICK = 0
  end
end

function invalid_alert:draw()
  game:draw()
  love.graphics.setColor(0,0,0,160)
  background:draw("fill")
  love.graphics.setColor(CLR.BLACK)
  ui_square:draw("fill")
  for pos, button in pairs(buttons) do
    button:draw()
  end
  for pos, field in pairs(fields) do
    field:draw()
  end
  for _, label in pairs(labels) do
    label:draw()
  end
end

function invalid_alert:keypressed(key)
  for pos, field in pairs(fields) do
    field:keypressed(key)
  end
  if key == "p" then
    Gamestate.pop()
  end
end

function invalid_alert:mousepressed(mousex, mousey, mouseButton)
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

function invalid_alert:handleMouse()
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

function returnToGame()
  Gamestate.pop()
end