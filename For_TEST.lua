repeat wait() until game:IsLoaded()

------ [ Config ]

getgenv().Preset = getgenv().Preset or {
    ["Default"] = false,
    ["Custom"] = false
}

getgenv().Config = getgenv().Config or {
    ["Start Kaitun"] = false,
    ["Farm Setting"] = {
        ["Get All Item"] = {
            ["Enabled"] = false,
            ["Method"] = "Normal",--Fully
        },
    },
    ["Bring Mob Less Lag"] = false,
    ["Auto Rejoin"] = false,
    ["Increase FPS"] = false
}

Debug = Debug or {
    ["Developer Mode"] = false
}

if not Debug["Developer Mode"] then
    print = function() end
end

if getgenv().Preset["Default"] then
    getgenv().Config["Start Kaitun"] = true
    getgenv().Config["Bring Mob Less Lag"] = true
end


------ [ Function ]

warn("Starting")

warn("Get Config")

warn("---------------------------------------")

for i,v in pairs(getgenv().Config) do
    if v then 
        warn("[ "..i.." ] : ✅ Activate") 
    else
        warn("[ "..i.." ] : ❌ Not Activate") 
    end
end

warn("---------------------------------------")



local placeId = game.PlaceId
if placeId == 2753915549 then
	FirstSea = true
elseif placeId == 4442272183 then
	SecondSea = true
elseif placeId == 7449423635 then
	ThirdSea = true
end

SeaIndex = ThirdSea and 3 or SecondSea and 2 or FirstSea and 1 or Local_Player:Kick("Didn't update this Sea")

local Player = game.Players
local Local_Player = Player.LocalPlayer
local Players = game.Players
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

repeat wait() until Player

if not Local_Player.Team then
    repeat wait()
        if Local_Player.PlayerGui.Main.ChooseTeam.Visible then
            for i, v in pairs(getconnections(Local_Player.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.TextButton.Activated)) do                                                                                                
                v.Function()
            end
        end
    until Local_Player.Team
end

