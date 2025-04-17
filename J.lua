local Gghiza07UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function Gghiza07UI:CreateWindow(config)
    local window = {}

    local SETTINGS_FOLDER = "storage/" .. (config.Name or "Gghiza07UI")
    local SETTINGS_FILE = SETTINGS_FOLDER .. "/settingsconfig.rfld"
    local BACKGROUND_FILE = SETTINGS_FOLDER .. "/background"
    local VIDEO_FILE = SETTINGS_FOLDER .. "/video"

    local existingScreenGui = playerGui:FindFirstChild(config.Name or "Gghiza07UI")
    if existingScreenGui then
        existingScreenGui:Destroy()
    end

    local existingToggleGui = playerGui:FindFirstChild("ToggleGui")
    if existingToggleGui then
        existingToggleGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.Name or "Gghiza07UI"
    screenGui.Parent = playerGui
    screenGui.Enabled = true
    screenGui.DisplayOrder = 100

    local mainContent = Instance.new("Frame")
    mainContent.Size = UDim2.new(1, 0, 1, 0)
    mainContent.Position = UDim2.new(0, 0, 0, 0)
    mainContent.BackgroundTransparency = 1
    mainContent.ZIndex = 10
    mainContent.Parent = screenGui

    local backgroundImage = Instance.new("ImageLabel")
    backgroundImage.Size = UDim2.new(1, 0, 1, 0)
    backgroundImage.Position = UDim2.new(0, 0, 0, 0)
    backgroundImage.BackgroundTransparency = 1
    backgroundImage.ImageTransparency = 0.3
    backgroundImage.ZIndex = 9
    backgroundImage.Parent = mainContent

    local videoFrame = Instance.new("VideoFrame")
    videoFrame.Size = UDim2.new(1, 0, 1, 0)
    videoFrame.Position = UDim2.new(0, 0, 0, 0)
    videoFrame.BackgroundTransparency = 1
    videoFrame.ZIndex = 8
    videoFrame.Visible = false
    videoFrame.Parent = mainContent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainContent
    corner:Clone().Parent = backgroundImage
    corner:Clone().Parent = videoFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "Gghiza07UI"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextScaled = true
    titleLabel.ZIndex = 11
    titleLabel.Parent = mainContent

    local draggingUI = false
    local dragInput
    local dragStart
    local startPos

    mainContent.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingUI = true
            dragStart = input.Position
            startPos = mainContent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingUI = false
                end
            end)
        end
    end)

    mainContent.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and draggingUI then
            local delta = input.Position - dragStart
            mainContent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, -20, 0, 60)
    tabsFrame.Position = UDim2.new(0, 10, 0, 50)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    tabsFrame.ZIndex = 11
    tabsFrame.Parent = mainContent

    local cornerTabs = Instance.new("UICorner")
    cornerTabs.CornerRadius = UDim.new(0, 5)
    cornerTabs.Parent = tabsFrame

    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "ToggleGui"
    toggleGui.Parent = playerGui
    toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    toggleGui.DisplayOrder = 101

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 1, -60)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
    toggleButton.Text = "ON"
    toggleButton.TextScaled = true
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.ZIndex = 102
    toggleButton.Parent = toggleGui

    local cornerToggle = Instance.new("UICorner")
    cornerToggle.CornerRadius = UDim.new(0, 15)
    cornerToggle.Parent = toggleButton

    local draggingToggle = false
    local toggleDragInput
    local toggleDragStart
    local toggleStartPos

    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingToggle = true
            toggleDragStart = input.Position
            toggleStartPos = toggleButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingToggle = false
                end
            end)
        end
    end)

    toggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            toggleDragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == toggleDragInput and draggingToggle then
            local delta = input.Position - toggleDragStart
            toggleButton.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
        end
    end)

    local function toggleUI()
        screenGui.Enabled = not screenGui.Enabled
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        if screenGui.Enabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
            toggleButton.Text = "ON"
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            toggleButton.Text = "OFF"
        end
    end

    local lastToggleTime = 0
    local debounceTime = 0.5

    local function onToggleActivated()
        local currentTime = tick()
        if currentTime - lastToggleTime >= debounceTime then
            toggleUI()
            lastToggleTime = currentTime
        end
    end

    toggleButton.MouseButton1Click:Connect(onToggleActivated)
    toggleButton.TouchTap:Connect(onToggleActivated)

    local tabList = {}
    local toggles = {}

    local saveSettings = config.SaveSetting or false
    local toggleStates = {}

    local function ensureFolderExists()
        if not isfolder(SETTINGS_FOLDER) then
            makefolder(SETTINGS_FOLDER)
        end
    end

    local function loadToggleStates()
        ensureFolderExists()
        if isfile(SETTINGS_FILE) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(SETTINGS_FILE))
            end)
            if success and data then
                return data
            else
                warn("Failed to load toggle states: " .. tostring(data))
            end
        else
            warn("Settings file not found: " .. SETTINGS_FILE)
        end
        return {}
    end

    local function saveToggleStates()
        if saveSettings then
            ensureFolderExists()
            local success, err = pcall(function()
                writefile(SETTINGS_FILE, HttpService:JSONEncode(toggleStates))
            end)
            if not success then
                warn("Failed to save toggle states to file: " .. tostring(err))
            end
        end
    end

    local function loadBackgroundImage()
        ensureFolderExists()
        if isfile(BACKGROUND_FILE) then
            local success, data = pcall(function()
                return readfile(BACKGROUND_FILE)
            end)
            if success and data then
                print("Background file contents: " .. tostring(data))
                if data:match("^rbxassetid://%d+$") then
                    local success, asset = pcall(function()
                        return AssetService:GetAssetThumbnailAsync(data, Enum.ThumbnailType.Asset, Enum.ThumbnailSize.Size420x420)
                    end)
                    if success then
                        return data
                    else
                        warn("Failed to load background asset: " .. tostring(asset))
                    end
                else
                    warn("Invalid background image asset ID format: " .. tostring(data))
                end
            else
                warn("Failed to read background file: " .. tostring(data))
            end
        else
            warn("Background file not found: " .. BACKGROUND_FILE)
        end
        return ""
    end

    local function saveBackgroundImage(imageId)
        ensureFolderExists()
        local success, err = pcall(function()
            writefile(BACKGROUND_FILE, imageId)
        end)
        if not success then
            warn("Failed to save background image to file: " .. tostring(err))
        else
            print("Saved background image ID: " .. imageId)
        end
    end

    local function loadVideo()
        ensureFolderExists()
        if isfile(VIDEO_FILE) then
            local success, data = pcall(function()
                return readfile(VIDEO_FILE)
            end)
            if success and data then
                print("Video file contents: " .. tostring(data))
                if data:match("^rbxassetid://%d+$") then
                    local success, asset = pcall(function()
                        return AssetService:GetAssetThumbnailAsync(data, Enum.ThumbnailType.Asset, Enum.ThumbnailSize.Size420x420)
                    end)
                    if success then
                        return data
                    else
                        warn("Failed to load video asset: " .. tostring(asset))
                    end
                else
                    warn("Invalid video asset ID format: " .. tostring(data))
                end
            else
                warn("Failed to read video file: " .. tostring(data))
            end
        else
            warn("Video file not found: " .. VIDEO_FILE)
        end
        return ""
    end

    local function saveVideo(videoId)
        ensureFolderExists()
        local success, err = pcall(function()
            writefile(VIDEO_FILE, videoId)
        end)
        if not success then
            warn("Failed to save video to file: " .. tostring(err))
        else
            print("Saved video ID: " .. videoId)
        end
    end

    if saveSettings then
        toggleStates = loadToggleStates()
    end

    local backgroundImageId = loadBackgroundImage()
    if backgroundImageId ~= "" then
        local success, err = pcall(function()
            backgroundImage.Image = backgroundImageId
        end)
        if success then
            print("Applied background image: " .. backgroundImageId)
        else
            warn("Failed to apply background image: " .. tostring(err))
        end
    else
        warn("No valid background image ID found; using default (none).")
    end

    local videoId = loadVideo()
    if videoId ~= "" then
        local success, err = pcall(function()
            videoFrame.Video = videoId
            videoFrame.Visible = true
            videoFrame:Play()
        end)
        if success then
            print("Applied video: " .. videoId)
        else
            warn("Failed to apply video: " .. tostring(err))
            videoFrame.Visible = false
        end
    else
        warn("No valid video ID found; video not played.")
    end

    function window:CreateTab(tabConfig)
        local tab = {}
        local tabName = tabConfig.Name or "Tab"
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 110, 0, 40)
        tabButton.Position = UDim2.new(0, 10 + (#tabList * 120), 0, 10)
        tabButton.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.ZIndex = 12
        tabButton.Parent = tabsFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, -20, 1, -110)
        tabContent.Position = UDim2.new(0, 10, 0, 110)
        tabContent.BackgroundTransparency = 1
        tabContent.CanvasSize = UDim2.new(0, 0, 2, 0)
        tabContent.ScrollBarThickness = 5
        tabContent.ZIndex = 11
        tabContent.Parent = mainContent
        tabContent.Visible = false

        table.insert(tabList, {button = tabButton, content = tabContent})

        tabButton.MouseEnter:Connect(function()
            if tabButton.BackgroundColor3 ~= Color3.fromRGB(0, 123, 255) then
                tabButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if tabButton.BackgroundColor3 ~= Color3.fromRGB(0, 123, 255) then
                tabButton.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
            end
        end)

        local function switchTab()
            for _, tabData in ipairs(tabList) do
                tabData.content.Visible = false
                tabData.button.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
            end
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
        end

        tabButton.MouseButton1Click:Connect(switchTab)
        tabButton.TouchTap:Connect(switchTab)

        if #tabList == 1 then
            switchTab()
        end

        local yOffset = 0

        function tab:CreateToggle(toggleConfig)
            local toggle = {}
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 50)
            toggleFrame.Position = UDim2.new(0, 0, 0, yOffset)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.ZIndex = 11
            toggleFrame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleConfig.Name or "Toggle"
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 11
            label.Parent = toggleFrame

            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 50, 0, 25)
            toggleButton.Position = UDim2.new(0.85, 0, 0.25, 0)
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            toggleButton.Text = ""
            toggleButton.ZIndex = 11
            toggleButton.Parent = toggleFrame

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = UDim2.new(0, 2, 0, 2)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0
            toggleCircle.ZIndex = 11
            toggleCircle.Parent = toggleButton

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = toggleButton
            corner:Clone().Parent = toggleCircle

            local toggleFlag = toggleConfig.Flag or toggleConfig.Name or "UnnamedToggle"
            local isToggled = toggleStates[toggleFlag] or false

            if isToggled then
                toggleButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                toggleCircle.Position = UDim2.new(0.5, 2, 0, 2)
            else
                toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                toggleCircle.Position = UDim2.new(0, 2, 0, 2)
            end

            local isTweening = false

            local function toggle()
                if isTweening then return end
                isTweening = true
                isToggled = not isToggled

                local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local tween
                if isToggled then
                    toggleButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                    tween = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0.5, 2, 0, 2)})
                else
                    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    tween = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)})
                end
                tween:Play()
                tween.Completed:Connect(function()
                    if isToggled then
                        toggleButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                    else
                        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                    end
                    isTweening = false
                end)

                toggleStates[toggleFlag] = isToggled
                saveToggleStates()

                if toggleConfig.Callfunction then
                    if typeof(toggleConfig.Callfunction) == "function" then
                        local success, err = pcall(function()
                            toggleConfig.Callfunction(isToggled)
                        end)
                        if not success then
                            warn("Error calling Callfunction for toggle " .. tostring(toggleFlag) .. ": " .. tostring(err))
                        end
                    else
                        warn("Callfunction for toggle " .. tostring(toggleFlag) .. " is not a function, got: " .. typeof(toggleConfig.Callfunction))
                    end
                else
                    print("No Callfunction defined for toggle: " .. tostring(toggleFlag))
                end
            end

            toggleButton.MouseButton1Click:Connect(toggle)
            toggleButton.TouchTap:Connect(toggle)

            table.insert(toggles, {isToggled = isToggled, callfunction = toggleConfig.Callfunction})

            yOffset = yOffset + 60
            tabContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)

            return toggle
        end

        function tab:CreateButton(buttonConfig)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 140, 0, 50)
            button.Position = UDim2.new(0, 10, 0, yOffset)
            button.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
            button.Text = buttonConfig.Name or "Button"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.ZIndex = 11
            button.Parent = tabContent

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = button

            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(0, 86, 179)
            end)

            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
            end)

            local function activate()
                if buttonConfig.Callback then
                    if typeof(buttonConfig.Callback) == "function" then
                        local success, err = pcall(function()
                            buttonConfig.Callback()
                        end)
                        if not success then
                            warn("Error calling Callback for button " .. tostring(buttonConfig.Name) .. ": " .. tostring(err))
                        end
                    else
                        warn("Callback for button " .. tostring(buttonConfig.Name) .. " is not a function, got: " .. typeof(buttonConfig.Callback))
                    end
                else
                    print("No Callback defined for button: " .. tostring(buttonConfig.Name))
                end
            end

            button.MouseButton1Click:Connect(activate)
            button.TouchTap:Connect(activate)

            yOffset = yOffset + 60
            tabContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
        end

        function tab:CreateDropdown(dropdownConfig)
            local dropdown = {}
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, 50)
            dropdownFrame.Position = UDim2.new(0, 0, 0, yOffset)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.ZIndex = 11
            dropdownFrame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = dropdownConfig.Name or "Dropdown"
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 11
            label.Parent = dropdownFrame

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0, 100, 0, 25)
            dropdownButton.Position = UDim2.new(0.85, -50, 0.25, 0)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
            dropdownButton.Text = dropdownConfig.Default or "Select"
            dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdownButton.ZIndex = 11
            dropdownButton.Parent = dropdownFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = dropdownButton

            local dropdownList = Instance.new("ScrollingFrame")
            dropdownList.Size = UDim2.new(0, 100, 0, 0)
            dropdownList.Position = UDim2.new(0.85, -50, 0.25, 25)
            dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownList.BackgroundTransparency = 0
            dropdownList.Visible = false
            dropdownList.ScrollBarThickness = 5
            dropdownList.ZIndex = 11
            dropdownList.Parent = dropdownFrame

            local uiListLayout = Instance.new("UIListLayout")
            uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiListLayout.Parent = dropdownList

            local dropdownFlag = dropdownConfig.Flag or dropdownConfig.Name or "UnnamedDropdown"
            local selectedOption = toggleStates[dropdownFlag] or dropdownConfig.Default or "Select"

            dropdownButton.Text = selectedOption

            local function updateDropdownList()
                for _, child in ipairs(dropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                local listHeight = 0
                for i, option in ipairs(dropdownConfig.Options or {}) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, 0, 0, 25)
                    optionButton.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
                    optionButton.Text = tostring(option)
                    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    optionButton.ZIndex = 11
                    optionButton.Parent = dropdownList

                    local cornerOption = Instance.new("UICorner")
                    cornerOption.CornerRadius = UDim.new(0, 5)
                    cornerOption.Parent = optionButton

                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        dropdownButton.Text = selectedOption
                        toggleStates[dropdownFlag] = selectedOption
                        saveToggleStates()
                        dropdownList.Visible = false
                        if dropdownConfig.Callback then
                            if typeof(dropdownConfig.Callback) == "function" then
                                local success, err = pcall(function()
                                    dropdownConfig.Callback(selectedOption)
                                end)
                                if not success then
                                    warn("Error calling Callback for dropdown " .. tostring(dropdownFlag) .. ": " .. tostring(err))
                                end
                            else
                                warn("Callback for dropdown " .. tostring(dropdownFlag) .. " is not a function, got: " .. typeof(dropdownConfig.Callback))
                            end
                        end
                    end)

                    listHeight = listHeight + 25
                end

                dropdownList.CanvasSize = UDim2.new(0, 0, 0, listHeight)
                dropdownList.Size = UDim2.new(0, 100, 0, math.min(listHeight, 100))
            end

            updateDropdownList()

            dropdownButton.MouseButton1Click:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
            end)

            yOffset = yOffset + 60
            tabContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)

            return dropdown
        end

        function tab:CreateInput(inputConfig)
            local input = {}
            local inputFrame = Instance.new("Frame")
            inputFrame.Size = UDim2.new(1, 0, 0, 50)
            inputFrame.Position = UDim2.new(0, 0, 0, yOffset)
            inputFrame.BackgroundTransparency = 1
            inputFrame.ZIndex = 11
            inputFrame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = inputConfig.Name or "Input"
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 11
            label.Parent = inputFrame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0, 100, 0, 25)
            textBox.Position = UDim2.new(0.85, -50, 0.25, 0)
            textBox.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
            textBox.Text = inputConfig.Default or ""
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 11
            textBox.Parent = inputFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = textBox
            local inputFlag = inputConfig.Flag or inputConfig.Name or "UnnamedInput"
            textBox.Text = toggleStates[inputFlag] or inputConfig.Default or ""
            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    toggleStates[inputFlag] = textBox.Text
                    saveToggleStates()
                    if inputConfig.Callback then
                        if typeof(inputConfig.Callback) == "function" then
                            local success, err = pcall(function()
                                inputConfig.Callback(textBox.Text)
                            end)
                            if not success then
                                warn("Error calling Callback for input " .. tostring(inputFlag) .. ": " .. tostring(err))
                            end
                        else
                            warn("Callback for input " .. tostring(inputFlag) .. " is not a function, got: " .. typeof(inputConfig.Callback))
                        end
                    end
                end
            end)

            yOffset = yOffset + 60
            tabContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)

            return input
        end

        function tab:CreateSlider(sliderConfig)
            local slider = {}
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.Position = UDim2.new(0, 0, 0, yOffset)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.ZIndex = 11
            sliderFrame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 0, 25)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = sliderConfig.Name or "Slider"
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 11
            label.Parent = sliderFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 25)
            valueLabel.Position = UDim2.new(0.85, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.TextScaled = true
            valueLabel.ZIndex = 11
            valueLabel.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(0, 200, 0, 10)
            sliderBar.Position = UDim2.new(0, 10, 0, 30)
            sliderBar.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
            sliderBar.ZIndex = 11
            sliderBar.Parent = sliderFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 5)
            corner.Parent = sliderBar

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
            fill.ZIndex = 11
            fill.Parent = sliderBar

            local cornerFill = Instance.new("UICorner")
            cornerFill.CornerRadius = UDim.new(0, 5)
            cornerFill.Parent = fill

            local minValue = sliderConfig.Min or 0
            local maxValue = sliderConfig.Max or 100
            local defaultValue = sliderConfig.Default or minValue
            local sliderFlag = sliderConfig.Flag or sliderConfig.Name or "UnnamedSlider"

            local currentValue = toggleStates[sliderFlag] or defaultValue
            currentValue = math.clamp(currentValue, minValue, maxValue)

            local function updateSlider()
                local percentage = (currentValue - minValue) / (maxValue - minValue)
                fill.Size = UDim2.new(percentage, 0, 1, 0)
                valueLabel.Text = tostring(math.floor(currentValue))
                toggleStates[sliderFlag] = currentValue
                saveToggleStates()
                if sliderConfig.Callback then
                    if typeof(sliderConfig.Callback) == "function" then
                        local success, err = pcall(function()
                            sliderConfig.Callback(currentValue)
                        end)
                        if not success then
                            warn("Error calling Callback for slider " .. tostring(sliderFlag) .. ": " .. tostring(err))
                        end
                    else
                        warn("Callback for slider " .. tostring(sliderFlag) .. " is not a function, got: " .. typeof(sliderConfig.Callback))
                    end
                end
            end

            updateSlider()

            local dragging = false
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position.X
                    local sliderPos = sliderBar.AbsolutePosition.X
                    local sliderWidth = sliderBar.AbsoluteSize.X
                    local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
                    currentValue = minValue + (maxValue - minValue) * percentage
                    updateSlider()
                end
            end)

            yOffset = yOffset + 60
            tabContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)

            return slider
        end

        function tab:CreateBackgroundChanger()
            local changer = tab:CreateInput({
                Name = "Background Image ID",
                Flag = "BackgroundImage",
                Default = "",
                Callback = function(value)
                    if value:match("^rbxassetid://%d+$") then
                        local success, err = pcall(function()
                            backgroundImage.Image = value
                        end)
                        if success then
                            saveBackgroundImage(value)
                            videoFrame.Visible = false
                            print("Applied background image: " .. value)
                        else
                            warn("Failed to apply background image: " .. tostring(err))
                        end
                    else
                        warn("Invalid image asset ID format. Use rbxassetid://[Number]")
                    end
                end
            })
        end

        function tab:CreateDecalChanger()
            local changer = tab:CreateInput({
                Name = "Decal Item ID",
                Flag = "DecalItemID",
                Default = "",
                Callback = function(value)
                    if value:match("^%d+$") then
                        local success, imageId = pcall(function()
                            local assetInfo = game:GetService("MarketplaceService"):GetProductInfo(tonumber(value))
                            if assetInfo.AssetTypeId == 13 then
                                return "rbxassetid://" .. assetInfo.AssetId
                            else
                                return nil
                            end
                        end)
                        if success and imageId then
                            local applySuccess, applyErr = pcall(function()
                                backgroundImage.Image = imageId
                            end)
                            if applySuccess then
                                saveBackgroundImage(imageId)
                                videoFrame.Visible = false
                                print("Applied background from Decal Item ID: " .. imageId)
                            else
                                warn("Failed to apply background from Decal: " .. tostring(applyErr))
                            end
                        else
                            warn("Invalid Decal Item ID or not a Decal: " .. value)
                        end
                    else
                        warn("Invalid Decal Item ID format. Use [Number]")
                    end
                end
            })
        end

        function tab:CreateVideoChanger()
            local changer = tab:CreateInput({
                Name = "Video ID",
                Flag = "VideoID",
                Default = "",
                Callback = function(value)
                    if value:match("^rbxassetid://%d+$") then
                        local success, err = pcall(function()
                            videoFrame.Video = value
                            videoFrame.Visible = true
                            videoFrame:Play()
                        end)
                        if success then
                            saveVideo(value)
                            backgroundImage.Image = ""
                            print("Playing video: " .. value)
                        else
                            warn("Failed to play video: " .. tostring(err))
                            videoFrame.Visible = false
                        end
                    else
                        warn("Invalid video asset ID format. Use rbxassetid://[Number]")
                    end
                end
            })
        end

        return tab
    end

    for _, toggle in ipairs(toggles) do
        if toggle.isToggled and toggle.callfunction then
            if typeof(toggle.callfunction) == "function" then
                local success, err = pcall(function()
                    toggle.callfunction(true)
                end)
                if success then
                    print("Triggered Callfunction for toggle on load: " .. tostring(toggle.isToggled))
                else
                    warn("Error triggering Callfunction on load: " .. tostring(err))
                end
            else
                warn("Callfunction for toggle on load is not a function, got: " .. typeof(toggle.callfunction))
            end
        end
    end

    return window
end

return Gghiza07UI