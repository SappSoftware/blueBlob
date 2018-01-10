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
require "class/Label"
require "class/Graph"
require "class/BlueBlob"

require "state/game"
require "state/main_menu"
require "state/invalid_alert"
require "state/results"
require "state/overlay"

require "helper"
require "CLR"

SW = love.graphics.getWidth() 
SH = love.graphics.getHeight()

FPS = 1/60

TICK = 0

CUR = {}

FNT = {}


mousePos = {}

timeCheck = 0

currentseed = 0

function love.load(arg)
  if debug then require("mobdebug").start() end
  Gamestate.registerEvents()
  love.keyboard.setKeyRepeat(true)
  FNT.DEFAULT = love.graphics.newFont(math.floor(SH/64))
  FNT.SCORE = love.graphics.newFont(math.floor(SH/24))
  love.graphics.setFont(FNT.DEFAULT)
  love.graphics.setBackgroundColor(CLR.WHITE)
  CUR.H = love.mouse.getSystemCursor("hand")
  CUR.I = love.mouse.getSystemCursor("ibeam")
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