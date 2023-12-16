local placeId = game.PlaceId
if placeId == 2753915549 then
	FirstSea = true
elseif placeId == 4442272183 then
	SecondSea = true
elseif placeId == 7449423635 then
	ThirdSea = true
end

local Farm = {} ;

local QuestManager =  {} ;

QuestManager.Guide = require(game:GetService("ReplicatedStorage").GuideModule) ; 
QuestManager.AllQuest = require(game:GetService("ReplicatedStorage").Quests) ;

QuestManager.AllQuest = (function() 
   local Data = {} ;
  
    for i ,v in pairs(QuestManager.AllQuest) do 
        Data[i] = {
            Index = i ,
            Value = v    
        }
    end
  
   return Data
end)() 

QuestManager.QuestBag = {} ; 
QuestManager.BagNumber = {} 
-- QuestManager.CustomLevel = 1425 ; 

QuestManager.LevelReq  = function()
    local LevelReq = {} ;
 
    for i ,v in pairs(QuestManager.AllQuest) do 
        for i2 ,v2 in pairs(v.Value) do 
            table.insert(LevelReq,v2.LevelReq) ;  
        end
    end

    local MyLevel ; 
    if not QuestManager.CustomLevel then 
		MyLevel =  game.Players.LocalPlayer.Data.Level.Value 
	else
		MyLevel = QuestManager.CustomLevel
    end

	if FirstSea and MyLevel > 675  then 
		MyLevel = 675 
	elseif SecondSea and MyLevel > 1450 then 
		MyLevel = 1475 
	elseif MyLevel >= 2525 then 
		MyLevel = 2525
	elseif MyLevel >= 230 and MyLevel < 249	then 
		MyLevel = 200
	else
		MyLevel = MyLevel
	end

    table.sort(LevelReq) ; 
    
    local p1 , p2 ,p3 ; 

    for i ,v in pairs(LevelReq) do 
       if MyLevel == v then 
            p1 = LevelReq[i] ;
			if Double_Quest then  
				p2 = LevelReq[i - 1];
                p3 = LevelReq[i - 2]; 
			end
       	 break
       end
       if MyLevel < v then 
            p1 = LevelReq[i - 1] ;
			if Double_Quest then  
				p2 = LevelReq[i - 2]; 
				p3 = LevelReq[i - 3]; 
			end
		break
       end 
    end

    QuestManager.QuestBag = {
        [1] = p1 ,
        [2] = p2 or nil  , 
    }


    if  (MyLevel >= 400 and MyLevel < 625)  or (MyLevel > 700 and MyLevel <= 1450) then --and MyLevel < 525 
        QuestManager.QuestBag = {
            [1] = p1 ,
            [2] = p2 or nil  , 
            [3] = p3
        }
    end

    
    if (MyLevel > 300 and MyLevel < 325 ) or (MyLevel > 1000 and MyLevel < 1050) or ( MyLevel > 1100 and MyLevel < 1125) or ( MyLevel > 1250 and MyLevel < 1275) or (MyLevel > 1350 and MyLevel < 1375)  or (MyLevel > 1425 and MyLevel < 1450) or 
       (MyLevel > 1575 and MyLevel < 1600) or (MyLevel > 1625 and MyLevel < 1650) or  (MyLevel > 1700 and MyLevel < 1725) or  (MyLevel > 1775 and MyLevel < 1800 ) or  (MyLevel > 1825 and MyLevel < 1850) or (MyLevel > 1900 and MyLevel < 1925) or 
       (MyLevel > 1975 and MyLevel < 2000) or  (MyLevel > 2025 and MyLevel < 2050) or  (MyLevel > 2075 and MyLevel < 2100) or  (MyLevel > 2125 and MyLevel < 2150 ) or  (MyLevel > 2200 and MyLevel < 2225) or  (MyLevel > 2250 and MyLevel < 2275) or
       (MyLevel > 2300 and MyLevel < 2325) or  (MyLevel > 2350 and MyLevel < 2400)
    then 
        QuestManager.QuestBag = {
            [1] = p1 ,
            [2] = nil  , 
            [3] = nil ,
        }
    end

    --[[
        if FishMan then 
            [3] = p3 or nil ,
        end
    ]]

    return p1 
end

QuestManager.LevelReq()

QuestManager.DataData = {
    [1] = nil ; 
    [2] = nil ;
} 

QuestManager.CountCheck = 0 ; 

