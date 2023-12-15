repeat wait() until game:IsLoaded()

local Player = game.Players
local Local_Player = Player.LocalPlayer

repeat wait() until Local_Player
repeat wait() until Local_Player.Character

repeat wait()
    pcall(function()
        if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main").ChooseTeam.Visible then
            if Team == "Pirate" then
                for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                    v.Function()
                end
            elseif Team == "Marine" then
                for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                    v.Function()
                end
            else
                for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                    v.Function()
                end
            end
        end
    end)
until Local_Player.Team

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

local network = loadstring(game:HttpGet('https://raw.githubusercontent.com/hajibeza/File/main/Network.lua'))()

FirstSea = game.PlaceId == 2753915549
SecondSea = game.PlaceId == 4442272183
ThirdSea = game.PlaceId == 7449423635
SeaIndex = ThirdSea and 3 or SecondSea and 2 or FirstSea and 1 or Local_Player:Kick("Didn't update this Sea")

local Camera = require(game.ReplicatedStorage.Util.CameraShaker)
Camera:Stop()

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

if syn then
	Request_Var = syn.request
else
    Request_Var = request 
end

local res = Request_Var({
    Url = "https://httpbin.org/get",
    Method = "GET"
}).Body;

function Current_Exploit(Exploit)
    local decode = game:GetService('HttpService'):JSONDecode(res)
    if decode.headers['User-Agent'] == Exploit then
        return true
    end
end

local function tprint (tbl, indent)
    if not indent then
        indent = 0
    end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    return toprint
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

dist = function(a,b,noHeight)
    if not b then
        b = Local_Player.Character.HumanoidRootPart.Position
    end
    return (Vector3.new(a.X,not noHeight and a.Y,a.Z) - Vector3.new(b.X,not noHeight and b.Y,b.Z)).magnitude
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

function toTarget(...)
    local target = ...
    local tarPos = ...
    pcall(function()
        if Teleport_Island then
            local Dista,distm,middle = dist(target,nil,true),1/0
            if Local_Player.Character and Local_Player.Character.HumanoidRootPart and Dista >= 2000 and tick() - recentlySpawn > 5 then
                for i,v in pairs(CanTeleport[SeaIndex]) do
                    local distance = dist(v,target,true)
                    if distance < dist(target,nil,true) and distance < distm then
                        distm,middle = distance,v
                    end
                end
                if middle and InArea(Local_Player.Character.HumanoidRootPart.Position) ~= InArea(middle) then
                    -- print(Root.Position,"\n",target.p)
                    -- print(Dista,distm,CurrentArea,InArea(middle))
                    Use_Remote("requestEntrance",middle)
                end
            end
        end
                    -- if not disableIslandSkip and Bypass_Tp then
            --     if Local_Player.Character.HumanoidRootPart then
            --         local Area = InArea(target.p)
            --         local MyArea = InArea(Local_Player.Character.HumanoidRootPart.Position)
            --         local SpawnPoint = workspace["_WorldOrigin"].PlayerSpawns[Local_Player.Team.Name]:GetChildren()
            --         local dista,distm,charDist,nearest = 2000,9000
            --         for i,v in pairs(SpawnPoint) do
            --             local Position = v:GetPivot().p
            --             local distance = dist(target.p,Position,true)
            --             if distance <= dista then
            --                 charDist = dist(Position,nil,true)
            --                 dista,nearest = distance,v
            --             end
            --         end
            --         if nearest and (charDist <= 8700) then
            --             if not Local_Player.Character:FindFirstChild("Humanoid") then return end
            --             if not Local_Player.Character:FindFirstChild("HumanoidRootPart") then return end
            --             if Local_Player.Character.HumanoidRootPart:FindFirstChild("Died") then
            --                 Local_Player.Character.HumanoidRootPart.Died:Destroy()
            --             end
            --             repeat wait()
            --                 pcall(task.spawn,Use_Remote,"SetLastSpawnPoint",nearest.Name)
            --             until Local_Player.Data.LastSpawnPoint.Value == nearest.Name
            --             pcall(function()
            --                 if Current_Exploit("Fluxus") or Current_Exploit("Comat") or IsValyse then
            --                     Local_Player.Character.Humanoid:ChangeState(15)
            --                 else
            --                     Local_Player.Character.HumanoidRootPart:Destroy()
            --                 end
            --             end)
            --             repeat wait(.1) until Local_Player.Character.HumanoidRootPart.Parent
            --         end
            --     end
            -- end
    end)
    if currentThread then
        currentThread:Disconnect()
        currentThread = nil
    end
    local distance = 6
    local notMagnitude = (tarPos.Position - Local_Player.Character.PrimaryPart.Position)
    if notMagnitude.Magnitude < 300 then Local_Player.Character:SetPrimaryPartCFrame(tarPos) return; end
    local direction = notMagnitude.Unit
    local Steps_Num = math.ceil(notMagnitude.Magnitude / distance)
    local Steps_Tween = notMagnitude.Magnitude / Steps_Num
    local currentCFrame = Local_Player.Character.PrimaryPart.CFrame
    local currentStep = 1
    currentThread = game:GetService("RunService").Heartbeat:Connect(function()
        if currentStep < Steps_Num and Local_Player.Character.Humanoid.Health > 0 then
            pcall(function()
                local nextPosition = currentCFrame.Position + direction * Steps_Tween
                local nextCFrame = CFrame.new(nextPosition, tarPos.LookVector)
                Local_Player.Character:SetPrimaryPartCFrame(nextCFrame)
                currentCFrame = nextCFrame
                currentStep = currentStep + 1
            end)
        else
            currentThread:Disconnect()
            currentThread = nil
        end
    end)
