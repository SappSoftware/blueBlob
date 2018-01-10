FillableField = Class{__includes = Button,
  init = function(self, x, y, w, h, default_text, isNumber, hasTitle, isPrivate)
    Button.init(self, x, y, w, h, default_text)
    self.default_text = default_text
    self.isNumber = isNumber
    self.hasControl = false
    self.linePulse = FillableField.pulseTime
    self.line = false
    self.lineIndex = nil
    self.fontHeight = love.graphics.getFont():getHeight()
    self.isPrivate = false or isPrivate
    self.hasTitle = hasTitle
    self.textLimit = 500
    if self.hasTitle then
      self.title = self.default_text
      self.default_text = ""
      self.text = ""
    end
    self.isSigned = false
  end;
  pulseTime = 0.7,
  
  mousepressed = function(self, button)
    if self.isActive then
      if self.hasControl and not self.isHighlighted then
        self:loseControl()
      end
      
      if not self.hasControl and self.isHighlighted then
        self:gainControl()
      end
    end
  end;
  
  textinput = function(self, key)
    if self.hasControl then
      if self.isNumber then
        if self.isSigned then
          if key == "-" then
            if self.text == "" or self.text == nil then
              self.text = "-"
            end
          elseif key == "." then
            local text = tostring(self.text)
            if not text:find("%.") then
              if text == "" then
                self.text = "0."
              elseif text == "-" then
                self.text = "-0."
              else
                self.text = self.text .. key
              end
            end
          else
            local toAdd = tonumber(key)
            if toAdd then
              if self.lineIndex == 0 then
                self.text = toAdd .. self.text
              elseif self.lineIndex == self.text:len() then
                self.text = self.text .. toAdd
              else
                self.text = self.text:sub(1, self.lineIndex) .. toAdd .. self.text:sub(self.lineIndex+1)
              end
              self:increaseIndex()
            end
          end
          
        else
          local toAdd = tonumber(key)
          if toAdd then
            if self.lineIndex == 0 then
              self.text = toAdd .. self.text
            elseif self.lineIndex == self.text:len() then
              self.text = self.text .. toAdd
            else
              self.text = self.text:sub(1, self.lineIndex) .. toAdd .. self.text:sub(self.lineIndex+1)
            end
            self:increaseIndex()
          end
        end
      else
        local toAdd = key
        if toAdd and string.len(self.text) < self.textLimit then
          if self.lineIndex == 0 then
            self.text = toAdd .. self.text
          elseif self.lineIndex == self.text:len() then
            self.text = self.text .. toAdd
          else
            self.text = self.text:sub(1, self.lineIndex) .. toAdd .. self.text:sub(self.lineIndex+1)
          end
          self:increaseIndex()
        end
      end
    end
  end;
  
  keypressed = function(self, key)
    if self.hasControl then
      if key == "backspace" then
        if self.lineIndex == 0 then
          
        elseif self.lineIndex == self.text:len() then
          self.text = tostring(self.text):sub(1, -2)
        else
          self.text = tostring(self.text):sub(1, self.lineIndex-1) .. tostring(self.text):sub(self.lineIndex+1)
        end
        self:decreaseIndex()
        if self.isNumber then
          --[[
          if self.hasTitle then
            
          else
            self.text = tonumber(self.text)
            if self.text == nil then
              self.text = 0
            end
          end
          ]]--
        end
      end
      if key == "return" then
        self.hasControl = false
      end
      if key == "left" then
        self:decreaseIndex()
      end
      if key == "right" then
        self:increaseIndex()
      end      
    end
  end;
  
  update = function(self, dt)
    if self.hasControl then
      self.linePulse = self.linePulse - dt
      if self.linePulse <= 0 then
        self.linePulse = FillableField.pulseTime
        self.line = not self.line
      end
    end
  end;
  
  draw = function(self)
    if self.isActive then
      if self.isSelectable then
        love.graphics.setColor(CLR.WHITE)
        self.body:draw("line")
        love.graphics.setColor(CLR.WHITE)
        local linex = 0
        local display_text = ""
      else
        love.graphics.setColor(CLR.GREY)
        self.body:draw("line")
        love.graphics.setColor(CLR.GREY)
        local linex = 0
        local display_text = ""
      end
      
      if self.isPrivate and self.text ~= self.default_text then
        display_text = string.rep("*", string.len(self.text))
        
      else
        display_text = self.text
        if self.hasTitle then
          love.graphics.printf(self.title, self.x+self.xOffset, math.floor(self.y-self.yOffset/2), self.w-self.xOffset, "left", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
        end
      end
      love.graphics.printf(display_text, self.x+self.xOffset, self.y+self.yOffset, self.w-self.xOffset, "left", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
      linex = self.x+self.xOffset+love.graphics.getFont():getWidth(display_text:sub(1, self.lineIndex))
      
      if self.hasControl and self.line then
        love.graphics.setColor(CLR.WHITE)
        love.graphics.line(linex, self.y+self.yOffset-self.fontHeight/2, linex, self.y+self.yOffset+self.fontHeight/2)
      end
    end
  end;
  
  gainControl = function(self)
    self.hasControl = true
    if self.hasTitle then
      
    else
      if self.text == self.default_text then
        if self.isNumber then
          self.text = 0
        else
          self.text = ""
        end
      end
    end
    self.linePulse = FillableField.pulseTime
    self.line = true
    self.lineIndex = self.text:len()
    
  end;
  
  loseControl = function(self)
    self.hasControl = false
    if self.text == "" then
      self.text = self.default_text
    end
  end;
  
  getvalue = function(self)
    if self.isNumber then
      local number = tonumber(self.text)
      if number == nil then
        return 0
      else
        return tonumber(self.text)
      end
    else
      return tostring(self.text)
    end
  end;
  
  setvalue = function(self, newValue)
    self.text = newValue
  end;
  
  increaseIndex = function(self)
    if self.lineIndex < self.text:len() then
      self.lineIndex = self.lineIndex + 1
      self.linePulse = FillableField.pulseTime
      self.line = true
    end
  end;
  
  decreaseIndex = function(self)
    if self.lineIndex > 0 then
      self.lineIndex = self.lineIndex - 1
      self.linePulse = FillableField.pulseTime
      self.line = true
    end
  end;
}