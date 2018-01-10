BlueBlob = Class{
  init = function(self, x, y, radius)
    self.pos = {x = x, y = y}
    self.radius = radius
    self.color = CLR.BLUE
    self.isHit = false
    self.wasHit = false
    self.mask = HC.circle(x, y, radius)
  end;
  
  draw = function(self)
    if self.wasHit then
      love.graphics.setColor(CLR.GREEN)
      self.mask:draw("line")
    elseif self.isHit then
      love.graphics.setColor(self.color)
      self.mask:draw("line")
    else
      love.graphics.setColor(self.color)
      self.mask:draw("fill")
    end
  end;
  
  getMinX = function(self)
    return self.pos.x - self.radius 
  end;
  
  getMaxX = function(self)
    return self.pos.x + self.radius 
  end;
  
  getMinY = function(self)
    return -self.pos.y - self.radius
  end;
  
  getMaxY = function(self)
    return -self.pos.y + self.radius
  end;
}