end

function Equip_Tool(Tool)
    if Local_Player.Backpack:FindFirstChild(Tool) then 
        local ToolHumanoid = Local_Player.Backpack:FindFirstChild(Tool) 
        Local_Player.Character.Humanoid:EquipTool(ToolHumanoid) 
    end
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

function Noclip(Value)
    if not Value or Value == false then
        if Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            Local_Player.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy();
        end
    end
    if Value then
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
    end
end

function Auto_Buso()
    if not Local_Player.Character:FindFirstChild("HasBuso") then
        Use_Remote("Buso")
	end 
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

function Check_Mastery_Melee(Melee_Name,Mastery_Value)
	if Local_Player.Backpack:FindFirstChild(Melee_Name) then
		if  Local_Player.Backpack:FindFirstChild(Melee_Name).Level.Value >= Mastery_Value then
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

function Check_Tool_Inventory(Tool_Name)
    if Local_Player.Backpack:FindFirstChild(Tool_Name) or Local_Player.Character:FindFirstChild(Tool_Name) then
        return true
    end
    return false
end

function Check_Near_Mon(Monster)
    local Table_Monster = Monster
    if type(Monster) == "string" then Table_Monster = {Monster} end
    for i,v in pairs(workspace.Enemies:GetChildren()) do
        if table.find(Table_Monster,v.Name) then
            return v
        end
    end
    return nil
end

function Check_Replicate_Mon(Replicate_Monster)
    local Table_Replicate_Monster = Replicate_Monster
    if type(Replicate_Monster) == "string" then Table_Replicate_Monster = {Replicate_Monster} end
    for i,v in pairs(game.ReplicatedStorage:GetChildren()) do
        if table.find(Table_Replicate_Monster,v.Name) then
            return v
        end
    end
    return nil
end

