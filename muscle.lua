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

if Settings.FastMode then
    humanoid.WalkSpeed = 100
    humanoid.JumpPower = 100
end

game:GetService("RunService").Heartbeat:Connect(function()
    doTraining()
    checkRebirth()
    antiAFK()
end)

print("Скрипт полностью загружен и работает")