CanTeleport = {
    {
        ["Sky3"] = Vector3.new(-7894, 5547, -380),
        ["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
        ["UnderWater"] = Vector3.new(61163, 11, 1819),
        ["UnderwaterExit"] = Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875),
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

local C_Shaker = require(game.ReplicatedStorage.Util.CameraShaker)
C_Shaker:Stop()

local CurrentAllMob = {}
local recentlySpawn = 0
local StoredSuccessFully = 0
local canHits = {}
local RecentCollected = 0
local FruitInServer = {}
local RecentlyLocationSet = 0
local lastequip = tick()

local PC = require(Local_Player.PlayerScripts.CombatFramework.Particle)
local RL = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
local DMG = require(Local_Player.PlayerScripts.CombatFramework.Particle.Damage)
local RigC = getupvalue(require(Local_Player.PlayerScripts.CombatFramework.RigController),2)
local Combat =  getupvalue(require(Local_Player.PlayerScripts.CombatFramework),2)

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

function IsLava(v)
    if v:IsA("Script") and v.Name == "LavaDamage" then
        task.wait()
        v.Parent:Destroy()
    end
end
for i,v in pairs(workspace:GetDescendants()) do
    IsLava(v)
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
    for i ,v in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do 
       if v.Name == self:FindIndex(p2) or v.Name:match(self:FindIndex(p2)) then 
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
    
    if Double_Quest then 
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

print("Cuurent Mon :",Data[Level].Mon)

Double_Quest = true

dist = function(a, b, noHeight)
    local vector_a = Vector3.new(a.X, not noHeight and a.Y or 0, a.Z)

    local success, result = pcall(function()
        if not b then
            while true do
                local Root = Local_Player.Character and Local_Player.Character:FindFirstChild("HumanoidRootPart")
                if Root and Root.Position then
                    b = Root.Position
                    break
                end
                wait(.5) 
            end
        end

        local vector_b = Vector3.new(b.X, not noHeight and b.Y or 0, b.Z)
        return (vector_a - vector_b).magnitude
    end)

    if success then
        return result
    else
        warn("Dist", result)
        return nil
    end
end

InArea = function(Pos,Location)
    local nearest,scale = nil,0
    if Location then
        if dist(Pos,Location.Position,true) <= (Location.Mesh.Scale.X/2)+500 then
            return Location
        end
    end
    for i,v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
        if dist(Pos,v.Position,true) <= (v.Mesh.Scale.X/2)+500 then
            if scale < v.Mesh.Scale.X then
                scale = v.Mesh.Scale.X
                nearest = v
            end
        end
    end
    return nearest
end

function Raiding()
    return Local_Player.PlayerGui.Main.Timer.Visible or StartingRaid
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

function Check_Fruit_Inventory()
    local Backpack = Local_Player.Backpack:GetChildren()
    for i=1,#Backpack do local v = Backpack[i]
        if v.Name:lower():find("fruit") then
            return true
        end
    end
    local Character = Local_Player.Character:GetChildren()
    for i=1,#Character do local v = Character[i]
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            return true
        end
    end
end

function TP(...)
    local function Convert_To_CFrame(value)
        if typeof(value) == "Vector3" then
            return CFrame.new(value)
        elseif typeof(value) == "CFrame" then
            return value
        else
            return nil
        end
    end
    local target = Convert_To_CFrame(...)
    if not Local_Player.Character:FindFirstChild("HumanoidRootPart") then return end
    if tweenPause then return end
    local thisId
    local s,e = pcall(function()
        local Dista,distm,middle = dist(target,nil,true),1/0
        if Local_Player.Character:FindFirstChild("HumanoidRootPart") and Dista >= 2000 and tick() - recentlySpawn > 5 then
            for i,v in pairs(CanTeleport[SeaIndex]) do
                local distance = dist(v,target,true)
                if distance < dist(target,nil,true) and distance < distm then
                    distm,middle = distance,v
                end
            end
            if middle and InArea(Local_Player.Character.HumanoidRootPart.Position) ~= InArea(middle) and not Raiding() then
                -- print(Local_Player.Character.HumanoidRootPart.Position,"\n",target.p)
                -- print(Dista,distm,CurrentArea,InArea(middle))
                Use_Remote("requestEntrance",middle)
            end
            if Local_Player.Character:FindFirstChild("HumanoidRootPart") and not Raiding() and not Check_Fruit_Inventory() then
                local Area = InArea(target.p)
                local MyArea = InArea(Local_Player.Character.HumanoidRootPart.Position)
                local SpawnPoint = workspace["_WorldOrigin"].PlayerSpawns[Local_Player.Team.Name]:GetChildren()
                local dista,distm,charDist,nearest = 2000,9000
                for i,v in pairs(SpawnPoint) do
                    local Position = v:GetPivot().p
                    local distance = dist(target.p,Position,true)
                    if distance <= dista then
                        charDist = dist(Position,nil,true)
                        dista,nearest = distance,v
                    end
                end
                wait(.5)
                local Dista = dist(target,nil,true)
                if nearest and (charDist <= 9200) and Dista >= 2000 then
                    if not Local_Player.Character:FindFirstChild("Humanoid") then return end
                    if not Local_Player.Character:FindFirstChild("HumanoidRootPart") then return end
                    if Local_Player.Character.HumanoidRootPart:FindFirstChild("Died") then
                        Local_Player.Character.HumanoidRootPart.Died:Destroy()
                    end
                    repeat task.wait(0.01)
                        pcall(task.spawn,Use_Remote,"SetLastSpawnPoint",nearest.Name)
                    until Local_Player.Data.LastSpawnPoint.Value == nearest.Name
                    pcall(function()
                        Local_Player.Character.Humanoid:ChangeState(15)
                        -- Local_Player.Character.HumanoidRootPart:Destroy()
                    end)
                    repeat wait(.1) until Local_Player.Character.HumanoidRootPart.Parent
                end
            end
        end
        if tweenActive and lastTweenTarget and (dist(target, lastTweenTarget) < 10 or dist(lastTweenTarget) >= 10) then
            return
        end
        tweenid = (tweenid or 0) + 1 
        lastTweenTarget = target
        thisId = tweenid
        Util = require(game:GetService("ReplicatedStorage").Util)
        if Util.FPSTracker.FPS > 60 then
            setfpscap(60)
        end
        task.spawn(pcall,function()
            lastPos = {tick(),target}
            local currentDistance = dist(Local_Player.Character.HumanoidRootPart.Position, target, true)
            local oldDistance = currentDistance
            Local_Player.Character.Humanoid:SetStateEnabled(13,false)
            while Local_Player.Character:FindFirstChild("HumanoidRootPart") and currentDistance > 75 and thisId == tweenid and Local_Player.Character.Humanoid.Health > 0 do
                local Percent = (58/math.clamp(Util.FPSTracker.FPS,0,60))
                local Speed = 6*Percent
                local Current = Local_Player.Character.HumanoidRootPart.Position
                local Dift = Vector3.new(target.X,0,target.Z) - Vector3.new(Current.X,0,Current.Z)
                local Sx =  (Dift.X < 0 and -1 or 1)*Speed
                local Sz =  (Dift.Z < 0 and -1 or 1)*Speed
                local SpeedX = math.abs(Dift.X) < Sx and Dift.X or Sx
                local SpeedZ = math.abs(Dift.Z) < Sz and Dift.Z or Sz
                task.spawn(function()
                    currentDistance = dist(Local_Player.Character.HumanoidRootPart.Position, target, true)
                    if currentDistance > oldDistance+10 then
                        tweenid = -1
                        tweenPause = true
                        Local_Player.Character.HumanoidRootPart.Anchored = true
                        wait(1)
                        tweenPause = false
                        Local_Player.Character.HumanoidRootPart.Anchored = false
                    end
                    oldDistance = currentDistance
                end)
                Local_Player.Character.HumanoidRootPart.CFrame = Local_Player.Character.HumanoidRootPart.CFrame + Vector3.new(math.abs(SpeedZ) < (5*Percent) and SpeedX or SpeedX/1.5, 0, math.abs(SpeedX) < (5*Percent) and SpeedZ or SpeedZ/1.5)
                Local_Player.Character.HumanoidRootPart.CFrame = CFrame.new(Local_Player.Character.HumanoidRootPart.CFrame.X,target.Y,Local_Player.Character.HumanoidRootPart.CFrame.Z)
                tweenActive = true
                task.wait(0.001)
            end
            Local_Player.Character.Humanoid:SetStateEnabled(13,true)
            tweenActive = false
            if currentDistance <= 100 and thisId == tweenid then
                Local_Player.Character.HumanoidRootPart.CFrame = target
            end
        end)
    end)
    if not s then warn("TP :",e) end
    return thisId
end

function Go_to_Part(Part,State_Ment) 
    local State_Ment = State_Ment or function() return true end
    local f,e = pcall(function()
        if not State_Ment() then
            Need_Noclip = true
            repeat task.wait(0.02) TP(Part.Position) until State_Ment()
            Need_Noclip = false
        end
        Need_Noclip = false
    end)
    if not f then warn("GTP :",e) end
end

getgenv().network = network or {
    cache = {
        connections = {
            insert = function(self,value)
                self[#self + 1] = value
            end,
            clear = function(self)
                for i=1,#self do local v = self[i]
                    if type(v) ~= "function" then
                    v:Disconnect()
                    table.remove(self,table.find(self,v))
                    end
                end
            end,
        },
        remotes = {
            insert = function(self,value)
                self[#self + 1] = value
            end,
        },
    },
    Retrieve = function(self,name,func)
        local Remote = self.cache.remotes[name] or (typeof(name) == "Instance" and name) or game:FindFirstChild(name,true)
        if Remote then
            if Remote:IsA("RemoteEvent") then
                self.cache.connections:insert(Remote.OnClientEvent:Connect(func))
                self.cache.remotes[name] = Remote
            elseif Remote:IsA("RemoteFunction") then
                Remote.OnClientInvoke = func
                self.cache.connections:insert(Remote.OnClientInvoke)
                self.cache.remotes[name] = Remote
            else
                warn("Unable to Connect Network")
            end
        else
            warn("Unable to Indentify Remote Network")
        end
    end,
    Send = function(self, name, ...)
        local success, result = pcall(function(...)
            local Remote = self.cache.remotes[name] or (typeof(name) == "Instance" and name) or game:FindFirstChild(name, true)
            if Remote then
                if Remote:IsA("RemoteEvent") then
                    self.cache.remotes[name] = Remote
                    Remote:FireServer(...)
                elseif Remote:IsA("RemoteFunction") then
                    self.cache.remotes[name] = Remote
                    return Remote:InvokeServer(...)
                else
                    error("Unable to Connect Network")
                end
            else
                error("Unable to Identify Remote Network")
            end
        end, ...)
        if not success then
            warn("Error in Send function:", result)
        end
        return result  -- Return the result of InvokeServer in case of success
    end,
}
-- return network

-- local network = loadstring(game:HttpGet('https://raw.githubusercontent.com/hajibeza/File/main/Network.lua'))()

function Check_Near_Mon(Monster)
    local Table_Monster = Monster
    if type(Monster) == "string" then Table_Monster = {Monster} end
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if table.find(Table_Monster,v.Name) and v.Humanoid.Health > 0 then
            return v,"workspace"
        end
    end
    for i,v in pairs(game.ReplicatedStorage:GetChildren()) do
        if table.find(Table_Monster,v.Name) and v.Humanoid.Health > 0 then    
            return v,"ReplicatedStorage"
        end
    end
    return nil
end

function Check_Available_Mon(mob)
    return mob:FindFirstChild("HumanoidRootPart") and
    mob:FindFirstChildOfClass("Humanoid") and
    mob.Humanoid.Health > 0
end
 
Use_Remote = function(...)
    local ARGS = {...}
    local Data = network:Send("CommF_",...)
    local r,s = pcall(function()
        if ARGS[1] == "requestEntrance" then
            CollectionService:AddTag(Local_Player,"Teleporting")
            task.delay(3,function()
                CollectionService:RemoveTag(Local_Player,"Teleporting")
            end)
            wait(.25)
        end
    end)
    if not r then warn("Remote : "..s) end
    return Data
end

isnetworkowner = isnetworkowner or function(part)
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        local Distance = math.clamp(Local_Player.SimulationRadius,0,1250)
        local MyDist = Local_Player:DistanceFromCharacter(part.Position)
        if MyDist < Distance then
            for i,v in pairs(Player:GetPlayers()) do
                if v:DistanceFromCharacter(part.Position) < MyDist and v ~= Local_Player then
                    return false
                end
            end
            return true
        end
    end
end

-- BringMob = function(Mon)

--     for _, v in pairs(workspace.Enemies:GetChildren()) do
--         if not Check_Available_Mon(v) then continue end

--         local isMatchingMob = not Mon or (v.Name == Mon.Name)

--         if isMatchingMob then
--             local mobPos = Mon and Mon.HumanoidRootPart.CFrame.Position or nil
--             if mobPos then
--                 local distanceToMon = dist(v.HumanoidRootPart.Position, mobPos)
--                 if distanceToMon <= 5 and getgenv().Config["Bring Mob Less Lag"] then
--                     return
--                 end
--             end

--             local distanceFromPlayer = dist(v.HumanoidRootPart.Position, workspace.CurrentCamera.CFrame.Position)
--             if isnetworkowner(v.HumanoidRootPart) or distanceFromPlayer <= 200 then
--                 v.Humanoid.JumpPower = 0
--                 v.Humanoid.WalkSpeed = 0
--                 v.Humanoid.Sit = true
--                 v.Humanoid.PlatformStand = true
--                 v.HumanoidRootPart.CanCollide = false
--                 v.HumanoidRootPart.CFrame = Mon and Mon.HumanoidRootPart.CFrame or v.HumanoidRootPart.CFrame

--                 local animator = v.Humanoid:FindFirstChild("Animator")
--                 if animator then
--                     animator:Destroy()
--                 end
--             end
--         end
--     end
-- end

-- BringMob = function(Mon) 
--     for _, enemy in pairs(workspace.Enemies:GetChildren()) do
--         local humanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
--         local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        
--         if Check_Available_Mon(enemy) and dist(humanoidRootPart.Position) <= 5000 then
--             local isValidMob = not Mon or (enemy ~= Mon and enemy.Name == Mon.Name)
            
--             if isValidMob then
--                 local monPos = Mon.HumanoidRootPart.CFrame.Position
--                 local distanceToMon = dist(humanoidRootPart.Position, monPos)
                
--                 if distanceToMon <= 5 and getgenv().Config["Bring Mob Less Lag"] then
--                     -- humanoidRootPart.Anchored = true
--                     return
--                 end
                
--                 if isnetworkowner(humanoidRootPart) or distanceToMon <= 200 then
--                     humanoid.JumpPower = 0
--                     humanoid.WalkSpeed = 0
--                     humanoid.Sit = true
--                     humanoid.PlatformStand = true
--                     humanoidRootPart.CanCollide = false
--                     humanoidRootPart.CFrame = CFrame.new(monPos)
                    
--                     local animator = humanoid:FindFirstChild("Animator")
--                     if animator then
--                         animator:Destroy()
--                     end
--                 end
--             end
--         end
--     end
-- end

BringMob = function(Mon)

    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        local humanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        
        if Check_Available_Mon(enemy) and dist(humanoidRootPart.Position, Mon.HumanoidRootPart.Position) <= 5000 then
            local isValidMob = not Mon or (enemy ~= Mon and enemy.Name == Mon.Name)
            
            if isValidMob then

                local monPos = Mon.HumanoidRootPart.CFrame.Position
                local distanceToMon = dist(humanoidRootPart.Position, monPos)
                
                if distanceToMon <= 5 and getgenv().Config["Bring Mob Less Lag"] then
                    return
                end
                
                if isnetworkowner(humanoidRootPart) or distanceToMon <= 200 then
                    humanoid.JumpPower = 0
                    humanoid.WalkSpeed = 0
                    humanoid.Sit = true
                    humanoid.PlatformStand = true
                    humanoidRootPart.CanCollide = false
                    humanoidRootPart.CFrame = CFrame.new(monPos)
                    
                    local animator = humanoid:FindFirstChild("Animator")
                    if animator then
                        animator:Destroy()
                    end
                end
            end
        end
    end

end



function Check_Tool_Inventory(Tool_Name)
    if Local_Player.Backpack:FindFirstChild(Tool_Name) or Local_Player.Character:FindFirstChild(Tool_Name) then
        return true
    end
    return false
end

function Equip_Tool(Tool)
    if Check_Tool_Inventory(Tool) then 
        local ToolHumanoid = Local_Player.Backpack:FindFirstChild(Tool)
        if ToolHumanoid then
            Local_Player.Character.Humanoid:EquipTool(ToolHumanoid) 
        end
    end
end

function Check_Mastery(Melee_Name,Mastery_Value)
	if Local_Player.Backpack:FindFirstChild(Melee_Name) then
		if Local_Player.Backpack:FindFirstChild(Melee_Name).Level.Value >= Mastery_Value then
			return true
		end
	end
	if Local_Player.Character:FindFirstChild(Melee_Name) then
	    if Local_Player.Character:FindFirstChild(Melee_Name).Level.Value >= Mastery_Value then
	        return true
	    end
    end
    return false
end

function Start_Attack(Entity,Expression,Weapon)
    local Expression = Expression or function() return true end
    local Success,Error = pcall(function()
        Human = Entity.Humanoid
        repeat task.wait(0.02)
            Need_Noclip = true
            NeedAttacking = true
            if not Local_Player.Character:FindFirstChild("HasBuso") and Local_Player.Character:FindFirstChild("HumanoidRootPart") then
                Use_Remote("Buso")
                -- continue
            end 
            if isnetworkowner(Human.RootPart) then
                Human.RootPart.CFrame = Human.RootPart.CFrame
            end
            if Weapon then
                Equip_Tool(Weapon)
            else
                Equip_Tool(Current_Weapon)
            end
            BringMob(Entity)
            TP(Entity.HumanoidRootPart.CFrame * CFrame.new(0,60,0))
        until Expression()
    end)
    if not Success then warn("Attack :",Error) end
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

function Check_Tool_Remote(Name)
    local Remote_Inventory = Use_Remote("getInventory")
    for i,v in pairs(Remote_Inventory) do
        if v.Name == Name then
            return true
        end
    end
    return false
end

function Check_Mastery_Remote(Name,Mastery_Value)
    local Remote_Inventory = Use_Remote("getInventory")
    for i,v in pairs(Remote_Inventory) do
        if v.Name == Name and v.Mastery >= Mastery_Value then
            return true
        end
    end
    return false
end

function Check_Total_Material(Name)
    local Remote_Inventory = Use_Remote("getInventory")
    for i,v in pairs(Remote_Inventory) do
	    if v.Type == "Material" then 
            if v.Name == Name then
                return v.Count
            end
        end
    end
    return 0
end

function Find_Mon_Spawn(Name_Mon)
    local Mon = type(Name_Mon) == "string" and {Name_Mon} or Name_Mon
    local matchingSpawns = {}

    for _, Mob in pairs(Mon) do
        for _, spawn in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
            if spawn.Name == Mob or spawn.Name:match(Mob) then
                table.insert(matchingSpawns, spawn)
            end
        end
    end

    return #matchingSpawns > 0 and matchingSpawns or nil
end

function Go_To_Mon_Spawn(Name_Mon,State_Ment)
    local Enemy_Spawn = Find_Mon_Spawn(Name_Mon)
    if not Enemy_Spawn then return end
    for _, spawn in pairs(Enemy_Spawn) do
        if not Check_Near_Mon(Name_Mon) and not State_Ment() then
            repeat task.wait(0.02)
                Need_Noclip = true
                TP(spawn.CFrame * CFrame.new(0, 30, 0))
            until dist(spawn.Position) < 50 or Check_Near_Mon(Name_Mon) or State_Ment()
            Need_Noclip = false
        end
    end
end

if getgenv().Config["Increase FPS"] then
    game:GetService("ReplicatedStorage").Assets.GUI.DamageCounter.Enabled = false
    Local_Player.PlayerGui.Notifications.Enabled = false
--     Local_Player.PlayerGui.Notifications.Enabled = false
--     game.ReplicatedStorage.Assets.GUI.DamageCounter.Enabled = false
--     game.Lighting.FogEnd = 9e9

--     if not game:IsLoaded() then repeat wait() until game:IsLoaded() end
--     if hookfunction and setreadonly then
--         local mt = getrawmetatable(game)
--         local old = mt.__newindex
--         setreadonly(mt, false)
--         local sda
--         sda = hookfunction(old, function(t, k, v)
--             if k == "Material" then
--                 if v ~= Enum.Material.Neon and v ~= Enum.Material.Plastic and v ~= Enum.Material.ForceField then v = Enum.Material.Plastic end
--             elseif k == "TopSurface" then v = "Smooth"
--             elseif k == "Reflectance" or k == "WaterWaveSize" or k == "WaterWaveSpeed" or k == "WaterReflectance" then v = 0
--             elseif k == "WaterTransparency" then v = 1
--             elseif k == "GlobalShadows" then v = false end
--             return sda(t, k, v)
--         end)
--         setreadonly(mt, true)
--     end
--     local g = game
--     local w = g.Workspace
--     local l = g:GetService"Lighting"
--     local t = w:WaitForChild"Terrain"
--     t.WaterWaveSize = 0
--     t.WaterWaveSpeed = 0
--     t.WaterReflectance = 0
--     t.WaterTransparency = 1
--     l.GlobalShadows = false

--     function change(v)
--         pcall(function()
--             if v.Material ~= Enum.Material.Neon and v.Material ~= Enum.Material.Plastic and v.Material ~= Enum.Material.ForceField then
--                 pcall(function() v.Reflectance = 0 end)
--                 pcall(function() v.Material = Enum.Material.Plastic end)
--                 pcall(function() v.TopSurface = "Smooth" end)
--             end
--         end)
--     end

--     game.DescendantAdded:Connect(function(v)
--         pcall(function()
--             if v:IsA"Part" then change(v)
--             elseif v:IsA"MeshPart" then change(v)
--             elseif v:IsA"TrussPart" then change(v)
--             elseif v:IsA"UnionOperation" then change(v)
--             elseif v:IsA"CornerWedgePart" then change(v)
--             elseif v:IsA"WedgePart" then change(v) end
--         end)
--     end)
--     for i, v in pairs(game:GetDescendants()) do
--         pcall(function()
--             if v:IsA"Part" then change(v)
--             elseif v:IsA"MeshPart" then change(v)
--             elseif v:IsA"TrussPart" then change(v)
--             elseif v:IsA"UnionOperation" then change(v)
--             elseif v:IsA"CornerWedgePart" then change(v)
--             elseif v:IsA"WedgePart" then change(v) end
--         end)
--     end
end

if Use_Remote("BuyElectro",true) == 1 then
    HasElectro = true
end
if Use_Remote("BuyBlackLeg",true) == 1 then
    HasBlackleg = true
end
if Use_Remote("BuyFishmanKarate",true) == 1 then
    HasFishman = true
end
if Use_Remote("BlackbeardReward","DragonClaw","1") == 1 then
    HasDragonClaw = true
end
if Use_Remote("BuySuperhuman",true) == 1 then
    Hassuperhuman = true
end
if Use_Remote("BuyDeathStep",true) == 1 then
    HasDeathStep = true
end
if Use_Remote("BuySharkmanKarate",true) == 1 then
    HasSharkman = true
end
if Use_Remote("BuyElectricClaw",true) == 1 then
    HasElectricClaw = true
end
if Use_Remote("BuyDragonTalon",true) == 1 then
    HasDragonTalon = true
end
if Use_Remote("BuyGodhuman",true) == 1 then
    HasGodhuman = true
end

task.spawn(function()
    while true do wait()
        if setscriptable then
            setscriptable(Local_Player, "SimulationRadius", true)
            Local_Player.SimulationRadius = math.huge
        end
        if sethiddenproperty then
            sethiddenproperty(Local_Player, "SimulationRadius", math.huge)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Need_Noclip then
            if Local_Player.Character:WaitForChild("Humanoid").Sit then
                Local_Player.Character:WaitForChild("Humanoid").Sit = false
            end
            for _, v in pairs(Local_Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
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

task.spawn(function()
    local weaponToolTipMap = {
        ["Melee"] = "Melee",
        ["Sword"] = "Sword",
        ["Devil Fruit"] = "Blox Fruit"
    }
    
    while wait(0.5) do
        for _, tool in pairs(Local_Player.Backpack:GetChildren()) do
            local weaponToolTip = weaponToolTipMap[Weapon]
            if weaponToolTip and tool.ToolTip == weaponToolTip and Check_Tool_Inventory(tool.Name) then
                Current_Weapon = tool.Name
                break
            end
        end
    end
end)

local Max_Level_Value = 2550
Weapon = "Melee"

-- First Sea Function

function Get_Pole()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Pole (1st Form)") then return end
        if not FirstSea then return end

        local Mon = "Thunder God"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Shark_Saw()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Shark Saw") then return end
        if not FirstSea then return end

        local Mon = "The Saw"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Trident()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Trident") then return end
        if not FirstSea then return end

        local Mon = "Fishman Lord"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Wardens_Sword()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Wardens Sword") then return end
        if not FirstSea then return end

        local Mon = "Chief Warden"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Pink_Coat()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Pink Coat") then return end
        if not FirstSea then return end

        local Mon = "Swan"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Coat()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Coat") then return end
        if not FirstSea then return end

        local Mon = "Vice Admiral"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Cool_Shades()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Cool Shades") then return end
        if not FirstSea then return end

        local Mon = "Cyborg"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon(Mon) or workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Saber()
    if getgenv().Config["Start Kaitun"] then
        if not FirstSea then return end

        local Remote_Check_Saber = Use_Remote("ProQuestProgress")
        local QuestPlates_Folder = workspace.Map.Jungle.QuestPlates

        if Check_Tool_Remote("Saber") then return end
        if not FirstSea then return end

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

                if Check_Near_Mon(Mon_Leader) and not workspace.Enemies:FindFirstChild(Mon_Leader) then
                    Go_to_Part(Check_Near_Mon(Mon_Leader).HumanoidRootPart.CFrame,function() return not Check_Near_Mon(Mon_Leader) or workspace.Enemies:FindFirstChild(Mon_Leader) or not getgenv().Config["Start Kaitun"] end)
                end

                if Check_Near_Mon(Mon_Leader) and workspace.Enemies:FindFirstChild(Mon_Leader) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Mon_Leader and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon_Leader) or not Check_Available_Mon(v)
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

                if Check_Near_Mon(Saber_Expert) and not workspace.Enemies:FindFirstChild(Saber_Expert) then
                    Go_to_Part(Check_Near_Mon(Saber_Expert).HumanoidRootPart.CFrame,function() return not Check_Near_Mon(Saber_Expert) or workspace.Enemies:FindFirstChild(Saber_Expert) or not getgenv().Config["Start Kaitun"] end)
                end

                if Check_Near_Mon(Saber_Expert) and workspace.Enemies:FindFirstChild(Saber_Expert) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Saber_Expert and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Saber_Expert) or not Check_Available_Mon(v) or Remote_Check_Saber.KilledShanks
                            end)
                        end
                    end
                end
            end
        end
    end
end

function Get_Refined_Musket()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Refined Musket") then return end
        if not FirstSea then return end

        local Mon = "Magma Admiral"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Bazooka()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Bazooka") then return end
        if not FirstSea then return end

        local Mon = "Wysper"

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Mon and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

-- function Get_Bisento_V2()
--     if not FirstSea then return end

--     local Mon = "Greybeard"

--     if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
--         Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
--     end

--     if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Mon) then
--         for i,v in pairs(workspace.Enemies:GetChildren()) do
--             if v.Name == Mon and Check_Available_Mon(v) then
--                 Start_Attack(v,function()
--                     return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
--                 end)
--                 Do_Bisento_V2 = true
--             end
--         end
--     end
-- end

function Go_To_Second_Sea()
    local Remote = Use_Remote("DressrosaQuestProgress")
    local MyLevel = Local_Player.Data.Level.Value 

    if Remote.KilledIceBoss then return end
    if not FirstSea then return end

    if not Remote.TalkedDetective then
        repeat task.wait(.1) 
            Use_Remote("DressrosaQuestProgress","Detective")
        until Check_Tool_Inventory("Key") or not getgenv().Config["Start Kaitun"]
    end
    
    if not Remote.UsedKey then
        repeat task.wait(.1) 
            Use_Remote("DressrosaQuestProgress","UseKey")
        until not Check_Tool_Inventory("Key") or not getgenv().Config["Start Kaitun"]
    end

    if not Remote.KilledIceBoss and Remote.UsedKey then

        if not Check_Near_Mon("Ice Admiral") then
            Go_To_Mon_Spawn("Ice Admiral",function()
                return not getgenv().Config["Start Kaitun"]
            end)
        end
        
        if Check_Near_Mon("Ice Admiral") and not workspace.Enemies:FindFirstChild("Ice Admiral") then
            Go_to_Part(Check_Near_Mon("Ice Admiral").HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return not Check_Near_Mon("Ice Admiral") or workspace.Enemies:FindFirstChild("Ice Admiral") or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon("Ice Admiral") and workspace.Enemies:FindFirstChild("Ice Admiral") then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == "Ice Admiral" and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon("Ice Admiral") or not Check_Available_Mon(v)
                    end)
                    Use_Remote("TravelDressrosa")
                end
            end
        end
    end
end

-- Second Sea Function

function Bartilo_Quest()
    if getgenv().Config["Start Kaitun"] then
        local Remote_Check_Bartilo = Use_Remote("BartiloQuestProgress")

        if not SecondSea then return end
        if Remote_Check_Bartilo.DidPlates then return end

        if not Remote_Check_Bartilo.KilledBandits then

            if not Local_Player.PlayerGui.Main.Quest.Visible then 
                Use_Remote("StartQuest","BartiloQuest",1)
            end

            if Local_Player.PlayerGui.Main.Quest.Visible then 

                local Mon = "Swan Pirate"
                
                if not Check_Near_Mon(Mon) then
                    Go_To_Mon_Spawn(Mon,function()
                        return not getgenv().Config["Start Kaitun"]
                    end)
                end

                if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
                    Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame,function()
                        return not getgenv().Config["Start Kaitun"] or workspace.Enemies:FindFirstChild(Mon)
                    end)
                end

                if Check_Near_Mon(Mon) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Mon and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not getgenv().Config["Start Kaitun"] or Remote_Check_Bartilo.KilledBandits or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end

        if not Remote_Check_Bartilo.KilledSpring and Remote_Check_Bartilo.KilledBandits then

            Boss = "Jeremy"

            if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
                Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() 
                    return not getgenv().Config["Start Kaitun"] or Remote_Check_Bartilo.KilledSpring or workspace.Enemies:FindFirstChild(Boss) or not Check_Near_Mon(Boss)
                end)
            end

            if Check_Near_Mon(Boss) then
                for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if v.Name == Boss and Check_Available_Mon(v) then
                        Start_Attack(v,function()
                            return not getgenv().Config["Start Kaitun"] or Remote_Check_Bartilo.KilledSpring or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                        end)
                    end
                end
            end
        end

        if not Remote_Check_Bartilo.DidPlates and Remote_Check_Bartilo.KilledSpring then
            Use_Remote("BartiloQuestProgress","DidPlates")
        end
    end
