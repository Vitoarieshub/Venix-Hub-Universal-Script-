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

local savedPositions = {
    ["Posição 1"] = nil,
    ["Posição 2"] = nil
}

local slotSelecionado = "Posição 1"
local teleporteSuaveAtivado = false
local TEMPO_FIXO = 7

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

AddDropdown(Teleportes, {
    Name = "Selecionar Posição",
    Options = {"Posição 1", "Posição 2"},
    Default = "Posição 1",
    Callback = function(opcaoSelecionada)
        slotSelecionado = opcaoSelecionada
    end
})

AddButton(Teleportes, {
    Name = "Salvar posição",
    Callback = function()
        pcall(function()
            local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            savedPositions[slotSelecionado] = hrp.CFrame
        end)
    end
})

AddButton(Teleportes, {
    Name = "Teleportar para posição",
    Callback = function()
        pcall(function()
            local cframeAlvo = savedPositions[slotSelecionado]
            
            if cframeAlvo then
                local character = Players.LocalPlayer.Character
                local hrp = character:WaitForChild("HumanoidRootPart")
                
                if teleporteSuaveAtivado then
                    local posicaoInicial = hrp.Position
                    local posicaoFinal = cframeAlvo.Position
                    local tempoDecorrido = 0
                    
                    local conexao
                    conexao = RunService.Heartbeat:Connect(function(dt)
                        if not character or not hrp:IsDescendantOf(game) then
                            conexao:Disconnect()
                            return
                        end
                        
                        tempoDecorrido = tempoDecorrido + dt
                        local alfa = math.clamp(tempoDecorrido / TEMPO_FIXO, 0, 1)
                        
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = CFrame.new(posicaoInicial:Lerp(posicaoFinal, alfa)) * (cframeAlvo - cframeAlvo.Position)
                        
                        if alfa >= 1 then
                            conexao:Disconnect()
                        end
                    end)
                else
                    hrp.CFrame = cframeAlvo
                end
            end
        end)
    end
})

