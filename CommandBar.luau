if loaded then ntf("Command Bar is already loaded!") return end
pcall(function()getgenv().loaded = true end)

local cloneref = cloneref or function(o) return o end

local cg = cloneref(game:GetService("CoreGui"))
local sg = cloneref(game:GetService("StarterGui"))
local ps = cloneref(game:GetService("Players"))
local uis = cloneref(game:GetService("UserInputService"))
local rs = cloneref(game:GetService("RunService"))
local ts = cloneref(game:GetService("TweenService"))
local tcs = cloneref(game:GetService("TextChatService"))
local rps = cloneref(game:GetService("ReplicatedStorage"))
local p = ps.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local cam = workspace.CurrentCamera
local r = c:WaitForChild("HumanoidRootPart")
local hui

getgenv().ntf = function(txt)
    sg:SetCore("SendNotification", {
        Title = "Command Bar",
        Text = txt,
        Duration = 5
    })
end

if get_hidden_gui or gethui then
    hui = gethui() or get_hidden_gui()
elseif cg:FindFirstChild('RobloxGui') then
    hui = cg.RobloxGui
else
    hui = cg
end

local sg = Instance.new("ScreenGui", hui)

local main = Instance.new("Frame", sg)
main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
main.Size = UDim2.new(1, 0, 0.0199999996, 0)

local gui = Instance.new("TextBox", main)
gui.BackgroundTransparency = 1
gui.Size = UDim2.new(1, 0, 1, 0)
gui.Font = Enum.Font.Roboto
gui.Text = ''
gui.TextColor3 = Color3.fromRGB(255, 255, 255)
gui.TextScaled = true
gui.TextSize = 14.000
gui.TextWrapped = true
gui.TextXAlignment = Enum.TextXAlignment.Left
gui.ZIndex = 2

local ac = Instance.new("TextLabel", gui)
ac.BackgroundTransparency = 1
ac.Size = UDim2.new(1, 0, 1, 0)
ac.Font = Enum.Font.Roboto
ac.Text = ''
ac.TextColor3 = Color3.fromRGB(128, 128, 128)
ac.TextScaled = true
ac.TextSize = 14.000
ac.TextWrapped = true
ac.TextXAlignment = Enum.TextXAlignment.Left
ac.ZIndex = 1

local cmds = {}

local function cmd(name, func)
    cmds[name] = func
end

local function exec(txt)
    local args = {}
    for arg in txt:gmatch("%S+") do
        table.insert(args, arg)
    end
    local cmd = table.remove(args, 1)
    if cmds[cmd] then
        cmds[cmd](unpack(args))
    end
end

local function Ac()
    local text = gui.Text
    if text == "" then
        ac.Visible = false
        return
    end

    for n in pairs(cmds) do
        if n:sub(1, #text) == text then
            ac.Text = n
            ac.Visible = true
            return
        end
    end

    ac.Visible = false
end

cmd("say", function(txt)
    if tcs.ChatVersion == Enum.ChatVersion.LegacyChatService then
        rps.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt, "All")
    else
        tcs.TextChannels.RBXGeneral:SendAsync(txt)
    end
end)
cmd("ws", function(n)
    h.WalkSpeed = tonumber(n)
end)

cmd("lws", function(n)
    h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        h.WalkSpeed = tonumber(n)
    end)
end)

cmd("sws", function(n)
    if hookmetamethod then
        hookmetamethod(game, "__index", function(t, k)
            if k == "WalkSpeed" and t == h and not checkcaller() then
                return tonumber(n)
            end
            return index(t, k)
        end)
    else
        ntf("Your executor does not support hookmetamethod")
    end
end)

cmd("sjp", function(n)
    if hookmetamethod then
        hookmetamethod(game, "__index", function(t, k)
            if k == "JumpPower" and t == h and not checkcaller() then
                return tonumber(n)
            end
            return index(t, k)
        end)
    else
        ntf("Your executor does not support hookmetamethod")
    end
end)

cmd("dex", function()
    loadstring(game:HttpGet("https://github.com/LorekeeperZinnia/Dex/releases/download/1.0.0/out.lua"))()
end)

cmd("jp", function(n)
    h.JumpPower = tonumber(n)
end)

cmd("reset", function()
    h.Health = 0
end)

cmd("v", function(pl)
    for _, plr in pairs(ps:GetPlayers()) do
        if plr.Name == pl or plr.DisplayName == pl then
            cam.CameraSubject = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") or h
            return
        end
    end
    cam.CameraSubject = h
end)

cmd("to", function(pl)
    for _, plr in pairs(ps:GetPlayers()) do
        if plr.Name == pl or plr.DisplayName == pl then
            c:SetPrimaryPartCFrame(plr.Character:GetPrimaryPartCFrame())
        return
        end
    end
end)

cmd("tsp", function(n)
    tsp = tonumber(n) or 1
end)

cmd("tto", function(pl)
    for _, plr in pairs(ps:GetPlayers()) do
        if plr.Name == pl or plr.DisplayName == pl then
            ts:Create(r, TweenInfo.new(tsp, Enum.EasingStyle.Linear), {CFrame = plr.Character:GetPrimaryPartCFrame()}):Play()
        return
        end
    end
end)

cmd("top", function(nm)
    for _,d in pairs(workspace:GetDescendants()) do
        if d.Name == nm and d:IsA("BasePart") then
            c:SetPrimaryPartCFrame(v.CFrame)
        end
    end
end)

cmd("ttop", function(nm)
    for _,d in pairs(workspace:GetDescendants()) do
        if d.Name == nm and d:IsA("BasePart") and h.SeatPart then
            h.Sit = false
            task.wait()
        end
        ts:Create(r, TweenInfo.new(tsp, Enum.EasingStyle.Linear), {CFrame = d.CFrame}):Play()
    end
end)

cmd("vol", function(n)
	UserSettings():GetService("UserGameSettings").MasterVolume = tonumber(n)/10
end)

cmd("fps", function(n)
	if setfpscap and type(setfpscap) == "function" then
        return setfpscap(n)
    else
        ntf("Your executor doesn't support setfpscap")
    end
end)

cmd("fov", function(n)
    if n then
        cam.FieldOfView = tonumber(n)
    else
        cam.FieldOfView = 70
    end
end)

cmd("ql", function(n)
    settings().Rendering.QualityLevel = tonumber(n)
end)

cmd("lc", function()
    if cam.CameraType == Enum.CameraType.Fixed then
        cam.CameraType = Enum.CameraType.Custom
    else
        cam.CameraType = Enum.CameraType.Fixed
    end
end)

local ui = {}

function ui.hide()
	gui.TextTransparency = 1
	main.BackgroundTransparency = 1
	gui.Active = false
    ac.Visible = false
end

function ui.show()
	gui.TextTransparency = 0
	main.BackgroundTransparency = 0
	gui.Active = true
    ac.Visible = true
end

ui.hide()

gui.Focused:Connect(function()
	ui.show()
end)

gui.FocusLost:Connect(function(p)
    if p then
        exec(gui.Text)
	    ui.hide()
    end
end)

uis.InputBegan:Connect(function(i, g)
	if not g and i.KeyCode == Enum.KeyCode.Semicolon then
		ui.show()
		gui:CaptureFocus()
	end
end)

gui:GetPropertyChangedSignal("Text"):Connect(function()
    gui.Text = gui.Text:gsub(";", "")
    Ac()
end)

ntf("Command Bar has been loaded!")
