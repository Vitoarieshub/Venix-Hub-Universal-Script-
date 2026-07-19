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
local Trollar = MakeTab({Name = "Trollar"})
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

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local AllBool = false
local jogadorDigitado = ""
local scriptAtivo = true

local visualizando = false
local conexaoCam = nil

getgenv().FPDH = workspace.FallenPartsDestroyHeight

local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        AllBool = true
        return nil
    elseif Name == "random" then
        local GetPlayers = Players:GetPlayers()
        if table.find(GetPlayers, Player) then table.remove(GetPlayers, table.find(GetPlayers, Player)) end
        return GetPlayers[math.random(#GetPlayers)]
    elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
        for _, x in next, Players:GetPlayers() do
            if x ~= Player then
                if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                    return x
                end
            end
        end
    end
    return nil
end

local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local SkidFling = function(TargetPlayer)
    if not TargetPlayer or not scriptAtivo then return end
    
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character

    if not TCharacter or not Character or not Humanoid or not RootPart then return end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    if THumanoid and THumanoid.Sit and not AllBool then
        return Message("Erro", "O alvo está sentado", 5)
    end
    if THead and not visualizando then
        workspace.CurrentCamera.CameraSubject = THead
    elseif not THead and Handle and not visualizando then
        workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart and not visualizando then
        workspace.CurrentCamera.CameraSubject = THumanoid
    end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then
        return
    end
    
    local FPos = function(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    local SFBasePart = function(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0

        repeat
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                    task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                    task.wait()
                end
            else
                break
            end
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end
    
    workspace.FallenPartsDestroyHeight = 0/0
    
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart and not THead then
        SFBasePart(TRootPart)
    elseif not TRootPart and THead then
        SFBasePart(THead)
    elseif not TRootPart and not THead and Accessory and Handle then
        SFBasePart(Handle)
    else
        return Message("Erro", "Alvo inconsistente", 5)
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    
    if not visualizando then
        workspace.CurrentCamera.CameraSubject = Humanoid
    end
    
    repeat
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
        Humanoid:ChangeState("GettingUp")
        table.foreach(Character:GetChildren(), function(_, x)
            if x:IsA("BasePart") then
                x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
            end
        end)
        task.wait()
    until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

AddTextBox(Jogador, {
	Name = "Alvo",
	Default = "",
	Placeholder = "Nome do jogador",
	Callback = function(text)
		jogadorDigitado = text
	end
})

AddToggle(Jogador, {
	Name = "Visualizar",
	Default = false,
	Callback = function(state)
		visualizando = state
		
		if conexaoCam then 
			conexaoCam:Disconnect() 
			conexaoCam = nil 
		end

		if visualizando then
			if jogadorDigitado and jogadorDigitado ~= "" then
				local alvo = GetPlayer(jogadorDigitado)
				if alvo then
					local focarCamera = function(char)
						if char then
							local hum = char:WaitForChild("Humanoid", 5)
							if hum then workspace.CurrentCamera.CameraSubject = hum end
						end
					end
					focarCamera(alvo.Character)
					conexaoCam = alvo.CharacterAdded:Connect(focarCamera)
				end
			end
		else
			local meuHumanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if meuHumanoid then workspace.CurrentCamera.CameraSubject = meuHumanoid end
		end
	end
})

AddButton(Jogador, {
	Name = "Teleportar",
	Callback = function()
		if jogadorDigitado and jogadorDigitado ~= "" then
			local alvo = GetPlayer(jogadorDigitado)
			local meuChar = Player.Character
			local meuRoot = meuChar and meuChar:FindFirstChild("HumanoidRootPart")
			if alvo and alvo.Character and meuRoot then
				local alvoRoot = alvo.Character:FindFirstChild("HumanoidRootPart")
				if alvoRoot then
					meuRoot.CFrame = alvoRoot.CFrame * CFrame.new(0, 2, 2)
				end
			end
		end
	end
})

AddButton(Jogador, {
	Name = "Arremessar Jogador",
	Callback = function()
		if jogadorDigitado and jogadorDigitado ~= "" then
			AllBool = false
			local alvo = GetPlayer(jogadorDigitado)
			if AllBool then
				for _, x in next, Players:GetPlayers() do
					if x ~= Player then
						task.spawn(function() SkidFling(x) end)
					end
				end
			elseif alvo then
				if alvo.UserId ~= 1414978355 then
					SkidFling(alvo)
				else
					Message("Erro", "Este usuário está na Whitelist!", 5)
				end
			else
				Message("Erro", "Jogador não encontrado", 5)
			end
		else
			Message("Aviso", "Digite o nome de um jogador primeiro!", 5)
		end
	end
})


AddButton(Jogador, {
    Name = "Arremessar Todos",
    Callback = function()
        print("Botão foi clicado!")
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Vitoarieshub/Fling-Univesal-Venix/refs/heads/main/Venix%20Universal"))()
        end)
    end
}) 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local loopConexao = nil
local voando = false
local bV = nil
local bBG = nil

local function ObterAlvoFisico()
    local Character = localPlayer.Character
    if not Character then return nil end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
    if Humanoid and Humanoid.SeatPart then
        return Humanoid.SeatPart
    end
    return Character:FindFirstChild("HumanoidRootPart")
end

local function ForcarDesancorarPecas(alvo)
    if not alvo then return end
    local rootModel = alvo:FindFirstAncestorOfClass("Model") or alvo
    for _, part in ipairs(rootModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Anchored then
            part.Anchored = false
        end
    end
end

local function DesativarVoo()
    voando = false
    if bV then bV:Destroy() bV = nil end
    if bBG then bBG:Destroy() bBG = nil end
    if loopConexao then loopConexao:Disconnect() loopConexao = nil end
    
    local alvo = ObterAlvoFisico()
    if alvo then
        alvo.AssemblyLinearVelocity = Vector3.zero
        alvo.AssemblyAngularVelocity = Vector3.zero
    end
end

local function VoarComVeiculo()
    DesativarVoo()
    voando = true
    
    local alvo = ObterAlvoFisico()
    if not alvo then return end
    ForcarDesancorarPecas(alvo)
    
    bV = Instance.new("BodyVelocity")
    bV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bV.Velocity = Vector3.new(0, 4, 0)
    bV.Parent = alvo

    bBG = Instance.new("BodyGyro")
    bBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bBG.P = 5000
    bBG.D = 500
    bBG.CFrame = alvo.CFrame
    bBG.Parent = alvo
    
    loopConexao = RunService.Heartbeat:Connect(function()
        if not voando or not alvo or not alvo.Parent then 
            DesativarVoo()
            return 
        end
        
        local numVel = 130
        local cam = workspace.CurrentCamera
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            local direcaoMovimento = humanoid.MoveDirection
            
            if direcaoMovimento:Dot(cam.CFrame.LookVector) > 0.4 then
                bV.Velocity = cam.CFrame.LookVector * numVel
                local _, camYaw, _ = cam.CFrame:ToEulerAnglesYXZ()
                bBG.CFrame = CFrame.Angles(0, camYaw, 0)
            else
                bV.Velocity = direcaoMovimento * numVel
            end
        else
            bV.Velocity = Vector3.zero
        end
        
        alvo.AssemblyLinearVelocity = Vector3.zero
        alvo.AssemblyAngularVelocity = Vector3.zero
    end)
end

AddToggle(Trollar, {
    Name = "Voar com veículo",
    Default = false,
    Callback = function(state)
        if state then
            VoarComVeiculo()
        else
            DesativarVoo()
        end
    end
})
