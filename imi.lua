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
-- local Local_Player.Character = Local_Player.Character
-- local Root = Local_Player.Character.HumanoidRootPart
Players = game.Players

repeat wait() until Players

CollectionService = game:GetService("CollectionService")

local kkii = require(game.ReplicatedStorage.Util.CameraShaker)
kkii:Stop()

CurrentAllMob = {}
recentlySpawn = 0
StoredSuccessFully = 0
canHits = {}
RecentCollected = 0
FruitInServer = {}
RecentlyLocationSet = 0
lastequip = tick()

PC = require(Local_Player.PlayerScripts.CombatFramework.Particle)
RL = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
DMG = require(Local_Player.PlayerScripts.CombatFramework.Particle.Damage)
RigC = getupvalue(require(Local_Player.PlayerScripts.CombatFramework.RigController),2)
Combat =  getupvalue(require(Local_Player.PlayerScripts.CombatFramework),2)

RunService = game:GetService("RunService")

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

local All_Sea_Level_Position = {
    ["Level 1"] = CFrame.new(-23389.0898, 10.9074259, 296.483856, -0.0450573377, 0.000193513129, 0.998984396, 0.00429478567, 0.999990761, 2.47677212e-10, -0.998975158, 0.00429042382, -0.0450577512),
    ["Level 2"] = CFrame.new(-25876.0156, 10.9075279, 5039.88672, -0.280789793, -0.00336067379, 0.959763408, -0.0119677978, 0.999928355, -2.53116017e-09, -0.959694684, -0.0114862556, -0.280809909),
    ["Level 3"] = CFrame.new(-29253.4727, 10.9073896, 7178.87695, -0.495283306, 0.00373801985, 0.868723452, 0.00754702045, 0.999971509, -4.56886473e-11, -0.868698716, 0.0065562739, -0.495297432),
    ["Level 4"] = CFrame.new(-32652.248, 10.9073563, 9512.91992, -0.681220591, 0.00730621675, 0.732041717, 0.0107245669, 0.999942482, -4.62178074e-10, -0.731999636, 0.00785083044, -0.681259811),
    ["Level 5"] = CFrame.new(-35744.3672, 10.907443, 12456.9619, -0.700875878, -0.00188420608, 0.713280737, -0.00268834946, 0.999996364, -6.71825998e-11, -0.713278174, -0.0019175479, -0.700878441),
    ["Level 6"] = CFrame.new(-37822.7188, 10.9074373, 15771.582, -0.917537987, 0.00250468403, 0.397640318, 0.00272977748, 0.999996245, -1.12917967e-10, -0.397638828, 0.0010854695, -0.917541385),
}

-- Get sorted sea indices
local sortedSeaIndices = {}
for seaIndex in pairs(All_Sea_Level_Position) do
    table.insert(sortedSeaIndices, seaIndex)
end
table.sort(sortedSeaIndices)

MasteryData = {}

Check_Buy_Melee = {}

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

All_Random_Position = {
    CFrame.new(0,60,0),
    CFrame.new(0,0,60),
    CFrame.new(0,0,-60),
    CFrame.new(60,0,0),
    CFrame.new(-60,0,0),
}

if FirstSea then
    All_Material = {
        "Fish Tail";
        "Scrap Metal";
        "Angel Wings";
        "Magma Ore";
    }
elseif SecondSea then
    All_Material = {
        "Magma Ore";
        "Radioactive";
        "Scrap Metal";
        "Vampire Fang";
        "Mystic Droplet";
        "Ectoplasm";
    }
elseif ThirdSea then
    All_Material = {
        "Scrap Metal";
        "Conjured Cocoa";
        "Fish Tail";
        "Mini Tusk";
        "Dragon Scale";
        "Demonic Wisp";
        "Bones";
        "Gunpowder";
    }
end

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

QuestManager.QuestBoss = function() 
    local Data , Result = {} , {}  ; 

    for i ,v in pairs(QuestManager.AllQuest) do 
        for i2 ,v2 in pairs(v.Value)do 
            if QuestManager:FindValue(v2.Task) == 1 and game.PlaceId == 2753915549 and v2.LevelReq < 700 then 
                Data[v2.Name] = {
                    Index = i , 
                    Value = v2 ,
                }  
            elseif QuestManager:FindValue(v2.Task) == 1 and game.PlaceId == 4442272183 and v2.LevelReq > 700 and v2.LevelReq < 1500 then 
                 Data[v2.Name] = {
                    Index = i , 
                    Value = v2 ,
                }  
            elseif QuestManager:FindValue(v2.Task) == 1  and game.PlaceId == 7449423635 and v2.LevelReq > 1500 and v2.LevelReq < 2500  then 
                Data[v2.Name] = {
                    Index = i , 
                    Value = v2 ,
                }          
            end
        end
    end
    
    for i ,v in pairs(Data) do 
    	Result[v.Index] = {
		  Mon = QuestManager:FindIndex(v.Value.Task) ,
		  NameQuest = v.Index ,
		  NumberQuest = QuestManager:FindData(v.Index,v.Value.LevelReq).Index,
		  CFrameQuest = QuestManager:Npcs(v.Value.LevelReq,v.Value.Task).Index.CFrame   ,   
	     }
    end
    
    local Mons = {} ;
    
    for i ,v in pairs(Result) do 
        table.insert(Mons,v.Mon) ;
    end
    
    return Result  , Mons 
end

local DataQuest , Mon = QuestManager.QuestBoss()

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


-- dist = function(a,b,noHeight)
--     if not b then
--         b = Local_Player.Character.HumanoidRootPart.Position
--     end
--     return (Vector3.new(a.X,not noHeight and a.Y,a.Z) - Vector3.new(b.X,not noHeight and b.Y,b.Z)).magnitude
-- end

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
    if not Local_Player.Character.HumanoidRootPart then return end
    if tweenPause then return end
    local thisId
    local s,e = pcall(function()
        local Dista,distm,middle = dist(target,nil,true),1/0
        if Local_Player.Character and Local_Player.Character.HumanoidRootPart and Dista >= 2000 and tick() - recentlySpawn > 5 then
            for i,v in pairs(CanTeleport[SeaIndex]) do
                local distance = dist(v,target,true)
                if distance < dist(target,nil,true) and distance < distm then
                    distm,middle = distance,v
                end
            end
            if Teleport_Island and middle and InArea(Local_Player.Character.HumanoidRootPart.Position) ~= InArea(middle) and not Raiding() then
                -- print(Local_Player.Character.HumanoidRootPart.Position,"\n",target.p)
                -- print(Dista,distm,CurrentArea,InArea(middle))
                Use_Remote("requestEntrance",middle)
            end 
            if Bypass_Tp then
                if Local_Player.Character.HumanoidRootPart and not Raiding() then
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
                    local Dista = dist(target,nil,true)
                    if nearest and (charDist <= 9200) then
                        if Dista >= 2000 then
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
            while Local_Player.Character.HumanoidRootPart and currentDistance > 75 and thisId == tweenid and Local_Player.Character.Humanoid.Health > 0 do
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
            if currentDistance <= 300 and thisId == tweenid then
                Local_Player.Character.HumanoidRootPart.CFrame = target
            end
        end)
    end)
    if not s then warn("TP :",e) end
    return thisId
end

-- function Go_to_Part(Part,State_Ment) 
--     local State_Ment = State_Ment or function() return true end
--     repeat task.wait() TP(CFrame.new(Part.Position)) until State_Ment()
-- end

function Material_Mon()
    if FirstSea then
        if Material == "Fish Tail" then
            MonMaterial = {"Fishman Warrior [Lv. 375]";"Fishman Commando [Lv. 400]";}
        elseif Material == "Scrap Metal" then
            MonMaterial = {"Brute [Lv. 45]";}
        elseif Material == "Angel Wings" then
            MonMaterial = {"Royal Squad [Lv. 525]";"Royal Soldier [Lv. 550]";}
        elseif Material == "Magma Ore" then
            MonMaterial = {"Military Soldier [Lv. 300]";"Military Spy [Lv. 325]";}
        end
    elseif SecondSea then
        if Material == "Magma Ore" then
            MonMaterial = {"Magma Ninja [Lv. 1175]";"Lava Pirate [Lv. 1200]";}
        elseif Material == "Radioactive" then
            MonMaterial = {"Factory Staff [Lv. 800]";}
        elseif Material == "Scrap Metal" then
            MonMaterial = {"Swan Pirate [Lv. 775]";}
        elseif Material == "Vampire Fang" then
            MonMaterial = {"Vampire [Lv. 975]";}
        elseif Material == "Mystic Droplet" then
            MonMaterial = {"Water Fighter [Lv. 1450]";"Sea Soldier [Lv. 1425]";}
        elseif Material == "Ectoplasm" then
            MonMaterial = {"Ship Deckhand [Lv. 1250]";"Ship Engineer [Lv. 1275]";"Ship Steward [Lv. 1300]";"Ship Officer [Lv. 1325]"}
        end
    elseif ThirdSea then
        if Material == "Scrap Metal" then
            MonMaterial = {"Jungle Pirate [Lv. 1900]";}
        elseif Material == "Conjured Cocoa" then
            MonMaterial = {"Cocoa Warrior [Lv. 2300]";"Chocolate Bar Battler [Lv. 2325]";"Sweet Thief [Lv. 2350]";"Candy Rebel [Lv. 2375]";}
        elseif Material == "Fish Tail" then
            MonMaterial = {"Fishman Raider [Lv. 1775]";"Fishman Captain [Lv. 1800]";}
        elseif Material == "Mini Tusk" then
            MonMaterial = {"Mythological Pirate [Lv. 1850]";}
        elseif Material == "Dragon Scale" then
            MonMaterial = {"Dragon Crew Archer [Lv. 1600]";"Dragon Crew Warrior [Lv. 1575]";}
        elseif Material == "Demonic Wisp" then
            MonMaterial = {"Demonic Soul [Lv. 2025]";}
        elseif Material == "Bones" then
            MonMaterial = {"Posessed Mummy [Lv. 2050]";"Living Zombie [Lv. 2000]";"Reborn Skeleton [Lv. 1975]";"Demonic Soul [Lv. 2025]";}
        elseif Material == "Gunpowder" then
            MonMaterial = {"Pistol Billionaire [Lv. 1525]";}
        end
    end
end

function Go_to_Part(Part,State_Ment) 
    local State_Ment = State_Ment or function() return true end
    local f,e = pcall(function()
        if dist(Part.Position) > 10 and not State_Ment() then
            Need_Noclip = true
            repeat task.wait(0.02) TP(Part.Position) until dist(Part.Position) < 10 or State_Ment()
            Need_Noclip = false
        end
        Need_Noclip = false
    end)
    if not f then warn("GTP :",e) end
end

local network = loadstring(game:HttpGet('https://raw.githubusercontent.com/hajibeza/File/main/Network.lua'))()

function Check_Near_Mon(Monster)
    local Table_Monster = Monster
    if type(Monster) == "string" then Table_Monster = {Monster} end
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if table.find(Table_Monster,v.Name) then
            return v,"workspace"
        end
    end
    for i,v in pairs(game.ReplicatedStorage:GetChildren()) do
        if table.find(Table_Monster,v.Name) then    
            return v,"ReplicatedStorage"
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
    local Client = Local_Player
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        local Distance = math.clamp(Client.SimulationRadius,0,1250)
        local MyDist = Client:DistanceFromCharacter(part.Position)
        if MyDist < Distance then
            for i,v in pairs(game.Players:GetPlayers()) do
                if v:DistanceFromCharacter(part.Position) < MyDist and v ~= Client then
                    return false
                end
            end
            return true
        end
    end
end

BringMob = function(Mon) 
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if not v:FindFirstChild("HumanoidRootPart") then continue end
        if v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 and dist(v.HumanoidRootPart.Position) <= 5000 then
            local IsVaidMob = not Mon or (v ~= Mon and v.Name == Mon.Name)
            if IsVaidMob then
                local Mon_Pos = Mon.HumanoidRootPart.CFrame
                if dist(v.HumanoidRootPart.Position) <= 50 and Bring_Mob_Mode == "Less Lag" then return end
                if isnetworkowner(v.HumanoidRootPart) or dist(v.HumanoidRootPart.Position) <= 200 then                                   
                    v.Humanoid.JumpPower = 0
                    v.Humanoid.WalkSpeed = 0
                    v.Humanoid.Sit = true	
                    v.Humanoid.PlatformStand = true			
                    v.HumanoidRootPart.CanCollide = false
                    v.HumanoidRootPart.CFrame = Mon_Pos
                    if v.Humanoid:FindFirstChild("Animator") then
                        v.Humanoid.Animator:Destroy()
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

function Check_Mastery_Melee(Melee_Name,Mastery_Value)
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

