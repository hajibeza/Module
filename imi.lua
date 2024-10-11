local function createCircleBeam(character, radius, width)
    -- ตรวจสอบว่ามี HumanoidRootPart หรือไม่
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("Character or HumanoidRootPart not found!")
        return
    end

    -- ลบ Beam เก่าออก (ถ้ามี)
    if character.HumanoidRootPart:FindFirstChild("CircleBeam") then
        character.HumanoidRootPart.CircleBeam:Destroy()
    end

    -- สร้าง Attachment สองตัว
    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(0, 0, 0)
    attachment1.Parent = character.HumanoidRootPart

    local attachment2 = Instance.new("Attachment")
    attachment2.Position = Vector3.new(0, 0, radius)
    attachment2.Parent = character.HumanoidRootPart

    -- สร้าง Beam
    local beam = Instance.new("Beam")
    beam.Name = "CircleBeam"  -- ตั้งชื่อเพื่อให้สามารถลบได้ในภายหลัง
    beam.Attachment0 = attachment1
    beam.Attachment1 = attachment2
    beam.Width0 = width
    beam.Width1 = width
    beam.CurveSize0 = 1
    beam.CurveSize1 = 1
    beam.FaceCamera = true
    beam.Parent = character.HumanoidRootPart
end

-- ตัวอย่างการเรียกใช้ฟังก์ชัน
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
createCircleBeam(character, 10, 0.2)  -- กำหนด radius และ width
