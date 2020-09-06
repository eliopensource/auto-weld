local toolbar = plugin:CreateToolbar("Auto Weld")
    local ToggleBtn = toolbar:CreateButton("Toggle", "Toggle the plugin", "")

    local c = "weld"

    local selection = game:GetService("Selection")

    local mainFrame = script.Parent:WaitForChild("MainFrame"):Clone()
    local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 300, 150, 150)

    function weld(e, z)
        if c == "weld" then
            local CF = CFrame.new(e.Position)
            local created = Instance.new("ManualWeld")
            created.Part0 = e
            created.Part1 = z
            created.C0 = e.CFrame:inverse() * CF
            created.C1 = z.CFrame:inverse() * CF
            created.Parent = e
            return created
        elseif c == "weldconstraint" then
            local created = Instance.new("WeldConstraint")
            created.Part0 = e
            created.Part1 = z
            created.Parent = e
            return created
        end
    end

    local widget = plugin:CreateDockWidgetPluginGui("Weld Plugin", widgetInfo)
    widget.Title = "Weld Plugin"
    widget.Enabled = false

    ToggleBtn.Click:Connect(
        function()
            widget.Enabled = not widget.Enabled
        end
    )

    function getColor(g, style)
        style = style or Enum.StudioStyleGuideModifier.Default
        g = g or Enum.StudioStyleGuideColor.MainBackground
        return settings().Studio.Theme:GetColor(g, style)
    end

    function colorframes()
        mainFrame.BackgroundColor3 = getColor(Enum.StudioStyleGuideColor.MainBackground)
        for _, thign in pairs(mainFrame:GetChildren()) do
            if thign.Name == "Instruction" then
                thign.TextColor3 = getColor(Enum.StudioStyleGuideColor.TitlebarText)
            end
        end
        mainFrame:WaitForChild("Run").TextColor3 = getColor(Enum.StudioStyleGuideColor.ButtonText)
        mainFrame:WaitForChild("Run").BackgroundColor3 =
            getColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)
        mainFrame:WaitForChild("Weld").TextColor3 = getColor(Enum.StudioStyleGuideColor.ButtonText)
        mainFrame:WaitForChild("Weld").BackgroundColor3 =
            getColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)
        mainFrame:WaitForChild("WeldConstraint").TextColor3 = getColor(Enum.StudioStyleGuideColor.ButtonText)
        mainFrame:WaitForChild("WeldConstraint").BackgroundColor3 =
            getColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)
        mainFrame:WaitForChild("Title").TextColor3 = getColor(Enum.StudioStyleGuideColor.BrightText)
    end

    mainFrame:WaitForChild("Weld").MouseButton1Down:Connect(
        function()
            print("Weld")
            c = "weld"
        end
    )

    mainFrame:WaitForChild("WeldConstraint").MouseButton1Down:Connect(
        function()
            print("Weld Constraint")
            c = "weldconstraint"
        end
    )

    mainFrame:WaitForChild("Run").MouseButton1Down:Connect(
        function()
            print("Running")
            local selected = selection:Get()
            if #selected == 0 then
                warn("Nothing selected.")
                return
            elseif #selected < 2 then
                warn("Select a model and then the part to weld to.")
                return
            elseif #selected > 2 then
                warn("Select only two things.")
                return
            elseif selected[1].ClassName ~= "Model" then
                warn("First selection should be a model.")
                return
            end

            if selected[2]:IsA("BasePart") then
                --epic
            else
                warn("Second selection should be a part/mesh.")
                return
            end

            for _, thing in pairs(selected[1]:GetDescendants()) do
                if thing ~= selected[2] then
                    if thing:IsA("BasePart") then
                        print(thing.Name)
                        local w = weld(thing, selected[2])
                        w.Name = thing.Name .. " to " .. selected[2].Name
                    end
                end
            end
        end
    )

    settings().Studio.ThemeChanged:Connect(colorframes)

    colorframes()
    mainFrame.Parent = widget