QuestManager.CheckBossLevel = function(p1)

    local ix = 0 ; 
    local DataIndx =  {} 
    for i , v in pairs(p1) do 
        table.insert(DataIndx,i)
    end
    table.sort(DataIndx)

    local DataValue = {} 

    for i ,v in pairs(p1) do 
        DataValue[i] =v 
    end

    local retun 

    for i ,v in pairs(DataIndx) do 
        for i2 ,v2 in pairs(QuestManager.QuestBag) do
            if v ~= v2 then continue end
            -- print(tprint(DataValue[DataIndx[ i -1 ]]))
            if QuestManager:FindValue(DataValue[v].Value.Task) == 1  then 
                retun =  DataValue[DataIndx[ i -1 ]]
            else
                retun = DataValue[DataIndx[ i ]]
            end

        end
    end

    return retun
end

QuestManager.MyData = function() 
	QuestManager.BagNumber = {} ; 

    for i ,v in pairs(QuestManager.DataData) do 
        if not v.Used then continue end ; 
        QuestManager.CountCheck +=  1 ;
    end

    -- Reset ;
	if QuestManager.CountCheck >= 2 then 
        QuestManager.CountCheck = 0 ; 
        QuestManager.DataData = {
            [1] = nil ; 
            [2] = nil ;
        } 
    end

    if not Double_Quest then 
        QuestManager.DataData  = {} 
    end

    local p2 = {} ; 

	for i ,v in pairs(QuestManager.AllQuest) do
        for i2 ,v2 in pairs(v.Value) do 
            if (i:sub(1,11) == "MarineQuest" and #i == 11) or i == "BartiloQuest" or i == "CitizenQuest" then  continue end 
            p2[v2.LevelReq] = {
                Index = i , 
                Value = v2 , 
            }
        end
     end
     local Data = QuestManager.CheckBossLevel(p2) ;  

	 if Double_Quest then 
		for i ,v in pairs(p2) do 
			for i2 , v2 in pairs(QuestManager.QuestBag) do 
				if p2[i].Value.LevelReq == v2 then 

					if QuestManager:FindValue(p2[i].Value.Task) == 1 and Double_Quest then 
						continue
					end
					table.insert(QuestManager.BagNumber,v2)
					if not QuestManager.DataData[v2] then 
						QuestManager.DataData[v2] = {
							Index = p2[i].Index ,
							Value = p2[i].Value ,
							Used = false,       
						}
					end

				end
			end ;
		end ;
	else
		for i , v in pairs(p2) do 
			if p2[i].Value.LevelReq == Data.Value.LevelReq then 
				table.insert(QuestManager.BagNumber,Data.Value.LevelReq)
				if not QuestManager.DataData[Data.Value.LevelReq] then 
					QuestManager.DataData[Data.Value.LevelReq] = {
						Index = p2[i].Index ,
						Value = p2[i].Value ,
						Used = false,       
					}
				end
			end
		 end
	 end

    
    return QuestManager.DataData ;
end

function QuestManager:FindValue(p1)
	if not p1 then return warn("havenil") end 
	for i ,v in pairs(p1) do 
		return v 
	end
end

function QuestManager:FindIndex(p1,p2) 
    if not p1 then return warn("havenil") end 
   for i ,v in pairs(p1) do 
       return i 
   end
end

function QuestManager:FindData(p1,p2,p3)
    for i, v in pairs(require(game:GetService("ReplicatedStorage").Quests)[p1]) do 
        if v.LevelReq == p2 then 
            return {
                Value = v,
                Index = i ,
            }
        end
    end

end

function QuestManager:Npcs(p1,p2) 
    
    local PositionMon ;
    for i ,v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do 
       if v.Name:match(self:FindIndex(p2)) then 
            PositionMon = v 
       end
    end
    
    for i ,v in pairs(self.Guide.Data.NPCList) do 
        for i2 ,v2 in pairs(v.Levels) do 
            if v2 == p1 then 
				return {
                    Index = i , 
                    Value = v ,
                    MonPosition = PositionMon or nil ,
                }
            end
        end
    end
    
end

function QuestManager:GetQuest()  
	QuestManager.LevelReq()
    local Data = {} ;

    local M_Data = self.MyData() ;
 
    local p1 , p2
    
    if Double_Quest  then 
        p1 = math.max(unpack(QuestManager.BagNumber)) ; 
    else
        p1 = QuestManager.LevelReq()
    end
    
    table.sort(QuestManager.BagNumber)

    for i ,v in pairs(QuestManager.BagNumber) do 
       if v == p1 then continue end ;
	   p2 = v 
    end

    if not p2 then p2 = p1 end 

    -- p2 = QuestManager.BagNumber[2]

    if Double_Quest then 
		if not QuestManager.DataData[M_Data[p1].Value.LevelReq].Used then 
			Data[M_Data[p1].Value.LevelReq] = {
				  Mon = self:FindIndex(M_Data[p1].Value.Task) ,
				  NameQuest = M_Data[p1].Index ,
				  NumberQuest = self:FindData(M_Data[p1].Index,M_Data[p1].Value.LevelReq).Index,
				  CFrameQuest = self:Npcs(M_Data[p1].Value.LevelReq,M_Data[p1].Value.Task).Index.CFrame  ,   
				  CFrameMon = self:Npcs(M_Data[p1].Value.LevelReq,M_Data[p1].Value.Task).MonPosition  , 
			  }
		  else
            -- if not p2 then  
            Data[M_Data[p2].Value.LevelReq] = {
				  Mon = self:FindIndex(M_Data[p2].Value.Task) ,
				  NameQuest = M_Data[p2].Index ,
				  NumberQuest = self:FindData(M_Data[p2].Index,M_Data[p2].Value.LevelReq).Index,
				  CFrameQuest = self:Npcs(M_Data[p2].Value.LevelReq,M_Data[p2].Value.Task).Index.CFrame  ,   
				  CFrameMon = self:Npcs(M_Data[p2].Value.LevelReq,M_Data[p2].Value.Task).MonPosition  , 
			  }
		  end
	  else
        C = p2 
		  Data[M_Data[C].Value.LevelReq] = {
			  Mon = self:FindIndex(M_Data[C].Value.Task) ,
			  NameQuest = M_Data[C].Index ,
			  NumberQuest = self:FindData(M_Data[C].Index,M_Data[C].Value.LevelReq).Index , 
			  CFrameQuest = self:Npcs(M_Data[C].Value.LevelReq,M_Data[C].Value.Task).Index.CFrame  ,   
			  CFrameMon = self:Npcs(M_Data[C].Value.LevelReq,M_Data[C].Value.Task).MonPosition  , 
		  } 
    end

    return self:FindIndex(Data) , Data 
end  ; 

local Level , Data  = QuestManager:GetQuest()

function getnear(name) 
    if not name:match("Lv. ") then return end 
    local namenew = name:split("Lv. ")[2]:split("]")[1]

    local MyLevel ; 
    if not QuestManager.CustomLevel then 
        MyLevel =  game.Players.LocalPlayer.Data.Level.Value 
    else
        MyLevel = QuestManager.CustomLevel
    end

    if FirstSea and MyLevel > 675  then 
        MyLevel = 675 
    elseif SecondSea and MyLevel > 1450 then 
        MyLevel = 1475 
    elseif MyLevel >= 2525 then 
        MyLevel = 2525
    else
        MyLevel = MyLevel
    end

    local frist = namenew:split("")[1] ; 

    namenew = tonumber(namenew)

    local list = { 
        "Shanda" ,
        "Royal" ,
        "Gelley"
    }

    function c() 
        for i ,v in pairs(list) do 
            if name:match(v) then 
                return true 
            end
        end 
        return false 
    end 

    -- if compare_Level(25,250) and c() then 
    --     return true 
    -- end
    local Level = MyLevel ; 
    -- print(Level)
    if( ( (namenew >= Level and namenew - Level < 75 ) or (namenew <= Level and Level - namenew  < 75) )  or (c() or frist == tostring(Level):split("")[1] ) ) and #tostring(Level) == #tostring(namenew) then 
        return true 
    else
        return false 
    end

end  ; 

print(Data[Level].Mon)

function TP(P)
    Distance = (P.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 170 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = P
        Speed = 350
    elseif Distance < 1000 then
        Speed = 350
    elseif Distance >= 1000 then
        Speed = 250
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = P}
    ):Play()

    function cancelTween()
        tween:Cancel()
    end
