if loaded then return end
pcall(function() getgenv().loaded = true end)

local cloneref = cloneref or function(o) return o end

local cg = cloneref(game:GetService("CoreGui"))
local sg = cloneref(game:GetService("StarterGui"))
local ps = cloneref(game:GetService("Players"))
local uis = cloneref(game:GetService("UserInputService"))
local rs = cloneref(game:GetService("RunService"))
local hs = cloneref(game:GetService("HttpService"))
local gs = cloneref(game:GetService("GuiService"))
local ts = cloneref(game:GetService("TweenService"))
local mps = cloneref(game:GetService("MarketplaceService"))
local tps = cloneref(game:GetService("TeleportService"))
local tcs = cloneref(game:GetService("TextChatService"))
local rps = cloneref(game:GetService("ReplicatedStorage"))
local p = ps.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local ms = p:GetMouse()
local cam = workspace.CurrentCamera
local r = c:WaitForChild("HumanoidRootPart")
local hui

p.CharacterAdded:Connect(function()
    c = p.Character
    h = c:WaitForChild("Humanoid")
    r = c:WaitForChild("HumanoidRootPart")
end)

local function gp(q)
    if not q then q = p.Name end
    q = q:lower()
    local m = {}

    for _, pl in ipairs(ps:GetPlayers()) do
        if pl.DisplayName:lower() == q then
            return pl
        elseif pl.DisplayName:lower():sub(1, #q) == q then
            table.insert(m, pl)
        elseif pl.Name:lower():sub(1, #q) == q then
            table.insert(m, pl)
        end
    end

    return #m == 1 and m[1] or nil
end



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
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.Size = UDim2.new(1, 0, 0.02, 0)
main.BorderSizePixel = 0
main.BackgroundTransparency = 0.2

local uc = Instance.new("UICorner", main)
uc.CornerRadius = UDim.new(0, 4)

local gui = Instance.new("TextBox", main)
gui.BackgroundTransparency = 1
gui.Size = UDim2.new(1, -6, 1, -3)
gui.Position = UDim2.new(0, 3, 0, 2)
gui.Font = Enum.Font.GothamMedium
gui.Text = ''
gui.TextColor3 = Color3.fromRGB(220, 220, 220)
gui.TextScaled = true
gui.TextSize = 12
gui.TextWrapped = true
gui.TextXAlignment = Enum.TextXAlignment.Left
gui.ZIndex = 2

local ac = Instance.new("TextLabel", gui)
ac.BackgroundTransparency = 1
ac.Size = UDim2.new(1, 0, 1, 0)
ac.Font = Enum.Font.GothamMedium
ac.Text = ''
ac.TextColor3 = Color3.fromRGB(150, 150, 150)
ac.TextScaled = true
ac.TextSize = 12
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

local pcmds = {v = true, to = true, tto = true}

local function Ac()
    local txt = gui.Text:lower()
    if txt == "" then
        ac.Visible = false
        return
    end

    local args = txt:split(" ")
    local c = args[1] or ""
    local p = args[2] or ""

    if not pcmds[c] then
        ac.Text = c
        ac.Visible = true
        return
    end

    local pl = gp(p)

    if pl then
        ac.Text = c .. " " .. pl.DisplayName
        ac.Visible = true
    else
        ac.Text = c
        ac.Visible = true
    end
end

cmd("say", function(txt)
    if tcs.ChatVersion == Enum.ChatVersion.LegacyChatService then
        rps.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(txt, "All")
    else
        tcs.TextChannels.RBXGeneral:SendAsync(txt)
    end
end)

cmd("ws", function(n)
    if n then
    h.WalkSpeed = tonumber(n)
    else
    h.WalkSpeed = 16
    end
end)
local con = nil
cmd("lws", function(n)
if con then con:Disconnect() con = nil end
    if n then
        con = h:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            task.wait()
            h.WalkSpeed = tonumber(n)
        end)
    else
        con:Disconnect()
        h.Walkspeed = 16
    end
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

local function rejoin()
    if #ps:GetPlayers() <= 1 then
        p:Kick("Rejoining...")
        tps:Teleport(game.PlaceId, p)
    else
        tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
    end
end
cmd("rj", function()
    rejoin()
end)

cmd("arj", function()
    gs.ErrorMessageChanged:Connect(function()
        rejoin()
    end)
    ntf("Auto rejoin enabled")
end)

cmd("dex", function()
    loadstring(game:HttpGet("https://github.com/LorekeeperZinnia/Dex/releases/download/1.0.0/out.lua"))()
end)

cmd("iy", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

cmd("rspy", function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpyBeta.lua"))()
end)
cmd("jp", function(n)
    if n then
    h.JumpPower = tonumber(n)
    else
    h.JumpPower = 50
    end
end)

cmd("reset", function()
    h.Health = 0
end)

cmd("a", function(id)
    local a = Instance.new("Animation")
    a.AnimationId = "rbxassetid://"..id
    local t = h:LoadAnimation(a)
    t:Play()
end)

cmd("ca", function()
    local fnd = ""

    for _,v in pairs(h:GetPlayingAnimationTracks()) do
        local aid = v.Animation.AnimationId
        local asid = aid:find("rbxassetid://") and animationId:match("%d+")

        if not string.find(aid, "507768375") and not string.find(aid, "180435571") then
            if asid then
                local suc, res = pcall(function()
                    return mps:GetProductInfo(tonumber(asid)).Name
                end)
                local nm = suc and res or "Failed to get name"
                fnd = "Name: " .. nm .. "\nAnimation Id: " .. aid
            else
                fnd = "Animation Id: " .. aid
            end
        end
    end

        if found ~= "" then
            setclipboard(fnd)
        else
            ntf("No animations to copy")
        end
end)

cmd("sa", function()
	for i,v in next, h:GetPlayingAnimationTracks() do
		v:Stop()
	end
end)
cmd("tsp", function(n)
    tsp = tonumber(n) or 1
end)
local nc = nil
local clip = true

cmd("nc", function()
    if nc then nc:Disconnect() nc = nil end
    clip = not clip
    if not clip then
        nc = rs.Stepped:Connect(function()
            if not clip and c ~= nil then
                for _, p in pairs(c:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        p.CanCollide = false
                    end
                end
            end
        end)
    else
        if nc then
            nc:Disconnect()
        end
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and not p.CanCollide then
                p.CanCollide = true
            end
        end
    end
end)

local af = nil
local afin = true

cmd("af", function()
    afin = not afin
    if not afin then
        af = rs.Stepped:Connect(function()
            for _, player in pairs(ps:GetPlayers()) do
                if player.Character then
                    for _, p in pairs(player.Character:GetDescendants()) do
                        if p:IsA("BasePart") and p.CanCollide then
                            p.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if af then
            af:Disconnect()
        end
        for _, player in pairs(ps:GetPlayers()) do
            if player.Character then
                for _, p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") and not p.CanCollide then
                        p.CanCollide = true
                    end
                end
            end
        end
    end
end)

tpwing = false
cmd("tpw", function(n)
    tpwing = not tpwing
	while tpwing and c and h and h.Parent do
		local delta = rs.Heartbeat:Wait()
		if h.MoveDirection.Magnitude > 0 then
			if n then
				c:TranslateBy(h.MoveDirection * tonumber(n) * delta * 10)
			else
				c:TranslateBy(h.MoveDirection * delta * 10)
			end
		end
	end
end)

cmd("spin", function(n)
    if n then
    for _,v in pairs(c:GetChildren()) do
		if v.Name == "spin" then
			v:Destroy()
		end
	end
	local sp = Instance.new("BodyAngularVelocity", c)
	sp.Name = "spin"
	sp.MaxTorque = Vector3.new(0, math.huge, 0)
	sp.AngularVelocity = Vector3.new(0,n,0)
else
    for _,v in pairs(c:GetChildren()) do
        if v.Name == "spin" then
            v:Destroy()
        end
    end
end
end)
cmd("mtp", function()
    local mpos = ms.Hit+Vector3.new(0,2.5,0)
    mpos = CFrame.new(mpos.X,mpos.Y,mpos.Z)
    
    r.CFrame = mpos
end)
cmd("tpt", function()
    local tpt = Instance.new("Tool")
    tpt.RequiresHandle = false
    tpt.Name = "Teleport Tool"
    tpt.Activated:Connect(function()
        local mpos = ms.Hit+Vector3.new(0,2.5,0)
        mpos = CFrame.new(mpos.X,mpos.Y,mpos.Z)
        
        r.CFrame = mpos
    end)
    tpt.Parent = p.Backpack
end)
cmd("v", function(pl)
    local target = gp(pl)
    if target and target.Character then
        cam.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid") or h
    else
        cam.CameraSubject = h
    end
end)

cmd("to", function(pl)
    local target = gp(pl)
    if target and target.Character and target.Character.PrimaryPart then
        r.CFrame = (target.Character.PrimaryPart.CFrame)
    end
end)

cmd("tto", function(pl)
    local target = gp(pl)
    if target and target.Character and target.Character.PrimaryPart then
        ts:Create(r, TweenInfo.new(tsp, Enum.EasingStyle.Linear), {CFrame = target.Character.PrimaryPart.CFrame}):Play()
    end
end)

cmd("top", function(nm)
    for _,d in pairs(workspace:GetDescendants()) do
        if d.Name == nm and d:IsA("BasePart") then
            r.CFrame = (target.Character.PrimaryPart.CFrame)
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
    UserSettings():GetService("UserGameSettings").MasterVolume = tonumber(n) / 10
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

cmd("cmds", function()
    local txt = "Commands:\n"
    for k, _ in pairs(cmds) do
        txt = txt .. k .. "\n"
    end
    setclipboard(txt)
    ntf("Copied commands to clipboard")
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

ntf("Command Bar loaded, type "cmds" to see the commands.")