end

function Get_Dragon_Trident()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Dragon Trident") then return end

        Boss = "Tide Keeper"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end

    end
end

function Get_Gravity_Cane()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Gravity Cane") then return end

        Boss = "Fajita"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Jitte()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Jitte") then return end

        Boss = "Smoke Admiral"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Longsword()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Longsword") then return end

        Boss = "Diamond"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Midnight_Blade()
    if getgenv().Config["Start Kaitun"] then
        if Check_Tool_Remote("Midnight Blade") then return end
        if Check_Total_Material("Ectoplasm") >= 100 then
            Use_Remote("Ectoplasm","Buy",3)
        else
            local Mon = {"Ship Deckhand";"Ship Engineer";"Ship Steward";"Ship Officer"}

            if not Check_Near_Mon(Mon) then
                Go_To_Mon_Spawn(Mon,function()
                    return not getgenv().Config["Start Kaitun"]
                end)
            end

            if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
                Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Mon) or not getgenv().Config["Start Kaitun"] end)
            end

            if Check_Near_Mon(Mon) and workspace.Enemies:FindFirstChild(Boss) then
                for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if table.find(Mon,v.Name) and Check_Available_Mon(v) then 
                        Start_Attack(v,function()
                            return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                        end)
                    end
                end
            end        
        end
    end
