--[[DropDownMenu = Class{
  init = function(self, x, y, w, h, items)
    self.w = SW*w
    self.h = SH*h
    self.x = SW*(x - w/2)
    self.y = SH*(y - h/2)
    self.body = HC.rectangle(self.x, self.y, self.w, self.h)
    self.xOffset = 3*love.graphics.getLineWidth()
    self.yOffset = self.h/2 - love.graphics.getFont():getHeight()/2
    self.items = {}
    self:fillList(items)
    self.isActive = true
    self.isHighlighted = false
    self.isSelectable = true
    self.hasControl = false
  end;
  
  draw = function(self)
    if self.isActive then
      if self.isSelectable then
        if self.hasControl then
          love.graphics.setColor(WHITE)
          self.body:draw("line")
          love.graphics.setColor(WHITE)
          love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
        else
          love.graphics.setColor(WHITE)
          self.body:draw("line")
          love.graphics.setColor(WHITE)
           love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
          for i, item in self.items do
            item.body:draw("line")
            love.graphics.printf(item.text, self.x+self.xOffset, self.y+self.yOffset+(self.h*i), self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
          end
        end
      else
        love.graphics.setColor(GREY)
        self.body:draw("line")
        love.graphics.setColor(GREY)
        love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
      end
    end
  end;
  
  highlight = function(self, mousePos)
    if self.isActive then
      if not self.isSelectable then return false end
      if self.hasControl then
        
      else
        local test = mousePos:collidesWith(self.body)
        if test then
          self.isHighlighted = true
        else 
          self.isHighlighted = false
        end
        return test
      end
    end
    self.isHighlighted = false
    return false
  end;
  
  fillList = function(self, list)
    for i, item in ipairs(list) do
      local toInsert = {text = item, body = HC.rectangle(self.x, self.y+(self.h*i), self.w, self.h)}
      table.insert(self.items, toInsert)
    end
  end;
}
]]--