function Farm:Level()
    local MyLevel = Local_Player.Data.Level.Value

    Noclip(true)

    if not Local_Player.PlayerGui.Main.Quest.Visible then 
        if Double_Quest then 
            Level , Data = QuestManager:GetQuest()  
            if not QuestManager.DataData[Level].Used then 
                QuestManager.DataData[Level].Used = true 
            end
            if MyLevel > 10 then repeat wait(.1) toTarget(Data[Level].CFrameQuest) until (Local_Player.Character.HumanoidRootPart.Position - Data[Level].CFrameQuest.Position).Magnitude <= 3 or not Auto_Farm_Level end
            wait(.5)
            if Auto_Farm_Level then Use_Remote("StartQuest",Data[Level].NameQuest,Data[Level].NumberQuest) end
            wait(.5)
        else
            Level , Data = QuestManager:GetQuest()  
            if MyLevel > 10 then repeat wait(.1) toTarget(Data[Level].CFrameQuest) until (Local_Player.Character.HumanoidRootPart.Position - Data[Level].CFrameQuest.Position).Magnitude <= 3 or not Auto_Farm_Level end
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
                    toTarget(v.CFrame * CFrame.new(0,30,0))
                until Check_Near_Mon(Data[Level].Mon) or (v.CFrame.Position - Local_Player.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= 70
            end
        end
    end

    if not Data[Level].Mon or (not Data[Level].CFrameMon and not Check_Near_Mon(Data[Level].Mon)) then return end 

    if Check_Near_Mon(Data[Level].Mon) then 
        for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == Data[Level].Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then 
                repeat task.wait(0.02)
                    Equip_Tool(Current_Weapon)
                    BringMob(v.HumanoidRootPart.CFrame,v.Name)
                    v.HumanoidRootPart.CanCollide = false
                    toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                until not Auto_Farm_Level or not v or v.Humanoid.Health <= 0 or not Local_Player.PlayerGui.Main.Quest.Visible
            end
        end
    end
end

function Farm:FastMon()
    local Fast_Mon_Module = Check_Near_Mon("God's Guard")

    Noclip(true)

    if not Fast_Mon_Module then
        for i,v in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
            if v.Name == "God's Guard" or v.Name:match("God's Guard") then 
                repeat task.wait(.1)  
                    if not Auto_Farm_Level or Fast_Mon_Module then break end
                    toTarget(v.CFrame * CFrame.new(0,30,0))
                until Fast_Mon_Module or (v.CFrame.Position - Local_Player.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= 70
            end
        end
    end

    if Fast_Mon_Module then 
        for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == "God's Guard [Lv. 450]" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then 
                repeat task.wait(0.02)
                    Equip_Tool(Current_Weapon)
                    BringMob(v.HumanoidRootPart.CFrame,v.Name)
                    v.HumanoidRootPart.CanCollide = false
                    toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                until not Auto_Farm_Level or not v or v.Humanoid.Health <= 0
            end
        end
    end
end

task.spawn(function()
    AvailablePlayer = {}
    if not FirstSea then return end
    while wait(.75) do
        if Auto_Farm_Level and Local_Player.Data.Level.Value > 20 and Local_Player.Data.Level.Value < 300 then
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

function Farm:KillPlayer()

    if not tostring(Use_Remote("PlayerHunter")):find("We heard some") then return self:FastAutoFarmMon() end

    Noclip(true)

    for i,v in pairs(AvailablePlayer) do
        if not Local_Player.PlayerGui.Main.Quest.Visible then
            repeat task.wait(.1) 
                Use_Remote("PlayerHunter")
            until string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,i)
        end

        if Local_Player.PlayerGui.Main.Quest.Visible then
            if string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,i) then
                repeat task.wait(0.02)
                    if Local_Player.PlayerGui.Main.PvpDisabled.Visible then
                        Use_Remote("EnablePvp")
                    end
                    print("Kill",i)
                    Equip_Tool(Current_Weapon)
                    toTarget(workspace.Characters[i].HumanoidRootPart.CFrame * CFrame.new(0,0,10))
                until Local_Player.PlayerGui.Main.SafeZone.Visible or not string.find(Local_Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,i) or not Auto_Farm_Level
                Use_Remote("AbandonQuest")
            end
        end
    end
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
        return 0
    end
end

function Farm:CakePrince()
    local Remote_Cake_Prince = Use_Remote("CakePrinceSpawner")
    local Cake_Boss = "Cake Prince [Raid Boss]"
    local Check_Near_Cake_Boss,Check_Replicate_Cake_Boss = Check_Near_Mon(Cake_Boss),Check_Replicate_Mon(Cake_Boss)

    Noclip(true)

    if string.find(Remote_Cake_Prince,"Do you want to open") then Use_Remote("CakePrinceSpawner") end
    
    if Check_Replicate_Cake_Boss and not Check_Near_Cake_Boss then
        repeat task.wait(.1)
            toTarget(game:GetService("ReplicatedStorage"):FindFirstChild(Cake_Boss).HumanoidRootPart.CFrame)
        until Check_Near_Cake_Boss or not Auto_Cake_Prince
    end

    if Check_Near_Cake_Boss then
        for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v.Name == Cake_Boss and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                repeat task.wait(0.02)
                    Equip_Tool(Current_Weapon)
                    BringMob(v.HumanoidRootPart.CFrame,v.Name)
                    v.HumanoidRootPart.CanCollide = false
                    toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                until not Check_Near_Cake_Boss or not v or v.Humanoid.Health <= 0
            end
        end
    end

    if not Check_Near_Cake_Boss and not Check_Replicate_Cake_Boss then
        local Cake_Monster = {"Baking Staff","Head Baker","Cake Guard","Cookie Crafter"}
        local Check_Near_Cake_Monster = Check_Near_Mon(Cake_Monster)

        if not Check_Near_Cake_Monster then 
            repeat task.wait(.1)
                local Check_Near_Cake_Monster = Check_Near_Mon(Cake_Monster)
                toTarget(CFrame.new(-2037.00171, 57.8413582, -12550.6748, 1, 0, 0, 0, 1, 0, 0, 0, 1))
            until Check_Near_Cake_Boss or Check_Replicate_Cake_Boss or Check_Near_Cake_Monster or not Auto_Cake_Prince
        end

        if Check_Near_Cake_Monster then
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                if table.find(Cake_Monster,v.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    repeat task.wait(0.02)
                        Equip_Tool(Current_Weapon)
                        BringMob(v.HumanoidRootPart.CFrame,v.Name)
                        v.HumanoidRootPart.CanCollide = false
                        toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                    until Check_Near_Cake_Boss or Check_Replicate_Cake_Boss or not Check_Near_Cake_Monster or not Auto_Cake_Prince or not v or v.Humanoid.Health <= 0
                end
            end
        end
    end
end

-- function Farm:Mastery_Weapon()
--     if FirstSea then
--         Mon = {"Galley Captain","Galley Pirate"}
--     elseif SecondSea then
--         Mon = {"Water Fighter","Sea Soldier"}
--     elseif ThirdSea then
--         Mon = {"Snow Demon","Candy Pirate"}
--     end

--     if ThirdSea then return Farm:CakePrince() end

--     local Check_Mob_Mastery = Check_Near_Mon(Match_Mon(Mon))
--     print("Mastery")
--     print(Check_Mob_Mastery)

--     if not Check_Mob_Mastery then
--         for i,v in pairs(workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
--             if v.Name == Mon or v.Name:match(Mon) then 
--                 repeat task.wait(.1) 
--                     if Check_Mob_Mastery then break end
--                     toTarget(v.CFrame * CFrame.new(0,30,0))
--                 until Check_Mob_Mastery or (v.CFrame.Position - Local_Player.Character:WaitForChild("HumanoidRootPart").Position).magnitude <= 70
--             end
--         end
--     end

--     if Check_Mob_Mastery then
--         for i,v in pairs(workspace.Enemies:GetChildren()) do
--             if v.Name == Match_Mon().Name and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
--                 repeat task.wait(0.02)
--                     Noclip(true)
--                     Equip_Tool(Current_Weapon)
--                     BringMob(v.HumanoidRootPart.CFrame,v.Name)
--                     v.HumanoidRootPart.CanCollide = false
--                     toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
--                 until not v or v.Humanoid.Health <= 0
--             end
--         end
--     end
-- end

----------------------------------------------Main 

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RIPPER HUB | [V4]",
   LoadingTitle = "Loading Resource",
   LoadingSubtitle = "UI by Rayfield",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RIPPER HUB [V4]",
      FileName = Local_Player.Name.."_Blox Fruit"
   },
   Discord = {
      Enabled = true,
      Invite = "vERu37nMKu",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "RIPPER HUB",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Free To Use"} 
   }
})

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