end

function Get_Rengoku()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        local Remote_Rengoku = Use_Remote("OpenRengoku")

        if Remote_Rengoku then return end
        
        if Check_Tool_Inventory("Hidden Key") then
            repeat task.wait(.1) Use_Remote("OpenRengoku") until not Check_Tool_Inventory("Hidden Key")
        end

        if not Check_Tool_Inventory("Hidden Key") then
            local Mon = {"Snow Lurker","Arctic Warrior"}

            if not Check_Near_Mon(Mon) then
                Go_To_Mon_Spawn(Mon,function()
                    return not getgenv().Config["Start Kaitun"]
                end)
            end

            if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Check_Near_Mon(Mon).Name) then
                Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Check_Near_Mon(Mon).Name) or not getgenv().Config["Start Kaitun"] end)
            end

            if Check_Near_Mon(Mon) then
                for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if table.find(Mon,v.Name) and Check_Available_Mon(v) then 
                        Start_Attack(v,function()
                            return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v) or Check_Tool_Inventory("Hidden Key")
                        end)
                    end
                end
            end
        end
    end
end

function Get_Ghoul_Mask()
    if Check_Tool_Remote("Ghoul Mask") then return end
    if Check_Total_Material("Ectoplasm") >= 50 then
        Use_Remote("Ectoplasm","Buy",2)
    else
        local Mon = {"Ship Deckhand";"Ship Engineer";"Ship Steward";"Ship Officer"}

        if not Check_Near_Mon(Mon) then
            Go_To_Mon_Spawn(Mon,function()
                return not getgenv().Config["Start Kaitun"]
            end)
        end

        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Check_Near_Mon(Mon).Name) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Mon) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if table.find(Mon,v.Name) and Check_Available_Mon(v) then 
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v) or Check_Tool_Inventory("Hidden Key")
                    end)
                end
            end
        end        
    end
