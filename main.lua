debug = false

HC = require "hc"
Shape = require "hc.shapes"

Gamestate = require "hump.gamestate"
Class = require "hump.class"
Vector = require "hump.vector"
Camera = require "hump.camera"
Timer = require "hump.timer"

require "class/Button"
require "class/FillableField"
require "class/TextLine"
require "class/Graph"
require "class/BlueBlob"

require "state/game"
require "state/main_menu"
require "state/invalid_alert"
require "state/results"

require "helper"

SW = love.graphics.getWidth() 
SH = love.graphics.getHeight()
CLR = {}

FPS = 1/60

TICK = 0

CLR.WHITE = {255,255,255}
CLR.BLACK = {0,0,0}
CLR.RED = {255,0,0}
CLR.BLUE = {0,0,255}
CLR.GREEN = {0,255,0}
CLR.GREY = {177,177,177}

FONT_SIZE = 24

mousePointer = {}

timeCheck = 0

currentseed = 0

function love.load(arg)
  if debug then require("mobdebug").start() end
  Gamestate.registerEvents()
  love.keyboard.setKeyRepeat(true)
  love.graphics.setFont(love.graphics.newFont(math.floor(SH/64)))
  love.graphics.setBackgroundColor(CLR.WHITE)
  cur_highlight = love.mouse.getSystemCursor("hand")
  cur_field = love.mouse.getSystemCursor("ibeam")
  test()
  Gamestate.switch(main_menu)
end

function love.update(dt)
  
end

function love.draw(dt)

end

function love.keypressed(key)

end

function test()
end