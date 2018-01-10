Label = Class{
  init = function(self, text, x, y, alignment, color, font)
    self.text = text
    self.x = math.floor(SW*(x))
    self.y = math.floor(SH*(y))
    self.alignment = alignment or "left"
    self.font = font or FNT.DEFAULT
    self.color = color or CLR.WHITE
    self.ox = 0
    self.oy = math.floor(self.font:getHeight()/2)
    if self.alignment == "right" then
      self.ox = math.floor(self.font:getWidth(self.text))
    elseif self.alignment == "center" then
      self.ox = math.floor(self.font:getWidth(self.text)/2)
    end
  end;
  
  draw = function(self)
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x, self.y, 0, 1, 1, self.ox, self.oy)
    love.graphics.setFont(FNT.DEFAULT)
  end;
  
  settext = function(self, text)
    self.text = text
    self.ox = 0
    self.oy = math.floor(love.graphics.getFont():getHeight()/2)
    if self.alignment == "right" then
      self.ox = math.floor(love.graphics.getFont():getWidth(self.text))
    elseif self.alignment == "center" then
      self.ox = math.floor(love.graphics.getFont():getWidth(self.text)/2)
    end
  end;
  
  setcolor = function(self, color)
    self.color = color
  end;
  
  setposition = function(self, x, y)
    self.x = x
    self.y = y
  end;
}