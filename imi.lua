local placeId = game.PlaceId
if placeId == 2753915549 then
	FirstSea = true
elseif placeId == 4442272183 then
	SecondSea = true
elseif placeId == 7449423635 then
	ThirdSea = true
end

local Player = game.Players
local Local_Player = Player.LocalPlayer
local Char = Local_Player.Character
local Root = Char.HumanoidRootPart
Players = game.Players

CanTeleport = {
    {
        ["Sky3"] = Vector3.new(-7894, 5547, -380),
        ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
        ["UnderWater"] = Vector3.new(61163, 11, 1819),
        ["UnderwaterExit"] = Vector3.new(4050, -1, -1814),
    },
    {
        ["Swan Mansion"] = Vector3.new(-390, 332, 673),
        ["Swan Room"] = Vector3.new(2285, 15, 905),
        ["Cursed Ship"] = Vector3.new(923, 126, 32852),
    },
    {
        ["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
        ["Hydra Island"] = Vector3.new(5745, 610, -267),
        ["Mansion"] = Vector3.new(-12462, 375, -7552),
        ["Castle"] = Vector3.new(-5036, 315, -3179),
    }
}

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
		MyLevel =  Local_Player.Data.Level.Value 
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
        MyLevel =  Local_Player.Data.Level.Value 
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
    Distance = (P.Position - Local_Player.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 170 then
        Local_Player.Character.HumanoidRootPart.CFrame = P
        Speed = 350
    elseif Distance < 1000 then
        Speed = 350
    elseif Distance >= 1000 then
        Speed = 250
    end
    
    game:GetService("TweenService"):Create(
        Local_Player.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = P}
    ):Play()

    function cancelTween()
        tween:Cancel()
    end
end

dist = function(Position_a,Position_b,noHeight)
    local pa,pb = pcall(function()
        if Local_Player.Character:FindFirstChild("HumanoidRootPart") then
            Position_b = Local_Player.Character.HumanoidRootPart.Position
        end
    end)
    if not pa then warn(pb) end
    return (Vector3.new(Position_a.X,not noHeight and Position_a.Y,Position_a.Z) - Vector3.new(Position_b.X,not noHeight and Position_b.Y,Position_b.Z)).magnitude
end

function Go_to_Part(Part,State_Ment) 
    local State_Ment = State_Ment or function() return true end
    if dist(Part.Position) > 10 and State_Ment() then
        Need_Noclip = true
        repeat wait() TP(CFrame.new(Part.Position)) until dist(Part.Position) < 10 or not State_Ment()
        Need_Noclip = false
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
        CollectionService:AddTag(Local_Player,"Teleporting")
        task.delay(3,function()
            CollectionService:RemoveTag(Local_Player,"Teleporting")
        end)
        wait(.25)
    end
    return Data
end

isnetworkowner = isnetworkowner or function(part)
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        local Distance = math.clamp(Local_Player.SimulationRadius,0,1250)
        local MyDist = Local_Player:DistanceFromCharacter(part.Position)
        if MyDist < Distance then
            for i,v in pairs(game.Players:GetPlayers()) do
                if v:DistanceFromCharacter(part.Position) < MyDist and v ~= Local_Player then
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

function Equip_Tool(Tool)
    if Check_Tool_Inventory(Tool) then 
        local ToolHumanoid = Local_Player.Backpack:FindFirstChild(Tool)
        Local_Player.Character.Humanoid:EquipTool(ToolHumanoid) 
    end
end

function Check_Raid_Chip()
    local Backpack = Local_Player.Backpack:GetChildren()
    for i=1,#Backpack do local v = Backpack[i]
        if v.Name:lower():find("microchip") then
            return true
        end
    end
    local Character = Local_Player.Character:GetChildren()
    for i=1,#Character do local v = Character[i]
        if v:IsA("Tool") and v.Name:lower():find("microchip") then
            return true
        end
    end
end

function Raiding()
    return Local_Player.PlayerGui.Main.Timer.Visible or StartingRaid
end

function Start_Attack(Entity_Name,Entity_Part,Expression)
    local Expression = Expression or function() return true end
    local Success,Error = pcall(function()
        repeat task.wait(0.02)
            Need_Noclip = true
            NeedAttacking = true
            Equip_Tool(Current_Weapon)
            BringMob(Entity_Part.CFrame,Entity_Name)
            Entity_Part.CanCollide = false
            TP(Entity_Part.CFrame * CFrame.new(0,30,0))
        until Expression()
    end)
    if not Success then warn(Error) end
    NeedAttacking = false
    Need_Noclip = false
end

function Server_Hop(Value)
	pcall(function()
        local Massage = Instance.new("Message",workspace)
        Massage.Text = "Server Hop | "..Value
		for count = math.random(1, math.random(40, 75)), 100 do
			remote = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(count)
			for _i ,v in pairs(remote) do
				if tonumber(v['Count']) < 12 then
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _i)
				end
			end    
		end
	end)