end

function Get_Black_Spikey_Coat()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Black Spikey Coat") then return end

        Boss = "Jeremy"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Blue_Spikey_Coat()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Blue Spikey Coat") then return end

        Boss = "Cursed Captain"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

function Get_Swan_Glasses()
    if getgenv().Config["Start Kaitun"] then
        if not SecondSea then return end
        if Check_Tool_Remote("Swan Glasses") then return end

        Boss = "Don Swan"

        if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
            Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Boss) or not getgenv().Config["Start Kaitun"] end)
        end

        if Check_Near_Mon(Boss) and workspace.Enemies:FindFirstChild(Boss) then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == Boss and Check_Available_Mon(v) then
                    Start_Attack(v,function()
                        return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
                    end)
                end
            end
        end
    end
end

task.spawn(function()
    AvailablePlayer = {}
    if not FirstSea then return end
    while wait(.75) do
        if getgenv().Config["Start Kaitun"] and Local_Player.Data.Level.Value > 50 and Local_Player.Data.Level.Value < 300 then
            Player_Can_Hunt = false
            table.clear(AvailablePlayer)
            for i,v in pairs(game.Players:GetPlayers()) do
                local Human = v.Character and v.Character:FindFirstChild("Humanoid")
                if v ~= Local_Player and Human and Human and Human.Health > 0 and not CollectionService:HasTag(v,"Ally"..Local_Player.Name) then
                    if v.Data.Level.Value > 20 and math.abs(v.Data.Level.Value - Local_Player.Data.Level.Value) < 100 then
                        Player_Can_Hunt = true
                        AvailablePlayer[v.Name] = true
                        -- table.foreach(AvailablePlayer ,print)
                    end
                end
            end
        end
    end
end)

function Up_Base_Stats()
    if Local_Player.Data.Stats.Melee.Level.Value < Max_Level_Value then
        Use_Remote("AddPoint","Melee",math.huge)
    end
    if Local_Player.Data.Stats.Melee.Level.Value >= Max_Level_Value then
        Use_Remote("AddPoint","Defense",math.huge)
    end
end

task.spawn(function()
    while wait(1) do
        if getgenv().Config["Start Kaitun"] then
            pcall(function()
                if not Local_Player.Character:FindFirstChild("HumanoidRootPart") then 
                    return
                end
                if not Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip") and Local_Player.Character:FindFirstChild("HumanoidRootPart") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = Local_Player.Character.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000,100000,100000)
                    Noclip.Velocity = Vector3.new(0,0,0)
                end
            end)
        else
            if Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
             end
        end
    end
end)

function Rejoin()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,Local_Player)
end

game:GetService("CoreGui"):FindFirstChild("promptOverlay",true).DescendantAdded:Connect(function(v)
    if getgenv().Config["Auto Rejoin"] then
        Rejoin()
    end
end)
game:service("GuiService").UiMessageChanged:Connect(function(v)
    if getgenv().Config["Auto Rejoin"] then
        Rejoin()
    end
end)

function Raid(Chip)
    task.spawn(function()
        while wait(1) and DoRaid do
            if FirstSea then return end
            if DoRaid and not Raiding() then
                wait(3)
                Stop_Store_Fruit = true
                if not Check_Raid_Chip() and not Raiding() then
                    if not Check_Fruit_Inventory() then
                        local Fruits = Use_Remote("getInventoryFruits")
                        local Cheapest = {Price = 1/0}
                        for i,v in pairs(Fruits or {}) do
                            if v.Price < 1000000 and v.Price < Cheapest.Price then
                                Cheapest = v
                            end
                        end
                        if Cheapest.Name then
                            Use_Remote("LoadFruit",Cheapest.Name)
                        end
                    end
                    if Check_Fruit_Inventory() then
                        Use_Remote("RaidsNpc","Select",Chip)
                    end
                end

                if Check_Raid_Chip() and not Raiding() then
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
            if DoRaid and Raiding() then
                function Kill_Aura()
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if Check_Available_Mon(v) then
                            v.Humanoid.Health = 0
                            v.HumanoidRootPart.CanCollide = false
                        end
                    end
                end
                repeat task.wait(0.02)
                    Need_Noclip = true
                    Kill_Aura()
                    local islandNames = {"Island 5", "Island 4", "Island 3", "Island 2", "Island 1"}
                    local nearestIsland
                    
                    for _, islandName in ipairs(islandNames) do
                        local island = workspace["_WorldOrigin"].Locations:FindFirstChild(islandName)
                        if island then
                            local islandPosition = island.Position
                            if dist(islandPosition) <= 3000 then
                                nearestIsland = island
                                break
                            elseif not nearestIsland or dist(islandPosition) < dist(nearestIsland.Position) then
                                nearestIsland = island
                            end
                        end
                    end
                    
                    if nearestIsland then
                        TP(nearestIsland.CFrame * CFrame.new(0, 70, 100))
                    end
                    
                    -- if workspace["_WorldOrigin"].Locations:FindFirstChild("Island 5") and dist(workspace["_WorldOrigin"].Locations["Island 5"].Position) <= 3000 then
                    --     TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame * CFrame.new(0,70,100))
                    -- elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 4") and dist(workspace["_WorldOrigin"].Locations["Island 4"].Position) <= 3000 then
                    --     TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame * CFrame.new(0,70,100))
                    -- elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 3") and dist(workspace["_WorldOrigin"].Locations["Island 3"].Position) <= 3000 then
                    --     TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame * CFrame.new(0,70,100))
                    -- elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 2") and dist(workspace["_WorldOrigin"].Locations["Island 2"].Position) <= 3000 then
                    --     TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame * CFrame.new(0,70,100))
                    -- elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1") and dist(workspace["_WorldOrigin"].Locations["Island 1"].Position) <= 3000 then
                    --     TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame * CFrame.new(0,70,100))
                    -- end
                until not DoRaid or not Raiding()
                Need_Noclip = false
                Stop_Store_Fruit = false
            end
        end
    end)