end

local network = loadstring(game:HttpGet('https://raw.githubusercontent.com/hajibeza/File/main/Network.lua'))()

function Check_Near_Mon(Monster)
    local Table_Monster = Monster
    if type(Monster) == "string" then Table_Monster = {Monster} end
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if table.find(Table_Monster,v.Name) then
            return v
        end
    end
    for i,v in pairs(game.ReplicatedStorage:GetChildren()) do
        if table.find(Table_Monster,v.Name) then    
            return v
        end
    end
    return nil
end

function Check_Available_Mon(index)
    if index:FindFirstChild("HumanoidRootPart") and index:FindFirstChild("Humanoid") and index.Humanoid.Health > 0 then
        return true
    end
    return false
end

Use_Remote = function(...)
    local ARGS = {...}
    local Data = network:Send("CommF_",...)
    if ARGS[1] == "requestEntrance" then
        CollectionService:AddTag(game.Players.LocalPlayer,"Teleporting")
        task.delay(3,function()
            CollectionService:RemoveTag(game.Players.LocalPlayer,"Teleporting")
        end)
        wait(.25)
    end
    return Data
end

isnetworkowner = isnetworkowner or function(part)
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        local Distance = math.clamp(game.Players.LocalPlayer.SimulationRadius,0,1250)
        local MyDist = game.Players.LocalPlayer:DistanceFromCharacter(part.Position)
        if MyDist < Distance then
            for i,v in pairs(game.Players:GetPlayers()) do
                if v:DistanceFromCharacter(part.Position) < MyDist and v ~= game.Players.LocalPlayer then
                    return false
                end
            end
            return true
        end
    end