function Start_Attack(Entity,Expression)
    local Expression = Expression or function() return true end
    local Success,Error = pcall(function()
        local Method_Value = 1
        local CSStart = tick()
        local Current_Mothod_Farm
        Human = Entity.Humanoid
        repeat task.wait(0.02)
            Need_Noclip = true
            NeedAttacking = true
            if tick() - CSStart > 0.2 then
                CSStart = tick()
                Method_Value = Method_Value + 1
                if Method_Value > #All_Random_Position then
                    Method_Value = 1
                end
            end
            if Random_Position then
                Current_Mothod_Farm = All_Random_Position[Method_Value]
            else
                Current_Mothod_Farm = CFrame.new(0,60,0)
            end
            if isnetworkowner(Human.RootPart) then
                Human.RootPart.CFrame = Human.RootPart.CFrame
            end
            Equip_Tool(Current_Weapon)
            BringMob(Entity)
            TP(Entity.HumanoidRootPart.CFrame * Current_Mothod_Farm)
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

function Check_Any_Remote(Name)
    local Remote_Inventory = Use_Remote("getInventory")
    for i,v in pairs(Remote_Inventory) do
        if v.Name == Name then
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

function Buy_Combat(Name_Combat,Num)
    local success,data
    if Name_Combat == "DragonClaw" then
        success,data = pcall(Use_Remote,"BlackbeardReward","DragonClaw","2")
    else
        success,data = pcall(Use_Remote,"Buy"..Name_Combat,Num)
    end
    return success and (data == 1 or data == 2)
end

function Remove_Lv(Name_Mon)
    local Table_Lv_Mon = Name_Mon
    if type(Name_Mon) == "string" then
        Table_Lv_Mon = {Name_Mon}
    end

    local cleanedNames = {}  -- Store cleaned names

    for i, v in pairs(Table_Lv_Mon) do
        table.insert(cleanedNames, v:gsub("%[Lv%..-%]", ""):gsub("%s+", " "):match("^%s*(.-)%s*$"))
    end

    return cleanedNames
end

function Use_Skill_Fruit()
    if Local_Player.Character:FindFirstChild(Local_Player.Data.DevilFruit.Value) then
        MasteryDevilFruit = require(Local_Player.Character[Local_Player.Data.DevilFruit.Value].Data)
        DevilFruitMastery = Local_Player.Character[Local_Player.Data.DevilFruit.Value].Level.Value
    elseif Local_Player.Backpack:FindFirstChild(Local_Player.Data.DevilFruit.Value) then
        MasteryDevilFruit = require(Local_Player.Backpack[Local_Player.Data.DevilFruit.Value].Data)
        DevilFruitMastery = Local_Player.Backpack[Local_Player.Data.DevilFruit.Value].Level.Value
    end
    if Local_Player.Character:FindFirstChild("Dragon-Dragon") then
        if SkillZ and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
            game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
        end
        if SkillX and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
            game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
        end   
    elseif Local_Player.Character:FindFirstChild("Human-Human: Buddha") then
        if SkillZ and Local_Player.Character.HumanoidRootPart.Size == Vector3.new(7.6, 7.676, 3.686) and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
        else
            game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
        end
        if SkillX and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
            game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
        end
        if SkillC and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
            game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
        end  
    elseif Local_Player.Character:FindFirstChild("Venom-Venom") then
        if SkillZ and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
            game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
            wait(4)
            game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
        end
        if SkillX and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
            game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
        end
        if SkillC and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
            game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
        end
    elseif Local_Player.Character:FindFirstChild(Local_Player.Data.DevilFruit.Value) then
        -- Local_Player.Character:FindFirstChild(Local_Player.Data.DevilFruit.Value).MousePos.Value = v.HumanoidRootPart.Position
        if SkillZ and DevilFruitMastery >= MasteryDevilFruit.Lvl.Z then
            game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
        end
        if SkillX and DevilFruitMastery >= MasteryDevilFruit.Lvl.X then
            game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
        end
        if SkillC and DevilFruitMastery >= MasteryDevilFruit.Lvl.C then
            game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
        end
        if SkillV and DevilFruitMastery >= MasteryDevilFruit.Lvl.V then
            game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
            wait(.1)
            game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
        end
    end
end

function Click()
	game:GetService("VirtualUser"):CaptureController()
	game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
end

function Check_Available_Boat()
    for i,v in pairs(workspace.Boats:GetChildren()) do
        if tostring(v.Owner.Value) == Local_Player.Name then
            return v.VehicleSeat
        end
    end
    return nil
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
    local Work,Result = pcall(function()
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
    end)
    if not Work then print("[ERROR]", Result) end
end

Name_Function = {}

funcName = {}

All_Function = setmetatable({},{
    __index = function(self,k)
        return rawget(Name_Function,k)
    end,
    __newindex = function(self,k,v)
        funcName[v] = k
        return rawset(Name_Function,k,v)
    end,
})

All_Function.Auto_Farm_Level = function()
    task.spawn(function() 
        while Auto_Farm_Level and wait(.5) do
            if Auto_Farm_Level then
                -- local e,a = pcall(function()
                    local MyLevel = Local_Player.Data.Level.Value

                    if MyLevel >= 20 and MyLevel <= 120 then 
                        Mon = "Shanda"
                        
                        if not Check_Near_Mon(Mon) then
                            Go_To_Mon_Spawn(Mon,function()
                                return not Auto_Farm_Level 
                            end)
                        end

                        if Check_Near_Mon(Mon) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Mon or v.Name:match(Mon) and Check_Available_Mon(v) then 
                                    Start_Attack(v,function()
                                        return not Auto_Farm_Level or not Check_Near_Mon(Mon) or not Check_Available_Mon(v) or MyLevel > 120
                                    end)
                                end
                            end
                        end
                    end

                    if MyLevel < 20 or MyLevel > 120 then
                        if not Local_Player.PlayerGui.Main.Quest.Visible then 
                            if Double_Quest then 
                                Level , Data = QuestManager:GetQuest()  
                                if not QuestManager.DataData[Level].Used then 
                                    QuestManager.DataData[Level].Used = true 
                                end
                                if MyLevel > 10 then Go_to_Part(Data[Level].CFrameQuest,function() return not Auto_Farm_Level or dist(Data[Level].CFrameQuest.Position) <= 3 end) end
                                wait(.5)
                                if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                                wait(.5)
                            else
                                Level , Data = QuestManager:GetQuest()  
                                if MyLevel > 10 then Go_to_Part(Data[Level].CFrameQuest,function() return not Auto_Farm_Level or dist(Data[Level].CFrameQuest.Position) end) end
                                wait(.5)
                                if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                                wait(.5)
                            end
                        end
                        
                        if not Check_Near_Mon(Data[Level].Mon) then
                            Go_To_Mon_Spawn(Data[Level].Mon,function()
                                return not Auto_Farm_Level
                            end)
                        end

                        if Check_Near_Mon(Data[Level].Mon) and not workspace.Enemies:FindFirstChild(Data[Level].Mon) then
                            Go_to_Part(Check_Near_Mon(Data[Level].Mon).HumanoidRootPart.CFrame,function()
                                return not Auto_Farm_Level or workspace.Enemies:FindFirstChild(Data[Level].Mon)
                            end)
                        end
                    
                        -- if not Data[Level].Mon or (not Data[Level].CFrameMon and not Check_Near_Mon(Data[Level].Mon)) then return end 
                    
                        if Check_Near_Mon(Data[Level].Mon) then 
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Data[Level].Mon and Check_Available_Mon(v) then 
                                    Start_Attack(v,function()
                                        return not Auto_Farm_Level or not Check_Available_Mon(v) or not Local_Player.PlayerGui.Main.Quest.Visible
                                    end)
                                end
                            end
                        end
                    end
                -- end)
                -- if not e then warn("Lv",a) end
            end
        end
    end)
end

All_Function.Auto_Second_Sea = function()
    task.spawn(function()
        while Auto_Second_Sea and wait(.5) do
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
                            Go_to_Part(Check_Near_Mon("Ice Admiral").HumanoidRootPart.CFrame * CFrame.new(0,30,0),function() return workspace.Enemies:FindFirstChild("Ice Admiral") or not Auto_Second_Sea end)
                        end

                        if Check_Near_Mon("Ice Admiral") and workspace.Enemies:FindFirstChild("Ice Admiral") then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == "Ice Admiral" and Check_Available_Mon(v) then
                                    Start_Attack(v,function()
                                        return not Auto_Second_Sea or not Check_Near_Mon("Ice Admiral") or not Check_Available_Mon(v)
                                    end)
                                    Use_Remote("TravelDressrosa")
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end

All_Function.Auto_Third_Sea = function()
    task.spawn(function()
        while Auto_Third_Sea and wait(.5) do
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
                                Go_to_Part(Check_Near_Mon(Don_Swan).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Don_Swan) or not Auto_Third_Sea end)
                            end

                            if Check_Near_Mon(Don_Swan) and workspace.Enemies:FindFirstChild(Don_Swan) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Don_Swan and Check_Available_Mon(v) then
                                        Start_Attack(v,function()
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
                                Go_to_Part(Check_Near_Mon(rip_indra).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(rip_indra) or not Auto_Third_Sea end)
                            end

                            if Check_Near_Mon(rip_indra) and workspace.Enemies:FindFirstChild(rip_indra) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == rip_indra and Check_Available_Mon(v) then
                                        Start_Attack(v,function()
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

All_Function.Auto_Farm_Mastery = function()
    task.spawn(function()
        while Auto_Farm_Mastery and wait(.5) do
            if Auto_Farm_Mastery then
                pcall(function()
                    local MyLevel = Local_Player.Data.Level.Value
                    if not Local_Player.PlayerGui.Main.Quest.Visible then 
                        if Double_Quest then 
                            Level , Data = QuestManager:GetQuest()  
                            if not QuestManager.DataData[Level].Used then 
                                QuestManager.DataData[Level].Used = true 
                            end
                            if MyLevel > 10 then Go_to_Part(Data[Level].CFrameQuest,function() return not Auto_Farm_Mastery or Local_Player.PlayerGui.Main.Quest.Visible or dist(Data[Level].CFrameQuest.Position) <= 3 end) end
                            wait(.5)
                            if Auto_Farm_Mastery then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                            wait(.5)
                        else
                            Level , Data = QuestManager:GetQuest()  
                            if MyLevel > 10 then Go_to_Part(Data[Level].CFrameQuest,function() return not Auto_Farm_Mastery or Local_Player.PlayerGui.Main.Quest.Visible or dist(Data[Level].CFrameQuest.Position) <= 3 end) end
                            wait(.5)
                            if Auto_Farm_Mastery then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
                            wait(.5)
                        end
                    end
                
                    if not Check_Near_Mon(Data[Level].Mon) then
                        Go_To_Mon_Spawn(Data[Level].Mon,function()
                            return not Auto_Farm_Mastery
                        end)
                    end

                    if Check_Near_Mon(Data[Level].Mon) and not workspace.Enemies:FindFirstChild(Data[Level].Mon) then
                        Go_to_Part(Check_Near_Mon(Data[Level].Mon).HumanoidRootPart.CFrame,function()
                            return not Auto_Farm_Mastery or workspace.Enemies:FindFirstChild(Data[Level].Mon)
                        end)
                    end
                
                    if not Data[Level].Mon or (not Data[Level].CFrameMon and not Check_Near_Mon(Data[Level].Mon)) then return end 
                
                    if Check_Near_Mon(Data[Level].Mon) then 
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Data[Level].Mon and Check_Available_Mon(v) then 
                                HealthMin = v.Humanoid.MaxHealth * Percent_Mon_Health/100
                                if v.Humanoid.Health <= HealthMin then
                                    if Mode_Mastery == "Fruit" then
                                        repeat task.wait(0.02)
                                            Need_Noclip = true
                                            Equip_Tool(Local_Player.Data.DevilFruit.Value)
                                            TP(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                            PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
                                            UseSkillMasteryDevilFruit = true
                                            task.spawn(Use_Skill_Fruit)
                                        until not Auto_Farm_Mastery or not Check_Near_Mon(Data[Level].Mon) or not Check_Available_Mon(v) or not Local_Player.PlayerGui.Main.Quest.Visible
                                        Need_Noclip = false
                                    end
                                    if Mode_Mastery == "Gun" then
                                        repeat task.wait(0.02)
                                            Need_Noclip = true
                                            Use_Gun = true
                                            PositionSkillMasteryGun = v.HumanoidRootPart.Position
                                            Equip_Tool(Weapon_Gun)
                                            TP(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                            if Local_Player.Character:FindFirstChild(Weapon_Gun) and Local_Player.Character:FindFirstChild(Weapon_Gun):FindFirstChild("RemoteFunctionShoot") then
                                                -- task.spawn(Click)
                                                -- Local_Player.Character[Weapon_Gun].RemoteFunctionShoot:InvokeServer(v.HumanoidRootPart.Position,v.HumanoidRootPart)
                                            end 
                                        until not Auto_Farm_Mastery or not Check_Near_Mon(Data[Level].Mon) or not Check_Available_Mon(v) or not Local_Player.PlayerGui.Main.Quest.Visible
                                        Need_Noclip = false
                                        Use_Gun = false
                                    end
                                end
                                if v.Humanoid.Health >= HealthMin then
                                    repeat task.wait(0.02)
                                        NormalClick = true
                                        Need_Noclip = true
                                        Equip_Tool(Current_Weapon)
                                        BringMob(v)
                                        TP(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                    until not Auto_Farm_Mastery or v.Humanoid.Health <= HealthMin or not Local_Player.PlayerGui.Main.Quest.Visible
                                    NormalClick = false
                                    Need_Noclip = false
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end

All_Function.Auto_Farm_Material = function()
    task.spawn(function()
        while Auto_Farm_Material and wait(.5) do
            if Auto_Farm_Material then
                -- pcall(function()
                    Material_Mon()
                    
                    if Material == nil then return end
        
                    local Get_Real_Name = Remove_Lv(MonMaterial)
        
                    local Real_Name_Mon = {}
                    
                    for i = 1, #Get_Real_Name do
                        table.insert(Real_Name_Mon, Get_Real_Name[i])
                    end
                    
                    if not Check_Near_Mon(Real_Name_Mon) then
                        Go_To_Mon_Spawn(Real_Name_Mon,function()
                            return not Auto_Farm_Material
                        end)
                    end

                    if Check_Near_Mon(Real_Name_Mon) and not workspace.Enemies:FindFirstChild(Check_Near_Mon(Real_Name_Mon).Name) then
                        Go_to_Part(Check_Near_Mon(Real_Name_Mon).HumanoidRootPart,function()
                            return not Auto_Farm_Material or workspace.Enemies:FindFirstChild(Check_Near_Mon(Real_Name_Mon).Name)
                        end)
                    end

                    if Check_Near_Mon(Real_Name_Mon) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if table.find(Real_Name_Mon,v.Name) and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Farm_Material or not Check_Near_Mon(Real_Name_Mon) or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                -- end)
            end
        end
    end)
end

local MasElectricClaw 
local MasDragonTalon
local MasSharkmanKarate 
local MasDeathStep

All_Function.Auto_God_Human = function()
    function Check_Available_To_Do_Got_Human()

        if not MasElectricClaw then
            if Check_Mastery_Melee("Electric Claw",400) then
                MasElectricClaw = true
            else
                Use_Remote("BuyElectricClaw")
            end
        end

        if MasElectricClaw and not MasDragonTalon then
            if Check_Mastery_Melee("Dragon Talon",400) then
                MasDragonTalon = true
            else
                Use_Remote("BuyDragonTalon")
            end
        end

        if MasElectricClaw and MasDragonTalon and not MasSharkmanKarate then
            if Check_Mastery_Melee("Sharkman Karate",400) then
                MasSharkmanKarate = true
            else
                Use_Remote("BuySharkmanKarate")
            end
        end

        if MasElectricClaw and MasDragonTalon and MasSharkmanKarate and not MasDeathStep then
            if Check_Mastery_Melee("Death Step",400) then
                MasDeathStep = true
            else    
                Use_Remote("BuyDeathStep")
            end
        end

        if MasElectricClaw and MasDragonTalon and MasSharkmanKarate and MasDeathStep then
            return true
        end
        return false
    end
    
    function Check_To_Farm_Mon()
        if Check_Total_Material("Fish Tail") >= 20 then
            GetFishTail = true
        end
        if Check_Total_Material("Magma Ore") >= 20 then
            GetMagmaOre = true
        end
        if Check_Total_Material("Mystic Droplet") >= 10 then
            GetMysticDroplet = true
        end
        if Check_Total_Material("Dragon Scale") >= 10 then
            GetDragonScale = true
        end
    
        if not GetFishTail and not GetMagmaOre then
            if not FirstSea or not ThirdSea then Use_Remote("TravelMain") end
        
            if FirstSea then
                Mon_God_Human = {"Fishman Warrior [Lv. 375]","Fishman Commando [Lv. 400]"}
            elseif ThirdSea then
                Mon_God_Human = {"Fishman Raider [Lv. 1775]","Fishman Captain [Lv. 1800]"}
            end
        end
        if GetFishTail and not GetMagmaOre then
            if not FirstSea or not SecondSea then Use_Remote("TravelMain") end
        
            if FireSea then
                Mon_God_Human = {"Military Soldier [Lv. 300]","Military Spy [Lv. 325]"}
            elseif SecondSea then
                Mon_God_Human = {"Magma Ninja [Lv. 1175]","Lava Pirate [Lv. 1200]"}
            end
        end
        if GetFishTail and GetMagmaOre and not GetMysticDroplet then
            if not SecondSea then Use_Remote("TravelDressrosa") end
            Mon_God_Human = {"Water Fighter [Lv. 1450]","Sea Soldier [Lv. 1425]"}
        end
        if GetFishTail and GetMagmaOre and GetMysticDroplet and not GetDragonScale then
            if not ThirdSea then Use_Remote("TravelZou") end
            Mon_God_Human = {"Dragon Crew Archer [Lv. 1600]","Dragon Crew Warrior [Lv. 1575]"}
        end
    end

    task.spawn(function()
        while Auto_God_Human and wait(.5) do
            if Auto_God_Human then
                if HasGodhuman then return end
                local Old_Value = Auto_Farm_Level
                if Check_Available_To_Do_Got_Human() then
                    if Local_Player.Data.Fragments.Value >= 5000 and not Raiding() then
                        if Old_Value then Auto_Farm_Level = true end
                        DoRaid = false
                        if Local_Player.Data.Beli.Value >= 5e+6 then
                            if Use_Remote("BuyGodhuman",true) ~= 0 then
                                Use_Remote("BuyGodhuman")
                                return
                            end
        
                            if string.find(Use_Remote("BuyGodhuman",true),"Bring me") then
                                -- if Buy_Combat("Godhuman") then
                                --     Auto_Start_Raid = false
                                --     Auto_Finish_Raid = false
                                --     Check_Buy_Melee.Godhuman = true
                                --     return
                                -- end
                                Check_To_Farm_Mon()
        
                                print(Mon_God_Human)
        
                                local Get_Real_Name = Remove_Lv(Mon_God_Human)
        
                                local Real_Name_Mon = {}
                                
                                for i = 1, #Get_Real_Name do
                                    table.insert(Real_Name_Mon, Get_Real_Name[i])
                                end
                                
                                if not Check_Near_Mon(Real_Name_Mon) then
                                    Go_To_Mon_Spawn(Real_Name_Mon,function()
                                        return not Auto_God_Human
                                    end)
                                end

                                if Check_Near_Mon(Real_Name_Mon) and not workspace.Enemies:FindFirstChild(Check_Near_Mon(Real_Name_Mon).Name) then
                                    Go_to_Part(Check_Near_Mon(Real_Name_Mon).HumanoidRootPart,function()
                                        return not Auto_God_Human or workspace.Enemies:FindFirstChild(Check_Near_Mon(Real_Name_Mon).Name)
                                    end)
                                end
        
                                if Check_Near_Mon(Real_Name_Mon) then
                                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                                        if table.find(Real_Name_Mon,v.Name) and Check_Available_Mon(v) then
                                            Start_Attack(v,function()
                                                return not Auto_God_Human or not Check_Near_Mon(Real_Name_Mon) or not Check_Available_Mon(v)
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if Auto_Farm_Level then Auto_Farm_Level = false end
                        DoRaid = true
                    end 
                end
            end
        end
    end)
end

All_Function.Auto_Electric_Claw = function()
    task.spawn(function()
        while Auto_Electric_Claw and wait(.5) do
            if Auto_Electric_Claw then

                local Old_Value = Auto_Farm_Level
                if HasElectricClaw then return end

                if Use_Remote("BuyElectricClaw",true) ~= 4 then
                    if Local_Player.Data.Fragments.Value >= 5000 and not Raiding() then
                        if Old_Value then Auto_Farm_Level = true end
                        DoRaid = false
                        if Local_Player.Data.Beli.Value >= 3e+6 then
                            Use_Remote("BuyElectricClaw")
                            return
                        end
                    else
                        if Auto_Farm_Level then Auto_Farm_Level = false end
                        DoRaid = true
                    end
                else
                    Use_Remote("BuyElectricClaw","Start")
                    Use_Remote("requestEntrance",Vector3.new(-12462, 375, -7552))
                end
            end
        end
    end)
end

All_Function.Auto_Superhuman = function()
    task.spawn(function()
        while Auto_Superhuman and wait(.5) do
            if Auto_Superhuman then 
    
                if Hassuperhuman then return end
                local Old_Value = Auto_Farm_Level
                if Old_Value and HasDragonClaw then Auto_Farm_Level = true end

                if not HasBlackleg and Local_Player.Data.Beli.Value >= 150000 then
                    return Use_Remote("BuyBlackLeg")
                end
    
                if Check_Mastery_Melee("Black Leg",300) then
                    Use_Remote("BuyElectro")
                end
    
                if Check_Mastery_Melee("Electro",300) then
                    Use_Remote("BuyFishmanKarate")
                end 
    
                if Check_Mastery_Melee("Fishman Karate",300) then
                    if Local_Player.Data.Level.Value > 1100 then
                        if Local_Player.Data.Fragments.Value >= 1500 then
                            DoRaid = false
                            Use_Remote("BlackbeardReward","DragonClaw","1")
                            Use_Remote("BlackbeardReward","DragonClaw","2")
                        else 
                            if Auto_Farm_Level then Auto_Farm_Level = false end
                            DoRaid = true
                        end
                    end
                end
    
                if Check_Mastery_Melee("Dragon Claw",300) then
                    Use_Remote("BuySuperhuman")
                end
            end
        end
    end)    
end

All_Function.Auto_Sea_Event = function()
    
    local function Skill_Weapon()
        local NameWeaponBounty = {}
        for index,value in pairs({"Melee", "Sword","DevilFruit","Gun"}) do 
            if value == "DevilFruit" then value = "Blox Fruit" end
            for i ,v in pairs(Local_Player.Backpack:GetChildren()) do
                if v:IsA("Tool") then
                    if v.ToolTip == value then
                        table.insert(NameWeaponBounty,v.Name)
                    end
                end
            end
            for i ,v in pairs(Local_Player.Character:GetChildren()) do
                if v:IsA("Tool") then
                    if v.ToolTip == value then
                        table.insert(NameWeaponBounty,v.Name)
                    end
                end
            end
        end
        for i,v in pairs(NameWeaponBounty) do 
            if Auto_Sea_Event and #workspace.SeaBeasts:GetChildren() > 0 then
                repeat wait(.5)
                    Equip_Tool(v)
                until Local_Player.Character:FindFirstChild(v) or not Auto_Sea_Event or #workspace.SeaBeasts:GetChildren() <= 0
                wait(.1)
                local Module = require(Local_Player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Data") or Local_Player.Character:FindFirstChildOfClass("Tool"):FindFirstChildOfClass("ModuleScript"))
                for i2,v2 in pairs(Module["Cooldown"]) do 
                    if Module["Lvl"][i2] <= Local_Player.Character:FindFirstChildOfClass("Tool"):WaitForChild("Level").Value then
                        if i2 ~= nil and i2 and #i2 == 1 then
                            game:service('VirtualInputManager'):SendKeyEvent(true, tostring(i2), false, game)
                            wait(.1)
                            game:service('VirtualInputManager'):SendKeyEvent(false, tostring(i2), false, game)

                            wait(.1)
                        end
                    end
                end
            end
            wait(0.1)
        end
    end

    task.spawn(function()
        while Auto_Sea_Event and wait(.1) do
            if Auto_Sea_Event then

                for _, seaIndex in ipairs(sortedSeaIndices) do
                    if Sea_Level == seaIndex then
                        local seaPosition = All_Sea_Level_Position[seaIndex]
                        Sea_Position = seaPosition
                        Current_Sea_Level = _
                        print(_, seaPosition)
                    end
                end

                if SecondSea then
                    Sea_Position = CFrame.new(38.905670166015625, -0.4971587657928467, 5150.13623046875)
                end

                if not Check_Available_Boat() then
                    local Npc_Position = CFrame.new(-6044.32031, 15.1150599, -2038.65674, 0.363744795, -0, -0.931498647, 0, 1, -0, 0.931498647, 0, 0.363744795)
                    if dist(Npc_Position.Position) > 30 then
                        repeat wait(.1)
                            Need_Noclip = true
                            TP(Npc_Position)
                        until not Auto_Sea_Event or dist(Npc_Position.Position) <= 30 or Check_Available_Boat()
                        Use_Remote("BuyBoat","PirateBrigade")
                        Need_Noclip = true
                    end
                end

                if tonumber(Local_Player.PlayerGui.Main.Compass.Frame.DangerLevel.TextLabel.Text) == Current_Sea_Level then
                    if #workspace.Enemies:GetChildren() > 0 then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if not string.find(v.Name,"Pirate") and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Sea_Event or not Check_Available_Mon(v) or #workspace.Enemies:GetChildren() <= 0
                                end)
                            end
                            if v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade" or v.Name == "FishBoat" then
                                game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
                                wait(0.5)
                                game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
                            end
                        end
                    end

                    if #workspace.SeaBeasts:GetChildren() > 0 then
                        for i,v in pairs(workspace.SeaBeasts:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v.Health.Value > 0 then
                                repeat task.wait(0.02)
                                    PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
                                    Need_Noclip = true
                                    task.spawn(Skill_Weapon)
                                    TP(v.HumanoidRootPart.CFrame * CFrame.new(1,500,1))
                                until not Auto_Sea_Event or not v:FindFirstChild("HumanoidRootPart") or v.Health.Value <= 0 or #workspace.SeaBeasts:GetChildren() <= 0
                                Need_Noclip = false
                            end
                        end
                    end
                end

                if Check_Available_Boat() then

                    -- if (#workspace.Enemies:GetChildren() > 0 or #workspace.SeaBeasts:GetChildren() > 0) and Local_Player.Character.Humanoid.Sit then
                    --     repeat wait()
                    --         game:GetService('VirtualInputManager'):SendKeyEvent(true, "Space", false, game)
                    --         wait(.1)
                    --         game:GetService('VirtualInputManager'):SendKeyEvent(false, "Space", false, game)
                    --     until not Auto_Sea_Event or #workspace.Enemies:GetChildren() <= 0 or #workspace.SeaBeasts:GetChildren() <= 0 or not Local_Player.Character.Humanoid.Sit
                    -- end

                    if #workspace.Enemies:GetChildren() <= 0 or #workspace.SeaBeasts:GetChildren() <= 0 then

                        if (dist(Sea_Position.Position) > 100 or tonumber(Local_Player.PlayerGui.Main.Compass.Frame.DangerLevel.TextLabel.Text) ~= Current_Sea_Level) and not Local_Player.Character.Humanoid.Sit then
                            Go_to_Part(Sea_Position,function()
                                return not Auto_Sea_Event or not Check_Available_Boat() or dist(Sea_Position.Position) <= 100 or Local_Player.Character.Humanoid.Sit
                            end)
                        end

                        -- if Local_Player.Character.Humanoid.Sit then
                        --     repeat wait()
                        --         game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
                        --         wait(0.5)
                        --         game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
                        --         wait(1)
                        --         game:service('VirtualInputManager'):SendKeyEvent(true, "S", false, game)
                        --         wait(0.5)
                        --         game:service('VirtualInputManager'):SendKeyEvent(false, "S", false, game)
                        --         wait(1)
                        --     until not Auto_Sea_Event or not Local_Player.Character.Humanoid.Sit or #workspace.Enemies:GetChildren() > 0 or #workspace.SeaBeasts:GetChildren() > 0
                        -- end
    
                        if tonumber(Local_Player.PlayerGui.Main.Compass.Frame.DangerLevel.TextLabel.Text) == Current_Sea_Level and not Local_Player.Character.Humanoid.Sit then
                            repeat wait()
                                game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
                                Local_Player.Character.HumanoidRootPart.CFrame = Check_Available_Boat().CFrame
                                wait()
                                game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
                                -- game:service('VirtualInputManager'):SendKeyEvent(true, "W", false, game)
                                -- Local_Player.Character.HumanoidRootPart.CFrame = Check_Available_Boat().CFrame
                                -- wait()
                                -- game:service('VirtualInputManager'):SendKeyEvent(false, "W", false, game)
                            until not Auto_Sea_Event or not Check_Available_Boat() or Local_Player.Character.Humanoid.Sit or #workspace.Enemies:GetChildren() > 0 or #workspace.SeaBeasts:GetChildren() > 0
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Elite_Hunter = function()
    task.spawn(function()
        while Auto_Elite_Hunter and wait(.5) do
            if Auto_Elite_Hunter then
                local Success,Error = pcall(function()
                    if not ThirdSea then return end

                    if Use_Remote("EliteHunter") == "I don't have anything for you right now. Come back later." and Enable_Server_Hop then
                        return Server_Hop("Finding Elite Hunter")
                    end

                    if not Local_Player.PlayerGui.Main.Quest.Visible then
                        Use_Remote("EliteHunter")
                    end

                    All_Elite_Hunter = {
                        [1] = "Diablo",
                        [2] = "Deandre",
                        [3] = "Urban",
                    }

                    if Local_Player.PlayerGui.Main.Quest.Visible then
                        for i,v in pairs(All_Elite_Hunter) do
                            if string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,v) then
                                Elite_Hunter_Name = v
                            end
                        end 
                    end

                    if Local_Player.PlayerGui.Main.Quest.Visible then

                        if Check_Near_Mon(Elite_Hunter_Name) and not workspace.Enemies:FindFirstChild(Elite_Hunter_Name) then
                            Go_to_Part(Check_Near_Mon(Elite_Hunter_Name).HumanoidRootPart.CFrame,function()
                                return not Auto_Elite_Hunter or not Check_Near_Mon(Elite_Hunter_Name) or workspace.Enemies:FindFirstChild(Elite_Hunter_Name)
                            end)
                        end

                        if Check_Near_Mon(Elite_Hunter_Name) and workspace.Enemies:FindFirstChild(Elite_Hunter_Name) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Elite_Hunter_Name and Check_Available_Mon(v) then
                                    Start_Attack(v,function()
                                        return not Auto_Elite_Hunter or not Check_Available_Mon(v) or not Check_Near_Mon(Elite_Hunter_Name)
                                    end)
                                end
                            end
                        end
                    end
                end)
                if not Success then warn(Error) end
            end
        end
    end)
end

All_Function.Auto_Saber = function()
    task.spawn(function()
        while Auto_Saber and  wait(.5) do
            if Auto_Saber then
                pcall(function()
                    if not FirstSea then return end

                    local Remote_Check_Saber = Use_Remote("ProQuestProgress")
                    local QuestPlates_Folder = workspace.Map.Jungle.QuestPlates
                    local Old_Value = Auto_Farm_Level

                    if not FirstSea then return end
                    if Remote_Check_Saber.KilledShanks and not Old_Value then return end
                    if Remote_Check_Saber.KilledShanks and Old_Value then Auto_Farm_Level = true end
                    if Auto_Farm_Level and Local_Player.Data.Level.Value >= 200 then Auto_Farm_Level = false end
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
                                Go_to_Part(Check_Near_Mon(Mon_Leader).HumanoidRootPart.CFrame,function() return  workspace.Enemies:FindFirstChild(Mon_Leader) or not Auto_Saber end)
                            end

                            if Check_Near_Mon(Mon_Leader) and workspace.Enemies:FindFirstChild(Mon_Leader) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Mon_Leader and Check_Available_Mon(v) then
                                        Start_Attack(v,function()
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
                                Go_to_Part(Check_Near_Mon(Saber_Expert).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Saber_Expert) or not Auto_Saber end)
                            end

                            if Check_Near_Mon(Saber_Expert) and workspace.Enemies:FindFirstChild(Saber_Expert) then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Saber_Expert and Check_Available_Mon(v) then
                                        Start_Attack(v,function()
                                            return not Auto_Saber or not Check_Near_Mon(Saber_Expert) or not Check_Available_Mon(v) or Remote_Check_Saber.KilledShanks
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

All_Function.Auto_Pole = function()
    task.spawn(function()
        while Auto_Pole and wait(.5) do
            if Auto_Pole then
                pcall(function()
                    if Check_Any_Remote("Pole (1st Form)") then return end
                    if not FirstSea then return end

                    local Thunder_God = "Thunder God"
                
                    if not Check_Near_Mon(Thunder_God) and Enable_Server_Hop then
                        Server_Hop("Finding Thunder God")
                    end

                    if Check_Near_Mon(Thunder_God) and not workspace.Enemies:FindFirstChild(Thunder_God) then
                        Go_to_Part(Check_Near_Mon(Thunder_God).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Thunder_God) or not Auto_Pole end)
                    end

                    if Check_Near_Mon(Thunder_God) and workspace.Enemies:FindFirstChild(Thunder_God) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Thunder_God and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Pole or not Check_Near_Mon(Thunder_God) or Check_Any_Remote("Pole (1st Form)") or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end

All_Function.Auto_Factory = function()
    task.spawn(function()
        while Auto_Factory and wait(.5) do
            if Auto_Factory then
                pcall(function()
                    if not SecondSea then return end
                    local Factory = "Core"

                    if not Check_Near_Mon(Factory) and Enable_Server_Hop then    
                        Server_Hop("Finding Factory")
                    end

                    if Check_Near_Mon(Factory) and not workspace.Enemies:FindFirstChild(Factory) then
                        Go_to_Part(Check_Near_Mon(Factory).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Factory) or not Auto_Factory end)
                    end

                    if Check_Near_Mon(Factory) and workspace.Enemies:FindFirstChild(Factory) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Factory and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Factory or not Check_Near_Mon(Factory) or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end

All_Function.Auto_Rengoku = function()
    task.spawn(function()
        while Auto_Rengoku and wait(.5) do
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
                            Go_to_Part(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188),function() return workspace.Enemies:FindFirstChild(Rengoku_Mon) or not Auto_Rengoku end)
                        end

                        if Check_Near_Mon(Rengoku_Mon) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if table.find(Rengoku_Mon,v.Name) and Check_Available_Mon(v) then 
                                    Start_Attack(v,function()
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
end

All_Function.Auto_Bartilo_Quest = function()
    task.spawn(function()
        while Auto_Bartilo_Quest and wait(.5) do
            if Auto_Bartilo_Quest then
                local Remote_Check_Bartilo = Use_Remote("BartiloQuestProgress")
                local MyLevel = Local_Player.Data.Level.Value

                if not SecondSea then return end
                if MyLevel < 850 then return end
                if Remote_Check_Bartilo.DidPlates then return end

                if not Remote_Check_Bartilo.KilledBandits then

                    if not Local_Player.PlayerGui.Main.Quest.Visible then 
                        Use_Remote("StartQuest","BartiloQuest",1)
                    end

                    if Local_Player.PlayerGui.Main.Quest.Visible then 

                        local Mon = "Swan Pirate"
                        
                        if not Check_Near_Mon(Mon) then
                            Go_To_Mon_Spawn(Mon,function()
                                return not Auto_Bartilo_Quest
                            end)
                        end

                        if Check_Near_Mon(Mon) and not workspace.Enemies:FindFirstChild(Mon) then
                            Go_to_Part(Check_Near_Mon(Mon).HumanoidRootPart.CFrame,function()
                                return not Auto_Bartilo_Quest or workspace.Enemies:FindFirstChild(Mon)
                            end)
                        end

                        if Check_Near_Mon(Mon) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Mon and Check_Available_Mon(v) then
                                    Start_Attack(v,function()
                                        return not Auto_Bartilo_Quest or Remote_Check_Bartilo.KilledBandits or not Check_Near_Mon(Mon) or not Check_Available_Mon(v)
                                    end)
                                end
                            end
                        end
                    end
                end

                if not Remote_Check_Bartilo.KilledSpring and Remote_Check_Bartilo.KilledBandits then

                    Boss = "Jeremy"

                    if not Check_Near_Mon(Boss) and Enable_Server_Hop then
                        Server_Hop("Finding Jeremy")
                    end

                    if Check_Near_Mon(Boss) and not workspace.Enemies:FindFirstChild(Boss) then
                        Go_to_Part(Check_Near_Mon(Boss).HumanoidRootPart.CFrame,function() 
                            return not Auto_Bartilo_Quest or Remote_Check_Bartilo.KilledSpring or workspace.Enemies:FindFirstChild(Boss) or not Check_Near_Mon(Boss)
                        end)
                    end

                    if Check_Near_Mon(Boss) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Boss and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Bartilo_Quest or Remote_Check_Bartilo.KilledSpring or not Check_Near_Mon(Boss) or not Check_Available_Mon(v)
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
    end)
end

All_Function.Auto_Evo_Race_V2 = function()
    task.spawn(function()
        while Auto_Evo_Race_V2 and wait(.5) do
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
                        Go_to_Part(Path_Flower[1].CFrame,function() return not Auto_Evo_Race_V2 or Check_Tool_Inventory("Flower 1") end)
                    end

                    if not Check_Tool_Inventory("Flower 2") then
                        Go_to_Part(Path_Flower[2].CFrame,function() return not Auto_Evo_Race_V2 or Check_Tool_Inventory("Flower 2") end)
                    end

                    if not Check_Tool_Inventory("Flower 3") then
                        Mon_Flower = "Swan Pirate"
                        if not Check_Near_Mon(Mon_Flower) then
                            Go_to_Part(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375),function() return workspace.Enemies:FindFirstChild(Mon_Flower) or not Auto_Evo_Race_V2 end)
                        end

                        if Check_Near_Mon(Mon_Flower) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == Mon_Flower and Check_Available_Mon(v) then
                                    Start_Attack(v,function()
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
end

All_Function.Auto_Swan_Glasses = function()
    task.spawn(function()
        while Auto_Swan_Glasses and wait(.5) do
            if Auto_Swan_Glasses then
                if not SecondSea then return end
                if Check_Any_Remote("Swan Glasses") then return end

                Don_Swan = "Don Swan"

                if not Check_Near_Mon(Don_Swan) and Enable_Server_Hop then
                    Server_Hop("Find Don Swan")
                end

                if Check_Near_Mon(Don_Swan) and not workspace.Enemies:FindFirstChild(Don_Swan) then
                    Go_to_Part(Check_Near_Mon(Don_Swan).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Don_Swan) or not Auto_Swan_Glasses end)
                end

                if Check_Near_Mon(Don_Swan) and workspace.Enemies:FindFirstChild(Don_Swan) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Don_Swan and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Swan_Glasses or not Check_Near_Mon(Don_Swan) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end

            end
        end
    end)
end

All_Function.Auto_Dragon_Trident = function()
    task.spawn(function()
        while Auto_Dragon_Trident and wait(.5) do
            if Auto_Dragon_Trident then
                if not SecondSea then return end
                if Check_Any_Remote("Dragon Trident") then return end

                Tide_Keeper = "Tide Keeper"

                if not Check_Near_Mon(Tide_Keeper) and Enable_Server_Hop then
                    Server_Hop("Find Tide Keeper")
                end

                if Check_Near_Mon(Tide_Keeper) and not workspace.Enemies:FindFirstChild(Tide_Keeper) then
                    Go_to_Part(Check_Near_Mon(Tide_Keeper).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Tide_Keeper) or not Auto_Dragon_Trident end)
                end

                if Check_Near_Mon(Tide_Keeper) and workspace.Enemies:FindFirstChild(Tide_Keeper) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Tide_Keeper and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Dragon_Trident or not Check_Near_Mon(Tide_Keeper) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end

            end
        end
    end)
end

All_Function.Auto_Soul_Reaper = function()
    task.spawn(function()
        while Auto_Soul_Reaper and wait(.5) do
            if Auto_Soul_Reaper then
                if not ThirdSea then return end
                Soul_Reaper = "Soul Reaper"

                local Remote_Random_Bone = Use_Remote("Bones","Buy",1,1)

                if not Check_Tool_Inventory("Hallow Essence") then
                    if not Remote_Random_Bone > 0 then
                        Use_Remote("Bones","Buy",1,1)
                    end
                end

                if Check_Tool_Inventory("Hallow Essence") then
                    Go_to_Part(CFrame.new(-8932.83789, 144.098709, 6059.34229, -0.999290943, 7.95623478e-09, -0.0376505218, 4.4684243e-09, 1, 9.27205832e-08, 0.0376505218, 9.24866086e-08, -0.999290943),function() return not Auto_Soul_Reaper or Check_Near_Mon(Soul_Reaper) or not Check_Tool_Inventory("Hallow Essence") end)
                end

                if not Check_Near_Mon(Soul_Reaper) and Enable_Server_Hop and not Check_Tool_Inventory("Hallow Essence") then
                    Server_Hop("Find Soul Reaper")
                end

                if Check_Near_Mon(Soul_Reaper) and not workspace.Enemies:FindFirstChild(Soul_Reaper) then
                    Go_to_Part(Check_Near_Mon(Soul_Reaper).HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild(Soul_Reaper) or not Auto_Soul_Reaper end)
                end

                if Check_Near_Mon(Soul_Reaper) and workspace.Enemies:FindFirstChild(Soul_Reaper) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Soul_Reaper and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Soul_Reaper or not Check_Near_Mon(Soul_Reaper) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Cake_Prince = function() 
    task.spawn(function()
        while Auto_Cake_Prince and wait(.5) do
            if Auto_Cake_Prince then
                -- local r,e = pcall(function()
                    if not ThirdSea then return end

                    local Remote_Cake_Prince = Use_Remote("CakePrinceSpawner")

                    if string.find(Remote_Cake_Prince,"Do you want to open") then Use_Remote("CakePrinceSpawner") end

                    if not Check_Near_Mon("Cake Prince") then
                        Mon_Cake = {"Baking Staff","Head Baker","Cake Guard","Cookie Crafter"}

                        if not Check_Near_Mon(Mon_Cake) then
                            Go_To_Mon_Spawn(Mon_Cake,function()
                                return not Auto_Cake_Prince
                            end)
                        end

                        if Check_Near_Mon(Mon_Cake) and not workspace.Enemies:FindFirstChild(Check_Near_Mon(Mon_Cake).Name) then
                            Go_to_Part(Check_Near_Mon(Mon_Cake).HumanoidRootPart.CFrame,function()
                                return not Auto_Cake_Prince or workspace.Enemies:FindFirstChild(Check_Near_Mon(Mon_Cake).Name)
                            end)
                        end

                        if Check_Near_Mon(Mon_Cake) then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if table.find(Mon_Cake,v.Name) and Check_Available_Mon(v) then
                                    Start_Attack(v,function()
                                        return not Auto_Cake_Prince or not Check_Near_Mon(Mon_Cake) or not Check_Available_Mon(v)
                                    end)
                                end
                            end
                        end
                    end

                    if Check_Near_Mon("Cake Prince") and not workspace.Enemies:FindFirstChild("Cake Prince") then
                        Go_to_Part(Check_Near_Mon("Cake Prince").HumanoidRootPart.CFrame,function()
                            return not Auto_Cake_Prince or workspace.Enemies:FindFirstChild("Cake Prince")
                        end)
                    end

                    if Check_Near_Mon("Cake Prince") and workspace.Enemies:FindFirstChild("Cake Prince") then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == "Cake Prince" and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Cake_Prince or not Check_Near_Mon("Cake Prince") or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                -- end)
                -- if not r then warn("Cake",e) end
            end
        end
    end)
end

All_Function.Auto_Rainbow_Haki = function()
    task.spawn(function()
        while Auto_Rainbow_Haki and wait(.5) do
            if Auto_Rainbow_Haki then
                if not ThirdSea then return end

                ListBossRainBow = {
                    [1] = "Stone",
                    [2] = "Island Empress",
                    [3] = "Kilo Admiral",
                    [4] = "Captain Elephant",
                    [5] = "Beautiful Pirate"
                }

                for i,v in pairs(ListBossRainBow) do
                    if string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,v) then
                        Name_Mon = v
                    end
                end

                if not Local_Player.PlayerGui.Main.Quest.Visible then
                    Use_Remote("HornedMan","Bet")
                end

                if Local_Player.PlayerGui.Main.Quest.Visible then
                    if not Check_Near_Mon(Name_Mon) and Enable_Server_Hop then
                        Server_Hop("Finding Rainbow boss")
                    end

                    if Check_Near_Mon(Name_Mon) and not workspace.Enemies:FindFirstChild(Name_Mon) then
                        Go_to_Part(Check_Near_Mon(Name_Mon).HumanoidRootPart.CFrame,function() return not Auto_Rainbow_Haki or workspace.Enemies:FindFirstChild(Name_Mon) end)
                    end

                    if Check_Near_Mon(Name_Mon) and workspace.Enemies:FindFirstChild(Name_Mon) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Name_Mon and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Rainbow_Haki or not Check_Near_Mon(Name_Mon) or not Check_Near_Mon(Name_Mon)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Yama = function()
    task.spawn(function()
        while Auto_Yama and wait(.5) do
            if Auto_Yama then
                if not ThirdSea then return end
                if Use_Remote("EliteHunter","Progress") >= 30 then
                    fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
                end
            end
        end
    end)
end

All_Function.Auto_Canvander = function()
    task.spawn(function()
        while Auto_Canvander and wait(.5) do
            if Auto_Canvander then
                if not ThirdSea then return end
                local Canvander_Boss = "Beautiful Pirate" 

                if not Check_Near_Mon(Canvander_Boss) and Enable_Server_Hop then
                    Server_Hop("Finding Beautiful Pirate")
                end

                if Check_Near_Mon(Canvander_Boss) and not workspace.Enemies:FindFirstChild(Canvander_Boss) then
                    Go_to_Part(Check_Near_Mon(Canvander_Boss).HumanoidRootPart.CFrame,function() return not Auto_Canvander or workspace.Enemies:FindFirstChild(Canvander_Boss) end)
                end

                if Check_Near_Mon(Canvander_Boss) and workspace.Enemies:FindFirstChild(Canvander_Boss) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Canvander_Boss and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Canvander or not Check_Near_Mon(Canvander_Boss) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Twin_Hook = function()
    task.spawn(function()
        while Auto_Twin_Hook and wait(.5) do
            if Auto_Twin_Hook then
                if not ThirdSea then return end

                local Twin_Hook_Boss = "Captain Elephant" 

                if not Check_Near_Mon(Twin_Hook_Boss) and Enable_Server_Hop then
                    Server_Hop("Finding Captain Elephant")
                end

                if Check_Near_Mon(Twin_Hook_Boss) and not workspace.Enemies:FindFirstChild(Twin_Hook_Boss) then
                    Go_to_Part(Check_Near_Mon(Twin_Hook_Boss).HumanoidRootPart.CFrame,function() return not Auto_Twin_Hook or workspace.Enemies:FindFirstChild(Twin_Hook_Boss) end)
                end

                if Check_Near_Mon(Twin_Hook_Boss) and workspace.Enemies:FindFirstChild(Twin_Hook_Boss) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Twin_Hook_Boss and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Twin_Hook or not Check_Near_Mon(Twin_Hook_Boss) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Serpent_Bow = function()
    task.spawn(function()
        while Auto_Serpent_Bow and wait(.5) do
            if Auto_Serpent_Bow then
                if not ThirdSea then return end

                local Serpent_Bow_Boss = "Island Empress" 

                if not Check_Near_Mon(Serpent_Bow_Boss) and Enable_Server_Hop then
                    Server_Hop("Finding Island Empress")
                end

                if Check_Near_Mon(Serpent_Bow_Boss) and not workspace.Enemies:FindFirstChild(Serpent_Bow_Boss) then
                    Go_to_Part(Check_Near_Mon(Serpent_Bow_Boss).HumanoidRootPart.CFrame,function() return not Auto_Serpent_Bow or workspace.Enemies:FindFirstChild(Serpent_Bow_Boss) end)
                end

                if Check_Near_Mon(Serpent_Bow_Boss) and workspace.Enemies:FindFirstChild(Serpent_Bow_Boss) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Serpent_Bow_Boss and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Serpent_Bow or not Check_Near_Mon(Serpent_Bow_Boss) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Dark_Dagger = function()
    task.spawn(function()
        while Auto_Dark_Dagger and wait(.5) do
            if Auto_Dark_Dagger then
                if not ThirdSea then return end

                local Dark_Dagger_Boss = "rip_indra True Form" 

                if not Check_Near_Mon(Dark_Dagger_Boss) and Enable_Server_Hop then
                    Server_Hop("Finding rip_indra True Form")
                end

                if Check_Near_Mon(Dark_Dagger_Boss) and not workspace.Enemies:FindFirstChild(Dark_Dagger_Boss) then
                    Go_to_Part(Check_Near_Mon(Dark_Dagger_Boss).HumanoidRootPart.CFrame,function() return not Auto_Dark_Dagger or workspace.Enemies:FindFirstChild(Dark_Dagger_Boss) end)
                end

                if Check_Near_Mon(Dark_Dagger_Boss) and workspace.Enemies:FindFirstChild(Dark_Dagger_Boss) then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == Dark_Dagger_Boss and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Dark_Dagger or not Check_Near_Mon(Dark_Dagger_Boss) or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Buso = function()
    task.spawn(function()
        while Auto_Buso and wait(.5) do
            if Auto_Buso then
                if not Local_Player.Character:FindFirstChild("HasBuso") then
                    Use_Remote("Buso")
                end 
            end
        end
    end)
end

All_Function.Disable_Damage_Effect = function()
    task.spawn(function()
        while Disable_Damage_Effect and wait(.5) do
            if Disable_Damage_Effect then
                for i, v in pairs(game.Workspace["_WorldOrigin"]:GetChildren()) do
                    if v.Name == "DamageCounter" then
                        repeat task.wait(0.02)
                            v:Destroy()
                        until not Disable_Damage_Effect or not v.Parent
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Redeem_Code = function()
    task.spawn(function()
        while Auto_Redeem_Code and wait(1) do
            if Auto_Redeem_Code then 
                for i,v in pairs(Code) do
                    game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v)
                end
            end
        end
    end)    
end

All_Function.Auto_Start_Raid = function()
    task.spawn(function()
        while Auto_Start_Raid and wait(.5) do
            if Auto_Start_Raid then
                if FirstSea then return end
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
end

All_Function.Auto_Finish_Raid = function()
    if FirstSea then return end
    function Kill_Aura()
        for i,v in pairs(workspace.Enemies:GetChildren()) do
            if Check_Available_Mon(v) then
                v.Humanoid.Health = 0
                v.HumanoidRootPart.CanCollide = false
            end
        end
    end

    task.spawn(function()
        while Auto_Finish_Raid and wait(.5) do
            if Auto_Finish_Raid and Raiding() then
                if FirstSea then return end
                repeat task.wait(0.02)
                    Need_Noclip = true
                    Kill_Aura()
                    if workspace["_WorldOrigin"].Locations:FindFirstChild("Island 5") and dist(workspace["_WorldOrigin"].Locations["Island 5"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 4") and dist(workspace["_WorldOrigin"].Locations["Island 4"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 3") and dist(workspace["_WorldOrigin"].Locations["Island 3"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 2") and dist(workspace["_WorldOrigin"].Locations["Island 2"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1") and dist(workspace["_WorldOrigin"].Locations["Island 1"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame * CFrame.new(0,70,100))
                    end
                until not Auto_Finish_Raid or not Raiding()
                Need_Noclip = false
            end
        end
    end)
end

All_Function.Use_Fruit_Inventory = function()
    task.spawn(function()
        while Use_Fruit_Inventory and wait(.5) do
            if Use_Fruit_Inventory then
                if FirstSea then return end
                if not Raiding() then 
                    wait(1)
                    local Remote_Inventory_Fruit = Use_Remote("getInventoryFruits")
                    for i,v in pairs(Remote_Inventory_Fruit) do
                        if v.Price <= Fruit_Value then
                            Can_Use_Fruit = v
                        end
                        if Can_Use_Fruit.Name then
                            Use_Remote("LoadFruit",Can_Use_Fruit.Name)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Start_Law_Raid = function()
    task.spawn(function()
        while Auto_Start_Law_Raid and wait(3) do
            if Auto_Start_Law_Raid then
                if not SecondSea then return end
                if not Check_Raid_Chip() then
                    Use_Remote("BlackbeardReward","Microchip","2")
                end
    
                if Check_Raid_Chip() and not Check_Near_Mon("Order") then
                    fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
                end
            end
        end
    end)
end

All_Function.Auto_Law_Raid = function()
    task.spawn(function()
        while Auto_Law_Raid and wait(.5) do
            if Auto_Law_Raid then
                if not SecondSea then return end
                if Check_Near_Mon("Order") and not workspace.Enemies:FindFirstChild("Order") then
                    Go_to_Part(Check_Near_Mon("Order").HumanoidRootPart.CFrame,function() return workspace.Enemies:FindFirstChild("Order") or not Auto_Law_Raid end)
                end
    
                if Check_Near_Mon("Order") and workspace.Enemies:FindFirstChild("Order") then
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        if v.Name == "Order" and Check_Available_Mon(v) then
                            Start_Attack(v,function()
                                return not Auto_Law_Raid or not Check_Near_Mon("Order") or not Check_Available_Mon(v)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Teleport_To_Gear = function()
    local function Check_Gear_From()
        for _, v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
            if v.Name == 'Part' and v:IsA('MeshPart') then
                return v
            end
        end
        return nil
    end
    task.spawn(function()
        while Teleport_To_Gear and wait(.5) do
            if Teleport_To_Gear then
                if Check_Gear_From() then 
                    Go_to_Part(Check_Gear_From().CFrame,function()
                        return not Teleport_To_Gear or not Check_Gear_From()
                    end)
                end
            end
        end
    end)
end

All_Function.Teleport_To_Trail_Door = function()
    task.spawn(function()
        while Teleport_To_Trail_Door and wait(.5) do
            if Teleport_To_Trail_Door then
                if Local_Player.Data.Race.Value == "Mink" then
                    Go_to_Part(workspace.Map["Temple of Time"].MinkCorridor.Door.Entrance.CFrame,function()
                        return not Teleport_To_Trail_Door
                    end)
                elseif Local_Player.Data.Race.Value == "Fishman" then
                    Go_to_Part(workspace.Map["Temple of Time"].FishmanCorridor.Door.Entrance.CFrame,function()
                        return not Teleport_To_Trail_Door
                    end)
                elseif Local_Player.Data.Race.Value == "Skypiea" then
                    Go_to_Part(workspace.Map["Temple of Time"].SkyCorridor.Door.Entrance.CFrame,function()
                        return not Teleport_To_Trail_Door
                    end)
                elseif Local_Player.Data.Race.Value == "Human" then
                    Go_to_Part(workspace.Map["Temple of Time"].HumanCorridor.Door.Entrance.CFrame,function()
                        return not Teleport_To_Trail_Door
                    end)
                elseif Local_Player.Data.Race.Value == "Ghoul" then
                    Go_to_Part(workspace.Map["Temple of Time"].GhoulCorridor.Door.Entrance.CFrame,function()
                        return not Teleport_To_Trail_Door
                    end)
                elseif Local_Player.Data.Race.Value == "Cybrog" then
                    Go_to_Part(workspace.Map["Temple of Time"].CybrogCorridor.Door.Entrance.CFrame,function()
                        return not Teleport_To_Trail_Door
                    end)
                end
            end
        end
    end)
end

All_Function.Auto_Farm_Boss = function()
    task.spawn(function()
        while Auto_Farm_Boss and wait(.5) do
            if Auto_Farm_Boss then

                for i,v in pairs(DataQuest) do
                    if v.Mon == BossChosen then
                        Boss_Name = v.Mon
                        Quest_Boss_Name = v.NameQuest
                        Number_Quest_Boss = v.NumberQuest
                        Boss_Quest_CFrame = v.CFrameQuest
                    end
                end

                if not Local_Player.PlayerGui.Main.Quest.Visible then 
                    Go_to_Part(Boss_Quest_CFrame,function() return not Auto_Farm_Boss or Local_Player.PlayerGui.Main.Quest.Visible or dist(Boss_Quest_CFrame.Position) end)
                    wait(.5)
                    Use_Remote("StartQuest",Quest_Boss_Name,Number_Quest_Boss)
                end

                if Local_Player.PlayerGui.Main.Quest.Visible then 

                    if not Check_Near_Mon(Boss_Name) and Enable_Server_Hop then
                        Server_Hop("Finding "..Boss_Name)
                    end

                    if Check_Near_Mon(Boss_Name) and not workspace.Enemies:FindFirstChild(Boss_Name) then
                        Go_to_Part(Check_Near_Mon(Boss_Name).HumanoidRootPart.CFrame,function() return not Auto_Farm_Boss or workspace.Enemies:FindFirstChild(Boss_Name) end)
                    end

                    if Check_Near_Mon(Boss_Name) then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Boss_Name and Check_Available_Mon(v) then
                                Start_Attack(v,function()
                                    return not Auto_Farm_Boss or not Check_Near_Mon(Boss_Name) or not Local_Player.PlayerGui.Main.Quest.Visible or not Check_Available_Mon(v)
                                end)
                            end
                        end
                    end
                end
            end
        end
    end)
end

All_Function.Teleport_To_Island = function()
    task.spawn(function()
        while Teleport_To_Island and wait(.5) do
            if Teleport_To_Island then
                
                if Island_Selected == nil then return end

                for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
                    if v.Name == Island_Selected then
                        Go_to_Part(v.CFrame * CFrame.new(0,40,0),function()
                            return not Teleport_To_Island
                        end)
                    end
                end

            end
        end
    end)
end

All_Function.Auto_Observation_Farm = function()

    task.spawn(function()
        while Auto_Observation_Farm and wait(.5) do
            if Auto_Observation_Farm then
                if not Local_Player.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
                    wait(40)
                    game:GetService('VirtualUser'):CaptureController()
                    game:GetService('VirtualUser'):SetKeyDown('0x65')
                    wait(2)
                    game:GetService('VirtualUser'):SetKeyUp('0x65')
                end
            end
        end
    end)

    task.spawn(function()
        while Auto_Observation_Farm and wait(.5) do
            if Auto_Observation_Farm then
                pcall(function()
                    if FirstSea then
                        Mon = "Galley Captain"
                    elseif SecondSea then
                        Mon = "Snow Lurker"
                    elseif ThirdSea then
                        Mon = "Marine Commodore"
                    end

                    if not Check_Near_Mon(Mon) then
                        Go_To_Mon_Spawn(Mon,function()
                            return not Auto_Observation_Farm
                        end)
                    end

                    if not Local_Player.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then

                        if Check_Near_Mon(Mon) then
                            repeat task.wait(0.02)
                                TP(workspace.Enemies:FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0,25,10))
                            until Local_Player.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") or not Auto_Observation_Farm or not Check_Near_Mon(Mon) 
                        end

                    end

                    if Local_Player.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then

                        if Check_Near_Mon(Mon) then
                            repeat task.wait(0.02)
                                TP(workspace.Enemies:FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0,0,-5))
                            until not Local_Player.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") or not Auto_Observation_Farm or not Check_Near_Mon(Mon) 
                        end
                    end
                end)
            end
        end
    end)
    
end

All_Function.Auto_Observation_V2 = function()
    task.spawn(function()
        while Auto_Observation_V2 and wait(.5) do
            if Auto_Observation_V2 then
                pcall(function()
                    if not ThirdSea then return end
                    if not Check_Tool_Inventory("Apple") and not Check_Tool_Inventory("Banana") then
                        repeat wait(.1)
                            firetouchinterest(Local_Player.Character.HumanoidRootPart,workspace.AppleSpawner.Apple.Handle.CFrame.Handle,0)    
                        until not Auto_Observation_V2 or Check_Tool_Inventory("Apple")
                    end
    
                    if Check_Tool_Inventory("Apple") and not Check_Tool_Inventory("Banana") then
                        repeat wait(.1)
                            firetouchinterest(Local_Player.Character.HumanoidRootPart,workspace.BananaSpawner.Banana.Handle,0)    
                        until not Auto_Observation_V2 or Check_Tool_Inventory("Banana")
                    end
    
                    if Check_Tool_Inventory("Apple") and Check_Tool_Inventory("Banana") and not Check_Tool_Inventory("Pineapple") then
                        repeat wait(.1)
                            firetouchinterest(Local_Player.Character.HumanoidRootPart,workspace.PineappleSpawner.Pineapple.Handle,0)    
                        until not Auto_Observation_V2 or Check_Tool_Inventory("Pineapple")
                    end
    
                    if Check_Tool_Inventory("Apple") and Check_Tool_Inventory("Banana") and Check_Tool_Inventory("Pineapple") then
                        repeat wait(.5)
                            Use_Remote("CitizenQuestProgress","Citizen")
                        until not Auto_Observation_V2 or Check_Tool_Inventory("Fruit Bowl")
                    end
    
                    if Check_Tool_Inventory("Fruit Bowl") then
                        repeat wait(.5)
                            Use_Remote("KenTalk2","Buy")
                        until not Auto_Observation_V2 or not Check_Tool_Inventory("Fruit Bowl")
                    end
                end)
            end
        end
    end)
end

All_Function.Auto_Buy_Devil_Fruit = function()
    task.spawn(function()
        while Auto_Buy_Devil_Fruit and wait(.5) do
            if Auto_Buy_Devil_Fruit then
                Use_Remote("PurchaseRawFruit",Fruit_Selected)
            end                              
        end
    end)
end

All_Function.Auto_Random_Fruit = function()
    task.spawn(function()
        while Auto_Random_Fruit and wait(.5) do
            if Auto_Random_Fruit then	
                Use_Remote("Cousin","Buy")
            end
        end
    end)
end

All_Function.Auto_Bring_Fruit = function()
    task.spawn(function()
        while Auto_Bring_Fruit and wait(.5) do
            if Auto_Bring_Fruit then
                for i,v in pairs(workspace:GetChildren()) do
                    if string.find(v.Name, "Fruit") or v.Name == "Fruit " then
                        firetouchinterest(v.Handle,0)    
                    end
                end
            end
        end
    end)
end

All_Function.Auto_Store_Fruit = function()

    local function RemoveSpaces(str)
        return str:gsub(" Fruit", "")
    end    

    task.spawn(function()
        while Auto_Store_Fruit and wait(.5) do
            if Auto_Store_Fruit then
                pcall(function()
                    for i,v in pairs(Local_Player.Backpack:GetChildren()) do
                        if string.find(v.Name,"Fruit") then
                            local FruitName = RemoveSpaces(v.Name)
                            if v.Name == "Bird: Falcon Fruit" then
                                NameFruit = "Bird-Bird: Falcon"
                            elseif v.Name == "Bird: Phoenix Fruit" then
                                NameFruit = "Bird-Bird: Phoenix"
                            elseif v.Name == "Human: Buddha Fruit" then
                                NameFruit = "Human-Human: Buddha"
                            else
                                NameFruit = FruitName.."-"..FruitName
                            end
                            local string_1 = "getInventoryFruits";
                            local Target = game:GetService("ReplicatedStorage").Remotes["CommF_"];
                            for i1,v1 in pairs(Target:InvokeServer(string_1)) do
                                if v1.Name == NameFruit then
                                    HaveFruitInStore = true
                                end
                            end
                            if not HaveFruitInStore then
                                Use_Remote("StoreFruit",NameFruit,Local_Player.Character:FindFirstChild(v.Name) or Local_Player.Backpack:FindFirstChild(v.Name))
                            end
                            HaveFruitInStore = false
                        end
                    end
                end)
            end
        end
    end)    
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

-- setscriptable(Local_Player,"SimulationRadius",true)
-- task.spawn(function()
--     while game:GetService("RunService").Stepped:Wait() do
--         Local_Player.SimulationRadius = math.huge
--     end
-- end)

task.spawn(function()
    while RunService.Stepped:Wait() do
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

task.spawn(function()
	local gg = getrawmetatable(game)
	local old = gg.__namecall
	setreadonly(gg,false)
	gg.__namecall = newcclosure(function(...)
		local method = getnamecallmethod()
		local args = {...}
		if tostring(method) == "FireServer" then
			if tostring(args[1]) == "RemoteEvent" then
				if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if UseSkillMasteryDevilFruit and Auto_Farm_Mastery and Mode_Mastery == "Fruit" then
						if type(args[2]) == "vector" then 
							args[2] = PositionSkillMasteryDevilFruit
						else
							args[2] = CFrame.new(PositionSkillMasteryDevilFruit)
						end
						return old(unpack(args))
                    end
					-- if AimbotSkill and SelectAimbotMode == "Fov" then
					-- 	args[2] = _G.Aim_Players.Character.HumanoidRootPart.Position
					-- 	return old(unpack(args))
					-- elseif AimbotSkill and SelectAimbotMode == "Automatic" then
					-- 	args[2] = _G.Aim_Select_Players.Character.HumanoidRootPart.Position
					-- 	return old(unpack(args))
					-- end
				end
			end
		end
		return old(...)
	end)
end)

task.spawn(function()
    while wait(1) do
        for i,v in pairs(Local_Player.Backpack:GetChildren()) do  
            if v:IsA("Tool") then
                if v:FindFirstChild("RemoteFunctionShoot") then 
                    Weapon_Gun = v.Name
                end
            end
        end
        for i,v in pairs(Local_Player.Character:GetChildren()) do  
            if v:IsA("Tool") then
                if v:FindFirstChild("RemoteFunctionShoot") then 
                    Weapon_Gun = v.Name
                end
            end
        end
    end
end)

task.spawn(function()
	local gt = getrawmetatable(game)
	local old = gt.__namecall
	setreadonly(gt,false)
	gt.__namecall = newcclosure(function(...)
		local args = {...}
		if getnamecallmethod() == "InvokeServer" then 
			if Weapon_Gun then
				if Weapon_Gun == "Soul Guitar" then
					if tostring(args[2]) == "TAP" then
						if Auto_Farm_Mastery and Use_Gun then
							args[3] = PositionSkillMasteryGun
						end
					end
				end
			end
		end
		return old(unpack(args))
	end)
	setreadonly(gt,true)
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
    while wait(.5) do
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
    end
end)

task.spawn(function()
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
                        if Check_Tool_Inventory(v.Name) then
                            Current_Weapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while wait(.5) do
        if DoRaid and not Raiding() then
            Raid_Chip = "Dark"
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
        if DoRaid and Raiding() then
            pcall(function()
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
                    task.spawn(Kill_Aura)
                    if workspace["_WorldOrigin"].Locations:FindFirstChild("Island 5") and dist(workspace["_WorldOrigin"].Locations["Island 5"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 4") and dist(workspace["_WorldOrigin"].Locations["Island 4"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 3") and dist(workspace["_WorldOrigin"].Locations["Island 3"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 2") and dist(workspace["_WorldOrigin"].Locations["Island 2"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame * CFrame.new(0,70,100))
                    elseif workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1") and dist(workspace["_WorldOrigin"].Locations["Island 1"].Position) <= 3000 then
                        TP(workspace["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame * CFrame.new(0,70,100))
                    end
                until not DoRaid or not Raiding()
                Need_Noclip = false
            end)
        end
    end
end)

task.spawn(function()
    local stacking = 0
    local printCooldown = 0
    while wait(.075) do
        nearbymon = false
        table.clear(CurrentAllMob)
        table.clear(canHits)
        if not nearbymon then
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
                continue
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

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local MainLibrary = 'https://raw.githubusercontent.com/hajibeza/GUISTORAGE/main/Mobile_Gui.lua'
local Theme = 'https://raw.githubusercontent.com/hajibeza/GUISTORAGE/main/'

local Library = loadstring(game:HttpGet(MainLibrary))()
local ThemeManager = loadstring(game:HttpGet(Theme .. 'RIPPERGui.lua'))()
-- local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

getgenv().Calendar = {
    DateTime.now():FormatLocalTime("dddd", "eu-us");
    DateTime.now():FormatLocalTime("D", "eu-us");
    DateTime.now():FormatLocalTime("MMMM", "eu-us");
    DateTime.now():FormatLocalTime("YYYY", "eu-us")
}

local Window = Library:CreateWindow({
    Title = 'RIPPER - Mobile - '..Calendar[1]..' | '..Calendar[2]..' | '..Calendar[3]..' | '..Calendar[4]..' | ',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab('Main'), 
	-- Player = Window:AddTab('Player'),
	Teleport = Window:AddTab('Teleport'),
	Raid = Window:AddTab('Raid'),
	Item = Window:AddTab('Shop'),
	['Settings'] = Window:AddTab('Settings'),
}

ThemeManager:SetLibrary(Library)

ThemeManager:ApplyToTab(Tabs['Settings'])

Library:SetWatermarkVisibility(true)

function UpdateTime()
    local GameTime = math.floor(workspace.DistributedGameTime+0.5)
    local Hour = math.floor(GameTime/(60^2))%24
    local Minute = math.floor(GameTime/(60^1))%60
    local Second = math.floor(GameTime/(60^0))%60
	Library:SetWatermark("RIPPER HUB | Hour : "..Hour.." Minute : "..Minute.." Second : "..Second)
end

spawn(function()
    while true do
        UpdateTime()
        wait()
    end
end)

local Main_Tab = Tabs.Main:AddLeftTabbox()

local Main_Section = Main_Tab:AddTab('Main')

Main_Section:AddToggle('Auto_Farm_Level', {
    Text = 'Auto Farm Level',
    Default = false,
}):OnChanged(function(value)
	Auto_Farm_Level = value
    if All_Function["Auto_Farm_Level"] then
        All_Function["Auto_Farm_Level"]()
    end
end)

if FirstSea then

    Main_Section:AddToggle('Auto_Second_Sea', {
        Text = 'Auto Second Sea',
        Default = false,
    }):OnChanged(function(value)
        Auto_Second_Sea = value
        if All_Function["Auto_Second_Sea"] then
            All_Function["Auto_Second_Sea"]()
        end
    end)

elseif SecondSea then

    Main_Section:AddToggle('Auto_Third_Sea', {
        Text = 'Auto Third Sea',
        Default = false,
    }):OnChanged(function(value)
        Auto_Third_Sea = value
        if All_Function["Auto_Third_Sea"] then
            All_Function["Auto_Third_Sea"]()
        end
    end)

end

local Mastery_Tab = Tabs.Main:AddLeftTabbox()

local Mastery_Section = Mastery_Tab:AddTab('Mastery')

Mastery_Section:AddSlider('Health %', {
    Text = 'Health %',
    Default = 15,
    Min = 1,
    Max = 100,
    Rounding = 0,

    Compact = true,
}):OnChanged(function(value)
    Percent_Mon_Health = value
end)

local Mastery_Dropdown = Mastery_Section:AddDropdown('Mastery Mode', {
    Values = {"Fruit","Gun [Not Work]"},
    Default = 1,
    Multi = false,
    Text = 'Mastery Mode',
})Options["Mastery Mode"]:OnChanged(function(value)
    Mode_Mastery = value
end)

Mastery_Section:AddToggle('Auto_Farm_Mastery', {
    Text = 'Auto Farm Mastery',
    Default = false,
}):OnChanged(function(value)
    Auto_Farm_Mastery = value
    if All_Function["Auto_Farm_Mastery"] then
        All_Function["Auto_Farm_Mastery"]()
    end
end)

local Boss_Tab = Tabs.Main:AddLeftTabbox()

local Boss_Section = Boss_Tab:AddTab('Boss')

local Boss_Check_Label = Boss_Section:AddLabel("")

task.spawn(function()
    while wait(.1) do
        if Check_Near_Mon(BossChosen) then
            Boss_Check_Label:SetText(BossChosen.." : Available")
        end
        if not Check_Near_Mon(BossChosen) then
            Boss_Check_Label:SetText(BossChosen.." : Not Available")
        end
    end
end)

local Boss_Table = {}   
for i,v in pairs(Mon) do
	table.insert(Boss_Table, v)
end

local Boss_Dropdown = Boss_Section:AddDropdown('Boss', {
    Values = Boss_Table,
    Default = 1,
    Multi = false,
    Text = 'Boss',
})Options["Boss"]:OnChanged(function(value)
    BossChosen = value
end)

-- Boss_Section:AddButton('Refresh Boss',function()
-- 	table.clear(Boss_Table)
--     for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
--         if string.find(v.Name, "Boss") then
--             table.insert(Boss_Table, v.Name)
--         end
--     end
-- 	Boss_Dropdown:SetValues(Boss_Table)
-- end)

Boss_Section:AddToggle('Auto_Farm_Boss', {
    Text = 'Auto Farm Boss',
    Default = false,
}):OnChanged(function(value)
    Auto_Farm_Boss = value
    if All_Function["Auto_Farm_Boss"] then
        All_Function["Auto_Farm_Boss"]()
    end
end)

local Material_Tab = Tabs.Main:AddLeftTabbox()

local Material_Section = Material_Tab:AddTab('Material')

local Boss_Dropdown = Material_Section:AddDropdown('Material', {
    Values = All_Material,
    Default = 1,
    Multi = false,
    Text = 'Material',
})Options["Material"]:OnChanged(function(value)
    Material = value
end)

Material_Section:AddToggle('Auto_Farm_Material', {
    Text = 'Auto Farm Material',
    Default = false,
}):OnChanged(function(value)
    Auto_Farm_Material = value
    if All_Function["Auto_Farm_Material"] then
        All_Function["Auto_Farm_Material"]()
    end
end)

local FightingStyle_Tab = Tabs.Main:AddLeftTabbox()

local FightingStyle_Section = FightingStyle_Tab:AddTab('Fighting Style')

FightingStyle_Section:AddToggle('Auto_God_Human', {
    Text = 'Auto God Human',
    Default = false,
}):OnChanged(function(value)
    Auto_God_Human = value
    if All_Function["Auto_God_Human"] then
        All_Function["Auto_God_Human"]()
    end
end)

FightingStyle_Section:AddToggle('Auto_Electric_Claw', {
    Text = 'Auto Electric Claw',
    Default = false,
}):OnChanged(function(value)
    Auto_Electric_Claw = value
    if All_Function["Auto_Electric_Claw"] then
        All_Function["Auto_Electric_Claw"]()
    end
end)

FightingStyle_Section:AddToggle('Auto_Superhuman', {
    Text = 'Auto Super Human',
    Default = false,
}):OnChanged(function(value)
    Auto_Superhuman = value
    if All_Function["Auto_Superhuman"] then
        All_Function["Auto_Superhuman"]()
    end
end)

if SecondSea or ThirdSea then

    local Sea_Evernt_Tab = Tabs.Main:AddLeftTabbox()

    local Sea_Evernt_Section = Sea_Evernt_Tab:AddTab('Sea Event')

    local Sea_Dropdown = Sea_Evernt_Section:AddDropdown('Sea Level', {
        Values = sortedSeaIndices,
        Default = 1,
        Multi = false,
        Text = 'Sea Level'
    }):OnChanged(function(value)
        Sea_Level = value
    end)

    Sea_Evernt_Section:AddToggle('Auto_Sea_Event', {
        Text = 'Auto Sea Event',
        Default = false,
    }):OnChanged(function(value)
        Auto_Sea_Event = value
        if All_Function["Auto_Sea_Event"] then
            All_Function["Auto_Sea_Event"]()
        end
    end)

end

if ThirdSea then

    local Elite_Hunter_Tab = Tabs.Main:AddLeftTabbox()

    local Elite_Hunter_Section = Elite_Hunter_Tab:AddTab('Elite Hunter')

    local Elite_Hunter_Status = Elite_Hunter_Section:AddLabel("")

    task.spawn(function()
        while wait(.1) do
            if Check_Near_Mon("Diablo") or Check_Near_Mon("Deandre") or Check_Near_Mon("Urban") then
                Elite_Hunter_Status:SetText("Elite Hunter : Available")	
            else
                Elite_Hunter_Status:SetText("Elite Hunter : Not Available")	
            end
        end
    end)

    local Killed_Elite_Hunter = Elite_Hunter_Section:AddLabel("")

    task.spawn(function()
        while wait(.1) do
            Killed_Elite_Hunter:SetText("Total Elite Hunter : "..Use_Remote("EliteHunter","Progress"))
        end
    end)

    Elite_Hunter_Section:AddToggle('Auto_Elite_Hunter', {
        Text = 'Auto Elite Hunter',
        Default = false,
    }):OnChanged(function(value)
        Auto_Elite_Hunter = value
        if All_Function["Auto_Elite_Hunter"] then
            All_Function["Auto_Elite_Hunter"]()
        end
    end)

end

local Item_Farm_Tab = Tabs.Main:AddLeftTabbox()

local Item_Farm_Section = Item_Farm_Tab:AddTab('Item')

if FirstSea then
    Item_Farm_Section:AddToggle('Auto_Saber', {
        Text = 'Auto Saber',
        Default = false,
    }):OnChanged(function(value)
        Auto_Saber = value
        if All_Function["Auto_Saber"] then
            All_Function["Auto_Saber"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Pole', {
        Text = 'Auto Pole',
        Default = false,
    }):OnChanged(function(value)
        Auto_Pole = value
        if All_Function["Auto_Pole"] then
            All_Function["Auto_Pole"]()
        end
    end)

elseif SecondSea then

    Item_Farm_Section:AddToggle('Auto_Factory', {
        Text = 'Auto Factory',
        Default = false,
    }):OnChanged(function(value)
        Auto_Factory = value
        if All_Function["Auto_Factory"] then
            All_Function["Auto_Factory"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Rengoku', {
        Text = 'Auto Rengoku',
        Default = false,
    }):OnChanged(function(value)
        Auto_Rengoku = value
        if All_Function["Auto_Rengoku"] then
            All_Function["Auto_Rengoku"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Bartilo_Quest', {
        Text = 'Auto Bartilo Quest',
        Default = false,
    }):OnChanged(function(value)
        Auto_Bartilo_Quest = value
        if All_Function["Auto_Bartilo_Quest"] then
            All_Function["Auto_Bartilo_Quest"]()
        end
    end)


    Item_Farm_Section:AddToggle('Auto_Evo_Race_V2', {
        Text = 'Auto Evo Race [V2]',
        Default = false,
    }):OnChanged(function(value)
        Auto_Evo_Race_V2 = value
        if All_Function["Auto_Evo_Race_V2"] then
            All_Function["Auto_Evo_Race_V2"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Swan_Glasses', {
        Text = 'Auto Swan Glasses',
        Default = false,
    }):OnChanged(function(value)
        Auto_Swan_Glasses = value
        if All_Function["Auto_Swan_Glasses"] then
            All_Function["Auto_Swan_Glasses"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Dragon_Trident', {
        Text = 'Auto Dragon Trident',
        Default = false,
    }):OnChanged(function(value)
        Auto_Dragon_Trident = value
        if All_Function["Auto_Dragon_Trident"] then
            All_Function["Auto_Dragon_Trident"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Buy_Legendary_Sword', {
        Text = 'Auto Buy Legendary Sword',
        Default = false,
    }):OnChanged(function(value)
        Auto_Buy_Legendary_Sword = value
        if All_Function["Auto_Buy_Legendary_Sword"] then
            All_Function["Auto_Buy_Legendary_Sword"]()
        end
    end)

    task.spawn(function()
        while wait(.5) do
            if Auto_Buy_Legendary_Sword then
				Use_Remote("LegendarySwordDealer","1")
				Use_Remote("LegendarySwordDealer","2")
				Use_Remote("LegendarySwordDealer","3")
            end
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Buy_Enchancement', {
        Text = 'Auto Buy Enchancement',
        Default = false,
    }):OnChanged(function(value)
        Auto_Buy_Enchancement = value
        if All_Function["Auto_Buy_Enchancement"] then
            All_Function["Auto_Buy_Enchancement"]()
        end
    end)

    task.spawn(function()
        while wait(.5) do
            if Auto_Buy_Enchancement then
				Use_Remote("ColorsDealer","2")
            end
        end
    end)

elseif ThirdSea then

    Item_Farm_Section:AddToggle('Auto_Soul_Reaper', {
        Text = 'Auto Soul Reaper',
        Default = false,
    }):OnChanged(function(value)
        Auto_Soul_Reaper = value
        if All_Function["Auto_Soul_Reaper"] then
            All_Function["Auto_Soul_Reaper"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Cake_Prince', {
        Text = 'Auto Cake Prince',
        Default = false,
    }):OnChanged(function(value)
        Auto_Cake_Prince = value
        if All_Function["Auto_Cake_Prince"] then
            All_Function["Auto_Cake_Prince"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Rainbow_Haki', {
        Text = 'Auto Rainbow Haki',
        Default = false,
    }):OnChanged(function(value)
        Auto_Rainbow_Haki = value
        if All_Function["Auto_Rainbow_Haki"] then
            All_Function["Auto_Rainbow_Haki"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Musketeer_Hat', {
        Text = 'Auto Musketeer Hat',
        Default = false,
    }):OnChanged(function(value)
        Auto_Musketeer_Hat = value
        if All_Function["Auto_Musketeer_Hat"] then
            All_Function["Auto_Musketeer_Hat"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Yama', {
        Text = 'Auto Yama',
        Default = false,
    }):OnChanged(function(value)
        Auto_Yama = value
        if All_Function["Auto_Yama"] then
            All_Function["Auto_Yama"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Canvander', {
        Text = 'Auto Canvander',
        Default = false,
    }):OnChanged(function(value)
        Auto_Canvander = value
        if All_Function["Auto_Canvander"] then
            All_Function["Auto_Canvander"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Dark_Dagger', {
        Text = 'Auto Dark Dagger',
        Default = false,
    }):OnChanged(function(value)
        Auto_Dark_Dagger = value
        if All_Function["Auto_Dark_Dagger"] then
            All_Function["Auto_Dark_Dagger"]()
        end
    end)

    Item_Farm_Section:AddToggle('Auto_Serpent_Bow', {
        Text = 'Auto Serpent Bow',
        Default = false,
    }):OnChanged(function(value)
        Auto_Serpent_Bow = value
        if All_Function["Auto_Serpent_Bow"] then
            All_Function["Auto_Serpent_Bow"]()
        end
    end)

end

local Main_Setting_Tab = Tabs.Main:AddRightTabbox()

local Main_Setting_Section = Main_Setting_Tab:AddTab('Setting')

Main_Setting_Section:AddToggle('FastAttack', {
    Text = 'Fast Attack',
    Default = true,
}):OnChanged(function(value)
    FastAttack = value
    NewFastAttack = value
    NoAttackAnimation = value
    if All_Function["FastAttack"] then
        All_Function["FastAttack"]()
    end
end)

Main_Setting_Section:AddToggle('Teleport_Island', {
    Text = 'Teleport Island',
    Default = true,
}):OnChanged(function(value)
    Teleport_Island = value
    if All_Function["Teleport_Island"] then
        All_Function["Teleport_Island"]()
    end
end)

Main_Setting_Section:AddToggle('Bypass_Tp', {
    Text = 'Fast Tp',
    Default = true,
}):OnChanged(function(value)
    Bypass_Tp = value
    if All_Function["Bypass_Tp"] then
        All_Function["Bypass_Tp"]()
    end
end)

Main_Setting_Section:AddToggle('Double_Quest', {
    Text = 'Double Quest',
    Default = true,
}):OnChanged(function(value)
    Double_Quest = value
    if All_Function["Double_Quest"] then
        All_Function["Double_Quest"]()
    end
end)

Main_Setting_Section:AddToggle('Random Position', {
    Text = 'Random Position',
    Default = true,
}):OnChanged(function(value)
    Random_Position = value
    if All_Function["Random_Position"] then
        All_Function["Random_Position"]()
    end
end)


Main_Setting_Section:AddToggle('Auto_Buso', {
    Text = 'Auto Buso',
    Default = true,
}):OnChanged(function(value)
    Auto_Buso = value
    if All_Function["Auto_Buso"] then 
        All_Function["Auto_Buso"]()
    end
end)

Main_Setting_Section:AddToggle('Disable_Damage_Effect', {
    Text = 'Disable Damage Effect',
    Default = true,
}):OnChanged(function(value)
    Disable_Damage_Effect = value
    if All_Function["Disable_Damage_Effect"] then 
        All_Function["Disable_Damage_Effect"]()
    end
end)

Main_Setting_Section:AddToggle('Disable_Notifications', {
    Text = 'Disable Notifications',
    Default = true,
}):OnChanged(function(value)
    Disable_Notifications = value
    if All_Function["Disable_Notifications"] then
        All_Function["Disable_Notifications"]()
    end
    if Disable_Notifications then
        Local_Player.PlayerGui.Notifications.Enabled = false
    else
        Local_Player.PlayerGui.Notifications.Enabled = true
    end
end)

Main_Setting_Section:AddToggle('Enable_Server_Hop', {
    Text = 'Enable Server Hop',
    Default = false,
}):OnChanged(function(value)
    Enable_Server_Hop = value
    if All_Function["Enable_Server_Hop"] then
        All_Function["Enable_Server_Hop"]()
    end
end)

Main_Setting_Section:AddSlider('Redeem_Code_At_Level', {
    Text = 'Level to Redeem Code',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = true,
}):OnChanged(function(value)
    Redeem_Code_At_Level = value
end)

Main_Setting_Section:AddToggle('Auto_Redeem_Code', {
    Text = 'Auto Redeem Code [X2 EXP]',
    Default = false,
}):OnChanged(function(value)
    Auto_Redeem_Code = value
    if All_Function["Auto_Redeem_Code"] then
        All_Function["Auto_Redeem_Code"]()
    end
end)

local Bring_Mob_Mode_Dropdown = Main_Setting_Section:AddDropdown('Bring Mon Mode', {
    Values = {"Default","Less Lag"},
    Default = 1,
    Multi = false,
    Text = 'Bring Mob Mode'
}):OnChanged(function(value)
    Bring_Mob_Mode = value
end)

local Weapon_Dropdown = Main_Setting_Section:AddDropdown('Weapon', {
    Values = {"Melee","Sword"},
    Default = 1,
    Multi = false,
    Text = 'Weapon'
}):OnChanged(function(value)
    Weapon = value
end)

local Stats_Tab = Tabs.Main:AddRightTabbox()

local Stats_Section = Stats_Tab:AddTab('Stats')

Stats_Section:AddToggle('Auto_Stats_Kaitun_Sword', {
    Text = 'Auto Stats Kaitun [Fruit]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Kaitun_Sword = value
    if All_Function["Auto_Stats_Kaitun_Sword"] then
        All_Function["Auto_Stats_Kaitun_Sword"]()
    end
end)

Stats_Section:AddToggle('Auto_Stats_Kaitun_Gun', {
    Text = 'Auto Stats Kaitun [Gun]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Kaitun_Gun = value
    if All_Function["Auto_Stats_Kaitun_Gun"] then
        All_Function["Auto_Stats_Kaitun_Gun"]()
    end
end)

Stats_Section:AddToggle('Auto_Stats_Kaitun_Devil_Fruit', {
    Text = 'Auto Stats Kaitun [Devil Fruit]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Kaitun_Devil_Fruit = value
    if All_Function["Auto_Stats_Kaitun_Devil_Fruit"] then
        All_Function["Auto_Stats_Kaitun_Devil_Fruit"]()
    end
end)

Stats_Section:AddDivider()

Stats_Section:AddToggle('Auto_Stats_Melee', {
    Text = 'Auto Stats [Melee]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Melee = value
    if All_Function["Auto_Stats_Melee"] then
        All_Function["Auto_Stats_Melee"]()
    end
end)

Stats_Section:AddToggle('Auto_Stats_Defense', {
    Text = 'Auto Stats [Defense]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Defense = value
    if All_Function["Auto_Stats_Defense"] then
        All_Function["Auto_Stats_Defense"]()
    end
end)

Stats_Section:AddToggle('Auto_Stats_Sword', {
    Text = 'Auto Stats [Sword]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Sword = value
    if All_Function["Auto_Stats_Sword"] then
        All_Function["Auto_Stats_Sword"]()
    end
end)

Stats_Section:AddToggle('Auto_Stats_Gun', {
    Text = 'Auto Stats [Gun]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Gun = value
    if All_Function["Auto_Stats_Gun"] then
        All_Function["Auto_Stats_Gun"]()
    end
end)

Stats_Section:AddToggle('Auto_Stats_Devil_Fruit', {
    Text = 'Auto Stats [Gun]',
    Default = false,
}):OnChanged(function(value)
    Auto_Stats_Devil_Fruit = value
    if All_Function["Auto_Stats_Devil_Fruit"] then
        All_Function["Auto_Stats_Devil_Fruit"]()
    end
end)

Stats_Section:AddSlider('Point', {
    Text = 'Point',
    Default = 3,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = true,
}):OnChanged(function(value)
    Stats_Point = value
end)

local Observation_Tab = Tabs.Main:AddRightTabbox()

local Observation_Section = Observation_Tab:AddTab('Observation')

local Level_Observation = Observation_Section:AddLabel("")

task.spawn(function()
	while wait(.5) do
        local Remote_Observation = Use_Remote("KenTalk","Status")
        local Observation_Level = tonumber(Remote_Observation:match("(%d+)"))
		Level_Observation:SetText("Observation Level : "..Observation_Level)
	end
end)

Observation_Section:AddToggle('Auto_Observation_Farm', {
    Text = 'Auto Observation Farm',
    Default = false,
}):OnChanged(function(value)
    Auto_Observation_Farm = value
    if All_Function["Auto_Observation_Farm"] then
        All_Function["Auto_Observation_Farm"]()
    end
    if value then
        game:GetService('VirtualUser'):CaptureController()
        game:GetService('VirtualUser'):SetKeyDown('0x65')
        wait(2)
        game:GetService('VirtualUser'):SetKeyUp('0x65')
    end
end)

Observation_Section:AddToggle('Auto_Observation_V2', {
    Text = 'Auto Observation V2',
    Default = false,
}):OnChanged(function(value)
    Auto_Observation_V2 = value
    if All_Function["Auto_Observation_V2"] then
        All_Function["Auto_Observation_V2"]()
    end
end)

local Mastery_Setting_Tab = Tabs.Main:AddRightTabbox()

local Mastery_Setting_Section = Mastery_Setting_Tab:AddTab('Mastery Setting')

Mastery_Setting_Section:AddToggle('SkillZ', {
    Text = 'Skill Z',
    Default = true,
}):OnChanged(function(value)
    SkillZ = value
    if All_Function["SkillZ"] then
        All_Function["SkillZ"]()
    end
end)

Mastery_Setting_Section:AddToggle('SkillX', {
    Text = 'Skill X',
    Default = true,
}):OnChanged(function(value)
    SkillX = value
    if All_Function["SkillX"] then
        All_Function["SkillX"]()
    end
end)

Mastery_Setting_Section:AddToggle('SkillC', {
    Text = 'Skill C',
    Default = true,
}):OnChanged(function(value)
    SkillC = value
    if All_Function["SkillC"] then
        All_Function["SkillC"]()
    end
end)

Mastery_Setting_Section:AddToggle('SkillV', {
    Text = 'Skill V',
    Default = true,
}):OnChanged(function(value)
    SkillV = value
    if All_Function["SkillV"] then
        All_Function["SkillV"]()
    end
end)

local Teleport_World_Tab = Tabs.Teleport:AddLeftTabbox()

local Teleport_World_Section = Teleport_World_Tab:AddTab('Teleport Sea')

Teleport_World_Section:AddButton('First World', function()
    Use_Remote("TravelMain")
end)

Teleport_World_Section:AddButton('Second World', function()
    Use_Remote("TravelDressrosa")
end)

Teleport_World_Section:AddButton('Third World', function()
    Use_Remote("TravelZou")
end)

local Teleport_Island_Tab = Tabs.Teleport:AddRightTabbox()

local Teleport_Island_Section = Teleport_Island_Tab:AddTab('Teleport Island')

Location = {}
for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do  
    if not table.find(Location,v.Name) then
        table.insert(Location ,v.Name)
    end
end

local Island_Dropdown = Teleport_Island_Section:AddDropdown('Island', {
    Values = Location,
    Default = 1,
    Multi = false,
    Text = 'Island',
})Options["Island"]:OnChanged(function(value)
    Island_Selected = value
end)

Teleport_Island_Section:AddToggle('Teleport_To_Island', {
    Text = 'Teleport To Island',
    Default = false,
}):OnChanged(function(value)
    Teleport_To_Island = value
    if All_Function["Teleport_To_Island"] then
        All_Function["Teleport_To_Island"]()
    end
end)

local Main_Raid_Tab = Tabs.Raid:AddLeftTabbox()

local Main_Raid_Section = Main_Raid_Tab:AddTab('Main Raid')

local Chip_Dropdown = Main_Raid_Section:AddDropdown('Select Raid', {
    Values = All_Raid_Chip,
    Default = 1,
    Multi = false,
    Text = 'Select Raid',
})Options["Select Raid"]:OnChanged(function(value)
    Raid_Chip = value
end)

Main_Raid_Section:AddToggle('Auto_Start_Raid', {
    Text = 'Auto Start Raid',
    Default = false,
}):OnChanged(function(value)
    Auto_Start_Raid = value
    if All_Function["Auto_Start_Raid"] then
        All_Function["Auto_Start_Raid"]()
    end
end)

Main_Raid_Section:AddToggle('Auto_Finish_Raid', {
    Text = 'Auto Finish Raid',
    Default = false,
}):OnChanged(function(value)
    Auto_Finish_Raid = value
    if All_Function["Auto_Finish_Raid"] then
        All_Function["Auto_Finish_Raid"]()
    end
end)

local Main_Raid_Setting_Tab = Tabs.Raid:AddLeftTabbox()

local Main_Raid_Setting_Section = Main_Raid_Setting_Tab:AddTab('Setting Main Raid')

local Remote_GetFruits = Use_Remote("GetFruits")

if #Remote_GetFruits > 0 then
    local cheapestFruit = Remote_GetFruits[1]
    local mostExpensiveFruit = Remote_GetFruits[1]

    for i, v in ipairs(Remote_GetFruits) do
        if v.Price < cheapestFruit.Price then
            cheapestFruit = v
        end

        if v.Price > mostExpensiveFruit.Price then
            mostExpensiveFruit = v
        end
    end

	Cheapest_Fruit_Value = cheapestFruit.Price
	Most_Expensive_Fruit_Value = mostExpensiveFruit.Price
end

Main_Raid_Setting_Section:AddSlider('Fruit Value', {
    Text = 'Fruit Value',
    Default = 1000000,
    Min = Cheapest_Fruit_Value,
    Max = Most_Expensive_Fruit_Value,
    Rounding = 0,

    Compact = true,
}):OnChanged(function(value)
    Fruit_Value = value
end)

Main_Raid_Setting_Section:AddToggle('Use_Fruit_Inventory', {
    Text = 'Use Fruit Inventory',
    Default = false,
}):OnChanged(function(value)
    Use_Fruit_Inventory = value
    if All_Function["Use_Fruit_Inventory"] then
        All_Function["Use_Fruit_Inventory"]()
    end
end)

local Law_Raid_Tab = Tabs.Raid:AddRightTabbox()

local Law_Raid_Section = Law_Raid_Tab:AddTab('Law Raid')

Law_Raid_Section:AddToggle('Auto_Start_Law_Raid', {
    Text = 'Auto Start Law Raid',
    Default = false,
}):OnChanged(function(value)
    Auto_Start_Law_Raid = value
    if All_Function["Auto_Start_Law_Raid"] then
        All_Function["Auto_Start_Law_Raid"]()
    end
end)

Law_Raid_Section:AddToggle('Auto_Law_Raid', {
    Text = 'Auto Law Raid',
    Default = false,
}):OnChanged(function(value)
    Auto_Law_Raid = value
    if All_Function["Auto_Law_Raid"] then
        All_Function["Auto_Law_Raid"]()
    end
end)

local Race_V4_Tab = Tabs.Raid:AddLeftTabbox()

local Race_V4_Section = Race_V4_Tab:AddTab('Race V4')

Race_V4_Section:AddToggle('Teleport_To_Gear', {
    Text = 'Teleport To Gear',
    Default = false,
}):OnChanged(function(value)
    Teleport_To_Gear = value
    if All_Function["Teleport_To_Gear"] then
        All_Function["Teleport_To_Gear"]()
    end
end)

Race_V4_Section:AddToggle('Teleport_To_Trail_Door', {
    Text = 'Teleport To Trail Door',
    Default = false,
}):OnChanged(function(value)
    Teleport_To_Trail_Door = value
    if All_Function["Teleport_To_Trail_Door"] then
        All_Function["Teleport_To_Trail_Door"]()
    end
end)

Race_V4_Section:AddButton('Pull Lever', function()
    fireproximityprompt(workspace.Map["Temple of Time"].Lever.Prompt.ProximityPrompt,math.huge)
end)

Race_V4_Section:AddButton('Teleport To Temple Of Time', function()
    Local_Player.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
end)

Race_V4_Section:AddButton('Teleport To Lever', function()
    Local_Player.Character.HumanoidRootPart.CFrame = CFrame.new(28576.873046875, 14937.958984375, 76.49504852294922)
end)

local Devil_Fruit_Tab = Tabs.Item:AddLeftTabbox()

local Devil_Fruit_Section = Devil_Fruit_Tab:AddTab('Devil Fruit')

local Remote_GetFruits = Use_Remote("GetFruits");

Table_DevilFruitSniper = {}
ShopDevilSell = {}

for i,v in next,Remote_GetFruits do
	table.insert(Table_DevilFruitSniper,v.Name)
	if v.OnSale then 
		table.insert(ShopDevilSell,v.Name)
	end
end

local Devil_Fruit_Dropdown = Devil_Fruit_Section:AddDropdown('Fruit_Selected', {
    Values = Table_DevilFruitSniper,
    Default = 1,
    Multi = false,
    Text = 'Devil Fruit',
})

Options.Fruit_Selected:OnChanged(function(value)
    Fruit_Selected = value
    if All_Function["Fruit_Selected"] then
        All_Function["Fruit_Selected"]()
    end
end)

Devil_Fruit_Section:AddToggle('Auto_Buy_Devil_Fruit', {
    Text = 'Auto Buy Devil Fruit',
    Default = false,
}):OnChanged(function(value)
    Auto_Buy_Devil_Fruit = value
    if All_Function["Auto_Buy_Devil_Fruit"] then
        All_Function["Auto_Buy_Devil_Fruit"]()
    end
end)

Devil_Fruit_Section:AddToggle('Auto_Random_Fruit', {
    Text = 'Auto Random Fruit',
    Default = false,
}):OnChanged(function(value)
	Auto_Random_Fruit = value
    if All_Function["Auto_Random_Fruit"] then
        All_Function["Auto_Random_Fruit"]()
    end
end)

Devil_Fruit_Section:AddToggle('Auto_Bring_Fruit', {
    Text = 'Auto Bring Fruit',
    Default = false,
}):OnChanged(function(value)
	Auto_Bring_Fruit = value
    if All_Function["Auto_Bring_Fruit"] then
        All_Function["Auto_Bring_Fruit"]()
    end
end)

Devil_Fruit_Section:AddToggle('Auto_Store_Fruit', {
    Text = 'Auto Store Fruit',
    Default = false,
}):OnChanged(function(value)
	Auto_Store_Fruit = value
    if All_Function["Auto_Store_Fruit"] then
        All_Function["Auto_Store_Fruit"]()
    end
end)

local Fighting_Style_Shop_Tab = Tabs.Item:AddRightTabbox()

local Fighting_Style_Shop_Section = Fighting_Style_Shop_Tab:AddTab('Combat')

Fighting_Style_Shop_Section:AddButton("Black Leg",function()
	Use_Remote("BuyBlackLeg")
end)

Fighting_Style_Shop_Section:AddButton("Electro",function()
	Use_Remote("BuyElectro")
end)

Fighting_Style_Shop_Section:AddButton("Fishman Karate",function()
	Use_Remote("BuyFishmanKarate")
end)

Fighting_Style_Shop_Section:AddButton("Dragon Claw",function()
	Use_Remote("BlackbeardReward","DragonClaw","1")
	Use_Remote("BlackbeardReward","DragonClaw","2")
end)

Fighting_Style_Shop_Section:AddButton("Superhuman",function()
	Use_Remote("BuySuperhuman")
end)
Fighting_Style_Shop_Section:AddButton("Death Step",function()
	Use_Remote("BuyDeathStep")
end)
Fighting_Style_Shop_Section:AddButton("Sharkman Karate",function()
	Use_Remote("BuySharkmanKarate",true)
	Use_Remote("BuySharkmanKarate")
end)
Fighting_Style_Shop_Section:AddButton("Electric Claw",function()
	Use_Remote("BuyElectricClaw",true)
	Use_Remote("BuyElectricClaw")
end)

Fighting_Style_Shop_Section:AddButton("Dragon Talon",function()
	Use_Remote("BuyDragonTalon",true)
	Use_Remote("BuyDragonTalon")
end)

Fighting_Style_Shop_Section:AddButton("Godhuman",function()
	Use_Remote("BuyGodhuman",true)
	Use_Remote("BuyGodhuman")
end)

local Sword_Shop_Tab = Tabs.Item:AddRightTabbox()

local Sword_Shop_Section = Sword_Shop_Tab:AddTab('Sword')

Sword_Shop_Section:AddButton("Katana",function()
	Use_Remote("BuyItem","Katana")
end)

Sword_Shop_Section:AddButton("Cutlass",function()
	Use_Remote("BuyItem","Cutlass")
end)

Sword_Shop_Section:AddButton("Duel Katana",function()
	Use_Remote("BuyItem","Duel Katana")
end)

Sword_Shop_Section:AddButton("Iron Mace",function()
	Use_Remote("BuyItem","Iron Mace")
end)

Sword_Shop_Section:AddButton("Pipe",function()
	Use_Remote("BuyItem","Pipe")
end)

Sword_Shop_Section:AddButton("Triple Katana",function()
	Use_Remote("BuyItem","Triple Katana")
end)

Sword_Shop_Section:AddButton("Dual-Headed Blade",function()
	Use_Remote("BuyItem","Dual-Headed Blade")
end)

Sword_Shop_Section:AddButton("Bisento",function()
	Use_Remote("BuyItem","Bisento")
end)

Sword_Shop_Section:AddButton("Soul Cane",function()
	Use_Remote("BuyItem","Soul Cane")
end)

local Gun_Shop_Tab = Tabs.Item:AddRightTabbox()

local Gun_Shop_Section = Gun_Shop_Tab:AddTab('Gun')

Gun_Shop_Section:AddButton("Slingshot",function()
	Use_Remote("BuyItem","Slingshot")
end)

Gun_Shop_Section:AddButton("Musket",function()
	Use_Remote("BuyItem","Musket")
end)

Gun_Shop_Section:AddButton("Flintlock",function()
	Use_Remote("BuyItem","Flintlock")
end)

Gun_Shop_Section:AddButton("Refined Flintlock",function()
	Use_Remote("BuyItem","Refined Flintlock")
end)

Gun_Shop_Section:AddButton("Cannon",function()
	Use_Remote("BuyItem","Cannon")
end)

Gun_Shop_Section:AddButton("Kabucha",function()
	Use_Remote("BlackbeardReward","Slingshot","1")
	Use_Remote("BlackbeardReward","Slingshot","2")
end)

local Abilities_Shop_Tab = Tabs.Item:AddLeftTabbox()

local Abilities_Shop_Section = Abilities_Shop_Tab:AddTab('Abilities')

Abilities_Shop_Section:AddToggle('Auto_Buy_Ablility', {
    Text = 'Auto Buy Ablility',
    Default = false,
}):OnChanged(function(value)
    Auto_Buy_Ablility = value
end)

task.spawn(function()
    while wait() do
        if Auto_Buy_Ablility then
            local Beli = Local_Player.Data.Beli.Value
            local BusoCheck = false
            local SoruCheck = false
            local GeppoCheck = false
            local KenCheck = false
            if Beli >= 885000 then
                repeat wait() 
                    Use_Remote("BuyHaki","Buso")
                    BusoCheck = true
                    Use_Remote("BuyHaki","Geppo")
                    GeppoCheck = true
                    Use_Remote("BuyHaki","Soru")
                    SoruCheck = true
                    Use_Remote("KenTalk","Start")
                    Use_Remote("KenTalk","Buy")
                    KenCheck = true
                until not BusoCheck and not GeppoCheck and not SoruCheck and not KenCheck or not Auto_Buy_Ablility
            end
        end
    end
end)

Abilities_Shop_Section:AddButton("Haki",function()
	Use_Remote("BuyHaki","Buso")
end)
Abilities_Shop_Section:AddButton("Geppo",function()
	Use_Remote("BuyHaki","Geppo")
end)
Abilities_Shop_Section:AddButton("Soru",function()
	Use_Remote("BuyHaki","Soru")
end)
Abilities_Shop_Section:AddButton("KenHaki",function()
	Use_Remote("KenTalk","Buy")
end)

-- local BoneShopSection = Abilities_Shop_Tab:AddTab('Bone')

-- BoneShopSection:AddToggle('Auto Random Surprise', {
-- 	Text = 'Auto Random Surprise',
-- 	Default = _G.Settings.Main["Auto Random Bone"],

-- })

-- Toggles['Auto Random Surprise']:OnChanged(function(value)
-- 	_G.Settings.Main["Auto Random Bone"] = value
-- 	getgenv().SaveSetting()
-- end)

-- task.spawn(function()
-- 	while wait(.1) do
-- 		if _G.Settings.Main["Auto Random Bone"] then
-- 			Use_Remote("Bones","Buy",1,1)
-- 		end
-- 	end
-- end)

local Abilities_Shop_Tab = Tabs.Item:AddLeftTabbox()

local Fragment_Shop_Section = Abilities_Shop_Tab:AddTab('Fragment')

Fragment_Shop_Section:AddButton("Refund Stat",function()
	Use_Remote("BlackbeardReward","Refund","1")
	Use_Remote("BlackbeardReward","Refund","2")
end)

Fragment_Shop_Section:AddButton("Reroll Race",function()
	Use_Remote("BlackbeardReward","Reroll","1")
	Use_Remote("BlackbeardReward","Reroll","2")
end)

local Accessory_Shop_Tab = Tabs.Item:AddLeftTabbox()

local Accessory_Shop_Section = Accessory_Shop_Tab:AddTab('Accessory')

Accessory_Shop_Section:AddButton("Black Cape",function()
	Use_Remote("BuyItem","Black Cape")
end)

Accessory_Shop_Section:AddButton("Toemo Ring",function()
	Use_Remote("BuyItem","Tomoe Ring")
end)

Accessory_Shop_Section:AddButton("Swordsman Hat",function()
	Use_Remote("BuyItem","Swordsman Hat")
end)

-- local BuyAllItemSection = Accessory_Shop_Tab:AddTab('All Items')

-- BuyAllItemSection:AddButton("Buy All Items",function()
-- 	Use_Remote("BuyItem","Swordsman Hat")
-- 	print("Swordsman Hat Buy!")
-- 	Use_Remote("BuyItem","Tomoe Ring")
-- 	print("Tomoe Ring Buy!")
-- 	Use_Remote("BuyItem","Black Cape")
-- 	print("Black Cape Buy!")
-- 	Use_Remote("BlackbeardReward","Slingshot","1")
-- 	Use_Remote("BlackbeardReward","Slingshot","2")
-- 	print("Kabucha Buy!")
-- 	Use_Remote("BuyItem","Cannon")
-- 	print("Cannon Buy!")
-- 	Use_Remote("BuyItem","Refined Flintlock")
-- 	print("Refined Flintlock Buy!")
-- 	Use_Remote("BuyItem","Flintlock")
-- 	print("Flintlock Buy!")
-- 	Use_Remote("BuyItem","Musket")
-- 	print("Musket Buy!")
-- 	Use_Remote("BuyItem","Slingshot")
-- 	print("Slingshot Buy!")
-- 	Use_Remote("BuyItem","Soul Cane")
-- 	print("Soul Cane Buy!")
-- 	Use_Remote("BuyItem","Bisento")
-- 	print("Bisento Buy!")
-- 	Use_Remote("BuyItem","Dual-Headed Blade")
-- 	print("Dual-Headed Blade Buy!")
-- 	Use_Remote("BuyItem","Pipe")
-- 	print("Pipe Buy!")
-- 	Use_Remote("BuyItem","Triple Katana")
-- 	print("Triple Katana Buy!")
-- 	Use_Remote("BuyItem","Iron Mace")
-- 	print("Iron Mace Buy!")
-- 	Use_Remote("BuyItem","Duel Katana")
-- 	print("Duel Katana Buy!")
-- 	Use_Remote("BuyItem","Cutlass")
-- 	print("Cutlass Buy!")
-- 	Use_Remote("BuyItem","Katana")
-- 	print("Katana Buy!")
-- 	Use_Remote("KenTalk","Buy")
-- 	print("Ken Buy!")
-- 	Use_Remote("BuyHaki","Soru")
-- 	print("Soru Buy!")
-- 	Use_Remote("BuyHaki","Geppo")
-- 	print("Geppo Buy!")
-- 	Use_Remote("BuyHaki","Buso")
-- 	print("Buso Buy!")
-- end)