end

function Check_Any_Remote(Name)
    local Remote_Inventory = Use_Remote("getInventory")
    for i,v in pairs(Remote_Inventory) do
        if v.Name == Name then
            return true
        end
    end
    return false
end

function Check_Tool_Inventory(Tool_Name)
    if Local_Player.Backpack:FindFirstChild(Tool_Name) or Local_Player.Character:FindFirstChild(Tool_Name) then
        return true
    end
    return false
end

setscriptable(Local_Player,"SimulationRadius",true)
spawn(function()
    while game:GetService("RunService").Stepped:Wait() do
        Local_Player.SimulationRadius = math.huge
    end
end)

spawn(function()
    while game:GetService("RunService").Stepped:Wait() do
        if Need_Noclip and Local_Player.Character.Humanoid.Health > 0 then
            -- setfflag("HumanoidParallelRemoveNoPhysics", "False")
            -- setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
            -- Local_Player.Character.Humanoid:ChangeState(11)
            if Local_Player.Character:WaitForChild("Humanoid").Sit then
                Local_Player.Character:WaitForChild("Humanoid").Sit = false
            end
            for _, v in pairs(Local_Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
            if not Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                local Noclip = Instance.new("BodyVelocity")
                Noclip.Name = "BodyClip"
                Noclip.Parent = Local_Player.Character.HumanoidRootPart
                Noclip.MaxForce = Vector3.new(100000,100000,100000)
                Noclip.Velocity = Vector3.new(0,0,0)
            end
        else
            if Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy();
            end
        end
    end
end)

spawn(function(InitializeService)
    for i,v in pairs(getconnections(Local_Player.Idled)) do
        v:Disable() 
    end
    Local_Player.Idled:connect(function()
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
end)

spawn(function() 
    while wait(.1) do
        pcall(function()
            if Auto_Farm_Level then
                local MyLevel = Local_Player.Data.Level.Value
                if not Local_Player.PlayerGui.Main.Quest.Visible then 
                    if Double_Quest then 
                        Level , Data = QuestManager:GetQuest()  
                        if not QuestManager.DataData[Level].Used then 
                            QuestManager.DataData[Level].Used = true 
                        end
                        if MyLevel > 10 then Go_to_Part(Data[Level].CFrameQuest,function() return Auto_Farm_Level or (Local_Player.Character.HumanoidRootPart.Position - Data[Level].CFrameQuest.Position).Magnitude >= 3 end) end
                        wait(.5)
                        if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                        wait(.5)
                    else
                        Level , Data = QuestManager:GetQuest()  
                        if MyLevel > 10 then Go_to_Part(Data[Level].CFrameQuest,function() return Auto_Farm_Level or (Local_Player.Character.HumanoidRootPart.Position - Data[Level].CFrameQuest.Position).Magnitude >= 3 end) end
                        wait(.5)
                        if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                        wait(.5)
                    end
                end
            
                if not Check_Near_Mon(Data[Level].Mon) then
                    for i,v in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                        if v.Name == Data[Level].Mon or v.Name:match(Data[Level].Mon) then 
                            Go_to_Part(v.CFrame * CFrame.new(0,30,0),function() return Auto_Farm_Level or not Check_Near_Mon(Data[Level].Mon) or (v.CFrame.Position - Local_Player.Character:WaitForChild("HumanoidRootPart").Position).magnitude >= 70 end)
                        end
                    end
                end
            
                if not Data[Level].Mon or (not Data[Level].CFrameMon and not Check_Near_Mon(Data[Level].Mon)) then return end 
            
                if Check_Near_Mon(Data[Level].Mon) then 
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Data[Level].Mon and Check_Available_Mon(v) then 
                            Start_Attack(v.Name,v.HumanoidRootPart,function()
                                return not Auto_Farm_Level or not Check_Available_Mon(v) or not Local_Player.PlayerGui.Main.Quest.Visible
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
    end)

    spawn(function()
        while wait() do
            if Auto_Second_Sea then
                pcall(function()
                    local Remote = Use_Remote("DressrosaQuestProgress")
                    local MyLevel = Local_Player.Data.Level.Value 

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
                        
                        if Check_Near_Mon("Ice Admiral") and not workspace.Enemies:FindFirstChild("Ice Admiral") then
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral") then
                                repeat task.wait(.1)
                                    Go_to_Part(game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral").HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return Auto_Second_Sea end)
                                until workspace.Enemies:FindFirstChild("Ice Admiral") or not Auto_Second_Sea
                            end
                        end

                        if Check_Near_Mon("Ice Admiral") and workspace.Enemies:FindFirstChild("Ice Admiral") then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == "Ice Admiral" and Check_Available_Mon(v) then
                                    Start_Attack(v.Name,v.HumanoidRootPart,function()
                                        return not Auto_Second_Sea or not Check_Near_Mon("Ice Admiral") or not Check_Available_Mon(v)
                                    end)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

elseif SecondSea then

    MainTab:Toggle("Auto Third Sea",false,function(value)
        Auto_Third_Sea = value
    end)

    spawn(function()
        while wait(.1) do
            if Auto_Third_Sea then
                pcall(function()
                    if not SecondSea then return end
                    local Remote_Rip = Use_Remote("ZQuestProgress")
                    local Remote_Check_Rip = Use_Remote("ZQuestProgress","Check")
                    local Remote_Swan = Use_Remote("GetUnlockables")

                    if Remote_Rip.KilledIndraBoss then Use_Remote("TravelZou") end

                    if not Remote_Rip.KilledIndraBoss then

                        if not Remote_Swan.FlamingoAccess then
                            local Remote_Inventory = Use_Remote("getInventoryFruits")
                            local Cheapest_Fruit = {Price = 1/0}

                            for i,v in pairs(Remote_Inventory) do
                                if v.Price >= 1000000 and v.Price < Cheapest_Fruit.Price then
                                    Cheapest_Fruit = v
                                end
                            end

                            if Cheapest_Fruit.Name then
                                Use_Remote("LoadFruit",Cheapest_Fruit.Name)
                                Use_Remote("TalkTrevor","1")
                                Use_Remote("TalkTrevor","2")
                                Use_Remote("TalkTrevor","3")
                            end
                        end

                        if not Remote_Check_Rip and Remote_Swan.FlamingoAccess then
                            Don_Swan = "Don Swan"

                            if not Check_Near_Mon(Don_Swan) and Enable_Server_Hop then
                                Server_Hop("Finding Don Swan")
                            end

                            if Check_Near_Mon(Don_Swan) and not workspace.Enemies:FindFirstChild(Don_Swan) then
                                if game.ReplicatedStorage:FindFirstChild(Don_Swan) then
                                    repeat task.wait(.1)
                                        Go_to_Part(game:GetService("ReplicatedStorage")[Don_Swan].HumanoidRootPart.CFrame,function() return Auto_Third_Sea end)
                                    until workspace.Enemies:FindFirstChild(Don_Swan) or not Auto_Third_Sea
                                end
                            end

                            if Check_Near_Mon(Don_Swan) and workspace.Enemies:FindFirstChild(Don_Swan) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Don_Swan and Check_Available_Mon(v) then
                                        Start_Attack(v.Name,v.HumanoidRootPart,function()
                                            return not Auto_Third_Sea or not Check_Near_Mon(Don_Swan) or not Check_Available_Mon(v)
                                        end)
                                    end
                                end
                            end
                        end

                        if Remote_Check_Rip then
                            rip_indra = "rip_indra"
                            if not Check_Near_Mon(rip_indra) and Enable_Server_Hop then
                                Server_Hop("Finding Rip_Indra")
                            end

                            if Check_Near_Mon(rip_indra) and not workspace.Enemies:FindFirstChild(rip_indra) then
                                if game.ReplicatedStorage:FindFirstChild(rip_indra) then
                                    repeat task.wait(.1)
                                        Go_to_Part(game:GetService("ReplicatedStorage")[rip_indra].HumanoidRootPart.CFrame,function() return Auto_Third_Sea end)
                                    until workspace.Enemies:FindFirstChild(rip_indra) or not Auto_Third_Sea
                                end
                            end

                            if Check_Near_Mon(rip_indra) and workspace.Enemies:FindFirstChild(rip_indra) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == rip_indra and Check_Available_Mon(v) then
                                        Start_Attack(v.Name,v.HumanoidRootPart,function()
                                            return not Auto_Third_Sea or not Check_Near_Mon(rip_indra) or not Check_Available_Mon(v)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

end

MainTab:Line()

MainTab:Label("Misc Farm")

if FirstSea then

    MainTab:Toggle("Auto Pole [V1]",false,function(value)
        Auto_Saber = value
    end)

    spawn(function()
        while wait(.1) do 
            if Auto_Saber then
                pcall(function()
                    local Remote_Check_Saber = Use_Remote("ProQuestProgress")
                    local QuestPlates_Folder = workspace.Map.Jungle.QuestPlates


                    if not FirstSea then return end
                    if Remote_Check_Saber.KilledShanks and not Auto_Farm_Level_Other then return end
                    if Remote_Check_Saber.KilledShanks and Auto_Farm_Level_Other then Auto_Farm_Level = true end
                    if Auto_Farm_Level_Other and Local_Player.Data.Level.Value >= 200 then Auto_Farm_Level = false end
                    if Local_Player.Data.Level.Value <= 200 then return end

                    for i = 1,#Remote_Check_Saber.Plates do
                        if not Remote_Check_Saber.Plates[i] then
                            Use_Remote("ProQuestProgress","Plate",i)
                        end
                    end

                    if not Remote_Check_Saber.KilledShanks then
                        if not Remote_Check_Saber.UsedTorch then 
                            repeat wait() Use_Remote("ProQuestProgress","GetTorch") until Check_Tool_Inventory("Torch") 
                            repeat wait() Use_Remote("ProQuestProgress","DestroyTorch") until not Check_Tool_Inventory("Torch") 
                        end

                        if Remote_Check_Saber.UsedTorch and not Remote_Check_Saber.UsedCup then
                            repeat wait() Use_Remote("ProQuestProgress","GetCup") until Check_Tool_Inventory("Cup") 
                            repeat wait() Use_Remote("ProQuestProgress","FillCup",Local_Player.Backpack.Cup) Use_Remote("ProQuestProgress","SickMan") until not Check_Tool_Inventory("Cup") 
                        end

                        if Remote_Check_Saber.UsedCup and not Remote_Check_Saber.TalkedSon then
                            Use_Remote("ProQuestProgress","RichSon")
                        end

                        if Remote_Check_Saber.TalkedSon and not Remote_Check_Saber.KilledMob then
                            local Mon_Leader = "Mob Leader"

                            if not Check_Near_Mon(Mon_Leader) and Enable_Server_Hop then
                                Server_Hop("Find Mon Leader")
                            end

                            if Check_Near_Mon(Mon_Leader) and not workspace.Enemies:FindFirstChild(Mon_Leader) then
                                if game.ReplicatedStorage:FindFirstChild(Mon_Leader) then
                                    repeat task.wait(.1)
                                        Go_to_Part(game:GetService("ReplicatedStorage")[Mon_Leader].HumanoidRootPart.CFrame,function() return Auto_Saber end)
                                    until workspace.Enemies:FindFirstChild(Mon_Leader) or not Auto_Saber
                                end
                            end

                            if Check_Near_Mon(Mon_Leader) and workspace.Enemies:FindFirstChild(Mon_Leader) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Mon_Leader and Check_Available_Mon(v) then
                                        Start_Attack(v.Name,v.HumanoidRootPart,function()
                                            return not Auto_Saber or not Check_Near_Mon(Mon_Leader) or not Check_Available_Mon(v)
                                        end)
                                    end
                                end
                            end
                        end

                        if Remote_Check_Saber.KilledMob and not Remote_Check_Saber.UsedRelic then
                            repeat wait() Use_Remote("ProQuestProgress","RichSon") until Check_Tool_Inventory("Relic")
                            repeat wait() Use_Remote("ProQuestProgress","PlaceRelic") until not Check_Tool_Inventory("Relic")
                        end

                        if Remote_Check_Saber.UsedRelic and not Remote_Check_Saber.KilledShanks then
                            local Saber_Expert = "Saber Expert"

                            if not Check_Near_Mon(Saber_Expert) and Enable_Server_Hop then
                                Server_Hop("Find Saber Expert")
                            end

                            if Check_Near_Mon(Saber_Expert) and not workspace.Enemies:FindFirstChild(Saber_Expert) then
                                if not game.ReplicatedStorage:FindFirstChild(Saber_Expert) then
                                    repeat task.wait(.1)
                                        Go_to_Part(game:GetService("ReplicatedStorage")[Saber_Expert].HumanoidRootPart.CFrame,function() return Auto_Saber end)
                                    until workspace.Enemies:FindFirstChild(Saber_Expert) or not Auto_Saber
                                end
                            end

                            if Check_Near_Mon(Saber_Expert) and workspace.Enemies:FindFirstChild(Saber_Expert) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Saber_Expert and Check_Available_Mon(v) then
                                        Start_Attack(v.Name,v.HumanoidRootPart,function()
                                            return not Auto_Saber or not Check_Near_Mon(Saber_Expert) or not Check_Available_Mon(v) or Remote_Check_Saber.KilledMob
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    MainTab:Toggle("Auto Pole [V1]",false,function(value)
        Auto_Pole = value
    end)

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Pole then
                    pcall(function()
                        if Check_Any_Remote("Pole (1st Form)") then return end
                        if not FirstSea then return end

                        local Thunder_God = "Thunder God"
                    
                        if not Check_Near_Mon(Thunder_God) and Enable_Server_Hop then
                            Server_Hop("Finding Thunder God")
                        end

                        if Check_Near_Mon(Thunder_God) and not workspace.Enemies:FindFirstChild(Thunder_God) then
                            if game.ReplicatedStorage:FindFirstChild(Thunder_God) then
                                repeat task.wait(.1)
                                    Go_to_Part(game:GetService("ReplicatedStorage")[Thunder_God].HumanoidRootPart.CFrame,function() return Auto_Pole end)
                                until workspace.Enemies:FindFirstChild(Thunder_God) or not Auto_Pole
                            end
                        end

                        if Check_Near_Mon(Thunder_God) and workspace.Enemies:FindFirstChild(Thunder_God) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Thunder_God and Check_Available_Mon(v) then
                                    Start_Attack(v.Name,v.HumanoidRootPart,function()
                                        return not Auto_Pole or not Check_Near_Mon(Thunder_God) or Check_Any_Remote("Pole (1st Form)") or not Check_Available_Mon(v)
                                    end)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end)

elseif SecondSea then

    MainTab:Toggle("Auto Factory",false,function(value)
        Auto_Factory = value
    end)

    spawn(function()
        while wait() do
            if Auto_Factory then
                pcall(function()
                    if not SecondSea then return end
                    local Factory = "Core"
                    
                    if not Check_Near_Mon(Factory) and Enable_Server_Hop then    
                        Server_Hop("Finding Factory")
                    end

                    if Check_Near_Mon(Factory) and not workspace.Enemies:FindFirstChild(Factory) then
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Factory) then
                            repeat task.wait(.1)
                                Go_to_Part(game:GetService("ReplicatedStorage")[Factory].HumanoidRootPart.CFrame,function() return Auto_Factory end)
                            until workspace.Enemies:FindFirstChild(Factory) or not Auto_Factory
                        end
                    end

                    if Check_Near_Mon(Factory) and workspace.Enemies:FindFirstChild(Factory) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Factory and Check_Available_Mon(v) then
                                Start_Attack(v.Name,v.HumanoidRootPart,function()
                                    return not Auto_Factory or not Check_Near_Mon(Factory) or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)

    MainTab:Toggle("Auto Rengoku",false,function(value)
        Auto_Rengoku = value
    end)

    spawn(function()
        while wait(.1) do
            if Auto_Rengoku then
                pcall(function()
                    if not SecondSea then return end
                    local Remote_Rengoku = Use_Remote("OpenRengoku")

                    if Remote_Rengoku then return end
                    
                    if Check_Tool_Inventory("Hidden Key") then
                        repeat task.wait(.1) Use_Remote("OpenRengoku") until not Check_Tool_Inventory("Hidden Key")
                    end

                    if not Check_Tool_Inventory("Hidden Key") then
                        local Rengoku_Mon = {"Snow Lurker","Arctic Warrior"}

                        if not Check_Near_Mon(Rengoku_Mon) then
                            repeat task.wait(.1)
                                Go_to_Part(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188),function() return Auto_Rengoku end)
                            until workspace.Enemies:FindFirstChild(Rengoku_Mon) or not Auto_Rengoku
                        end

                        if Check_Near_Mon(Rengoku_Mon) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if table.find(Rengoku_Mon,v.Name) and Check_Available_Mon(v) then 
                                    Start_Attack(v.Name,v.HumanoidRootPart,function()
                                        return not Auto_Rengoku or not Check_Near_Mon(Rengoku_Mon) or not Check_Available_Mon(v) or Check_Tool_Inventory("Hidden Key")
                                    end)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    MainTab:Toggle("Auto Evo Race [V2]",false,function(value)
        Auto_Evo_Race_V2 = value
    end)

    spawn(function()
        while wait() do
            if Auto_Evo_Race_V2 then
                if not SecondSea then return end

                local Path_Flower = {
                    workspace:FindFirstChild("Flower1"),
                    workspace:FindFirstChild("Flower2"),
                }
                local Remote_Evo_V2 = Use_Remote("Alchemist","3")

                if Use_Remote("Alchemist","1") == 0 then Use_Remote("Alchemist","2") end

                if Remote_Evo_V2 and Remote_Evo_V2:find("don't") then
                    if not Check_Tool_Inventory("Flower 1") then
                        repeat task.wait(.1)
                            Go_to_Part(Path_Flower[1].CFrame,function() return Auto_Evo_Race_V2 end)
                        until not Auto_Evo_Race_V2 or Check_Tool_Inventory("Flower 1")
                    end

                    if not Check_Tool_Inventory("Flower 2") then
                        repeat task.wait(.1)
                            Go_to_Part(Path_Flower[2].CFrame,function() return Auto_Evo_Race_V2 end)
                        until not Auto_Evo_Race_V2 or Check_Tool_Inventory("Flower 2")
                    end

                    if not Check_Tool_Inventory("Flower 3") then
                        Mon_Flower = "Swan Pirate"
                        if not Check_Near_Mon(Mon_Flower) then
                            repeat task.wait(.1)
                                Go_to_Part(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375),function() return Auto_Evo_Race_V2 end)
                            until workspace.Enemies:FindFirstChild(Mon_Flower) or not Auto_Evo_Race_V2
                        end

                        if Check_Near_Mon(Mon_Flower) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Mon_Flower and Check_Available_Mon(v) then
                                    Start_Attack(v.Name,v.HumanoidRootPart,function()
                                        return not Auto_Evo_Race_V2 or not Check_Near_Mon(Mon_Flower) or not Check_Available_Mon(v)
                                    end)
                                end
                            end
                        end
                    end

                    if Check_Tool_Inventory("Flower 1") and Check_Tool_Inventory("Flower 2") and Check_Tool_Inventory("Flower 3") then
                        Use_Remote("Alchemist","3")
                    end
                end
            end
        end
    end)

    MainTab:Toggle("Auto Swan Glasses",false,function(value)
        Auto_Swan_Glasses = value
    end)

    spawn(function()
        while wait() do
            if Auto_Swan_Glasses then
                if not SecondSea then return end
                if Check_Any_Remote("Swan Glasses") then return end

                Don_Swan = "Don Swan"

                if not Check_Near_Mon(Don_Swan) and Enable_Server_Hop then
                    Server_Hop("Find Don Swan")
                end

                if Check_Near_Mon(Don_Swan) and not workspace.Enemies:FindFirstChild(Don_Swan) then
                    if game.ReplicatedStorage:FindFirstChild(Don_Swan) then
                        repeat task.wait(.1)
                            Go_to_Part(game.ReplicatedStorage:FindFirstChild(Don_Swan).HumanoidRootPart.CFrame,function() return Auto_Swan_Glasses end)
                        until workspace.Enemies:FindFirstChild(Don_Swan) or Auto_Swan_Glasses
                    end 
                end

                if Check_Near_Mon(Don_Swan) and workspace.Enemies:FindFirstChild(Don_Swan) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Don_Swan and Check_Available_Mon(v) then
                            Start_Attack(v.Name,v.HumanoidRootPart,function()
                                return not Auto_Swan_Glasses or not Check_Near_Mon(Don_Swan) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end

            end
        end
    end)

    MainTab:Toggle("Auto Dragon Trident",false,function(value)
        Auto_Dragon_Trident = value
    end)

    spawn(function()
        while wait() do
            if Auto_Dragon_Trident then
                if not SecondSea then return end
                if Check_Any_Remote("Dragon Trident") then return end

                Tide_Keeper = "Tide Keeper"

                if not Check_Near_Mon(Tide_Keeper) and Enable_Server_Hop then
                    Server_Hop("Find Tide Keeper")
                end

                if Check_Near_Mon(Tide_Keeper) and not workspace.Enemies:FindFirstChild(Tide_Keeper) then
                    if game.ReplicatedStorage:FindFirstChild(Tide_Keeper) then
                        repeat task.wait(.1)
                            Go_to_Part(game.ReplicatedStorage:FindFirstChild(Tide_Keeper).HumanoidRootPart.CFrame,function() return Auto_Dragon_Trident end)
                        until workspace.Enemies:FindFirstChild(Tide_Keeper) or Auto_Dragon_Trident
                    end 
                end

                if Check_Near_Mon(Tide_Keeper) and workspace.Enemies:FindFirstChild(Tide_Keeper) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Tide_Keeper and Check_Available_Mon(v) then
                            Start_Attack(v.Name,v.HumanoidRootPart,function()
                                return not Auto_Dragon_Trident or not Check_Near_Mon(Tide_Keeper) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end

            end
        end
    end)
    
    MainTab:Toggle("Auto Buy Legendary Sword",false,function(value)
        Auto_Buy_Legendary_Sword = value
    end)

    spawn(function()
        while wait(.5) do
            if Auto_Buy_Legendary_Sword then
				Use_Remote("LegendarySwordDealer","1")
				Use_Remote("LegendarySwordDealer","2")
				Use_Remote("LegendarySwordDealer","3")
            end
        end
    end)
    
    MainTab:Toggle("Auto Buy Enchancement",false,function(value)
        Auto_Buy_Enchancement = value
    end)
    
    spawn(function()
        while wait(.5) do
            if Auto_Buy_Enchancement then
				Use_Remote("ColorsDealer","2")
            end
        end
    end)


elseif ThirdSea then

    MainTab:Toggle("Auto Soul Reaper",false,function(value)
        Auto_Soul_Reaper = value
    end)

    spawn(function()
        while wait() do
            if Auto_Soul_Reaper then
                
                if not Check_Tool_Inventory("Hallow Essence") then

                end

                if Check_Tool_Inventory("Hallow Essence") then

                end

                Soul_Reaper = "Soul Reaper"

                if not Check_Near_Mon(Soul_Reaper) and Enable_Server_Hop and not Check_Tool_Inventory("Hallow Essence") then
                    Server_Hop("Find Soul Reaper")
                end

                if Check_Near_Mon(Soul_Reaper) and not workspace.Enemies:FindFirstChild(Soul_Reaper) then
                    if game.ReplicatedStorage:FindFirstChild(Soul_Reaper) then
                        repeat task.wait(.1)
                            Go_to_Part(game.ReplicatedStorage:FindFirstChild(Soul_Reaper).HumanoidRootPart.CFrame)
                        until workspace.Enemies:FindFirstChild(Soul_Reaper) or not Auto_Soul_Reaper
                    end
                end

                if Check_Near_Mon(Soul_Reaper) and workspace.Enemies:FindFirstChild(Soul_Reaper) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Soul_Reaper and Check_Available_Mon(v) then
                            Start_Attack(v.Name,v.HumanoidRootPart,function()
                                return not Auto_Soul_Reaper or not Check_Near_Mon(Soul_Reaper) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)

    MainTab:Toggle("Auto Cake Prince",false,function(value)
        Auto_Cake_Prince = value
    end)

    spawn(function()
        while wait(.1) do
            if Auto_Cake_Prince then
                pcall(function()

                    local Remote_Cake_Prince = Use_Remote("CakePrinceSpawner")

                    if string.find(Remote_Cake_Prince,"Do you want to open") then Use_Remote("CakePrinceSpawner") end

                    if not Check_Near_Mon("Cake Prince") then
                        Mon_Cake = {"Baking Staff","Head Baker","Cake Guard","Cookie Crafter"}

                        if not Check_Near_Mon(Mon_Cake) then
                            Go_to_Part(CFrame.new(-2037.00171, 57.8413582, -12550.6748, 1, 0, 0, 0, 1, 0, 0, 0, 1),function()
                                return Auto_Cake_Prince
                            end)
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
                        
                        if game.ReplicatedStorage:FindFirstChild("Cake Prince") then
                            repeat wait()
                                Go_to_Part(game.ReplicatedStorage:FindFirstChild("Cake Prince").HumanoidRootPart.CFrame,function()
                                    return Auto_Cake_Prince
                                end)
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
                end)
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

CollectionService = game:GetService("CollectionService")

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
    PC = require(Local_Player.PlayerScripts.CombatFramework.Particle)
    RL = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
    DMG = require(Local_Player.PlayerScripts.CombatFramework.Particle.Damage)
    RigC = getupvalue(require(Local_Player.PlayerScripts.CombatFramework.RigController),2)
    Combat =  getupvalue(require(Local_Player.PlayerScripts.CombatFramework),2)
end

do -- Services
    RunService = game:GetService("RunService")
    CollectionService = game:GetService("CollectionService")
end

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
            if Human and Human.Health > 0 and Human.RootPart and v ~= Local_Player.Character then
                local IsPlayer = game.Players:GetPlayerFromCharacter(v)
                local IsAlly = IsPlayer and CollectionService:HasTag(IsPlayer,"Ally"..Local_Player.Name)
                if not IsAlly then
                    CurrentAllMob[#CurrentAllMob + 1] = v
                    if dist(Human.RootPart.Position) <= 65 then
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
                if not Players[i]:GetAttribute("PvpDisabled") and v and v ~= Local_Player.Character then
                    local Human = v:FindFirstChildOfClass("Humanoid")
                    if Human and Human.RootPart and Human.Health > 0 and dist(Human.RootPart.Position) < 65 then
                        canHits[#canHits+1] = Human.RootPart
                    end
                end
            end
        end
    end
end)

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
        Controller = Data.activeController
        if #canHits > 0 then
            if NormalClick then
                pcall(task.spawn,Controller.attack,Controller)
                -- continue
            end
            if Controller and Controller.equipped and (not Local_Player.PlayerGui.Main.Dialogue.Visible) and Controller.currentWeaponModel then
                if (NeedAttacking or DamageAura) then
                    if NewFastAttack and tick() > AttackCD and not DisableFastAttack then
                        resetCD()
                    end
                    if tick() - lastFireValid > 0.5 or not FastAttack then
                        Controller.timeToNextAttack = 0
                        Controller.hitboxMagnitude = 65
                        pcall(task.spawn,Controller.attack,Controller)
                        lastFireValid = tick()
                        -- continue
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

MainTab:Toggle("Double Quest",true,function(value)
    Double_Quest = value
end)

MainTab:Toggle("Auto Buso",true,function(value)
    Auto_Buso = value
    spawn(function()
        while wait() do
            if Auto_Buso then
                if not Local_Player.Character:FindFirstChild("HasBuso") then
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
            for i ,v in pairs(Local_Player.Backpack:GetChildren()) do
                if Weapon == "Melee" then 
                    if  v.ToolTip == "Melee" then
                        if Check_Tool_Inventory(v.Name) then
                            Current_Weapon = v.Name
                        end
                    end
                elseif Weapon == "Sword" then
                     if v.ToolTip == "Sword" then
                        if Check_Tool_Inventory(v.Name) then
                            Current_Weapon = v.Name
                        end
                    end
                elseif Weapon == "Devil Fruit" then 
                    if v.ToolTip == "Blox Fruit" then
                        if Check_Tool_Inventory(v.Name)  then
                            Current_Weapon = v.Name
                        end
                    end
                end
            end
        end)
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

StatsTab:Toggle("Auto Stats [Melee]",false,function(value)
	Auto_Stats_Melee = value
end)

StatsTab:Toggle("Auto Stats [Defense]",false,function(value)
	Auto_Stats_Defense = value
end)

StatsTab:Toggle("Auto Stats [Sword]",false,function(value)
	Auto_Stats_Sword = value
end)

StatsTab:Toggle("Auto Stats [Gun]",false,function(value)
	Auto_Stats_Gun = value
end)

StatsTab:Toggle("Auto Stats [Devil Fruit]",false,function(value)
	Auto_Stats_Devil_Fruit = value
end)

StatsTab:Line()

StatsTab:Slider("Point", 1, 100, 3, function(value)
	Stats_Point = value
end)

spawn(function()
    while wait(.5) do
        pcall(function()
            if Auto_Stats_Kaitun_Sword or Auto_Stats_Kaitun_Gun or Auto_Stats_Kaitun_Devil_Fruit then
                if Local_Player.Data.Stats.Defense.Level.Value == 2450 then return end
                if Local_Player.Data.Stats.Melee.Level.Value < 2450 then
                    Use_Remote("AddPoint","Melee",Stats_Point)
                end
                if Local_Player.Data.Stats.Melee.Level.Value == 2450 then
                    Use_Remote("AddPoint","Defense",Stats_Point)
                end
                if Local_Player.Data.Stats.Defense.Level.Value == 2450 then
                    if Auto_Stats_Kaitun_Sword then Use_Remote("AddPoint","Sword",Stats_Point) end
                    if Auto_Stats_Kaitun_Gun then Use_Remote("AddPoint","Gun",Stats_Point) end
                    if Auto_Stats_Kaitun_Devil_Fruit then Use_Remote("AddPoint","Demon Fruit",Stats_Point) end
                end
            end
            if Auto_Stats_Melee then
                Use_Remote("AddPoint","Melee",Stats_Point)
            end
            if Auto_Stats_Defense then
                Use_Remote("AddPoint","Defense",Stats_Point)
            end
            if Auto_Stats_Sword then 
                Use_Remote("AddPoint","Sword",Stats_Point)
            end
            if Auto_Stats_Gun then
                Use_Remote("AddPoint","Gun",Stats_Point)
            end
            if Auto_Stats_Devil_Fruit then
                Use_Remote("AddPoint","Demon Fruit",Stats_Point)
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
    while wait(.1) do
        if Auto_Finish_Raid and Raiding() then
            Kill_Aura()
            if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") and (Local_Player.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 5"].Position).Magnitude <= 3000 then
                Go_to_Part(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame * CFrame.new(0,70,100),function() return Auto_Finish_Raid end)
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") and (Local_Player.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 4"].Position).Magnitude <= 3000 then
                Go_to_Part(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame * CFrame.new(0,70,100),function() return Auto_Finish_Raid end)
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") and (Local_Player.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 3"].Position).Magnitude <= 3000 then
                Go_to_Part(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame * CFrame.new(0,70,100),function() return Auto_Finish_Raid end)
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") and (Local_Player.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 2"].Position).Magnitude <= 3000 then
                Go_to_Part(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame * CFrame.new(0,70,100),function() return Auto_Finish_Raid end)
            elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and (Local_Player.Character.HumanoidRootPart.Position - game:GetService("Workspace")["_WorldOrigin"].Locations["Island 1"].Position).Magnitude <= 3000 then
                Go_to_Part(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame * CFrame.new(0,70,100),function() return Auto_Finish_Raid end)
            end
        end
    end
end)

RaidTab:Line()

RaidTab:Toggle("Auto Start Law Raid",false,function(value)
	Auto_Start_Law_Raid = value
end)

spawn(function()
    while wait() do
        if Auto_Start_Law_Raid then
            if SecondSea then return end
            if not Check_Raid_Chip() then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
            end

            if Check_Raid_Chip() and not Check_Near_Mon("Order [Lv. 1250] [Raid Boss]") then
                fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end
        end
    end
end)

RaidTab:Toggle("Auto Law Raid",false,function(value)
	Auto_Law_Raid = value
end)

spawn(function()
    while wait() do
        if Auto_Law_Raid then

            if game.ReplicatedStorage:FindFirstChild("Order") then
                repeat task.wait(.1)
                    Go_to_Part(game.ReplicatedStorage:FindFirstChild("Order").HumanoidRootPart.CFrame,function() return Auto_Law_Raid end)
                until workspace.Enemies:FindFirstChild("Order") or not Auto_Law_Raid
            end

            if Check_Near_Mon("Order") then
                for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == "Order" and Check_Available_Mon(v) then
                        Start_Attack(v.Name,v.HumanoidRootPart,function()
                            return not Auto_Law_Raid or not Check_Near_Mon("Order") or not Check_Available_Mon(v)
                        end)
                    end
                end
            end
        end
    end
end)