setscriptable(Local_Player,"SimulationRadius",true)
spawn(function()
    while game:GetService("RunService").Stepped:Wait() do
        Local_Player.SimulationRadius = math.huge
    end
end)
 
local MainTab = Window:CreateTab("Main", 7040391851)
local PlayerTab = Window:CreateTab("Player", 5012544693)

local MainSection = MainTab:CreateSection("Main Farm")

MainTab:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Flag = "Auto Farm Level",
    Callback = function(value)
        Auto_Farm_Level = value
        Auto_Farm_Level_Other = value
        Noclip(false)
   end,
})

spawn(function()
   while wait(.1) do
        pcall(function()
            if Auto_Farm_Level then
                local MyLevel = Local_Player.Data.Level.Value 
                if MyLevel >= 21 and MyLevel < 50 then
                    Farm:FastMon()
                end
                if MyLevel >= 50 and MyLevel < 300 then
                    Farm:KillPlayer()
                end
                if MyLevel <= 20 or MyLevel > 300 then 
                    Farm:Level()
                end
            end
        end)
    end
end)

MainTab:CreateToggle({
    Name = "Server Hop",
    CurrentValue = false,
    Flag = "Server Hop",
    Callback = function(value)
        Enable_Server_Hop = value
        Noclip(false)
   end,
})

