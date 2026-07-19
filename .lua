loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/Venix-Hub-Universal-/refs/heads/main/loader.lua"))()

MakeWindow({

    Hub = {

        Title = "Venix Hub",

        Animation = "Venix Hub Universal"

    },

    

    Key = {

        KeySystem = false,

        Title = "Sistema de Chave",

        Description = "Digite a chave correta para continuar.",

        KeyLink = "https://seusite.com/chave",

        Keys = {"1234", "28922"},

        Notifi = {

            Notifications = true,

            CorrectKey = "Chave correta! Iniciando script...",

            Incorrectkey = "Chave incorreta, tente novamente.",

            CopyKeyLink = "Link copiado!"

        }

    }

})


MinimizeButton({
    Image = "rbxassetid://112246739043935",
    Size = {40, 40},
    Color = Color3.fromRGB(10, 10, 10),
    Corner = true,                       
    CornerRadius = UDim.new(1, 0),       
    Stroke = true,                      
    StrokeColor = Color3.fromRGB(0, 0, 0) 
})


local Jogador = MakeTab({Name = "Jogador"})
local Visuais = MakeTab({Name = "Visual"})
local Troll = MakeTab({Name = "Troll"})
local Teleportes = MakeTab({Name = "Teleportes"})
local Combate = MakeTab({Name = "Combate"})
local Config = MakeTab({Name = "Config"})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WalkSpeedEnabled = false
local WalkSpeedValue = 25

AddTextBox(Jogador,{
	Name = "Velocidade",
	Default = "25",
	PlaceholderText = "16 - 250",
	ClearText = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num then
			WalkSpeedValue = math.clamp(Num,16,250)
		end
	end
})

AddToggle(Jogador,{
	Name = "Velocidade",
	Default = false,
	Callback = function(Value)
		WalkSpeedEnabled = Value

		local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = Value and WalkSpeedValue or 16
		end
	end
})

local JumpEnabled = false
local JumpValue = 50

AddTextBox(Jogador,{
	Name = "Super pulo",
	Default = "50",
	PlaceholderText = "10 - 900",
	ClearText = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num then
			JumpValue = math.clamp(Num,10,900)
		end
	end
})

AddToggle(Jogador,{
	Name = "Super pulo",
	Default = JumpPower,
	Callback = function(Value)
		JumpEnabled = Value

		local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = Value and JumpValue or 50
		end
	end
})

local GravityEnabled = false
local GravityValue = workspace.Gravity
local DefaultGravity = workspace.Gravity

AddTextBox(Jogador,{
	Name = "Gravidade",
	Default = tostring(DefaultGravity),
	PlaceholderText = "0 - 500",
	ClearText = true,
	Callback = function(Value)
		local Num = tonumber(Value)
		if Num then
			GravityValue = math.clamp(Num,0,500)
		end
	end
})

AddToggle(Jogador,{
	Name = "Gravidade",
	Default = false,
	Callback = function(Value)
		GravityEnabled = Value
		workspace.Gravity = Value and GravityValue or DefaultGravity
	end
})

task.spawn(function()
	while task.wait(0.2) do
		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			if WalkSpeedEnabled then
				Humanoid.WalkSpeed = WalkSpeedValue
			end

			if JumpEnabled then
				Humanoid.UseJumpPower = true
				Humanoid.JumpPower = JumpValue
			end
		end

		if GravityEnabled then
			workspace.Gravity = GravityValue
		end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(Character)
	local Humanoid = Character:WaitForChild("Humanoid")

	task.wait(0.5)

	if WalkSpeedEnabled then
		Humanoid.WalkSpeed = WalkSpeedValue
	end

	if JumpEnabled then
		Humanoid.UseJumpPower = true
		Humanoid.JumpPower = JumpValue
	end

	if GravityEnabled then
		workspace.Gravity = GravityValue
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclipEnabled = false

AddToggle(Jogador, {
    Name = "Atravessar Parede", 
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        if not Value and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
        print("Noclip:", Value and "Ativado" or "Desativado")
    end
})

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)


-- Infinite Jump
local jumpConnection

local function toggleInfiniteJump(enable)

    if enable then

        if not jumpConnection then

            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()

                local player = game.Players.LocalPlayer

                local character = player.Character or player.CharacterAdded:Wait()

                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then

                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                end

            end)

        end

    else

        if jumpConnection then

            jumpConnection:Disconnect()

            jumpConnection = nil

        end

    end

end


-- Toggle pulo infinito

local Toggle = AddToggle(Jogador, {

    Name = "Pulo Infinito",

    Default = false,

    Callback = function(Value)

        toggleInfiniteJump(Value)

    end

})