end

function Buy_All_Sword()
    print("Buy Sword")
	Use_Remote("BuyItem","Swordsman Hat")
	Use_Remote("BuyItem","Tomoe Ring")
	Use_Remote("BuyItem","Black Cape")
	Use_Remote("BlackbeardReward","Slingshot","1")
	Use_Remote("BlackbeardReward","Slingshot","2")
	Use_Remote("BuyItem","Cannon")
	Use_Remote("BuyItem","Refined Flintlock")
	Use_Remote("BuyItem","Flintlock")
	Use_Remote("BuyItem","Musket")
	Use_Remote("BuyItem","Slingshot")
	Use_Remote("BuyItem","Soul Cane")
	Use_Remote("BuyItem","Bisento")
	Use_Remote("BuyItem","Dual-Headed Blade")
	Use_Remote("BuyItem","Pipe")
	Use_Remote("BuyItem","Triple Katana")
	Use_Remote("BuyItem","Iron Mace")
	Use_Remote("BuyItem","Duel Katana")
	Use_Remote("BuyItem","Cutlass")
	Use_Remote("BuyItem","Katana")
end

function Bring_Fruit() 
    for i,v in pairs(workspace:GetChildren()) do
        if string.find(v.Name, "Fruit") or v.Name:find("Fruit") then
            Local_Player.Character.HumanoidRootPart.CFrame = CFrame.new(v:WaitForChild("Handle").Position)
            -- if dist(Local_Player.Character.HumanoidRootPart.CFrame,v:WaitForChild("Handle").Position) <= 10 then
            --     firetouchinterest(v.Handle,Local_Player.Character.HumanoidRootPart,0)
            --     task.wait()
            --     firetouchinterest(v.Handle,Local_Player.Character.HumanoidRootPart,1)
            -- end
        end
    end
end

function Shanda_Farm()
    print("SKIP")
    Mon = "Shanda"
    if not Check_Near_Mon(Mon) then
        Go_To_Mon_Spawn(Mon,function()
            return not getgenv().Config["Start Kaitun"] 
        end)
    end

    if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
        Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame,function()
            return not getgenv().Config["Start Kaitun"] or workspace.Enemies:FindFirstChild(Mon)
        end)
    end

    if Check_Near_Mon(Mon) then
        for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == Mon or v.Name:match(Mon) and Check_Available_Mon(v) then 
                Start_Attack(v,function()
                    return not getgenv().Config["Start Kaitun"] or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                end)
            end
        end
    end
end

function Kill_Player_Quest()

        local function Use_Skill(Ready_To_Kill)
        if Ready_To_Kill then
            game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
        end
        if Ready_To_Kill then
            game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
        end  
    end

    print("KILL")
    for i,v in pairs(AvailablePlayer) do
        print(i,v)
        -- if not Local_Player.PlayerGui.Main.Quest.Visible then
        --     repeat task.wait(.1) 
        --         Use_Remote("PlayerHunter")
        --     until Local_Player.PlayerGui.Main.Quest.Visible
        -- end

        task.delay(30,function()
            if not string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,i) and tostring(Use_Remote("PlayerHunter")):find("We heard some") then
                Server_Hop("Anti Bug")
            end
        end)

        if Local_Player.PlayerGui.Main.Quest.Visible and string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,i) then
            repeat task.wait(0.02)
                Equip_Tool(Current_Weapon)
                if not Local_Player.Character:FindFirstChild("HasBuso") then
                    Use_Remote("Buso")
                end 
                if Local_Player.PlayerGui.Main.PvpDisabled.Visible then
                    Use_Remote("EnablePvp")
                end
                if dist(workspace.Characters[i].HumanoidRootPart.CFrame) <= 5 then
                    task.spawn(Use_Skill,true)
                end
                TP(workspace.Characters[i].HumanoidRootPart.CFrame * CFrame.new(0,2,0))
                NeedAttacking = true
            until Local_Player.PlayerGui.Main.BottomHUDList.SafeZone.Visible or not Local_Player.PlayerGui.Main.Quest.Visible or not string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,i) or not getgenv().Config["Start Kaitun"]
            Use_Remote("AbandonQuest")
        end
    end
end

function Main_Level_Farm()
    print("FARMING")
    if not Local_Player.PlayerGui.Main.Quest.Visible then 
        if Double_Quest then 
            Level , Data = QuestManager:GetQuest()  
            if not QuestManager.DataData[Level].Used then 
                QuestManager.DataData[Level].Used = true 
            end
            if Data[Level].Mon == "Bandit" then
                local badit_CFrame = CFrame.new(1061.66699, 16.5166187, 1544.52905, -0.942978859, -3.33851502e-09, 0.332852632, 7.04340497e-09, 1, 2.99841325e-08, -0.332852632, 3.06188177e-08, -0.942978859)
                Go_to_Part(badit_CFrame,function() return not getgenv().Config["Start Kaitun"] or dist(badit_CFrame.Position) <= 3 end)
            else
                Go_to_Part(Data[Level].CFrameQuest,function() return not getgenv().Config["Start Kaitun"] or dist(Data[Level].CFrameQuest.Position) <= 3 end)
            end
            wait(.5)
            Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest)
            wait(.5)
        else
            Level , Data = QuestManager:GetQuest()  
            -- Go_to_Part(Data[Level].CFrameQuest,function() return not getgenv().Config["Start Kaitun"] or dist(Data[Level].CFrameQuest.Position) <= 3 end)
            -- if Data[Level].Mon ~= "Bandit" then Go_to_Part(Data[Level].CFrameQuest,function() return not getgenv().Config["Start Kaitun"] or dist(Data[Level].CFrameQuest.Position) <= 3 end) end
            if Data[Level].Mon == "Bandit" then
                local badit_CFrame = CFrame.new(1061.66699, 16.5166187, 1544.52905, -0.942978859, -3.33851502e-09, 0.332852632, 7.04340497e-09, 1, 2.99841325e-08, -0.332852632, 3.06188177e-08, -0.942978859)
                Go_to_Part(badit_CFrame,function() return not getgenv().Config["Start Kaitun"] or dist(badit_CFrame.Position) <= 3 end)
            else
                Go_to_Part(Data[Level].CFrameQuest,function() return not getgenv().Config["Start Kaitun"] or dist(Data[Level].CFrameQuest.Position) <= 3 end)
            end
            wait(.5)
            Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest)
            wait(.5)
        end
    end
                            
    if not Check_Near_Mon(Data[Level].Mon) then
        Go_To_Mon_Spawn(Data[Level].Mon,function()
            return not getgenv().Config["Start Kaitun"]
        end)
    end

    if Check_Near_Mon(Data[Level].Mon) and not workspace.Enemies:FindFirstChild(Data[Level].Mon) then
        Go_to_Part(Check_Near_Mon(Data[Level].Mon).HumanoidRootPart.CFrame,function()
            return not getgenv().Config["Start Kaitun"] or workspace.Enemies:FindFirstChild(Data[Level].Mon)
        end)
    end

    if Check_Near_Mon(Data[Level].Mon) then 
        for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == Data[Level].Mon and Check_Available_Mon(v) then 
                Start_Attack(v,function()
                    return not getgenv().Config["Start Kaitun"] or not Check_Available_Mon(v) or not Local_Player.PlayerGui.Main.Quest.Visible
                end)
            end
        end
    end
end