if FirstSea then
    MainTab:CreateToggle({
        Name = "Auto Second World",
        CurrentValue = false,
        Flag = "Auto Second World",
        Callback = function(value)
            Auto_Second_World = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Second_World then
                    local Remote = Use_Remote("DressrosaQuestProgress")
                    local MyLevel = Local_Player.Data.Level.Value 

                    Noclip(true)

                    if Remote.KilledIceBoss then return end
                    if not FirstSea then return end
                    if Auto_Farm_Level and MyLevel >= 700 and FirstSea then Auto_Farm_Level = false end

                    if not Remote.TalkedDetective then
                        repeat task.wait(.1) 
                            Use_Remote("DressrosaQuestProgress","Detective")
                        until Check_Tool_Inventory("Key") or not Auto_Second_World
                    end
                    
                    if not Remote.UsedKey then
                        repeat task.wait(.1) 
                            Use_Remote("DressrosaQuestProgress","UseKey")
                        until not Check_Tool_Inventory("Key") or not Auto_Second_World
                    end

                    if Remote.KilledIceBoss then
                        Use_Remote("TravelDressrosa")
                    end

                    if not Remote.KilledIceBoss and Remote.UsedKey then
                        Check_Boss_Ice = Check_Near_Mon("Ice Admiral [Lv. 700] [Boss]")

                        if not Check_Boss_Ice then
                            repeat task.wait(.1)
                                toTarget(game:GetService("ReplicatedStorage"):FindFirstChild("Ice Admiral [Lv. 700] [Boss]").HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                            until Check_Boss_Ice or not Auto_Second_World
                        end

                        if Check_Boss_Ice then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == "Ice Admiral [Lv. 700] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    repeat task.wait(0.02)
                                        Equip_Tool(Current_Weapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                    until not Auto_Second_World or not v or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

end

if SecondSea then
    MainTab:CreateToggle({
        Name = "Auto Third World",
        CurrentValue = false,  
        Flag = "Auto Third World",
        Callback = function(value)
            Auto_Third_World = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Third_World then
                    if not SecondSea then return end
                    local Remote_Rip = Use_Remote("ZQuestProgress")
                    local Remote_Check_Rip = Use_Remote("ZQuestProgress","Check")
                    local Remote_Swan = Use_Remote("GetUnlockables")

                    Noclip(true)

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
                            local Check_Boss_Swan,Check_Replicate_Swan = Check_Near_Mon("Don Swan [Lv. 1000] [Boss]"),Check_Replicate_Mon("Don Swan [Lv. 1000] [Boss]")
                            
                            if not Check_Boss_Swan and not Check_Replicate_Swan and Enable_Server_Hop then
                                Server_Hop("Finding Don Swan")
                            end

                            if not Check_Boss_Swan then
                                repeat task.wait(.1)
                                    toTarget(game:GetService("ReplicatedStorage")["Don Swan [Lv. 1000] [Boss]"].HumanoidRootPart.CFrame)
                                until Check_Boss_Swan or not Auto_Third_World
                            end

                            if Check_Boss_Swan then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == "Don Swan [Lv. 1000] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                        repeat task.wait(0.02)
                                            Equip_Tool(Current_Weapon)
                                            v.HumanoidRootPart.CanCollide = false
                                            toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                        until Check_Boss_Swan or not v or v.Humanoid.Health <= 0 or not Auto_Third_World
                                    end
                                end
                            end
                        end

                        if Remote_Check_Rip then
                            local Check_Boss_Rip,Check_Replicate_Rip = Check_Near_Mon("rip_indra [Lv. 1500] [Boss]"),Check_Replicate_Mon("rip_indra [Lv. 1500] [Boss]")
                            
                            if not Check_Boss_Rip and not Check_Replicate_Rip and Enable_Server_Hop then
                                Server_Hop("Finding Rip_Indra")
                            end

                            if not Check_Boss_Rip then
                                repeat task.wait(.1)
                                    toTarget(game:GetService("ReplicatedStorage")["rip_indra [Lv. 1500] [Boss]"].HumanoidRootPart.CFrame)
                                until Check_Boss_Rip or not Auto_Third_World
                            end

                            if Check_Boss_Rip then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == "rip_indra [Lv. 1500] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                        repeat task.wait(0.02)
                                            Equip_Tool(Current_Weapon)
                                            v.HumanoidRootPart.CanCollide = false
                                            toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                        until not Auto_Third_World or not v or v.Humanoid.Health <= 0
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

local MaterialSection = MainTab:CreateSection("Material")



if ThirdSea then
    local CakePrinceSection = MainTab:CreateSection("Cake Prince")

    MainTab:CreateToggle({
        Name = "Auto Cake Prince",
        CurrentValue = false,
        Flag = "Auto Cake Prince",
        Callback = function(value)
            Auto_Cake_Prince = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Cake_Prince then Farm:CakePrince() end
            end)
        end
    end)

end

local OtherSection = MainTab:CreateSection("Other Farm")

if FirstSea then

    MainTab:CreateToggle({
        Name = "Auto Saber",
        CurrentValue = false,
        Flag = "Auto Saber",
        Callback = function(value)
            Auto_Saber = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do 
            pcall(function()
                if Auto_Saber then
                    local Remote_Check_Saber = Use_Remote("ProQuestProgress")
                    local QuestPlates_Folder = workspace.Map.Jungle.QuestPlates

                    Noclip(true)

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
                            repeat wait() Use_Remote("ProQuestProgress","GetTorch") until Local_Player.Backpack:FindFirstChild("Torch") 
                            repeat wait() Use_Remote("ProQuestProgress","DestroyTorch") until not Local_Player.Backpack:FindFirstChild("Torch")
                        end

                        if Remote_Check_Saber.UsedTorch and not Remote_Check_Saber.UsedCup then
                            repeat wait() Use_Remote("ProQuestProgress","GetCup") until Local_Player.Backpack:FindFirstChild("Cup")
                            repeat wait() Use_Remote("ProQuestProgress","FillCup",Local_Player.Backpack.Cup) Use_Remote("ProQuestProgress","SickMan") until not Local_Player.Backpack:FindFirstChild("Cup")
                        end

                        if Remote_Check_Saber.UsedCup and not Remote_Check_Saber.TalkedSon then
                            Use_Remote("ProQuestProgress","RichSon")
                        end

                        if Remote_Check_Saber.TalkedSon and not Remote_Check_Saber.KilledMob then
                            local Mon_Leader = "Mob Leader [Lv. 120] [Boss]"
                            local Check_Near_Mob_Leader = Check_Near_Mon(Mon_Leader)

                            if not Check_Near_Mob_Leader then
                                repeat task.wait(.1)
                                    toTarget(game:GetService("ReplicatedStorage")[Mon_Leader].HumanoidRootPart.CFrame)
                                until Check_Near_Mob_Leader or not Auto_Saber
                            end

                            if Check_Near_Mob_Leader then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Mon_Leader and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                        repeat task.wait(0.02)
                                            Equip_Tool(Current_Weapon)
                                            v.HumanoidRootPart.CanCollide = false
                                            toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                        until not Check_Near_Mob_Leader or Remote_Check_Saber.KilledMob or not v or v.Humanoid.Health <= 0 or not Auto_Saber
                                    end
                                end
                            end
                        end

                        if Remote_Check_Saber.KilledMob and not Remote_Check_Saber.UsedRelic then
                            repeat wait() Use_Remote("ProQuestProgress","RichSon") until Local_Player.Backpack:FindFirstChild("Relic")
                            repeat wait() Use_Remote("ProQuestProgress","PlaceRelic") until not Local_Player.Backpack:FindFirstChild("Relic")
                        end

                        if Remote_Check_Saber.UsedRelic and not Remote_Check_Saber.KilledShanks then
                            local Saber_Expert = "Saber Expert [Lv. 200] [Boss]"
                            local Check_Near_Saber_Expert = Check_Near_Mon(Saber_Expert)

                            if not Check_Near_Saber_Expert then
                                repeat task.wait(.1)
                                    toTarget(game:GetService("ReplicatedStorage")[Saber_Expert].HumanoidRootPart.CFrame)
                                until Check_Near_Saber_Expert or not Auto_Saber
                            end

                            if Check_Near_Saber_Expert then
                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v.Name == Saber_Expert and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                        repeat task.wait(0.02)
                                            Equip_Tool(Current_Weapon)
                                            v.HumanoidRootPart.CanCollide = false
                                            toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                        until not Check_Near_Saber_Expert or Remote_Check_Saber.KilledMob or not v or v.Humanoid.Health <= 0 or not Auto_Saber
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

    MainTab:CreateToggle({
        Name = "Auto Pole",
        CurrentValue = false,
        Flag = "Auto Pole",
        Callback = function(value)
            Auto_Pole = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Pole then

                    if Check_Any_Remote("Pole (1st Form)") then return end
                    if not FirstSea then return end

                    Noclip(true)

                    local Thunder_God = "Thunder God [Lv. 575] [Boss]"
                    local Check_Near_Thunder_God,Check_Replicate_Thunder_God = Check_Near_Mon(Thunder_God),Check_Replicate_Mon(Thunder_God)
                   
                    if not Check_Near_Thunder_God and not Check_Replicate_Thunder_God and Enable_Server_Hop then
                        Server_Hop("Finding Thunder God")
                    end

                    if not Check_Near_Thunder_God then
                        repeat task.wait(.1)
                            toTarget(game:GetService("ReplicatedStorage")[Thunder_God].HumanoidRootPart.CFrame)
                        until Check_Near_Thunder_God or not Auto_Pole
                    end

                    if Check_Near_Thunder_God then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Thunder_God and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                repeat task.wait(0.02)
                                    Equip_Tool(Current_Weapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                until not Check_Near_Thunder_God or Check_Any_Remote("Pole (1st Form)") or not v or v.Humanoid.Health <= 0 or not Auto_Saber
                            end
                        end
                    end
                end
            end)
        end
    end)

elseif SecondSea then
    
    MainTab:CreateToggle({
        Name = "Auto Factory",
        CurrentValue = false,
        Flag = "Auto Factory",
        Callback = function(value)
            Auto_Factory = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Factory then
                    local Factory = "Core"
                    local Check_Near_Factory,Check_Replicate_Factory = Check_Near_Mon(Factory),Check_Replicate_Mon(Factory)
                    
                    Noclip(true)

                    if not Check_Near_Factory and not Check_Replicate_Factory and Enable_Server_Hop then    
                        Server_Hop("Finding Factory")
                    end

                    if not Check_Near_Factory then
                        repeat task.wait(.1)
                            toTarget(game:GetService("ReplicatedStorage")[Factory].HumanoidRootPart.CFrame)
                        until Check_Near_Factory or not Auto_Factory
                    end

                    if Check_Near_Factory then
                        for i,v in pairs(workspace.Enemies:GetChildren()) do
                            if v.Name == Factory and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                repeat task.wait(0.02)
                                    Equip_Tool(Current_Weapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                until not Check_Near_Factory or not v or v.Humanoid.Health <= 0 or not Auto_Factory
                            end
                        end
                    end
                end
            end)
        end
    end)

    MainTab:CreateToggle({
        Name = "Auto Rengoku",
        CurrentValue = false,
        Flag = "Auto Rengoku",
        Callback = function(value)
            Auto_Rengoku = value
            Noclip(false)
        end,
    })

    spawn(function()
        while wait(.1) do
            pcall(function()
                if Auto_Rengoku then
                    local Remote_Rengoku = Use_Remote("OpenRengoku")

                    Noclip(true)

                    if Remote_Rengoku then return end
                    
                    if Local_Player.Backpack:FindFirstChild("Hidden Key") then
                        repeat wait()
                            Use_Remote("OpenRengoku")
                        until not Local_Player.Backpack:FindFirstChild("Hidden Key")
                    end

                    if not Local_Player.Backpack:FindFirstChild("Hidden Key") then
                        local Rengoku_Mon = {"Snow Lurker [Lv. 1375]","Arctic Warrior [Lv. 1350]"}
                        local Check_Near_Rengoku_Mon = Check_Near_Mon(Rengoku_Mon)

                        if not Check_Near_Rengoku_Mon then
                            
                        end

                        if Check_Near_Rengoku_Mon then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if table.find(Rengoku_Mon,v.Name) and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then 
                                    repeat task.wait(0.02)
                                        Equip_Tool(Current_Weapon)
                                        BringMob(v.HumanoidRootPart.CFrame,v.Name)
                                        v.HumanoidRootPart.CanCollide = false
                                        toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                    until not Check_Near_Rengoku_Mon or not Auto_Rengoku or Local_Player.Backpack:FindFirstChild("Hidden Key") or not v or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

end

local FightingStyleSection = MainTab:CreateSection("Fighting Style")

MainTab:CreateToggle({
    Name = "Auto Superhuman",
    CurrentValue = false,
    Flag = "Auto Superhuman",
    Callback = function(value)
        Auto_Superhuman = value
        Noclip(false)
    end,
})

spawn(function()
    while wait(.5) do
        pcall(function()
            if Auto_Superhuman then
                if Check_Mastery_Melee("Combat",1) and Local_Player.Data.Beli.Value >= 150000 then
                    Use_Remote("BuyBlackLeg")
                end

                if Check_Mastery_Melee("Black Leg",300) then
                    Use_Remote("BuyElectro")
                end

                if Check_Mastery_Melee("Electro",300) then
                    Use_Remote("BuyFishmanKarate")
                end 

                if Check_Mastery_Melee("Fishman Karate") then
                    if Local_Player.Data.Level.Value > 1100 and Local_Player.Data.Fragments.Value < 1500 and Auto_Fully_Superhuman then
                        --Raid
                    end
                    Use_Remote("BlackbeardReward","DragonClaw","1")
                    Use_Remote("BlackbeardReward","DragonClaw","2")
                end

                if Check_Mastery_Melee("Dragon Claw",300) then
                    Use_Remote("BuySuperhuman")
                end
            end
        end)
    end
end)

MainTab:CreateToggle({
    Name = "Auto Death Step",
    CurrentValue = false,
    Flag = "Auto Death Step",
    Callback = function(value)
        Auto_Death_Step = value
        Noclip(false)
    end,
})

spawn(function()
    while wait(.1) do
        pcall(function()
            if Auto_Death_Step then
                Remote_Death_Step = Use_Remote("OpenLibrary")

                if not Check_Tool_Inventory("Black Leg") then Use_Remote("BuyBlackLeg") end
                if Remote_Death_Step and Check_Mastery_Melee("Black Leg",400) then Use_Remote("BuyDeathStep") end

                Noclip(true)

                if not Remote_Death_Step then

                    if Check_Tool_Inventory("Library Key") then Use_Remote("BuyDeathStep",true) end

                    if not Check_Tool_Inventory("Library Key") then
                        local Check_Boss_Ice,Check_Replicate_Ice = Check_Near_Mon("Awakened Ice Admiral"),Check_Replicate_Mon("Awakened Ice Admiral")
                        
                        if not Check_Boss_Ice and not Check_Replicate_Ice and Enable_Server_Hop then
                            Server_Hop("Auto Death Step")
                        end

                        if not Check_Boss_Ice then
                            repeat task.wait(.1)
                                toTarget(game:GetService("ReplicatedStorage")["Awakened Ice Admiral"].HumdwanoidRootPart.CFrame)
                            until Check_Boss_Tide or not Auto_Death_Step
                        end

                        if Check_Boss_Ice then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == "Awakened Ice Admiral" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    repeat task.wait(0.02)
                                        Equip_Tool(Current_Weapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                    until not Check_Boss_Ice or Check_Tool_Inventory("Library Key") or not Auto_Death_Step or not v or v.Humanoid.Health <= 0 
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

MainTab:CreateToggle({
    Name = "Auto SharkMan Karate",
    CurrentValue = false,
    Flag = "Auto SharkMan Karate",
    Callback = function(value)
        Auto_SharkMan_Karate = value
        Noclip(false)
    end,
})

spawn(function()
    while wait(.1) do
        pcall(function()
            if Auto_SharkMan_Karate then
                Remote_Sharkman = Use_Remote("BuySharkmanKarate",true)
                
                Noclip(true)

                if not Check_Tool_Inventory("Fishman Karate") then Use_Remote("BuyFishmanKarate") end
                if not string.find(Remote_Sharkman,"I lost") then Use_Remote("BuySharkmanKarate") end

                if string.find(Remote_Sharkman,"I lost") then

                    if Check_Tool_Inventory("Water Key") then Use_Remote("BuySharkmanKarate",true) end

                    if not Check_Tool_Inventory("Water Key") then
                        local Check_Boss_Tide,Check_Boss_Tide_Replic = Check_Near_Mon("Tide Keeper [Lv. 1475] [Boss]"),Check_Replicate_Mon("Tide Keeper [Lv. 1475] [Boss]")
                        
                        if not Check_Boss_Tide and not Check_Boss_Tide_Replic and Enable_Server_Hop then
                            Server_Hop("Auto SharkMan Karate")
                        end

                        if not Check_Boss_Tide then
                            repeat task.wait(.1)
                                toTarget(game:GetService("ReplicatedStorage")["Tide Keeper [Lv. 1475] [Boss]"].HumanoidRootPart.CFrame)
                            until Check_Boss_Tide or not Auto_SharkMan_Karate
                        end

                        if Check_Boss_Tide then
                            for i,v in pairs(workspace.Enemies:GetChildren()) do
                                if v.Name == "Tide Keeper [Lv. 1475] [Boss]" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                    repeat task.wait(0.02)
                                        Equip_Tool(Current_Weapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                    until not Check_Boss_Tide or Check_Tool_Inventory("Water Key") or not v or v.Humanoid.Health <= 0 or not Auto_SharkMan_Karate
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local SettingSection = MainTab:CreateSection("Setting")

local Dropdown = MainTab:CreateDropdown({
    Name = "TypeWeapon",
    Options = {"Melee","Sword","Devil Fruit"},
    CurrentOption = {"nil"},
    MultipleOptions = false,
    Flag = "Weapon",
    Callback = function(value)
        Weapon = value
        print(value)
        for i,v in pairs(Weapon) do
            print(v)
            TypeWeapon = v
        end
    end,
})

spawn(function()
    while wait(.5) do
        pcall(function()
            for i ,v in pairs(Local_Player.Backpack:GetChildren()) do
                if TypeWeapon == "Melee" then 
                    if  v.ToolTip == "Melee" then
                        if Local_Player.Backpack:FindFirstChild(tostring(v.Name)) then
                            Current_Weapon = v.Name
                        end
                    end
                elseif TypeWeapon == "Sword" then
                     if v.ToolTip == "Sword" then
                        if Local_Player.Backpack:FindFirstChild(tostring(v.Name)) then
                            Currenlt_Weapon = v.Name
                        end
                    end
                elseif TypeWeapon == "Devil Fruit" then 
                    if v.ToolTip == "Blox Fruit" then
                        if Local_Player.Backpack:FindFirstChild(tostring(v.Name)) then
                            Current_Weapon = v.Name
                        end
                    end
                end
            end
        end)
    end
end)

MainTab:CreateToggle({
    Name = "Double Quest",
    CurrentValue = false,
    Flag = "Double Quest",
    Callback = function(value)
        Double_Quest = value
   end,
})

MainTab:CreateToggle({
    Name = "Auto Buso",
    CurrentValue = false,
    Flag = "Auto Buso",
    Callback = function(value)
        Auto_Haki = value
        while wait(.5) do
            if Auto_Haki then
                Auto_Buso()
            end
        end
   end,
})

MainTab:CreateToggle({
    Name = "Teleport Island",
    CurrentValue = false,
    Flag = "Teleport Island",
    Callback = function(value)
        Teleport_Island = value
   end,
})

MainTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = false,
    Flag = "Fast Attack",
    Callback = function(value)
        NeedAttacking = value
        NewFastAttack = value
        NoAttackAnimation = value
   end,
})

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
            local Players = Player:GetPlayers()
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
        if #canHits > 0 then
            Controller = Data.activeController
            if NormalClick then
                pcall(task.spawn,Controller.attack,Controller)
                continue
            end
            if Controller and Controller.equipped and (not Local_Player.Character.Busy.Value or Local_Player.PlayerGui.Main.Dialogue.Visible) and Local_Player.Character.Stun.Value < 1 and Controller.currentWeaponModel then
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

MainTab:CreateButton({
    Name = "Redeem All Code",
    Callback = function()
        for i,v in pairs(Code) do
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v)
        end
    end,
})

local StatsSection = PlayerTab:CreateSection("Stats")

PlayerTab:CreateDropdown({
    Name = "Stats",
    Options = {"Melee","Defense","Sword","Gun","Demon Fruit"},
    CurrentOption = {"nil"},
    MultipleOptions = true,
    Flag = "Stats",
    Callback = function(value)
        Select_Stats = value
    end,
})

PlayerTab:CreateToggle({
    Name = "Auto Up Stats",
    CurrentValue = false,
    Flag = "Auto Up Stats",
    Callback = function(value)
        Auto_Up_Stats = value
   end,
})

spawn(function()
    while wait(.5) do
        if Auto_Up_Stats then
            for i,v in pairs(Select_Stats) do
                Use_Remote("AddPoint",v,Stats_Point)
            end
        end
    end
end)

PlayerTab:CreateToggle({
    Name = "Auto Stats Kaitun [Sword]",
    CurrentValue = false,
    Flag = "Auto Stats Kaitun [Sword]",
    Callback = function(value)
        Auto_Stats_Kaitun_Sword = value
   end,
})

PlayerTab:CreateToggle({
    Name = "Auto Stats Kaitun [Gun]",
    CurrentValue = false,
    Flag = "Auto Stats Kaitun [Gun]",
    Callback = function(value)
        Auto_Stats_Kaitun_Gun = value
   end,
})

PlayerTab:CreateToggle({
    Name = "Auto Stats Kaitun [Devil Fruit]",
    CurrentValue = false,
    Flag = "Auto Stats Kaitun [Devil Fruit]",
    Callback = function(value)
        Auto_Stats_Kaitun_Devil_Fruit = value
   end,
})

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
        end)
    end
end)

PlayerTab:CreateSlider({
    Name = "Point",
    Range = {1, 100},
    Increment = 5,
    Suffix = "Point",
    CurrentValue = 10,
    Flag = "Stats Point",
    Callback = function(value)
        Stats_Point = value
    end,
})
