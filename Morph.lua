local Players = game:GetService("Players")
local player = Players.LocalPlayer

function morphToUser(userId)
    local character = player.Character
    if not character then return end
    
    local appearance = Players:GetCharacterAppearanceAsync(userId)
    if not appearance then return end
    
    local toRemove = {
        ["Accessory"] = true,
        ["Shirt"] = true,
        ["Pants"] = true,
        ["CharacterMesh"] = true,
        ["Hat"] = true,
        ["BodyColors"] = true
    }
    
    for _, item in ipairs(character:GetChildren()) do
        if toRemove[item.ClassName] then
            item:Destroy()
        end
    end
    
    local face = character.Head:FindFirstChild("face")
    if face then face:Destroy() end
    
    for _, item in ipairs(appearance:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") then
            item.Parent = character
        elseif item:IsA("Accessory") then
            character.Humanoid:AddAccessory(item)
        elseif item.Name == character.Humanoid.RigType.Name then
            local mesh = item:FindFirstChildOfClass("CharacterMesh")
            if mesh then mesh.Parent = character end
        end
    end
    
    local newFace = appearance:FindFirstChild("face")
    if newFace then
        newFace.Parent = character.Head
    else
        local defaultFace = Instance.new("Decal")
        defaultFace.Name = "face"
        defaultFace.Face = "Front"
        defaultFace.Texture = "rbxasset://textures/face.png"
        defaultFace.Parent = character.Head
    end
    
    character.Parent = nil
    character.Parent = workspace
end

local function onCharacterAdded(character)
    morphToUser(getgenv().userId)
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    onCharacterAdded(player.Character)
end