end

BringMob = function(Pos, MonName)
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and (v.Name == MonName) then
            if isnetworkowner(v.HumanoidRootPart) then
                v.Humanoid.Sit = true
                v.Humanoid.WalkSpeed = 0 
                v.Humanoid.PlatformStand = true
                v.Humanoid:ChangeState(11)
                v.HumanoidRootPart.CanCollide = false
                v.HumanoidRootPart.CFrame = Pos
                if not v.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = v.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000,100000,100000)
                    Noclip.Velocity = Vector3.new(0,0,0)
                end
            end
        end
    end
end

function Noclip(Value)
    if not Value or Value == false then
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy();
        end
    end
    if Value then
        -- setfflag("HumanoidParallelRemoveNoPhysics", "False")
        -- setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
        -- game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
        if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit = false
        end
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            local Noclip = Instance.new("BodyVelocity")
            Noclip.Name = "BodyClip"
            Noclip.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            Noclip.MaxForce = Vector3.new(100000,100000,100000)
            Noclip.Velocity = Vector3.new(0,0,0)
        end
    end
end

function Equip_Tool(Tool)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(Tool) then 
        local ToolHumanoid = game.Players.LocalPlayer.Backpack:FindFirstChild(Tool) 
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(ToolHumanoid) 
    end
end

function Check_Raid_Chip()
    local Backpack = game.Players.LocalPlayer.Backpack:GetChildren()
    for i=1,#Backpack do local v = Backpack[i]
        if v.Name:lower():find("microchip") then
            return true
        end
    end
    local Character = game.Players.LocalPlayer.Character:GetChildren()
    for i=1,#Character do local v = Character[i]
        if v:IsA("Tool") and v.Name:lower():find("microchip") then
            return true
        end
    end
end

function Raiding()
    return game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible or StartingRaid
end

function Start_Attack(Entity_Name,Entity_Part,Expression)
    local Expression = Expression or function() return true end
    local Success,Error = pcall(function()
        repeat task.wait(0.02)
            Noclip(true)
            NeedAttacking = true
            Equip_Tool(Current_Weapon)
            BringMob(Entity_Part.CFrame,Entity_Name)
            Entity_Part.CanCollide = false
            TP(Entity_Part.CFrame * CFrame.new(0,30,0))
        until Expression()
    end)
    if not Success then warn(Error) end
    NeedAttacking = false
end

Double_Quest = true

setscriptable(game.Players.LocalPlayer,"SimulationRadius",true)
spawn(function()
    while game:GetService("RunService").Stepped:Wait() do
        game.Players.LocalPlayer.SimulationRadius = math.huge
    end
end)