AddToggle(Teleportes, {
    Name = "Teleporte Suave",
    Default = false,
    Callback = function(estado)
        teleporteSuaveAtivado = estado
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espNomeAtivado = false
local espDistAtivado = false

local connections = {}

local function criarBillboard(nome, adornee, offsetY)
	local gui = Instance.new("BillboardGui")
	gui.Name = nome
	gui.Adornee = adornee
	gui.Size = UDim2.new(0, 200, 0, 20)
	gui.StudsOffset = Vector3.new(0, offsetY, 0)
	gui.AlwaysOnTop = true

	local texto = Instance.new("TextLabel")
	texto.Name = "Texto"
	texto.Size = UDim2.new(1, 0, 1, 0)
	texto.BackgroundTransparency = 1
	texto.TextColor3 = Color3.new(1, 1, 1)
	texto.TextStrokeTransparency = 0
	texto.TextStrokeColor3 = Color3.new(0, 0, 0)
	texto.Font = Enum.Font.Gotham
	texto.TextSize = 12
	texto.Parent = gui

	gui.Parent = adornee

	return texto, gui
end

local function limparTodoESP()
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local esp = char.HumanoidRootPart:FindFirstChild("ESP_Info")
			if esp then
				esp:Destroy()
			end
		end
	end
end

local function criarESP(player)
	if player == LocalPlayer then
		return
	end

	task.spawn(function()
		while (espNomeAtivado or espDistAtivado) and player and player.Parent do
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local humanoid = char and char:FindFirstChild("Humanoid")

			if root and humanoid and humanoid.Health > 0 then
				local guiInfo = root:FindFirstChild("ESP_Info")
				local texto
				
				if not guiInfo then
					texto = criarBillboard("ESP_Info", root, -3.5)
				else
					texto = guiInfo:FindFirstChild("Texto")
				end

				if texto then
					local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local textoFinal = ""

					if espNomeAtivado then
						textoFinal = player.Name
					end

					if espDistAtivado and myRoot then
						local distancia = math.floor((myRoot.Position - root.Position).Magnitude)
						if espNomeAtivado then
							textoFinal = textoFinal .. " - " .. distancia .. "m"
						else
							textoFinal = distancia .. "m"
						end
					end

					texto.Text = textoFinal
				end
			else
				local guiInfo = root and root:FindFirstChild("ESP_Info")
				if guiInfo then
					guiInfo:Destroy()
				end
			end

			task.wait(0.1)
		end
		
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local guiInfo = root and root:FindFirstChild("ESP_Info")
		if guiInfo then
			guiInfo:Destroy()
		end
	end)
end

local function monitorarPlayer(player)
	if player == LocalPlayer then
		return
	end

	if connections[player] then
		connections[player]:Disconnect()
	end

	connections[player] = player.CharacterAdded:Connect(function()
		task.wait(1)
		if espNomeAtivado or espDistAtivado then
			criarESP(player)
		end
	end)

	if player.Character then
		criarESP(player)
	end
end

local function atualizarTodos()
	for _, player in ipairs(Players:GetPlayers()) do
		monitorarPlayer(player)
	end

	if not connections.PlayerAdded then
		connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
			monitorarPlayer(player)
		end)
	end
end

AddToggle(Visuais, {
	Name = "ESP Nome",
	Default = false,
	Callback = function(Value)
		espNomeAtivado = Value
		if Value then
			atualizarTodos()
		else
			if not espDistAtivado then
				limparTodoESP()
			end
		end
	end
})

AddToggle(Visuais, {
	Name = "ESP Distância",
	Default = false,
	Callback = function(Value)
		espDistAtivado = Value
		if Value then
			atualizarTodos()
		else
			if not espNomeAtivado then
				limparTodoESP()
			end
		end
	end
})


local espAtivado = false
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function aplicarHighlight(player)
    if player == LocalPlayer then return end

    local character = player.Character
    if not character then return end

    local highlight = character:FindFirstChild("ESPHighlight")

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
    end

    -- Verifica time
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        else
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        end
    else
        -- Caso o jogo não tenha Teams
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end

local function removerHighlight(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espAtivado then
        for _, player in ipairs(Players:GetPlayers()) do
            aplicarHighlight(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            removerHighlight(player)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if espAtivado then
            aplicarHighlight(player)
        end
    end)
end)

AddToggle(Visuais, {
    Name = "ESP Caixa",
    Default = false,
    Callback = function(Value)
        espAtivado = Value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local linhas = {}
local espConnections = {}
local espLinhaAtivado = false
local corVermelha = Color3.fromRGB(255, 255, 255)

local function criarLinha(player)
    if player == LocalPlayer then return end

    if linhas[player] then
        linhas[player]:Remove()
        linhas[player] = nil
    end
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end

    local linha = Drawing.new("Line")
    linha.Thickness = 2
    linha.Transparency = 1
    linha.Visible = false
    linha.Color = corVermelha
    linhas[player] = linha

    espConnections[player] = RunService.RenderStepped:Connect(function()
        if not espLinhaAtivado then
            linha.Visible = false
            return
        end

        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then
            linha.Visible = false
            return
        end

        local cam = workspace.CurrentCamera
        local screenSize = cam.ViewportSize
        local headPos, onScreen = cam:WorldToViewportPoint(head.Position)

        if onScreen then
            linha.From = Vector2.new(screenSize.X / 2, 0)
            linha.To = Vector2.new(headPos.X, headPos.Y)
            linha.Visible = true
        else
            linha.Visible = false
        end
    end)

    player.CharacterAdded:Connect(function()
        wait(1)
        if espLinhaAtivado then
            criarLinha(player)
        end
    end)
end

function ativarESP()
    for _, p in ipairs(Players:GetPlayers()) do
        criarLinha(p)
    end
    espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
        wait(1)
        criarLinha(p)
    end)
end

function desativarESP()
    for _, linha in pairs(linhas) do
        if linha then linha:Remove() end
    end
    linhas = {}
    for _, conn in pairs(espConnections) do
        if conn then conn:Disconnect() end
    end
    espConnections = {}
end

AddToggle(Visuais, {
    Name = "ESP Linha",
    Default = false,
    Callback = function(Value)
        espLinhaAtivado = Value
        if espLinhaAtivado then
            ativarESP()
        else
            desativarESP()
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local trackedPlayers = {}
local antiFlingEnabled = false

local function setCollide(part, state)
    if part:IsA("BasePart") then
        part.CanCollide = state
    end
end

local function trackCharacter(character)
    for _, part in pairs(character:GetChildren()) do
        setCollide(part, not antiFlingEnabled)
    end
    character.ChildAdded:Connect(function(child)
        setCollide(child, not antiFlingEnabled)
    end)
end

local function trackPlayer(player)
    if player == localPlayer then return end
    if player.Character then
        trackCharacter(player.Character)
    end
    player.CharacterAdded:Connect(trackCharacter)
    trackedPlayers[player] = true
end

local function applyState(state)
    for player in pairs(trackedPlayers) do
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                setCollide(part, state)
            end
        end
    end
end

local function enableTracking()
    for _, player in pairs(Players:GetPlayers()) do
        trackPlayer(player)
    end
    Players.PlayerAdded:Connect(trackPlayer)
    RunService.RenderStepped:Connect(function()
        if antiFlingEnabled then
            for player in pairs(trackedPlayers) do
                local character = player.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        setCollide(part, false)
                    end
                end
            end
        end
    end)
end

AddToggle(Config, {
    Name = "Anti Arremesso",
    Default = false,
    Callback = function(state)
        antiFlingEnabled = state
        if antiFlingEnabled then
            if next(trackedPlayers) == nil then
                enableTracking()
            end
        else
            applyState(true)
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local zoomInfinitoAtivo = false

LocalPlayer.CharacterAdded:Connect(function()
    if zoomInfinitoAtivo then
        task.wait(0.5)
        LocalPlayer.CameraMaxZoomDistance = math.huge
    end
end)

AddToggle(Config, {
    Name = "Zoom Infinito",
    Default = false,
    Callback = function(state)
        zoomInfinitoAtivo = state
        if state then
            LocalPlayer.CameraMaxZoomDistance = math.huge
        else
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
})


local Workspace = game:GetService("Workspace")
local storedTransparency = {}

local function setXRay(state)
    if state then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
                storedTransparency[part] = part.Transparency
                part.Transparency = 0.7
            end
        end
    else
        for part, t in pairs(storedTransparency) do
            if part and part:IsA("BasePart") then
                part.Transparency = t
            end
        end
        storedTransparency = {}
    end
end

AddToggle(Config, {
    Name = "Raio X",
    Default = false,
    Callback = function(state)
        setXRay(state)
    end
})

AddButton(Config, {
    Name = "Aumento de FPS",
    Callback = function()
        pcall(function()
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local v = descendants[i]
                if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                    v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    v:Destroy()
                end
            end

            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                workspace.GlobalShadows = false 

                local lighting = game:GetService("Lighting")
                if lighting then
                    lighting.FogEnd = 1e10 
                    lighting.GlobalShadows = false
                    lighting.Brightness = 2
                    
                    local effects = lighting:GetChildren()
                    for i = 1, #effects do
                        local effect = effects[i]
                        if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") then
                            effect:Destroy()
                        end
                    end
                end
            end)
        end)
    end
})
