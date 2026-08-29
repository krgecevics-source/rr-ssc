༒ 𝕶𝖗𝖎𝖘𝖘.𝖉𝖔𝖞 ⟡ [𝖓𝖔.𝖘𝖎𝖌𝖓𝖆𝖑] ༒:
-- Muscle Legends GUI Script (fixed v2)
print("Скрипт запущен")

local player = game.Players.LocalPlayer

-- Ожидание персонажа
local function waitForCharacter()
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
return player.Character
end
local char = waitForCharacter()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Настройки (объявлены ДО использования)
local Settings = {
AutoTrain = true,
Teleport = true,
AutoRebirth = true,
AntiAFK = true,
FastMode = true,
RebirthStrength = 1000,
AFKInterval = 60,
}

-- ===== СОЗДАНИЕ GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MuscleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Muscle Legends Cheat"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Функция создания переключателя
local function createToggle(name, yPos, default, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 30)
btn.Position = UDim2.new(0, 10, 0, yPos)
btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.SourceSansBold
btn.Text = name .. ": " .. (default and "ON" or "OFF")
btn.TextSize = 14
btn.Parent = MainFrame
btn.MouseButton1Click:Connect(function()
local current = btn.BackgroundColor3 == Color3.fromRGB(0,170,0)
if current then
btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
btn.Text = name .. ": OFF"
callback(false)
else
btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
btn.Text = name .. ": ON"
callback(true)
end
end)
return btn
end

createToggle("Auto Train", 40, Settings.AutoTrain, function(v) Settings.AutoTrain = v end)
createToggle("Teleport", 80, Settings.Teleport, function(v) Settings.Teleport = v end)
createToggle("Auto Rebirth", 120, Settings.AutoRebirth, function(v) Settings.AutoRebirth = v end)
createToggle("Anti AFK", 160, Settings.AntiAFK, function(v) Settings.AntiAFK = v end)

print("GUI создан")

-- ===== ФУНКЦИИ =====
local function getNearestTrainer()
local nearest = nil
local minDist = math.huge
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then
local name = v.Name:lower()
if name:find("train") or name:find("equip") or name:find("machine") or name:find("bench") or name:find("dumbbell") then
local dist = (v.Position - root.Position).Magnitude
if dist < minDist then
minDist = dist
nearest = v
end
end
end
end
return nearest
end

local function clickGui(obj)
if not obj or not obj.Visible then return end
local vim = game:GetService("VirtualInputManager")
local pos = obj.AbsolutePosition
local size = obj.AbsoluteSize
vim:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, true, game, 1)
task.wait(0.05)
vim:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 1)
end

༒ 𝕶𝖗𝖎𝖘𝖘.𝖉𝖔𝖞 ⟡ [𝖓𝖔.𝖘𝖎𝖌𝖓𝖆𝖑] ༒:
local function doTraining()
if not Settings.AutoTrain then return end
local trainer = getNearestTrainer()
if not trainer then return end
if Settings.Teleport then
root.CFrame = CFrame.new(trainer.Position + Vector3.new(0, 5, 0))
task.wait(0.1)
end
local prompt = trainer:FindFirstChildOfClass("ProximityPrompt")
if prompt then
prompt:InputHoldBegin()
task.wait(0.2)
prompt:InputHoldEnd()
else
local cam = workspace.CurrentCamera
local screenPos, onScreen = cam:WorldToViewportPoint(trainer.Position)
if onScreen then
local vim = game:GetService("VirtualInputManager")
vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 1)
task.wait(0.05)
vim:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 1)
end
end
end

local function checkRebirth()
if not Settings.AutoRebirth then return end
local ls = player:FindFirstChild("leaderstats")
if not ls then return end
local strength = ls:FindFirstChild("Strength") or ls:FindFirstChild("Power") or ls:FindFirstChild("Muscles")
if not strength then return end
if strength.Value < Settings.RebirthStrength then return end
for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
if obj:IsA("TextButton") or obj:IsA("ImageButton") then
local name = obj.Name:lower()
if name:find("rebirth") or name:find("prestige") or name:find("reborn") then
clickGui(obj)
task.wait(0.5)
for _, confirmObj in ipairs(player.PlayerGui:GetDescendants()) do
if confirmObj:IsA("TextButton") or confirmObj:IsA("ImageButton") then
local cname = confirmObj.Name:lower()
local ctext = (confirmObj:IsA("TextButton") and confirmObj.Text:lower() or "")
if cname:find("yes") or ctext:find("yes") or cname:find("confirm") or ctext:find("confirm") or cname:find("ok") then
clickGui(confirmObj)
break
end
end
end
break
end
end
end
end

local lastAFK = 0
local function antiAFK()
if not Settings.AntiAFK then return end
if tick() - lastAFK < Settings.AFKInterval then return end
lastAFK = tick()
if humanoid and humanoid.Health > 0 then
humanoid.Jump = true
end
end

-- Применяем быстрый режим
if Settings.FastMode then
humanoid.WalkSpeed = 100
humanoid.JumpPower = 100
end

-- Главный цикл
game:GetService("RunService").Heartbeat:Connect(function()
doTraining()
checkRebirth()
antiAFK()
end)

print("Скрипт полностью загружен")