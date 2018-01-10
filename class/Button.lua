Button = Class{
  init = function(self, x, y, w, h, text)
    self.w = math.floor(SW*w)
    self.h = math.floor(SH*h)
    self.x = math.floor(SW*(x - w/2))+.5
    self.y = math.floor(SH*(y - h/2))+.5
    self.body = HC.rectangle(self.x, self.y, self.w, self.h)
    self.text = text
    self.xOffset = math.floor(3*love.graphics.getLineWidth())+.5
    self.yOffset = math.floor(self.h/2 - math.floor(love.graphics.getFont():getWidth(self.text)/(self.w-2*self.xOffset))*love.graphics.getFont():getHeight()/2)+.5
    self.isActive = true
    self.isHighlighted = false
    self.isSelectable = true
  end;
  
  update = function(self, dt)
    
  end;
  
  draw = function(self)
    if self.isActive then
      if self.isSelectable then
        love.graphics.setColor(CLR.WHITE)
        self.body:draw("line")
        love.graphics.setColor(CLR.WHITE)
        love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
      else
        love.graphics.setColor(CLR.GREY)
        self.body:draw("line")
        love.graphics.setColor(CLR.GREY)
        love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
      end
    end
  end;
  
  highlight = function(self, mousePos)
    if self.isActive then
      if not self.isSelectable then self.isHighlighted = false return false end
      local test = mousePos:collidesWith(self.body)
      if test then
        self.isHighlighted = true
      else 
        self.isHighlighted = false
      end
      return test
    end
    self.isHighlighted = false
    return false
  end;
  
  mousepressed = function(self, mouseButton)
    if self.isHighlighted then
      self:action()
    end
  end;
  
  settext = function(self, newText)		
    self.text = newText		
    self.yOffset = math.floor(self.h/2 - math.floor(love.graphics.getFont():getWidth(self.text)/(self.w-2*self.xOffset))*love.graphics.getFont():getHeight()/2)+.5		
  end;
  
  resize = function(self, oldW, oldH, newW, newH)
    self.w = self.w*(newW/oldW)
    self.h = self.h*(newH/oldH)
    self.x = self.x*(newW/oldW)
    self.y = self.y*(newH/oldH)
    self.body = HC.rectangle(self.x, self.y, self.w, self.h)
    self.xOffset = 3*love.graphics.getLineWidth()
    self.yOffset = self.h/2 - math.floor(love.graphics.getFont():getWidth(self.text)/(self.w-2*self.xOffset))*love.graphics.getFont():getHeight()/2
  end;
  
  action = function(self)
    
  end;
}