task.spawn(function()
    while wait(1) do
        -- Function to remove spaces from fruit names
        function RemoveSpaces(str)
            return str:gsub(" Fruit", "")
        end

        -- Function to store a fruit in the inventory
        function StoreFruit(fruitName, fruit)
            local Remote_Inventory_Fruit = Use_Remote("getInventoryFruits")
            local HaveFruitInStore = false

            -- Check if the fruit is already in the store
            for _, v1 in pairs(Remote_Inventory_Fruit) do
                if v1.Name == fruitName then
                    HaveFruitInStore = true
                    break
                end
            end

            if not HaveFruitInStore then
                if fruit then
                    Use_Remote("StoreFruit", fruitName, fruit)
                else
                    -- warn("Fruit not found: " .. fruitName)
                end
            else
                -- warn("Fruit already in store: " .. fruitName)
            end
        end

        -- Function to process fruits in a given container (backpack or character)
        function ProcessFruits(container)
            for _, v in pairs(container:GetChildren()) do
                if string.find(v.Name, "Fruit") then
                    local FruitName = RemoveSpaces(v.Name)
                    local NameFruit
                    if v.Name == "Bird: Falcon Fruit" then
                        NameFruit = "Bird-Bird: Falcon"
                    elseif v.Name == "Bird: Phoenix Fruit" then
                        NameFruit = "Bird-Bird: Phoenix"
                    elseif v.Name == "Human: Buddha Fruit" then
                        NameFruit = "Human-Human: Buddha"
                    else
                        NameFruit = FruitName .. "-" .. FruitName
                    end
                    StoreFruit(NameFruit, v)
                end
            end
        end

        -- Main execution
        -- warn("Store Fruit")
        ProcessFruits(Local_Player.Backpack)
        ProcessFruits(Local_Player.Character)
    end
end)

task.spawn(function()
    local Has_Buso = Use_Remote("BuyHaki","Buso")
    local Has_Geppo = Use_Remote("BuyHaki","Geppo")
    local Has_Soru = Use_Remote("BuyHaki","Soru")
    local Has_Observation_Haki = Use_Remote("KenTalk","Status")
    while wait(1) do         
        task.spawn(Buy_All_Sword)
        if SecondSea then
            Use_Remote("LegendarySwordDealer","2")
        end
        if not FirstSea then
            Use_Remote("ColorsDealer","2")
        end
        if Has_Buso == 1 then
            Use_Remote("BuyHaki","Buso")
        end

        if Has_Geppo == 1 then
            Use_Remote("BuyHaki","Geppo")
        end

        if Has_Soru == 1 then
            Use_Remote("BuyHaki","Soru")
        end

        if not Has_Observation_Haki then
            Use_Remote("KenTalk","Buy")
        end

        if Use_Remote("Cousin","Buy") == 1 then
            Use_Remote("Cousin","Buy")
        end
    end
end)

function Highlight_Monster()
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if Check_Available_Mon(v) and not v:FindFirstChild("Highlight") then
            Instance.new("Highlight",v)
        end
    end
end

function Highlight_Player()
    if (Local_Player.Character and Local_Player.Character:FindFirstChild("HumanoidRootPart")) and not Local_Player.Character:FindFirstChild("Highlight") then
        Instance.new("Highlight",Local_Player.Character)
        Local_Player.Character.Highlight.FillColor = Color3.fromRGB(0,255,0)
    end
end

task.spawn(function()
    while wait(.5) do
        task.spawn(Highlight_Monster)
        task.spawn(Highlight_Player)
    end
end)

task.spawn(function()
    while wait(.5) do
        if getgenv().Config["Start Kaitun"] then
            local s,r = pcall(function()
                print("ST")
                local MyLevel = Local_Player.Data.Level.Value
                if MyLevel <= Max_Level_Value then
                    task.spawn(Up_Base_Stats)
                    task.spawn(Bring_Fruit)
                    -- task.spawn(function()
                    --     if Local_Player.PlayerGui.Notifications:FindFirstChild("NotificationTemplate") and Local_Player.PlayerGui.Notifications.NotificationTemplate.Text:find("Something weird") then
                    --         Do_Bisento_V2 = true
                    --     end
                    -- end)

                    if not Hassuperhuman then

                        if not HasBlackleg and Local_Player.Data.Beli.Value >= 150000 then
                            Use_Remote("BuyBlackLeg")
                        end
            
                        if Check_Mastery("Black Leg",300) then
                            Use_Remote("BuyElectro")
                        end
            
                        if Check_Mastery("Electro",300) then
                            Use_Remote("BuyFishmanKarate")
                        end 
            
                        if Check_Mastery("Fishman Karate",300) then
                            if Local_Player.Data.Level.Value > 1100 then
                                if Local_Player.Data.Fragments.Value >= 1500 then
                                    DoRaid = false
                                    Raid("Dark")
                                    Use_Remote("BlackbeardReward","DragonClaw","1")
                                    Use_Remote("BlackbeardReward","DragonClaw","2")
                                else 
                                    DoRaid = true
                                    return Raid("Dark")
                                end
                            end
                        end
            
                        if Check_Mastery("Dragon Claw",300) then
                            Use_Remote("BuySuperhuman")
                            Hassuperhuman = true
                        end
                    end

                    if Check_Tool_Inventory("Water Key") then
                        Use_Remote("BuySharkmanKarate",true)
                    end

                    if Check_Tool_Inventory("Hidden Key") and not Check_Tool_Remote("Rengoku") then
                        repeat task.wait(.1) Use_Remote("OpenRengoku") until not Check_Tool_Inventory("Hidden Key") or Check_Tool_Remote("Rengoku")
                    end            

                    if FirstSea and getgenv().Config["Farm Setting"]["Get All Item"]["Enabled"] and
                        (Check_Tool_Remote("Pole (1st Form)") and
                        Check_Tool_Remote("Shark Saw") and
                        Check_Tool_Remote("Trident") and
                        Check_Tool_Remote("Wardens Sword") and
                        Check_Tool_Remote("Pink Coat") and
                        Check_Tool_Remote("Coat") and
                        Check_Tool_Remote("Cool Shades") and
                        Check_Tool_Remote("Saber") and
                        Check_Tool_Remote("Refined Musket") and
                        Check_Tool_Remote("Bazooka"))
                        -- and Do_Bisento_V2
                    then    
                        return Go_To_Second_Sea()
                    else 
                        if FirstSea and MyLevel > 300 and getgenv().Config["Farm Setting"]["Get All Item"]["Enabled"] then
                            print("Finding Staff")
                            local tasks = {
                                {monster = "Saber Expert", tool = "Saber", action = Get_Saber},
                                {monster = "Fishman Lord", tool = "Trident", action = Get_Trident},
                                {monster = "Thunder God", tool = "Pole (1st Form)", action = Get_Pole},
                                {monster = "The Saw", tool = "Shark Saw", action = Get_Shark_Saw},
                                {monster = "Chief Warden", tool = "Wardens Sword", action = Get_Wardens_Sword},
                                {monster = "Swan", tool = "Pink Coat", action = Get_Pink_Coat},
                                {monster = "Vice Admiral", tool = "Coat", action = Get_Coat},
                                {monster = "Cyborg", tool = "Cool Shades", action = Get_Cool_Shades},
                                {monster = "Magma Admiral", tool = "Refined Musket", action = Get_Refined_Musket},
                                {monster = "Wysper", tool = "Bazooka", action = Get_Bazooka}
                            }
    
                            local function check_all_tools_farmed()
                                for _, task in pairs(tasks) do
                                    if not Check_Tool_Remote(task.tool) then
                                        return false
                                    end
                                end
                                return true
                            end
    
                            local function all_bosses_not_spawned()
                                for _, task in pairs(tasks) do
                                    if (Check_Near_Mon(task.monster) and Check_Near_Mon(task.monster).Humanoid.Health > 0) and not Check_Tool_Remote(task.tool) then
                                        return false 
                                    end
                                end
                                return true 
                            end
    
                            farmed_all_tools = check_all_tools_farmed()
    
                            if not farmed_all_tools then
                                for _, task in pairs(tasks) do
                                    if Check_Near_Mon(task.monster) and not Check_Tool_Remote(task.tool) then
                                        return task.action()
                                    end
                                    if getgenv().Config["Farm Setting"]["Get All Item"]["Method"] == "Fully" and all_bosses_not_spawned() and not Check_Tool_Remote(task.tool) then
                                        Server_Hop("Finding : "..task.monster)
                                    end
                                end
    
                                farmed_all_tools = check_all_tools_farmed()
                            end
                        end    
                    end

                    -- if FirstSea and MyLevel >= 200 then
                    --     if not Check_Tool_Remote("Saber") then
                    --         if Check_Near_Mon("Saber Expert") then
                    --             return Get_Saber()
                    --         else
                    --             return Server_Hop("Finding Saber Expert")
                    --         end
                    --     end
                    -- end
                    
                    if SecondSea and MyLevel >= 1500 then

                        if not Check_Tool_Remote("Midnight Blade") then
                            repeat
                                wait(0.5)
                                Get_Midnight_Blade()
                            until Check_Tool_Remote("Midnight Blade")
                        end
                        
                        if not Check_Tool_Remote("Rengoku") then
                            repeat
                                wait(0.5)
                                Get_Rengoku()
                            until Check_Tool_Remote("Rengoku")
                        end
                        
                        if Check_Near_Mon("Jeremy") and not Check_Tool_Remote("Warrior Helmet") then
                            repeat
                                wait(0.5)
                                Bartilo_Quest()
                            until Check_Tool_Remote("Warrior Helmet") or not Check_Near_Mon("Jeremy")
                        end
                        
                        if Check_Near_Mon("Tide Keeper") and not Check_Tool_Remote("Dragon Trident") then
                            -- return Get_Dragon_Trident()
                            repeat
                                wait(0.5)
                                Get_Dragon_Trident()
                            until Check_Tool_Remote("Dragon Trident") or not Check_Near_Mon("Tide Keeper")
                        end
                        
                        if Check_Near_Mon("Fajita") and not Check_Tool_Remote("Gravity Cane") then
                            repeat
                                wait(0.5)
                                Get_Gravity_Cane()
                            until Check_Tool_Remote("Gravity Cane") or not Check_Near_Mon("Fajita")
                        end
                        
                        if Check_Near_Mon("Smoke Admiral") and not Check_Tool_Remote("Jitte") then
                            repeat
                                wait(0.5)
                                Get_Jitte()
                            until Check_Tool_Remote("Jitte") or not Check_Near_Mon("Smoke Admiral")
                        end
                        
                        if Check_Near_Mon("Diamond") and not Check_Tool_Remote("Longsword") then
                            repeat
                                wait(0.5)
                                Get_Longsword()
                            until Check_Tool_Remote("Longsword") or not Check_Near_Mon("Diamond")
                        end

                        --Acces
                        
                        if not Check_Tool_Remote("Ghoul Mask") then
                            repeat
                                wait(0.5)
                                Get_Ghoul_Mask()
                            until Check_Tool_Remote("Ghoul Mask")
                        end
                        
                        if Check_Near_Mon("Jeremy") and not Check_Tool_Remote("Black Spikey Coat") then
                            repeat
                                wait(0.5)
                                Get_Black_Spikey_Coat()
                            until Check_Tool_Remote("Black Spikey Coat") or not Check_Near_Mon("Jeremy")
                        end

                        if Check_Near_Mon("Cursed Captain") and not Check_Tool_Remote("Blue Spikey Coat") then
                            repeat
                                wait(0.5)
                                Get_Blue_Spikey_Coat()
                            until Check_Tool_Remote("Blue Spikey Coat") or not Check_Near_Mon("Cursed Captain")
                        end
                        
                        if Use_Remote("GetUnlockables").FlamingoAccess and Check_Near_Mon("Don Swan") and not Check_Tool_Remote("Swan Glasses") then
                            repeat
                                wait(0.5)
                                Get_Swan_Glasses()
                            until Check_Tool_Remote("Swan Glasses") or not Check_Near_Mon("Don Swan")
                        end

                        -- For Hop

                        if not Check_Near_Mon("Tide Keeper") and not Check_Tool_Remote("Dragon Trident") then
                            return Server_Hop("Finding Tide Keeper")
                        end

                        if not Check_Near_Mon("Fajita") and not Check_Tool_Remote("Gravity Cane") then
                            return Server_Hop("Finding Fajita")
                        end

                        if not Check_Near_Mon("Smoke Admiral") and not Check_Tool_Remote("Jitte") then
                            return Server_Hop("Finding Smoke Admiral")
                        end

                        if not Check_Near_Mon("Diamond") and not Check_Tool_Remote("Longsword") then
                            return Server_Hop("Finding Diamond")
                        end

                        if not Check_Near_Mon("Jeremy") and not Check_Tool_Remote("Black Spikey Coat") then
                            return Server_Hop("Finding Jeremy")
                        end

                        if not Check_Near_Mon("Cursed Captain") and not Check_Tool_Remote("Blue Spikey Coat") then
                            return Server_Hop("Finding Cursed Captain")
                        end

                        if Use_Remote("GetUnlockables").FlamingoAccess and not Check_Near_Mon("Don Swan") and not Check_Tool_Remote("Swan Glasses") then
                            return Server_Hop("Finding Don Swan")
                        end
                        
                    end

                    if MyLevel >= 20 and MyLevel <= 50 then 
                        Shanda_Farm()
                    elseif MyLevel > 50 and MyLevel < 300 and FirstSea and Player_Can_Hunt and tostring(Use_Remote("PlayerHunter")):find("We heard some") then
                        Kill_Player_Quest()
                    else
                        Main_Level_Farm()
                    end
                end
            end)
            if not s then warn("Main : "..r) end
        end
    end
end)

