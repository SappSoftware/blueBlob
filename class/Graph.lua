Graph = Class{
  init = function(self, minX, maxX, minY, maxY, xStep, yStep)
    self.xStep = xStep
    self.yStep = yStep
    self.minX = minX
    self.maxX = maxX
    self.minY = minY
    self.maxY = maxY
    self.xScale = SW/(self.maxX - self.minX)
    self.yScale = SW/(self.maxY - self.minY)
    self.gridlines = self:createGridlines()
    self.expression = {}
    self.graphingPoints = {}
    self.graphingLines = {}
    
    self.currentX = -SW/2
    self.currentY = -SW/2
    self.numIters = 40
    self.currentIter = 1
    self.deltaX = 10
    self.deltaY = 10
    self.numHit = {}
    self.globsLeft = 10
    
    self.isOfX = true
    
    self.globs = {}
    
    self.errorSubs = {}
    
    self:setErrorSubs()
  end;
  
  createGridlines = function(self)
    local gridlines = {}
    for x=self.minX, self.maxX do
      if x ~= 0 then
        table.insert(gridlines, {{x*self.xScale, self.minY*self.yScale},{x*self.xScale, self.maxY*self.yScale}})
        end
    end
    for y=self.minY, self.maxY do
      if y ~= 0 then
        table.insert(gridlines, {{self.minX*self.xScale, y*self.yScale},{self.maxX*self.xScale, y*self.yScale}})
      end
    end
    
    return gridlines
  end;
  
  draw = function(self)
    love.graphics.setColor(CLR.GREY)
    for i, line in ipairs(self.gridlines) do
      love.graphics.line(line[1][1], line[1][2], line[2][1], line[2][2])
    end
    love.graphics.setColor(CLR.BLACK)
    love.graphics.line(self.minX*self.xScale, 0, self.maxX*self.xScale, 0)
    love.graphics.line(0, self.minY*self.yScale, 0, self.maxY*self.yScale)
    
    if self.graphingLines ~= {} then
      love.graphics.setColor(CLR.GREEN)
      if #self.graphingPoints > 1 then
        for i = 1, #self.graphingPoints - 1 do
          love.graphics.points(self.graphingPoints[i])
          if self.graphingLines[i] ~= {} and #self.graphingLines[i]%2 == 0 and #self.graphingLines[i] >= 4 then
            love.graphics.line(self.graphingLines[i])
          end
        end
      end
      
      love.graphics.setColor(CLR.RED)
      if self.graphingPoints[#self.graphingPoints] ~= nil then
        love.graphics.points(self.graphingPoints[#self.graphingPoints])
      end
      if self.graphingLines[#self.graphingLines] ~= nil and #self.graphingLines[#self.graphingLines]%2 == 0 and #self.graphingLines[#self.graphingLines] >= 4 then
        love.graphics.line(self.graphingLines[#self.graphingLines])
      end
    end
      
    for i, glob in ipairs(self.globs) do
      glob:draw()
    end
  end;
  
  slopegraphExpression = function(self, newExpression)
    self.graphingPoints = {}
    self.graphingLines = {}
    self.expression = self:parse(newExpression)
    local x = self.minX
    local lasty = 0
    local lastx = 0
    
    while x < self.maxX do
      local tempString = string.gsub(self.expression, "x", tostring("(" .. x .. ")"))
      tempString = self:parse(tempString)
      
      local evalString = "return " .. tempString
      if loadstring(evalString) ~= nil then
        local eval = loadstring(evalString)
        if eval() ~= nil then
          local y = eval()
          if type(y) == "number" then
            table.insert(self.graphingPoints, {x*self.xScale, -y*self.yScale})
            table.insert(self.graphingLines, x*self.xScale)
            table.insert(self.graphingLines, -y*self.yScale)
            if x ~= self.minX then
              local deltaY = math.min(.4,math.max(0.1, math.abs(y-lasty)))
              local deltaX = math.min(.1,math.max(0.01, math.abs(x-lastx)))
              lasty = y
              lastx = x
              x = x + .1*(deltaX/deltaY)
            else
              lasty = y
              lastx = x
              x = x + .0001
            end
            
          end
        else
          break
        end
      else
        break
      end
    end
  end;
  
  pixelgraphExpression = function(self, newExpression)
    timeCheck = love.timer.getTime()
    self.graphingPoints = {}
    self.graphingLines = {}
    self.expression = self:parse(newExpression)
    
    for x = -SW/2, SW/2, .5 do
      local tempString = string.gsub(self.expression, "x", tostring("(" .. x/self.xScale .. ")"))
      tempString = self:parse(tempString)
      
      local evalString = "return " .. tempString
      if loadstring(evalString) ~= nil then
        local eval = loadstring(evalString)
        if eval() ~= nil then
          local y = eval()
          if type(y) == "number" then
            table.insert(self.graphingPoints, {x, -y*self.yScale})
            table.insert(self.graphingLines, x)
            table.insert(self.graphingLines, -y*self.yScale)
          end
        else
          break
        end
      else
        return false
      end
    end
    print(love.timer.getTime() - timeCheck)
    if #self.graphingPoints > 20 then
      return true
    else
      return false
    end
  end;
  
  pixelpartsgraphExpression = function(self)
    if self.isOfX then
      if self.currentX == -SW/2 then
        self:markOldData()
        table.insert(self.numHit, 0)
        table.insert(self.graphingPoints, {})
        table.insert(self.graphingLines, {})
      end
      
      for x = self.currentX, self.currentX + SW/self.numIters, 1/self.deltaX do
        local tempString = string.gsub(self.expression[#self.expression], "x", tostring("(" .. x/self.xScale .. ")"))
        tempString = self:parse(tempString)
        
        local evalString = "return " .. tempString
        if loadstring(evalString) ~= nil then
          local eval = loadstring(evalString)
          if eval() ~= nil then
            local y = eval()
            if type(y) == "number" then
              table.insert(self.graphingPoints[#self.graphingPoints], {x, -y*self.yScale})
              table.insert(self.graphingLines[#self.graphingLines], x)
              table.insert(self.graphingLines[#self.graphingLines], -y*self.yScale)
            end
          else
            break
          end
        else
          return false
        end
      end
      if #self.graphingPoints[#self.graphingPoints] > 20 then
        self.currentX = self.currentX + SW/self.numIters
        self.currentIter = self.currentIter + 1
        return true
      else
        return false
      end
    else
      --todo: iterate across y axis
      if self.currentY == -SW/2 then
        self:markOldData()
        table.insert(self.numHit, 0)
        table.insert(self.graphingPoints, {})
        table.insert(self.graphingLines, {})
      end
      
      for y = self.currentY, self.currentY + SW/self.numIters, 1/self.deltaY do
        local tempString = string.gsub(self.expression[#self.expression], "y", tostring("(" .. y/self.yScale .. ")"))
        tempString = self:parse(tempString)
        
        local evalString = "return " .. tempString
        if loadstring(evalString) ~= nil then
          local eval = loadstring(evalString)
          if eval() ~= nil then
            local x = eval()
            if type(x) == "number" then
              table.insert(self.graphingPoints[#self.graphingPoints], {x*self.xScale, -y})
              table.insert(self.graphingLines[#self.graphingLines], x*self.xScale)
              table.insert(self.graphingLines[#self.graphingLines], -y)
            end
          else
            break
          end
        else
          return false
        end
      end
      if #self.graphingPoints[#self.graphingPoints] > 20 then
        self.currentY = self.currentY + SW/self.numIters
        self.currentIter = self.currentIter + 1
        return true
      else
        return false
      end
    end
    
  end;
  
  graphExpression = function(self, newExpression)
    self.graphingPoints = {}
    self.graphingLines = {}
    self.expression = self:parse(newExpression)
    
    for i = self.minX, self.maxX, .1 do
      local tempString = string.gsub(self.expression, "x", tostring("(" .. i .. ")"))
      tempString = self:parse(tempString)
      
      local evalString = "return " .. tempString
      if loadstring(evalString) ~= nil then
        local eval = loadstring(evalString)
        if eval() ~= nil then
          if type(eval()) == "number" then
            table.insert(self.graphingPoints, {i*self.xScale, -eval()*self.yScale})
            table.insert(self.graphingLines, i*self.xScale)
            table.insert(self.graphingLines, -eval()*self.yScale)
          end
        else
          break
        end
      else
        break
      end
    end
  end;
  
  errorCheck = function(self, testExpression)
    local  tempExpression = testExpression
    
    for _, sub in ipairs(self.errorSubs) do
      tempExpression = string.gsub(tempExpression, sub[1], sub[2])
    end
    
    return tempExpression
  end;
  
  setErrorSubs = function(self)
    self.errorSubs = {}
    if self.isOfX then
      table.insert(self.errorSubs, {"xx", "x"})
      table.insert(self.errorSubs, {"X", "x"})
      table.insert(self.errorSubs, {"%(%)", ""})
      table.insert(self.errorSubs, {"[a-wy-zA-WY-Z]", ""})
    else
      table.insert(self.errorSubs, {"yy", "y"})
      table.insert(self.errorSubs, {"Y", "y"})
      table.insert(self.errorSubs, {"%(%)", ""})
      table.insert(self.errorSubs, {"[a-xzA-XZ]", ""})
    end
    
  end;
  
  parse = function(self, testExpression)
    local tempExpression = testExpression
    
    if self.isOfX then
      tempExpression = string.gsub(tempExpression, "(%d)(x)","%1%*%2")
      tempExpression = string.gsub(tempExpression, "(%d)(%()","%1%*%2")
      tempExpression = string.gsub(tempExpression, "(%))(%()","%1%*%2")
    else
      tempExpression = string.gsub(tempExpression, "(%d)(y)","%1%*%2")
      tempExpression = string.gsub(tempExpression, "(%d)(%()","%1%*%2")
      tempExpression = string.gsub(tempExpression, "(%))(%()","%1%*%2")
    end
    
    return tempExpression
  end;
  
  addBlueBlob = function(self, x, y, radius)
    table.insert(self.globs, BlueBlob(x*self.xScale, -y*self.yScale, radius*self.xScale))
  end;
  
  checkGlobCollisions = function(self)
    for _, glob in ipairs(self.globs) do
      --todo: more accurate collision checking? try testing against line normals?
      if self.isOfX then
        if not glob.isHit and glob:getMaxX() < self.currentX then
          for x = math.floor((glob:getMinX() + SW/2)*self.deltaX + 1), math.ceil((glob:getMaxX() + SW/2)*self.deltaX + 1), 1 do
            if not glob.isHit then
              if glob.mask:contains(self.graphingPoints[#self.graphingPoints][x][1], self.graphingPoints[#self.graphingPoints][x][2]) and not glob.isHit then
                glob.isHit = true
                self.numHit[#self.graphingPoints] = self.numHit[#self.graphingPoints] + 1
                self.globsLeft = self.globsLeft - 1
              end
            end
          end
        end
      else
        --todo: check by iterating across y
        if not glob.isHit and glob:getMaxY() < self.currentY then
          for y = math.floor((glob:getMinY() + SW/2)*self.deltaY + 1), math.ceil((glob:getMaxY() + SW/2)*self.deltaY + 1), 1 do
            if not glob.isHit then
              if glob.mask:contains(self.graphingPoints[#self.graphingPoints][y][1], self.graphingPoints[#self.graphingPoints][y][2]) and not glob.isHit then
                glob.isHit = true
                self.numHit[#self.graphingPoints] = self.numHit[#self.graphingPoints] + 1
                self.globsLeft = self.globsLeft - 1
              end
            end
          end
        end
      end
    end
  end;
  
  getScore = function(self)
    local score = 0
    if self.numHit[#self.graphingPoints] ~= 0 then
      score = 2^(self.numHit[#self.graphingPoints])-1
    end
    return score
  end;
  
  getGlobsLeft = function(self)
    return self.globsLeft
  end;
  
  markOldData = function(self)
    for _, glob in ipairs(self.globs) do
      if glob.isHit == true then
        glob.wasHit = true
      end
    end
  end;
  
  generateGlobs = function(self, numGlobs, globRadius)
    local adjustedGlobRadius = globRadius * self.xScale
    self.globsLeft = numGlobs
    while #self.globs < numGlobs do
      local tooClose = false
      local x = love.math.random(math.ceil((self.minX+globRadius)*self.xScale), math.floor((self.maxX-globRadius)*self.xScale))
      local y = love.math.random(math.ceil((self.minY+globRadius)*self.yScale), math.floor((self.maxY-globRadius)*self.yScale))
      if #self.globs > 0 then
        for _, glob in ipairs(self.globs) do
          local deltaDist = math.sqrt(((x-glob.pos.x)^2)+((y-glob.pos.y)^2))
          if deltaDist < adjustedGlobRadius * 4 then
            tooClose = true
          end
        end
      end
      
      if not tooClose then
        table.insert(self.globs, BlueBlob(x, y, adjustedGlobRadius))
      end
    end
  end;
  
  resetGraph = function(self)
    self.expression = {}
    self.graphingPoints = {}
    self.graphingLines = {}
    self.numHit = {}
    self.globs = {}
    self.globsLeft = 10
    self.currentIter = 1
    self.currentX = -SW/2
    self.currentY = -SW/2
  end;
  
  checkPreviousEquations = function(self)
    if #self.expression > 1 then
      for i = 1, #self.expression-1 do
        if self.isOfX then
          if self.expression[i] == "y = " .. self.expression[#self.expression] then
            table.remove(self.expression)
            return true
          end
        else
          if self.expression[i] == "x = " .. self.expression[#self.expression] then
            table.remove(self.expression)
            return true
          end
        end
      end
    end
    return false
  end;
}