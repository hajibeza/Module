local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- Add it to the player's GUI

local function showNotification(message, duration)
    local notifyLabel = Instance.new("TextLabel")
    notifyLabel.Size = UDim2.new(0, 200, 0, 50)  -- Size of the notification
    notifyLabel.Position = UDim2.new(0, 10, 0, 10)  -- Top-left corner (10px from top and left)
    notifyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black background
    notifyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
    notifyLabel.Text = message  -- Set the message text
    notifyLabel.TextScaled = true  -- Make the text fit the label
    notifyLabel.BackgroundTransparency = 0.3  -- Slightly transparent background
    notifyLabel.BorderSizePixel = 0  -- Remove border
    notifyLabel.Parent = screenGui  -- Add the label to the ScreenGui

    -- Make the notification disappear after the given duration
    wait(duration)
    notifyLabel:Destroy()
end