--

-- local ScreenGui = Instance.new("ScreenGui")
-- ScreenGui.Parent = game:GetService("CoreGui")
-- local ImageButton = Instance.new("ImageButton")
-- local UICorner = Instance.new("UICorner")
-- local SoundClick = Instance.new("Sound")

-- ImageButton.Parent = ScreenGui
-- ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
-- ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
-- ImageButton.BorderSizePixel = 0
-- ImageButton.Position = UDim2.new(0.126207203, 0, 0.142163664, 0)
-- ImageButton.Size = UDim2.new(0, 50, 0, 50)
-- ImageButton.Image = "rbxassetid://16098708875"

-- UICorner.CornerRadius = UDim.new(1, 0)
-- UICorner.Parent = ImageButton

-- SoundClick.Name = "Sound Effect"
-- SoundClick.Parent = ImageButton
-- SoundClick.SoundId = "rbxassetid://130785805"
-- SoundClick.Volume = 1

-- ImageButton.MouseButton1Click:Connect(function()
--     SoundClick:Play()
--     game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
--     game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
-- end)

FastAttack = true
NewFastAttack = true
NoAttackAnimation = true
-- getgenv().Config["Start Kaitun"] = true

for i,v in pairs(Code) do
    game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v)
end

-- local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- local colors = {
--     SchemeColor = Color3.fromRGB(0, 0, 0),
--     Background = Color3.fromRGB(24, 24, 24),
--     Header = Color3.fromRGB(0, 0, 0),
--     TextColor = Color3.fromRGB(255,255,255),
--     ElementColor = Color3.fromRGB(20, 20, 20)
-- }

-- local Window = Library.CreateLib("Galaxy Hub", colors)

-- local General_Tab = Window:NewTab("General")

-- local General_Section = General_Tab:NewSection("Main")

-- General_Section:NewToggle("Auto Start Kaitun", "Turn on for Start Kaitun", function(value)
--     getgenv().Config["Start Kaitun"] = value    
-- end)

-- local Setting_Section = General_Tab:NewSection("Setting")

-- Setting_Section:NewButton("Redeem All Code", "Redeem All Code", function()
--     for i,v in pairs(Code) do
--         game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v)
--     end
-- end)

-- local Item_Tab = Window:NewTab("Item")

-- local Sword_Check_Section = Item_Tab:NewSection("Sword")

-- local addedSwords = {}

-- task.spawn(function()
--     while true do
--         local Remote_Inventory = Use_Remote("getInventory")
        
--         for i, v in pairs(Remote_Inventory) do
--             if v.Type == "Sword" and not addedSwords[v.Name] then 
--                 Sword_Check_Section:NewLabel("✅ : "..v.Name)
--                 addedSwords[v.Name] = true  -- Mark sword as added
--             end
--         end
        
--         wait(1)  -- Wait before checking again
--     end
-- end)

-- local Accesory_Check_Section = Item_Tab:NewSection("Accesory")

-- local addedAccessory = {}

-- task.spawn(function()
--     while true do
--         local Remote_Inventory = Use_Remote("getInventory")
        
--         for i, v in pairs(Remote_Inventory) do
--             if v.Type == "Wear" and not addedAccessory[v.Name] then 
--                 Accesory_Check_Section:NewLabel("✅ : "..v.Name)
--                 addedAccessory[v.Name] = true  -- Mark sword as added
--             end
--         end
        
--         wait(1)  -- Wait before checking again
--     end
-- end)

-- local Gun_Check_Section = Item_Tab:NewSection("Gun")

-- local addedGun = {}

-- task.spawn(function()
--     while true do
--         local Remote_Inventory = Use_Remote("getInventory")
        
--         for i, v in pairs(Remote_Inventory) do
--             if v.Type == "Gun" and not addedGun[v.Name] then 
--                 Gun_Check_Section:NewLabel("✅ : "..v.Name)
--                 addedGun[v.Name] = true  -- Mark sword as added
--             end
--         end
        
--         wait(1)  -- Wait before checking again
--     end
-- end)