spawn(function(InitializeService)
    for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
        v:Disable() 
    end
    game.Players.LocalPlayer.Idled:connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
    while wait(300) do
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

local MIDN = loadstring(game:HttpGet('https://raw.githubusercontent.com/hajibeza/RIPPER/main/TESTGUI.lua'))();

local MIDN = MIDN:Window("RIPPER HUB Mobile Script")

local MIDNServer = MIDN:Server("Blox Fruit",7040391851)

local MainTab = MIDNServer:Channel("Main")
local StatsTab = MIDNServer:Channel("Stats")
local RaidTab = MIDNServer:Channel("Raid")

MainTab:Toggle("Auto Farm Level",false,function(value)
	Auto_Farm_Level = value
    Noclip(false)
end)

spawn(function() 
    while wait(.1) do
        pcall(function()
            if Auto_Farm_Level then
                Noclip(true)
                local MyLevel = game.Players.LocalPlayer.Data.Level.Value
                if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then 
                    if Double_Quest then 
                        Level , Data = QuestManager:GetQuest()  
                        if not QuestManager.DataData[Level].Used then 
                            QuestManager.DataData[Level].Used = true 
                        end
                        if MyLevel > 10 then repeat wait(.1) TP(Data[Level].CFrameQuest) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Data[Level].CFrameQuest.Position).Magnitude <= 3 or not Auto_Farm_Level end
                        wait(.5)
                        if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                        wait(.5)
                    else
                        Level , Data = QuestManager:GetQuest()  
                        if MyLevel > 10 then repeat wait(.1) TP(Data[Level].CFrameQuest) until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Data[Level].CFrameQuest.Position).Magnitude <= 3 or not Auto_Farm_Level end
                        wait(.5)
                        if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                        wait(.5)
                    end
                end
            
                if not Check_Near_Mon(Data[Level].Mon) then
                    for i,v in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                        if v.Name == Data[Level].Mon or v.Name:match(Data[Level].Mon) then 
                            repeat task.wait(.1) 
                                if not Auto_Farm_Level then break end
                                TP(v.CFrame * CFrame.new(0,30,0))
                            until Check_Near_Mon(Data[Level].Mon) or (v.CFrame.Position - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= 70
                        end
                    end
                end
            
                if not Data[Level].Mon or (not Data[Level].CFrameMon and not Check_Near_Mon(Data[Level].Mon)) then return end 
            
                if Check_Near_Mon(Data[Level].Mon) then 
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Data[Level].Mon and Check_Available_Mon(v) then 
                            Start_Attack(v.Name,v.HumanoidRootPart,function()
                                return not Auto_Farm_Level or not Check_Available_Mon(v) or not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible
                            end)
                        end
                    end
                end
            end
        end)
    end
end)

if FirstSea then

    MainTab:Toggle("Auto Second Sea",false,function(value)
        Auto_Second_Sea = value
        Noclip(false)
    end)

    spawn(function()
        while wait() do
            if Auto_Second_Sea then
                local Remote = Use_Remote("DressrosaQuestProgress")
                local MyLevel = game.Players.LocalPlayer.Data.Level.Value 

                Noclip(true)

                if Remote.KilledIceBoss then return end
                if not FirstSea then return end
                if Auto_Farm_Level and MyLevel >= 700 and FirstSea then Auto_Farm_Level = false end

                if not Remote.TalkedDetective then
                    repeat task.wait(.1) 
                        Use_Remote("DressrosaQuestProgress","Detective")
                    until Check_Tool_Inventory("Key") or not Auto_Second_Sea
                end
                
                if not Remote.UsedKey then
                    repeat task.wait(.1) 
                        Use_Remote("DressrosaQuestProgress","UseKey")
                    until not Check_Tool_Inventory("Key") or not Auto_Second_Sea
                end

                if Remote.KilledIceBoss then
                    Use_Remote("TravelDressrosa")
                end

                if not Remote.KilledIceBoss and Remote.UsedKey then

                    if not Check_Near_Mon("Ice Admiral [Lv. 700] [Boss]") then
                        repeat task.wait(.1)
                            TP(game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral [Lv. 700] [Boss]").HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                        until Check_Near_Mon("Ice Admiral [Lv. 700] [Boss]") or not Auto_Second_Sea
                    end

                    if Check_Near_Mon("Ice Admiral [Lv. 700] [Boss]") then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == "Ice Admiral [Lv. 700] [Boss]" and Check_Available_Mon(v) then
                                Start_Attack(v.Name,v.HumanoidRootPart,function()
                                    return not Auto_Second_Sea or not Check_Near_Mon("Ice Admiral [Lv. 700] [Boss]") or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)

end

MainTab:Line()

MainTab:Label("Misc Farm")

if FirstSea then

elseif SecondSea then

elseif ThirdSea then

    MainTab:Toggle("Auto Cake Prince",false,function(value)
        Auto_Cake_Prince = value
        Noclip(false)
    end)

    spawn(function()
        while wait(.1) do
            if Auto_Cake_Prince then

                local Remote_Cake_Prince = Use_Remote("CakePrinceSpawner")

                if string.find(Remote_Cake_Prince,"Do you want to open") then Use_Remote("CakePrinceSpawner") end

                if not Check_Near_Mon("Cake Prince") then
                    Mon_Cake = {"Baking Staff","Head Baker","Cake Guard","Cookie Crafter"}

                    if not Check_Near_Mon(Mon_Cake) then
                        TP(CFrame.new(-2037.00171, 57.8413582, -12550.6748, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                    end

                    if Check_Near_Mon(Mon_Cake) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if table.find(Mon_Cake,v.Name) and Check_Available_Mon(v) then
                                Start_Attack(v.Name,v.HumanoidRootPart,function()
                                    return not Auto_Cake_Prince or not Check_Near_Mon(Mon_Cake) or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                end

                if Check_Near_Mon("Cake Prince") then

                    if not workspace.Enemies:FindFirstChild("Cake Prince") then
                        repeat wait()
                            if game.ReplicatedStorage:FindFirstChild("Cake Prince") then
                                TP(game.ReplicatedStorage:FindFirstChild("Cake Prince").HumanoidRootPart.CFrame)
                            end
                        until not Auto_Cake_Prince or not Check_Near_Mon("Cake Prince")
                    end

                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == "Cake Prince" and Check_Available_Mon(v) then
                            Start_Attack(v.Name,v.HumanoidRootPart,function()
                                return not Auto_Cake_Prince or not Check_Near_Mon("Cake Prince") or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end

            end
        end
    end)

end

MainTab:Line()

MainTab:Label("Setting Farm")

MainTab:Toggle("Fast Attack",true,function(value)
    NewFastAttack = value
    NoAttackAnimation = value
    FastAttack = value
end)

MainTab:Toggle("Auto Buso",true,function(value)
    Auto_Buso = value
    spawn(function()
        while wait() do
            if Auto_Buso then
                if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
                    Use_Remote("Buso")
                end 
            end
        end
    end)
end)

local Code = {
	"EXP_5B",
	"CONTROL",
	"UPDATE11",
	"XMASEXP",
	"1BILLION",
	"ShutDownFix2",
	"UPD14",
	"STRAWHATMAINE",
	"TantaiGaming",
	"Colosseum",
	"Axiore",
	"Sub2Daigrock",
	"Sky Island 3",
	"Sub2OfficialNoobie",
	"SUB2NOOBMASTER123",
	"THEGREATACE",
	"Fountain City",
	"BIGNEWS",
	"FUDD10",
	"SUB2GAMERROBOT_EXP1",
	"UPD15",
	"2BILLION",
	"UPD16",
	"3BVISITS",
	"fudd10_v2",
	"Starcodeheo",
	"Magicbus",
	"JCWK",
	"Bluxxy",
	"Sub2Fer999",
	"Enyu_is_Pro",
	"GAMER_ROBOT_1M",
	"ADMINGIVEAWAY",
	"GAMERROBOT_YT",
	"kittgaming",
    "ADMIN_TROLL",
    "staffbattle",
    "youtuber_shipbattle",
    "Sub2CaptainMaui",
    "DEVSCOOKING",
}



MainTab:Slider("Level to Redeem Code", 1, 2525, 1, function(value)
	Redeem_Code_At_Level = value
end)

MainTab:Toggle("Auto Redeem Code [X2 EXP]",false,function(value)
    Auto_Redeem_Code = value
end)

spawn(function()
    while wait(.1) do
        if Auto_Redeem_Code then 
            for i,v in pairs(Code) do
                game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v)
            end
        end
    end
end)

local Weapon_Dropdown = MainTab:Dropdown("Weapon",{"Melee","Sword"}, function(value)
    Weapon = value
end)

spawn(function()
    while wait(.5) do
        pcall(function()
            for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if Weapon == "Melee" then 
                    if  v.ToolTip == "Melee" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            Current_Weapon = v.Name
                        end
                    end
                elseif Weapon == "Sword" then
                     if v.ToolTip == "Sword" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            Current_Weapon = v.Name
                        end
                    end
                elseif Weapon == "Devil Fruit" then 
                    if v.ToolTip == "Blox Fruit" then
                        if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                            Current_Weapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

CollectionService = game:GetService("CollectionService")
local Char = game.Players.LocalPlayer.Character
local Root = Char.HumanoidRootPart

Players = game.Players

local kkii = require(game.ReplicatedStorage.Util.CameraShaker)
kkii:Stop()

do -- Variable
    CurrentAllMob = {}
    recentlySpawn = 0
    StoredSuccessFully = 0
    canHits = {}
    RecentCollected = 0
    FruitInServer = {}
    RecentlyLocationSet = 0
    lastequip = tick()
end

do -- Module Requiring
    PC = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.Particle)
    RL = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
    DMG = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.Particle.Damage)
    RigC = getupvalue(require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.RigController),2)
    Combat =  getupvalue(require(game.Players.LocalPlayer.PlayerScripts.CombatFramework),2)
end

do -- Services
    RunService = game:GetService("RunService")
    CollectionService = game:GetService("CollectionService")
end

dist = function(a,b,noHeight)
    if not b then
        b = Root.Position
    end
    return (Vector3.new(a.X,not noHeight and a.Y,a.Z) - Vector3.new(b.X,not noHeight and b.Y,b.Z)).magnitude
end

do -- Starter Thread
    task.spawn(function()
        local stacking = 0
        local printCooldown = 0
        while wait(.075) do
            nearbymon = false
            table.clear(CurrentAllMob)
            table.clear(canHits)
            local mobs = CollectionService:GetTagged("ActiveRig")
            for i=1,#mobs do local v = mobs[i]
                local Human = v:FindFirstChildOfClass("Humanoid")
                if Human and Human.Health > 0 and Human.RootPart and v ~= Char then
                    local IsPlayer = game.Players:GetPlayerFromCharacter(v)
                    local IsAlly = IsPlayer and CollectionService:HasTag(IsPlayer,"Ally"..game.Players.LocalPlayer.Name)
                    if not IsAlly then
                        CurrentAllMob[#CurrentAllMob + 1] = v
                        if not nearbymon and dist(Human.RootPart.Position) < 65 then
                            nearbymon = true
                        end
                    end
                end
            end

            if nearbymon then
                local Enemies = workspace.Enemies:GetChildren()
                local Players = Players:GetPlayers()
                for i=1,#Enemies do local v = Enemies[i]
                    local Human = v:FindFirstChildOfClass("Humanoid")
                    if Human and Human.RootPart and Human.Health > 0 and dist(Human.RootPart.Position) < 65 then
                        canHits[#canHits+1] = Human.RootPart
                    end
                end
                for i=1,#Players do local v = Players[i].Character
                    if not Players[i]:GetAttribute("PvpDisabled") and v and v ~= game.Players.LocalPlayer.Character then
                        local Human = v:FindFirstChildOfClass("Humanoid")
                        if Human and Human.RootPart and Human.Health > 0 and dist(Human.RootPart.Position) < 65 then
                            canHits[#canHits+1] = Human.RootPart
                        end
                    end
                end
            end
        end
    end)
end

-- Initialize Fast Attack .
task.spawn(function()
    local Data = Combat
    local Blank = function() end
    local RigEvent = game:GetService("ReplicatedStorage").RigControllerEvent
    local Animation = Instance.new("Animation")
    local RecentlyFired = 0
    local AttackCD = 0
    local Controller
    local lastFireValid = 0
    local MaxLag = 350
    fucker = 0.07
    TryLag = 0
    local resetCD = function()
        local WeaponName = Controller.currentWeaponModel.Name
        local Cooldown = {
            combat = 0.07
        }
        AttackCD = tick() + (fucker and Cooldown[WeaponName:lower()] or fucker or 0.285) + ((TryLag/MaxLag)*0.3)
        RigEvent.FireServer(RigEvent,"weaponChange",WeaponName)
        TryLag += 1
        task.delay((fucker or 0.285) + (TryLag+0.5/MaxLag)*0.3,function()
            TryLag -= 1
        end)
    end

    if not shared.orl then shared.orl = RL.wrapAttackAnimationAsync end
    if not shared.cpc then shared.cpc = PC.play end
    if not shared.dnew then shared.dnew = DMG.new end
    if not shared.attack then shared.attack = RigC.attack end
    RL.wrapAttackAnimationAsync = function(a,b,c,d,func)
        if not NoAttackAnimation and not NeedAttacking then
            PC.play = shared.cpc
            return shared.orl(a,b,c,65,func)
        end
        local Radius = (DamageAura and DamageAuraRadius) or 65
        if canHits and #canHits > 0 then
            PC.play = function() end
            a:Play(0.00075,0.01,0.01)
            func(canHits)
            wait(a.length * 0.5)
            a:Stop()
        end
    end

    while RunService.Stepped:Wait() do
        if #canHits > 0 then
            Controller = Data.activeController
            if NormalClick then
                pcall(task.spawn,Controller.attack,Controller)
                continue
            end
            if Controller and Controller.equipped and (not game.Players.LocalPlayer.Character.Busy.Value or game.Players.LocalPlayer.PlayerGui.Main.Dialogue.Visible) and game.Players.LocalPlayer.Character.Stun.Value < 1 and Controller.currentWeaponModel then
                if (NeedAttacking or DamageAura) then
                    if NewFastAttack and tick() > AttackCD and not DisableFastAttack then
                        resetCD()
                    end
                    if tick() - lastFireValid > 0.5 or not FastAttack then
                        Controller.timeToNextAttack = 0
                        Controller.hitboxMagnitude = 65
                        pcall(task.spawn,Controller.attack,Controller)
                        lastFireValid = tick()
                        continue
                    end
                    local AID3 = Controller.anims.basic[3]
                    local AID2 = Controller.anims.basic[2]
                    local ID = AID3 or AID2
                    Animation.AnimationId = ID
                    local Playing = Controller.humanoid:LoadAnimation(Animation)
                    Playing:Play(0.00075,0.01,0.01)
                    RigEvent.FireServer(RigEvent,"hit",canHits,AID3 and 3 or 2,"")
                    -- AttackSignal:Fire()
                    delay(.5,function()
                        Playing:Stop()
                    end)
                end
            end
        end
    end
end)

-- [Stats] --

StatsTab:Toggle("Auto Stats Kaitun [Fruit]",false,function(value)
	Auto_Stats_Kaitun_Sword = value
end)

StatsTab:Toggle("Auto Stats Kaitun [Gun]",false,function(value)
	Auto_Stats_Kaitun_Gun = value
end)

StatsTab:Toggle("Auto Stats Kaitun [Devil Fruit]",false,function(value)
	Auto_Stats_Kaitun_Devil_Fruit = value
end)

StatsTab:Line()

StatsTab:Toggle("Auto Stats Kaitun [Devil Fruit]",false,function(value)
	Auto_Stats_Kaitun_Devil_Fruit = value
end)

spawn(function()
    while wait(.5) do
        pcall(function()
            if Auto_Stats_Kaitun_Sword or Auto_Stats_Kaitun_Gun or Auto_Stats_Kaitun_Devil_Fruit then
                if game.Players.LocalPlayer.Data.Stats.Defense.Level.Value == 2450 then return end
                if game.Players.LocalPlayer.Data.Stats.Melee.Level.Value < 2450 then
                    Use_Remote("AddPoint","Melee",Stats_Point)
                end
                if game.Players.LocalPlayer.Data.Stats.Melee.Level.Value == 2450 then
                    Use_Remote("AddPoint","Defense",Stats_Point)
                end
                if game.Players.LocalPlayer.Data.Stats.Defense.Level.Value == 2450 then
                    if Auto_Stats_Kaitun_Sword then Use_Remote("AddPoint","Sword",Stats_Point) end
                    if Auto_Stats_Kaitun_Gun then Use_Remote("AddPoint","Gun",Stats_Point) end
                    if Auto_Stats_Kaitun_Devil_Fruit then Use_Remote("AddPoint","Demon Fruit",Stats_Point) end
                end
            end
        end)
    end
end)

-- [Raid] --

local All_Raid_Chip = {}
local All_Raid = require(game:GetService("ReplicatedStorage").Raids)
local Advance_Raid = All_Raid.advancedRaids
local Normal_Raid = All_Raid.raids

for i,v in pairs(Advance_Raid) do
    table.insert(All_Raid_Chip,v) 
end
for i,v in pairs(Normal_Raid) do
    table.insert(All_Raid_Chip,v)
end

local Chip_Dropdown = RaidTab:Dropdown("Select Dungeon",All_Raid_Chip, function(value)
    Raid_Chip = value
end)

RaidTab:Line()

RaidTab:Toggle("Auto Start Raid",false,function(value)
	Auto_Start_Raid = value
    Noclip(false)
end)

spawn(function()
    while wait(1) do
        if Auto_Start_Raid then

            if not Check_Raid_Chip() then
                Use_Remote("RaidsNpc","Select",Raid_Chip)
            end

            if Check_Raid_Chip() and not Raiding() then
                wait(3)
                fireclickdetector(workspace.Map:FindFirstChild("RaidSummon2",true).Button.Main.ClickDetector)
                local ID = game:GetService("HttpService"):GenerateGUID()
                RaidID = ID
                StartingRaid = true 
                task.delay(60,function()
                    if RaidID == ID then
                        StartingRaid = false
                    end
                end)
            end
        end
    end
end)

RaidTab:Toggle("Auto Finish Raid",false,function(value)
	Auto_Finish_Raid = value
    Noclip(false)
end)

function Kill_Aura()
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if Check_Available_Mon(v) then
            repeat wait()
                v.Humanoid.Health = 0
                v.HumanoidRootPart.CanCollide = false
            until not Auto_Finish_Raid or not Check_Available_Mon(v)
        end
    end
end

spawn(function()
    while wait(1) do
        if Auto_Finish_Raid and Raiding() then
            Noclip(true)
            Kill_Aura()
            if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 5"].Position).Magnitude <= 3000 then
                TP(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame * CFrame.new(0,70,100))
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 4"].Position).Magnitude <= 3000 then
                TP(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame * CFrame.new(0,70,100))
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 3"].Position).Magnitude <= 3000 then
                TP(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame * CFrame.new(0,70,100))
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 2"].Position).Magnitude <= 3000 then
                TP(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame * CFrame.new(0,70,100))
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 1"].Position).Magnitude <= 3000 then
                TP(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame * CFrame.new(0,70,100))
            end
        end
    end
end)
