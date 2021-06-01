repeat wait() until game:IsLoaded()

local LB_MODULE = {}

do
	local getService = function(name)
		repeat wait() until game:GetService(name) ~= nil
		return game:GetService(name)
	end
	
	local sendNotification = function(title, content)
		getService('StarterGui'):SetCore('SendNotification', {
			Title = title or 'No Title';
			Text = content or 'No Content';
		})
	end
	
	local Main = {
		Services = {
			['CoreGui'] = getService('CoreGui');
			['Players'] = getService('Players');
			['ReplicatedStorage'] = getService('ReplicatedStorage');
			['RunService'] = getService('RunService');
			['UserInputService'] = getService('UserInputService');
			['Workspace'] = getService('Workspace');
		};
	
		REQUIRED = {
			['getgenv'] = pcall(function()return getgenv end) and getgenv;
			-- ['Drawing'] = pcall(function()return Drawing end) and Drawing;
		};
	
		MISSING = {};
	
		COLOR = {
			WINDOW = Color3.fromRGB(40,40,40);
			WINDOW_CLOSED = Color3.fromRGB(80, 0, 140);
			WINDOW_OPENED = Color3.fromRGB(0, 0, 140);
			TEXT = Color3.fromRGB(180,180,180);
			BUTTONBG = Color3.fromRGB(60,60,60);
			BUTTONTEXT = Color3.fromRGB(180,180,180);
			SELECTEDBG = Color3.fromRGB(80,80,80);
			SELECTEDTEXT = Color3.fromRGB(200,200,200);
			TITLEBAR = Color3.fromRGB(30,30,30);
		}
	}

	for a,b in next, Main.REQUIRED do
		if not b then
			table.insert(Main.MISSING, a)
		end
	end

	if #Main.MISSING ~= 0 then
		sendNotification('[UI LIB] Missing Feature(s)', table.concat(Main.MISSING, ', '))
		script:Destroy()
		return nil
	end

	if getgenv().LBConnections and typeof(getgenv().LBConnections) == 'table' then
		for a,b in next, getgenv().LBConnections do
			b:Disconnect()
		end
	end

	for a,b in next, Main.Services.CoreGui:children() do
		if string.find(b.Name, 'LB UI Library') then
			b:Destroy()
		end
	end

	if getgenv().UILibrary_Loading then return nil end
	getgenv().UILibrary_Loading = true

	if Drawing then
		local draw = Drawing.new('Square')
		draw.Size = Vector2.new(0,0)
		draw.Color = Color3.fromRGB(20,20,20)
		draw.Transparency = 1
		draw.Filled = true
		draw.Visible = true
		for i=0,100,1 do
			Main.Services.RunService.RenderStepped:wait()
			draw.Position = Vector2.new(
				(workspace.CurrentCamera.ViewportSize.X / 2) - i,
				(workspace.CurrentCamera.ViewportSize.Y / 2) - i
			)
			draw.Size = Vector2.new(draw.Size.X+2,draw.Size.Y+2)
		end

		draw.Transparency = 1
		local text = Drawing.new('Text')
		text.Text = 'NitroRBW3 GUI\n\n\n\n By: Roblox Script'
		text.Center = true
		text.Color = Color3.fromRGB(255,255,255)
		text.Size = 30
		text.Position = Vector2.new(
			(workspace.CurrentCamera.ViewportSize.X / 2),
			(workspace.CurrentCamera.ViewportSize.Y / 2)-92
		)
		text.Transparency = 0
		text.Visible = true
		for i=0,1,.01 do
			Main.Services.RunService.RenderStepped:wait()
			text.Transparency = i
		end
		text.Transparency = 1
		wait(1)
		for i=1,0,-.01 do
			Main.Services.RunService.RenderStepped:wait()
			text.Transparency = i
		end
		for i=100,0,-1 do
			Main.Services.RunService.RenderStepped:wait()
			draw.Position = Vector2.new(
				(workspace.CurrentCamera.ViewportSize.X / 2) - i,
				(workspace.CurrentCamera.ViewportSize.Y / 2) - i
			)
			draw.Size = Vector2.new(draw.Size.X-2,draw.Size.Y-2)
		end
		draw:Remove()
		text:Remove()
	end

	getgenv().UILibrary_Loading = false

	Main.GUI = Instance.new('ScreenGui', Main.Services.CoreGui)
	Main.GUI.Name = 'LB UI Library' .. getService('HttpService'):GenerateGUID()
	sendNotification('Loading...', '')
	wait(9)
	sendNotification('UI Loaded!', 'Enjoy!!')

	function LB_MODULE:Create(window, instance, props)
		local a = Instance.new(instance)
		for b,c in next, props do
			if b ~= 'Parent' then
				pcall(function()a[b]=c;end)
				pcall(function()a['BorderSizePixel']=0;end)
				pcall(function()a['ZIndex']=0;end)
			end
		end

		if window then
			a.Parent = window
		else
			a.Parent = Main.GUI
		end

		return a
	end

	local windowPos = 0
	getgenv().LBConnections = {}

	local windowMoving = false
	local currentWindow = nil
	local windowFocused = false
	local sliderFocused = false
	local sliderMoving = false
	local selectionOpened = false
	local mouseDown = false

	table.insert(getgenv().LBConnections,
		Main.Services.UserInputService.InputEnded:connect(function(key)
			if key.UserInputType == Enum.UserInputType.MouseButton1 then
				mouseDown = false
			end
		end)
	)

	function LB_MODULE:AddWindow(title)
		local height = 40
		local transition = false
		local closed = false
		local window = self:Create(nil, 'Frame', {
			AnchorPoint = Vector2.new(0,0);
			BackgroundColor3 = Main.COLOR.WINDOW;
			Position = UDim2.new(0,windowPos,0,0);
			Size = UDim2.new(0,200,0,height);
			ZIndex = 0;
		})

		self:Create(window, 'Frame', {
			BackgroundColor3 = Main.COLOR.TITLEBAR;
			Position = UDim2.new(0,0,0,0);
			Size = UDim2.new(1,0,0,25);
		})

		table.insert(getgenv().LBConnections,
			Main.Services.UserInputService.InputBegan:connect(function(key)
				if window ~= nil then
					if key.KeyCode == Enum.KeyCode.F1 then
						window.Visible = not window.Visible
					elseif key.UserInputType == Enum.UserInputType.MouseButton1 then
						mouseDown = true
					end
				end
			end)
		)

		
		windowPos = windowPos + 250
		
		self:Create(window, 'TextLabel', {
			BackgroundTransparency = 1;
			Position = UDim2.new(.5,0,0,1);
			TextColor3 = Main.COLOR.TEXT;
			TextSize = 14;
			TextXAlignment = 2;
			TextYAlignment = 0;
			Text = title or 'Untitled';
		})
		
		------------------

		local rBtn = self:Create(window, 'ImageButton', {
			BackgroundTransparency = 1;
			Image = 'rbxthumb://type=Asset&id=4693046251&w=150&h=150';
			ImageTransparency = 0;
			Position = UDim2.new(0,29,0,5);
			Size = UDim2.new(0,10,0,10);
			ScaleType = Enum.ScaleType.Fit;
			Text = '';
			TextColor3 = Main.COLOR.TEXT
		})

		rBtn.MouseButton1Click:connect(function()
			if currentWindow == window then
				if #Main.GUI:children() == 1 then
					currentWindow = nil
					Main.GUI:Destroy()
					script:Destroy()
				end
				pcall(function()
					windowPos = windowPos - 250
					if connection then
						pcall(function()
							for a,b in next, getgenv().LBConnections do
								if b == connection then
									table.remove(getgenv().LBConnections, a)
									connection:Disconnect()
								end
							end
						end)
					end
					currentWindow = nil
					window:Destroy()
				end)
			end
		end)

		------------------

		local gBtn = self:Create(window, 'ImageButton', {
			BackgroundTransparency = 1;
			Image = 'rbxthumb://type=Asset&id=4693044547&w=150&h=150';
			ImageTransparency = 0;
			Position = UDim2.new(0,5,0,5);
			Size = UDim2.new(0,10,0,10);
			ScaleType = Enum.ScaleType.Fit;
			Text = '';
			TextColor3 = Main.COLOR.TEXT
		})

		gBtn.MouseButton1Click:connect(function()
			if currentWindow == window then
				if not transition then
					if closed then
						transition = true
						closed = false
						for i=25,height,4 do
							Main.Services.RunService.Heartbeat:wait()
							window.Size = UDim2.new(0,200,0,i)
						end
						window.ClipsDescendants = false
						window.Size = UDim2.new(0,200,0,height)
						transition = false
					end
				end
			end
		end)

		------------------

		local oBtn = self:Create(window, 'ImageButton', {
			BackgroundTransparency = 1;
			Image = 'rbxthumb://type=Asset&id=4693046726&w=150&h=150';
			ImageTransparency = 0;
			Position = UDim2.new(0,17.8,0,5);
			Size = UDim2.new(0,10,0,10);
			ScaleType = Enum.ScaleType.Fit;
			Text = '';
			TextColor3 = Main.COLOR.TEXT
		})

		oBtn.MouseButton1Click:connect(function()
			if currentWindow == window then
				if not transition then
					if not closed then
						transition = true
						window.ClipsDescendants = true
						closed = true
						for i=height,25,-4 do
							Main.Services.RunService.Heartbeat:wait()
							window.Size = UDim2.new(0,200,0,i)
						end
						window.Size = UDim2.new(0,200,0,25)
						transition = false
					end
				end
			end
		end)

		------------------

		window.MouseMoved:connect(function()
			if not currentWindow and not selectionOpened then
				for a,b in next, window:children() do
					if b.ClassName ~= 'ScrollingFrame' then
						pcall(function()b.ZIndex = 1;end)
						pcall(function()b.Frame.ZIndex = 1;end)
						pcall(function()b.TextLabel.ZIndex = 1;end)
						pcall(function()b.TextButton.ZIndex = 1;end)
					end
				end
				window.ZIndex = 1
				currentWindow = window
				windowFocused = true
			end
		end)

		------------------
		
		window.MouseLeave:connect(function()
			if currentWindow == window then
				windowFocused = false
			end
			if currentWindow == window and not windowMoving and not sliderMoving and not selectionOpened then
				for a,b in next, window:children() do
					if b.ClassName ~= 'ScrollingFrame' then
						pcall(function()b.ZIndex = 0;end)
						pcall(function()b.Frame.ZIndex = 0;end)
						pcall(function()b.TextLabel.ZIndex = 0;end)
						pcall(function()b.TextButton.ZIndex = 0;end)
					end
				end
				window.ZIndex = 0
				currentWindow = nil
				windowFocused = false
			end
		end)

		------------------

		window.InputBegan:connect(function(key)
			if window == currentWindow then
				if not sliderFocused then
					local mouse = Main.Services.Players.LocalPlayer:GetMouse()
					local mb1 = Enum.UserInputType.MouseButton1
					local m = {
						x = 0;
						y = 0;
					}
					if key.UserInputType == mb1 then
						windowMoving = true
						local as = window.AbsolutePosition
						local pos = Vector2.new(mouse.X-as.X,mouse.Y-as.Y)
						while Main.Services.RunService.Heartbeat:wait() and Main.Services.UserInputService:IsMouseButtonPressed(mb1) and currentWindow == window do
							local obj = {
								mouse.X-pos.X,
								window.Size.X.Offset*window.AnchorPoint.X,
								mouse.Y-pos.Y,
								window.Size.Y.Offset*window.AnchorPoint.Y
							}
							if m.X ~= mouse.X or m.Y ~= mouse.Y then
								window:TweenPosition(
									UDim2.new(
										0,
										obj[1]+obj[2],
										0,
										obj[3]+obj[4]
									),
									'Out', 'Quad', .2,
									true
								)
							end
							m.X = mouse.X
							m.Y = mouse.Y
						end
						windowMoving = false
					end
				end
			end
		end)

		------------------

		local windowModule = {}
		function windowModule:Label(text)
			if not text or typeof(text) ~= 'string' then
				return sendNotification('Invalid Text!', 'You must set the text as a string for this button!')
			end
			LB_MODULE:Create(window, 'TextLabel', {
				Position = UDim2.new(.5,0,0,height-10);
				TextSize = 10;
				TextXAlignment = 2;
				TextYAlignment = 0;
				Text = text or 'Untitled';
				TextColor3 = Main.COLOR.TEXT;
			})

			height = height + 20
			window.Size = UDim2.new(0,200,0,height)
			return windowModule
		end

		------------------

		function windowModule:Button(text, callback)
			if not text or typeof(text) ~= 'string' then
				return sendNotification('Invalid Text!', 'You must set the text as a string for this button!')
			end
			if not callback or typeof(callback) ~= 'function' then
				return sendNotification('Invalid Callback!', 'You must set the callback as a function for this button: ' .. text)
			end
			local btn = LB_MODULE:Create(window, 'TextButton', {
				BackgroundColor3 = Main.COLOR.BUTTONBG;
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0, 180, 0, 20);
				Text = text or 'Untitled';
				TextColor3 = Main.COLOR.BUTTONTEXT;
				TextXAlignment = 2;
				TextYAlignment = 1;
			})

			btn.MouseButton1Click:connect(function()
				if window == currentWindow then
					callback()
				end
			end)

			height = height + 20
			window.Size = UDim2.new(0,200,0,height)
			return windowModule
		end

		------------------

		function windowModule:Toggle(text, callback)
			if not text or typeof(text) ~= 'string' then
				return sendNotification('Invalid Text!', 'You must set the text as a string for this toggle!')
			end
			if not callback or typeof(callback) ~= 'function' then
				return sendNotification('Invalid Callback!', 'You must set the callback as a function for this toggle: ' .. title)
			end

			local btn = LB_MODULE:Create(window, 'TextButton', {
				BackgroundColor3 = Color3.fromRGB(140,0,0);
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0, 180, 0, 20);
				Text = text or 'Untitled';
				TextColor3 = Main.COLOR.BUTTONTEXT;
				TextXAlignment = 2;
				TextYAlignment = 1;
			})

			btn.MouseButton1Click:connect(function()
				if window == currentWindow then
					btn.BackgroundColor3 = btn.BackgroundColor3 == Color3.fromRGB(140,0,0) and Color3.fromRGB(0,140,0) or Color3.fromRGB(140,0,0)
					callback()
				end
			end)

			height = height + 20
			window.Size = UDim2.new(0,200,0,height)
			return windowModule
		end

		------------------

		function windowModule:Selection(title, options)
			if not title or typeof(title) ~= 'string' then
				return sendNotification('Invalid Title!', 'You must set the title as a string for this selection!')
			end
			if not options or typeof(options) ~= 'table' then
				return sendNotification('Invalid Options!', 'You must set the options as a table for this selection: ' .. title)
			end
			
			if #options == 0 then
				table.insert(options, '')
			end
			
			local opts = {selected=tostring(options[1]), index=1}
			LB_MODULE:Create(window, 'TextLabel', {
				Position = UDim2.new(.5,0,0,height);
				Text = tostring(title or '');
				TextSize = 8;
				TextXAlignment = 2;
				TextYAlignment = 1;
				TextColor3 = Main.COLOR.TEXT;
			})

			height = height + 20

			local labelWindow = LB_MODULE:Create(window, 'Frame', {
				BackgroundColor3 = Main.COLOR.SELECTEDBG;
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0, 180, 0, 20);
			})

			local label = LB_MODULE:Create(labelWindow, 'TextLabel', {
				Position = UDim2.new(.5,0,0,0);
				TextSize = 10;
				TextXAlignment = 2;
				TextYAlignment = 0;
				Text = tostring(options[1]);
				TextColor3 = Main.COLOR.SELECTEDTEXT;
			})


			local selectionHeight = 0
			local _transition = false
			local closed = true

			local selectionWindow = LB_MODULE:Create(window, 'ScrollingFrame', {
				BackgroundColor3 = Color3.fromRGB(60,60,60);
				Position = UDim2.new(0,10,0,height+10);
				Size = UDim2.new(0, 180, 0, 0);
				Visible = false;
			})
			selectionWindow.ZIndex = 100

			selectionWindow.ChildAdded:connect(function()
				selectionWindow.CanvasSize = UDim2.new(0,180,0,selectionHeight+20)
			end)

			local sBtn = LB_MODULE:Create(labelWindow, 'TextButton', {
				BackgroundTransparency = 1;
				Size = UDim2.new(0,20,0,20);
				Position = UDim2.new(1,-20,0,0);
				Text = 'v';
				TextColor3 = Main.COLOR.BUTTONTEXT;
			})

			local lostFocusEvent = nil

			local closeFunc = function()
				if closed then
					selectionOpened = true
					sBtn.Text = '^'
					selectionWindow.Visible = true
					for i = 0, selectionHeight >= 140 and 140 or selectionHeight, 5 do
						Main.Services.RunService.RenderStepped:wait()
						selectionWindow.Size = UDim2.new(0, 180, 0, i)
					end
					selectionWindow.Size = UDim2.new(0, 180, 0, selectionHeight >= 140 and 140 or selectionHeight)
					closed = false
				elseif not closed then
					selectionOpened = false
					sBtn.Text = 'v'
					if lostFocusEvent then
						lostFocusEvent:Disconnect()
						lostFocusEvent = nil
					end

					for i = selectionHeight >= 140 and 140 or selectionHeight,0, -5 do
						Main.Services.RunService.RenderStepped:wait()
						selectionWindow.Size = UDim2.new(0, 180, 0, i)
					end
					selectionWindow.Size = UDim2.new(0, 180, 0, 0)
					selectionWindow.Visible = false
					closed = true
				end
				return true
			end

			sBtn.MouseButton1Click:connect(function()
				if window == currentWindow and not _transition then
					_transition = true
					if closed then
						selectionOpened = true
						lostFocusEvent = selectionWindow.MouseLeave:connect(function()
							if not _transition then
								_transition = true
								closeFunc()
								selectionOpened = false
								_transition = false
								if not windowFocused then
									for a,b in next, window:children() do
										if b.ClassName ~= 'ScrollingFrame' then
											pcall(function()b.ZIndex = 0;end)
											pcall(function()b.Frame.ZIndex = 0;end)
											pcall(function()b.TextLabel.ZIndex = 0;end)
											pcall(function()b.TextButton.ZIndex = 0;end)
										end
									end
									window.ZIndex = 0
									currentWindow = nil
								end
							end
						end)
					else
						selectionOpened = false
					end
					
					closeFunc()
					_transition = false
				end
			end)

			for a,b in next, options do
				local btn = LB_MODULE:Create(selectionWindow, 'TextButton', {
					BackgroundColor3 = Main.COLOR.BUTTONBG;
					Position = UDim2.new(0,0,0,selectionHeight);
					Size = UDim2.new(0, 160, 0, 20);
					Text = tostring(b);
					TextColor3 = Main.COLOR.TEXT;
					TextYAlignment = 1;
					TextXAlignment = 2;
				})
				btn.MouseButton1Click:connect(function()
					if not _transition then
						label.Text = tostring(b)
						opts.index = tonumber(a)
						opts.selected = tostring(b)
						closeFunc()
					end
				end)
				btn.ZIndex = 100;
				selectionHeight = selectionHeight + 20
			end

			height = height + 20
			window.Size = UDim2.new(0,200,0,height)
			return opts
		end

		------------------

		function windowModule:Slider(title, minValue, maxValue, callback)
			if not title or typeof(title) ~= 'string' then
				return sendNotification('Invalid Title!', 'You must set a title as a string for this slider!')
			end
			if (callback and typeof(callback) ~= 'function') then
				return sendNotification('Invalid Callback!', 'You must set a callback as a function for this slider: ' .. title)
			end
			if not maxValue then maxValue = 100 end
			if not minValue then minValue = 0 end
			if maxValue and typeof(maxValue) ~= 'number' then maxValue = 100 end
			if maxValue < 0 then maxValue = 100 end
			if minValue and typeof(minValue) ~= 'number' then minValue = 0 end
			if minValue < 0 then minValue = 0 end
			minValue = math.floor(minValue)
			maxValue = math.floor(maxValue)
			local tbl = {value=minValue;}
			local frame = LB_MODULE:Create(window, 'Frame', {
				BackgroundColor3 = Color3.fromRGB(75,75,75);
				Position = UDim2.new(0,10,0,height+5);
				Size = UDim2.new(0,180,0,20);
			})

			local cursor = LB_MODULE:Create(frame, 'Frame', {
				BackgroundColor3 = Color3.fromRGB(180,180,180);
				Position = UDim2.new(0,0,0,5);
				Size = UDim2.new(0,10,0,10);
			})
			
			local numValue = LB_MODULE:Create(frame, 'TextLabel', {
				BackgroundTransparency = 1;
				Position = UDim2.new(.5,0,0,5);
				Text = tostring(minValue);
				TextColor3 = Color3.fromRGB(255,255,255);
				TextYAlignment = 0;
			})

			local aaa = LB_MODULE:Create(window, 'TextLabel', {
				BackgroundTransparency = 1;
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0,180,0,20);
				Text = title;
				TextColor3 = Color3.fromRGB(255,255,255);
				TextXAlignment = 0;
				TextYAlignment = 0;
			})

			frame.InputBegan:connect(function()
				if not windowMoving and not sliderMoving and currentWindow == window and not mouseDown then
					local mouse = Main.Services.Players.LocalPlayer:GetMouse()
					local mouseAxis = {['x']=0;['y']=0;}
					local AbsolutePos = Vector2.new(
						frame.AbsolutePosition.X,
						frame.AbsolutePosition.Y
					)
					if not sliderMoving then
						while Main.Services.RunService.Heartbeat:wait() and Main.Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							sliderMoving = true
							if mouseAxis.x ~= mouse.X then
								local pos = nil;
								if mouse.X >= (AbsolutePos.X + 170) then
									pos=UDim2.new(0,170,0,5)
								elseif mouse.X <= AbsolutePos.X then
									pos=UDim2.new(0,0,0,5)
								else
									pos=UDim2.new(0,mouse.X-AbsolutePos.X,0,5)
								end
								cursor:TweenPosition(pos, 'Out', 'Quad', .2, true)
							end
							mouseAxis.x = mouse.X
						end
						sliderMoving = false
					end
				end
			end)

			------------------

			cursor:GetPropertyChangedSignal('Position'):connect(function()
				numValue.Text = tostring(
					math.clamp(
							math.floor(
							(
								(cursor.Position.X.Offset)
							/
								((frame.AbsoluteSize.X)-10)
							) * maxValue
						),
						minValue,
						maxValue
					)
				)
			end)

			numValue:GetPropertyChangedSignal('Text'):connect(function(property)
				tbl.value = tonumber(numValue.Text)
				if callback then
					callback(tonumber(numValue.Text))
				end
			end)

			frame.MouseEnter:connect(function()
				sliderFocused = true
			end)

			frame.MouseLeave:connect(function()
				sliderFocused = false
			end)

			height = height + 35
			window.Size = UDim2.new(0,200,0,height)

			return tbl
		end

		------------------

		function windowModule:Text(placeholderText)
			local tbl = {Text = ''}
			local txtBox = LB_MODULE:Create(window, 'TextBox', {
				BackgroundColor3 = Color3.fromRGB(150,150,150);
				ClearTextOnFocus = false;
				PlaceholderColor3 = Color3.fromRGB(255,255,255);
				PlaceholderText = placeholderText or '';
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0, 180, 0, 20);
				Text = '';
				TextColor3 = Color3.fromRGB(40,40,40);
			})

			txtBox.Changed:connect(function()
				tbl.Text = txtBox.Text
			end)

			height = height + 20
			window.Size = UDim2.new(0,200,0,height)

			return tbl
		end

		------------------

		function windowModule:KeyBind(title, key, callback)
			if not title or typeof(title) ~= 'string' then
				return sendNotification('Invalid Title!', 'You must set the title as a string for this keybind!')
			end

			if not pcall(function() return Enum.KeyCode[key] end) then
				return sendNotification('Invalid KeyCode!', 'You cannot set `'..tostring(key)..'` as a keybind!')
			end

			local keyCode = nil
			for a,b in next, Enum.KeyCode:GetEnumItems() do
				if tostring(b) == string.format('Enum.KeyCode.%s', key) then
					keyCode = b
					break
				end
			end

			if not callback or typeof(callback) ~= 'function' then
				return sendNotification('Invalid Callback!', 'You must set the callback function for this keybind: ' .. key)
			end

			table.insert(getgenv().LBConnections,
				Main.Services.UserInputService.InputBegan:connect(function(key)
					if key.KeyCode == keyCode then
						callback()
					end
				end)
			)

			LB_MODULE:Create(window, 'TextLabel', {
				BackgroundTransparency = 1,
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0,180,0,20),
				TextSize = 10;
				TextXAlignment = 0;
				TextYAlignment = 0;
				Text = string.format('%s', title);
				TextColor3 = Main.COLOR.TEXT;
			})

			LB_MODULE:Create(window, 'TextLabel', {
				BackgroundTransparency = 1,
				Position = UDim2.new(0,10,0,height-10);
				Size = UDim2.new(0,180,0,20),
				TextSize = 10;
				TextXAlignment = 1;
				TextYAlignment = 0;
				Text = string.format('[%s]', key);
				TextColor3 = Main.COLOR.TEXT;
			})

			height = height + 20
			window.Size = UDim2.new(0,200,0,height)

			return window
		end

		------------------

		function windowModule:GUIDestroy()
			for a,b in next, getgenv().LBConnections do
				b:Disconnect()
			end
			script:Destroy()
			Main.GUI:Destroy()
		end

		return windowModule
	end
end

wait(1)
local DiscordLib =
    loadstring(game:HttpGet "https://pastebin.com/raw/77UNR1q7")()

local FLOP = DiscordLib:Window("Rbw3 NitroHub By: Roblox Scripts")


local serv = FLOP:Server("NitroHub", "")

local btns = serv:Channel("Main")

btns:Button(
    "HitBox",
    function()
    --[[
IronBrew:tm: obfuscation; Version 2.7.2
]]
return(function(IllIIllllIlIlIlIIIIlIllI,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl)local IIlIllll=string.char;local IIllllIlllIlll=string.sub;local lIlIlIllIIIllIIIllI=table.concat;local IlllIlIlllllllIIIllllIlll=math.ldexp;local IllllIlIlllIllIl=getfenv or function()return _ENV end;local lIlllIIIIlIIlllIlI=select;local lIIIlIlIlIlIlIlll=unpack or table.unpack;local llllllIlIllIIlllI=tonumber;local function llIllIIll(lIIlIlIlIIllIlllllI)local lIIllIIlIlIIl,IIlIIllIIIl,IIlIlIlIllIIlIIII="","",{}local IIllIIlIIlIlllIIlIIIlIIII=256;local lIIIlIlIlIlIlIlll={}for IlIlllIIllIlllIlIlIl=0,IIllIIlIIlIlllIIlIIIlIIII-1 do lIIIlIlIlIlIlIlll[IlIlllIIllIlllIlIlIl]=IIlIllll(IlIlllIIllIlllIlIlIl)end;local IlIlllIIllIlllIlIlIl=1;local function llIlIIIIIlIlllllIlllIIlII()local lIIllIIlIlIIl=llllllIlIllIIlllI(IIllllIlllIlll(lIIlIlIlIIllIlllllI,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl),36)IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl+1;local IIlIIllIIIl=llllllIlIllIIlllI(IIllllIlllIlll(lIIlIlIlIIllIlllllI,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl+lIIllIIlIlIIl-1),36)IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl+lIIllIIlIlIIl;return IIlIIllIIIl end;lIIllIIlIlIIl=IIlIllll(llIlIIIIIlIlllllIlllIIlII())IIlIlIlIllIIlIIII[1]=lIIllIIlIlIIl;while IlIlllIIllIlllIlIlIl<#lIIlIlIlIIllIlllllI do local IlIlllIIllIlllIlIlIl=llIlIIIIIlIlllllIlllIIlII()if lIIIlIlIlIlIlIlll[IlIlllIIllIlllIlIlIl]then IIlIIllIIIl=lIIIlIlIlIlIlIlll[IlIlllIIllIlllIlIlIl]else IIlIIllIIIl=lIIllIIlIlIIl..IIllllIlllIlll(lIIllIIlIlIIl,1,1)end;lIIIlIlIlIlIlIlll[IIllIIlIIlIlllIIlIIIlIIII]=lIIllIIlIlIIl..IIllllIlllIlll(IIlIIllIIIl,1,1)IIlIlIlIllIIlIIII[#IIlIlIlIllIIlIIII+1],lIIllIIlIlIIl,IIllIIlIIlIlllIIlIIIlIIII=IIlIIllIIIl,IIlIIllIIIl,IIllIIlIIlIlllIIlIIIlIIII+1 end;return table.concat(IIlIlIlIllIIlIIII)end;local llIlIIIIIlIlllllIlllIIlII=llIllIIll('22L22327522321V2761221121K21R21621121421A22322027621121A21O22322J276191Y21121B21621521321A1D21Q27F21R1Y2102112772761421127A21P2101W27H22727621821621227H21T2761O27D21L21R21A21L1C21Q1Y22322428M21A21R1821021L27H27P2751O21A27T152102822191Y2142162822842232262761V1Y21R27X22322B2761P1922Z1S29221321B22Z23C22Z1921621321322Z1E21F28Q27T28R22328F2751V21A2A922323F27Q21E22Z1A21E21R22W23723I23E23H22Z1Z21R21R21N21K23522S22S21B1Y21K21429221B22T21821822S1X111Z16151621Q22Z1D29222Z1629221A22T2AD2792B82852762752782751F21Q21L29G2832112222BY27522N1B286275182A42132152162141W28W2761R21321621E28R21K22321S2761721029F2132CO2CQ2AC2C02231C28Z2BQ21Q21K27H28X2751021A21E1F21021O2852DC2232BW27L21421R27J2C92C92222C827622I2762DV22321Y2BY2DZ21M2BU27528H28J22321U27629W21L1W21K21N2CJ27H21X2762D621R1F21A2B729827U21121R2CT29K2752EG1Y21L2CT2AE2231528I28K27Q21621K28D21R2CI2A52E52231O1Y21D2DB2761T21A2DP29223C27I27K27M2DZ27622B2CC21Z29L2C427B2EG29327F21E2222192G52G624T2382E222A2762312EJ27527J2C82C82272DR2FP2GI2GK29R2C822H28L2C822127622Z28X2GH2FP22Z2752GX2F12232GS2232GT22H2752GT2EV2BY2GG2DS2GT2GT28F2H22742C822Z2CV28X2252232HN2312EA28X2HI2CM2GJ2762HT2GQ2CM2EA27522Z22R2CM28X28L2H72862CV2752I72EA2I92232I728L2ID2762I52H527O2752HN27828X2AK2HO2232FW2E12252H72GT2CV2H42HV2752IY2752DX2H02762E12DY2762192FD2E727H2I02232EC2EE2EG27G2232GE2D528Z2EN2EP27T27E2ET29J2762EX2EZ2FD2F32E828L2752A32F828Z2FB2132FD2FF2FH2CM2752FK2FM21L2FO2GK27L21O22223Q23R2KL2KL25B2G92FW2AF2FY2EF2162G12142G32DS2572G92DY2GB2752HQ2FT2H32L62J029Q2L62HY2H42I12GW2L627J2GZ2L62GI2E22IK2H62H82JT2C92HC2C92HE2BU2HH2L62HK2CM2HN2HP2EJ28X2EJ2C828X2L82M22AD2GK2HX28L28X2JE2I22I42232I62BZ2CU2762IB2MI2IA2752IG2DS2IJ2GT2952IN2CM2IQ2HN2IT2HO2IW2MF2L62HF2GK2GR2J32J827623327622122D2DS2IE2J52DZ2LH2GX2LM2IK2GK2J82LS2952LJ2MM2IK2HA2LH2LS2HN2NS2IK28X2I728F2D42762HA29K23F2FW29K2EA28L23F2292JT2CV2FW2IQ29K2E12EJ2OE22321W2IL29529K2DX2FS2H92LA2LN2NR2LN2LM2NV2GT22G2232OW22322N2BY2LS2GT2LW27J2GT22M2OZ28F27J27J2742NA2JT2FS2282FP29K2GP2GF2LO2OZ2PM27J2H72LH2PC2232OY2PS2FP2P22762P72IK2LH2PB2232P92Q22BU2PE2NB2HN2GT27627828F2HN2DV2J42L6275');local IlIlllIIllIlllIlIlIl=(bit or bit32);local IIllIIlIIlIlllIIlIIIlIIII=IlIlllIIllIlllIlIlIl and IlIlllIIllIlllIlIlIl.bxor or function(IlIlllIIllIlllIlIlIl,lIIllIIlIlIIl)local IIlIIllIIIl,IIllIIlIIlIlllIIlIIIlIIII,IIllllIlllIlll=1,0,10 while IlIlllIIllIlllIlIlIl>0 and lIIllIIlIlIIl>0 do local IIlIlIlIllIIlIIII,IIllllIlllIlll=IlIlllIIllIlllIlIlIl%2,lIIllIIlIlIIl%2 if IIlIlIlIllIIlIIII~=IIllllIlllIlll then IIllIIlIIlIlllIIlIIIlIIII=IIllIIlIIlIlllIIlIIIlIIII+IIlIIllIIIl end IlIlllIIllIlllIlIlIl,lIIllIIlIlIIl,IIlIIllIIIl=(IlIlllIIllIlllIlIlIl-IIlIlIlIllIIlIIII)/2,(lIIllIIlIlIIl-IIllllIlllIlll)/2,IIlIIllIIIl*2 end if IlIlllIIllIlllIlIlIl<lIIllIIlIlIIl then IlIlllIIllIlllIlIlIl=lIIllIIlIlIIl end while IlIlllIIllIlllIlIlIl>0 do local lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl%2 if lIIllIIlIlIIl>0 then IIllIIlIIlIlllIIlIIIlIIII=IIllIIlIIlIlllIIlIIIlIIII+IIlIIllIIIl end IlIlllIIllIlllIlIlIl,IIlIIllIIIl=(IlIlllIIllIlllIlIlIl-lIIllIIlIlIIl)/2,IIlIIllIIIl*2 end return IIllIIlIIlIlllIIlIIIlIIII end local function IIlIIllIIIl(IIlIIllIIIl,IlIlllIIllIlllIlIlIl,lIIllIIlIlIIl)if lIIllIIlIlIIl then local IlIlllIIllIlllIlIlIl=(IIlIIllIIIl/2^(IlIlllIIllIlllIlIlIl-1))%2^((lIIllIIlIlIIl-1)-(IlIlllIIllIlllIlIlIl-1)+1);return IlIlllIIllIlllIlIlIl-IlIlllIIllIlllIlIlIl%1;else local IlIlllIIllIlllIlIlIl=2^(IlIlllIIllIlllIlIlIl-1);return(IIlIIllIIIl%(IlIlllIIllIlllIlIlIl+IlIlllIIllIlllIlIlIl)>=IlIlllIIllIlllIlIlIl)and 1 or 0;end;end;local IlIlllIIllIlllIlIlIl=1;local function lIIllIIlIlIIl()local IIlIIllIIIl,lIIllIIlIlIIl,IIllllIlllIlll,IIlIlIlIllIIlIIII=IllIIllllIlIlIlIIIIlIllI(llIlIIIIIlIlllllIlllIIlII,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl+3);IIlIIllIIIl=IIllIIlIIlIlllIIlIIIlIIII(IIlIIllIIIl,75)lIIllIIlIlIIl=IIllIIlIIlIlllIIlIIIlIIII(lIIllIIlIlIIl,75)IIllllIlllIlll=IIllIIlIIlIlllIIlIIIlIIII(IIllllIlllIlll,75)IIlIlIlIllIIlIIII=IIllIIlIIlIlllIIlIIIlIIII(IIlIlIlIllIIlIIII,75)IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl+4;return(IIlIlIlIllIIlIIII*16777216)+(IIllllIlllIlll*65536)+(lIIllIIlIlIIl*256)+IIlIIllIIIl;end;local function lIIlIlIlIIllIlllllI()local lIIllIIlIlIIl=IIllIIlIIlIlllIIlIIIlIIII(IllIIllllIlIlIlIIIIlIllI(llIlIIIIIlIlllllIlllIIlII,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl),75);IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl+1;return lIIllIIlIlIIl;end;local function IIlIlIlIllIIlIIII()local lIIllIIlIlIIl,IIlIIllIIIl=IllIIllllIlIlIlIIIIlIllI(llIlIIIIIlIlllllIlllIIlII,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl+2);lIIllIIlIlIIl=IIllIIlIIlIlllIIlIIIlIIII(lIIllIIlIlIIl,75)IIlIIllIIIl=IIllIIlIIlIlllIIlIIIlIIII(IIlIIllIIIl,75)IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl+2;return(IIlIIllIIIl*256)+lIIllIIlIlIIl;end;local function llllllIlIllIIlllI()local IlIlllIIllIlllIlIlIl=lIIllIIlIlIIl();local lIIllIIlIlIIl=lIIllIIlIlIIl();local IIllllIlllIlll=1;local IIllIIlIIlIlllIIlIIIlIIII=(IIlIIllIIIl(lIIllIIlIlIIl,1,20)*(2^32))+IlIlllIIllIlllIlIlIl;local IlIlllIIllIlllIlIlIl=IIlIIllIIIl(lIIllIIlIlIIl,21,31);local lIIllIIlIlIIl=((-1)^IIlIIllIIIl(lIIllIIlIlIIl,32));if(IlIlllIIllIlllIlIlIl==0)then if(IIllIIlIIlIlllIIlIIIlIIII==0)then return lIIllIIlIlIIl*0;else IlIlllIIllIlllIlIlIl=1;IIllllIlllIlll=0;end;elseif(IlIlllIIllIlllIlIlIl==2047)then return(IIllIIlIIlIlllIIlIIIlIIII==0)and(lIIllIIlIlIIl*(1/0))or(lIIllIIlIlIIl*(0/0));end;return IlllIlIlllllllIIIllllIlll(lIIllIIlIlIIl,IlIlllIIllIlllIlIlIl-1023)*(IIllllIlllIlll+(IIllIIlIIlIlllIIlIIIlIIII/(2^52)));end;local llIllIIll=lIIllIIlIlIIl;local function IlllIlIlllllllIIIllllIlll(lIIllIIlIlIIl)local IIlIIllIIIl;if(not lIIllIIlIlIIl)then lIIllIIlIlIIl=llIllIIll();if(lIIllIIlIlIIl==0)then return'';end;end;IIlIIllIIIl=IIllllIlllIlll(llIlIIIIIlIlllllIlllIIlII,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl+lIIllIIlIlIIl-1);IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl+lIIllIIlIlIIl;local lIIllIIlIlIIl={}for IlIlllIIllIlllIlIlIl=1,#IIlIIllIIIl do lIIllIIlIlIIl[IlIlllIIllIlllIlIlIl]=IIlIllll(IIllIIlIIlIlllIIlIIIlIIII(IllIIllllIlIlIlIIIIlIllI(IIllllIlllIlll(IIlIIllIIIl,IlIlllIIllIlllIlIlIl,IlIlllIIllIlllIlIlIl)),75))end return lIlIlIllIIIllIIIllI(lIIllIIlIlIIl);end;local IlIlllIIllIlllIlIlIl=lIIllIIlIlIIl;local function llIllIIll(...)return{...},lIlllIIIIlIIlllIlI('#',...)end local function IIlIllll()local llIlIIIIIlIlllllIlllIIlII={};local IIllllIlllIlll={};local IlIlllIIllIlllIlIlIl={};local IllIIllllIlIlIlIIIIlIllI={[#{{755;761;672;399};{448;559;475;495};}]=IIllllIlllIlll,[#{{817;603;807;966};"1 + 1 = 111";{61;119;182;869};}]=nil,[#{"1 + 1 = 111";"1 + 1 = 111";{569;205;599;639};"1 + 1 = 111";}]=IlIlllIIllIlllIlIlIl,[#{"1 + 1 = 111";}]=llIlIIIIIlIlllllIlllIIlII,};local IlIlllIIllIlllIlIlIl=lIIllIIlIlIIl()local IIllIIlIIlIlllIIlIIIlIIII={}for IIlIIllIIIl=1,IlIlllIIllIlllIlIlIl do local lIIllIIlIlIIl=lIIlIlIlIIllIlllllI();local IlIlllIIllIlllIlIlIl;if(lIIllIIlIlIIl==3)then IlIlllIIllIlllIlIlIl=(lIIlIlIlIIllIlllllI()~=0);elseif(lIIllIIlIlIIl==1)then IlIlllIIllIlllIlIlIl=llllllIlIllIIlllI();elseif(lIIllIIlIlIIl==0)then IlIlllIIllIlllIlIlIl=IlllIlIlllllllIIIllllIlll();end;IIllIIlIIlIlllIIlIIIlIIII[IIlIIllIIIl]=IlIlllIIllIlllIlIlIl;end;for IlIlllIIllIlllIlIlIl=1,lIIllIIlIlIIl()do IIllllIlllIlll[IlIlllIIllIlllIlIlIl-1]=IIlIllll();end;IllIIllllIlIlIlIIIIlIllI[3]=lIIlIlIlIIllIlllllI();for IllIIllllIlIlIlIIIIlIllI=1,lIIllIIlIlIIl()do local IlIlllIIllIlllIlIlIl=lIIlIlIlIIllIlllllI();if(IIlIIllIIIl(IlIlllIIllIlllIlIlIl,1,1)==0)then local IIllllIlllIlll=IIlIIllIIIl(IlIlllIIllIlllIlIlIl,2,3);local lIIIlIlIlIlIlIlll=IIlIIllIIIl(IlIlllIIllIlllIlIlIl,4,6);local IlIlllIIllIlllIlIlIl={IIlIlIlIllIIlIIII(),IIlIlIlIllIIlIIII(),nil,nil};if(IIllllIlllIlll==0)then IlIlllIIllIlllIlIlIl[#("gry")]=IIlIlIlIllIIlIIII();IlIlllIIllIlllIlIlIl[#("0ItQ")]=IIlIlIlIllIIlIIII();elseif(IIllllIlllIlll==1)then IlIlllIIllIlllIlIlIl[#("pbm")]=lIIllIIlIlIIl();elseif(IIllllIlllIlll==2)then IlIlllIIllIlllIlIlIl[#("7uQ")]=lIIllIIlIlIIl()-(2^16)elseif(IIllllIlllIlll==3)then IlIlllIIllIlllIlIlIl[#("Sil")]=lIIllIIlIlIIl()-(2^16)IlIlllIIllIlllIlIlIl[#("UCrC")]=IIlIlIlIllIIlIIII();end;if(IIlIIllIIIl(lIIIlIlIlIlIlIlll,1,1)==1)then IlIlllIIllIlllIlIlIl[#("bm")]=IIllIIlIIlIlllIIlIIIlIIII[IlIlllIIllIlllIlIlIl[#("EU")]]end if(IIlIIllIIIl(lIIIlIlIlIlIlIlll,2,2)==1)then IlIlllIIllIlllIlIlIl[#("Usz")]=IIllIIlIIlIlllIIlIIIlIIII[IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{509;187;861;633};{824;295;309;204};}]]end if(IIlIIllIIIl(lIIIlIlIlIlIlIlll,3,3)==1)then IlIlllIIllIlllIlIlIl[#("Z7Xs")]=IIllIIlIIlIlllIIlIIIlIIII[IlIlllIIllIlllIlIlIl[#("doxn")]]end llIlIIIIIlIlllllIlllIIlII[IllIIllllIlIlIlIIIIlIllI]=IlIlllIIllIlllIlIlIl;end end;return IllIIllllIlIlIlIIIIlIllI;end;local function llIlIIIIIlIlllllIlllIIlII(IlIlllIIllIlllIlIlIl,lIIllIIlIlIIl,IIlIlIlIllIIlIIII)IlIlllIIllIlllIlIlIl=(IlIlllIIllIlllIlIlIl==true and IIlIllll())or IlIlllIIllIlllIlIlIl;return(function(...)local IIllIIlIIlIlllIIlIIIlIIII=IlIlllIIllIlllIlIlIl[1];local IIllllIlllIlll=IlIlllIIllIlllIlIlIl[3];local IIlIllll=IlIlllIIllIlllIlIlIl[2];local IlIlllIIllIlllIlIlIl=llIllIIll local lIIllIIlIlIIl=1;local IlIlllIIllIlllIlIlIl=-1;local llllllIlIllIIlllI={};local IllIIllllIlIlIlIIIIlIllI={...};local lIIlIlIlIIllIlllllI=lIlllIIIIlIIlllIlI('#',...)-1;local IlIlllIIllIlllIlIlIl={};local IIlIIllIIIl={};for IlIlllIIllIlllIlIlIl=0,lIIlIlIlIIllIlllllI do if(IlIlllIIllIlllIlIlIl>=IIllllIlllIlll)then llllllIlIllIIlllI[IlIlllIIllIlllIlIlIl-IIllllIlllIlll]=IllIIllllIlIlIlIIIIlIllI[IlIlllIIllIlllIlIlIl+1];else IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=IllIIllllIlIlIlIIIIlIllI[IlIlllIIllIlllIlIlIl+#{{905;202;259;614};}];end;end;local IlIlllIIllIlllIlIlIl=lIIlIlIlIIllIlllllI-IIllllIlllIlll+1 local IlIlllIIllIlllIlIlIl;local IIllllIlllIlll;while true do IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("b")];if IIllllIlllIlll<=#("n2YSpWYhmifVI8zqgy3f")then if IIllllIlllIlll<=#("LDPHyhAqr")then if IIllllIlllIlll<=#("r6VI")then if IIllllIlllIlll<=#("b")then if IIllllIlllIlll==#("")then local lIIIlIlIlIlIlIlll;local IIllllIlllIlll;IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("qC")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("pjS")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("0R")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("7Tt")]][IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{38;473;691;382};{271;93;267;747};{729;840;883;329};}]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("AF")]]=IlIlllIIllIlllIlIlIl[#("j80")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("er")]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Fc")]][IlIlllIIllIlllIlIlIl[#("mHF")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("sS5b")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Pp")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("IFm")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("xs")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";"1 + 1 = 111";{411;587;689;933};}]][IlIlllIIllIlllIlIlIl[#("PS3D")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("q8")];lIIIlIlIlIlIlIlll=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("7vd")]];IIlIIllIIIl[IIllllIlllIlll+1]=lIIIlIlIlIlIlIlll;IIlIIllIIIl[IIllllIlllIlll]=lIIIlIlIlIlIlIlll[IlIlllIIllIlllIlIlIl[#("vRPz")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("b4")]]=IlIlllIIllIlllIlIlIl[#("gyT")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{765;618;341;828};"1 + 1 = 111";}]]={};else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("0l")]]=IlIlllIIllIlllIlIlIl[#("G2a")];end;elseif IIllllIlllIlll<=#{"1 + 1 = 111";"1 + 1 = 111";}then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{636;955;951;61};{764;389;822;682};}]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]][IlIlllIIllIlllIlIlIl[#("4Cpk")]];elseif IIllllIlllIlll>#("PaO")then local IIllIIlIIlIlllIIlIIIlIIII=IlIlllIIllIlllIlIlIl[#("JT")];local lIIllIIlIlIIl=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("aQB")]];IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII+1]=lIIllIIlIlIIl;IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII]=lIIllIIlIlIIl[IlIlllIIllIlllIlIlIl[#("Lq4E")]];else lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("rDF")];end;elseif IIllllIlllIlll<=#("InnSeD")then if IIllllIlllIlll==#("asNAj")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("tk")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("XnD")]];else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("cq")]][IlIlllIIllIlllIlIlIl[#("VRh")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("YsWM")]];end;elseif IIllllIlllIlll<=#("2Oy04bY")then local lIIIlIlIlIlIlIlll;local llIlIIIIIlIlllllIlllIIlII;local lIIlIlIlIIllIlllllI;local IIllllIlllIlll;IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("M1")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]][IlIlllIIllIlllIlIlIl[#("gRne")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("vv")];lIIlIlIlIIllIlllllI=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Qx3")]];IIlIIllIIIl[IIllllIlllIlll+1]=lIIlIlIlIIllIlllllI;IIlIIllIIIl[IIllllIlllIlll]=lIIlIlIlIIllIlllllI[IlIlllIIllIlllIlIlIl[#("bGqG")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("Bh")]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Sa")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("pRm")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("ZY")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Hz1")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("SD")]llIlIIIIIlIlllllIlllIIlII={IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])};lIIIlIlIlIlIlIlll=0;for IlIlllIIllIlllIlIlIl=IIllllIlllIlll,IlIlllIIllIlllIlIlIl[#("heuV")]do lIIIlIlIlIlIlIlll=lIIIlIlIlIlIlIlll+1;IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=llIlIIIIIlIlllllIlllIIlII[lIIIlIlIlIlIlIlll];end lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("g7e")];elseif IIllllIlllIlll>#("XBoo7yA2")then if(IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{77;703;918;105};"1 + 1 = 111";}]]==IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";"1 + 1 = 111";{562;622;467;557};"1 + 1 = 111";}])then lIIllIIlIlIIl=lIIllIIlIlIIl+1;else lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("Wji")];end;else local lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("mW")]IIlIIllIIIl[lIIllIIlIlIIl](lIIIlIlIlIlIlIlll(IIlIIllIIIl,lIIllIIlIlIIl+1,IlIlllIIllIlllIlIlIl[#("00j")]))end;elseif IIllllIlllIlll<=#("6CbmZ4lJnOA6C5")then if IIllllIlllIlll<=#("27iYYtU9ZGV")then if IIllllIlllIlll>#("9DgfBh8R7h")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{967;867;746;469};{164;872;362;557};}]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("58z")]][IlIlllIIllIlllIlIlIl[#("REQ2")]];else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("7c")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("U7Z")]];end;elseif IIllllIlllIlll<=#("cUmrQyy3uGEx")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Po")]][IlIlllIIllIlllIlIlIl[#{{861;182;133;920};{151;775;882;116};"1 + 1 = 111";}]]=IlIlllIIllIlllIlIlIl[#("cYCE")];elseif IIllllIlllIlll==#{"1 + 1 = 111";"1 + 1 = 111";{967;241;466;435};{947;866;453;355};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{322;342;295;839};{772;456;167;762};{548;540;578;565};"1 + 1 = 111";{49;72;356;568};"1 + 1 = 111";}then if(IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("SA")]]==IlIlllIIllIlllIlIlIl[#("x5qc")])then lIIllIIlIlIIl=lIIllIIlIlIIl+1;else lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("WPE")];end;else if(IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{330;614;275;894};"1 + 1 = 111";}]]~=IlIlllIIllIlllIlIlIl[#("PEKB")])then lIIllIIlIlIIl=lIIllIIlIlIIl+1;else lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("qkP")];end;end;elseif IIllllIlllIlll<=#("9YEnXU8feLcdMBNBr")then if IIllllIlllIlll<=#("gf0Zd7GF5s9NblJ")then lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("vHO")];elseif IIllllIlllIlll==#("ze0rQMbjHD9h0VdM")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Hz")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Nzq")]];else do return end;end;elseif IIllllIlllIlll<=#("P8bRjVHSrYQfBK0FWc")then local IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{760;305;188;373};}];local IIlIlIlIllIIlIIII=IlIlllIIllIlllIlIlIl[#("ylTv")];local IIllIIlIIlIlllIIlIIIlIIII=IIllllIlllIlll+2 local IIllllIlllIlll={IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1],IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII])};for IlIlllIIllIlllIlIlIl=1,IIlIlIlIllIIlIIII do IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII+IlIlllIIllIlllIlIlIl]=IIllllIlllIlll[IlIlllIIllIlllIlIlIl];end;local IIllllIlllIlll=IIllllIlllIlll[1]if IIllllIlllIlll then IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII]=IIllllIlllIlll lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("jhW")];else lIIllIIlIlIIl=lIIllIIlIlIIl+1;end;elseif IIllllIlllIlll>#("L90FeRsK8yPkpxYvmIh")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("8U")]]={};else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("VM")]][IlIlllIIllIlllIlIlIl[#("ma0")]]=IlIlllIIllIlllIlIlIl[#("H5jB")];end;elseif IIllllIlllIlll<=#("ttKzXudf2iNdSFbZZE6a0kJtNOBTMnN")then if IIllllIlllIlll<=#("PXoqACRTNmSZVLCUv9HTLhziU")then if IIllllIlllIlll<=#("Vj4uEOGQz5pUzyXnyNDUJb")then if IIllllIlllIlll==#("QyNR4vIyfHkQHYsTdsemH")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("nt")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("sxK")]];else local lIIIlIlIlIlIlIlll;local llIlIIIIIlIlllllIlllIIlII;local lIIlIlIlIIllIlllllI;local IIllllIlllIlll;IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{291;547;719;449};"1 + 1 = 111";}]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("KZ6")]][IlIlllIIllIlllIlIlIl[#("nvDG")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#{{367;16;48;17};"1 + 1 = 111";}];lIIlIlIlIIllIlllllI=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("zB6")]];IIlIIllIIIl[IIllllIlllIlll+1]=lIIlIlIlIIllIlllllI;IIlIIllIIIl[IIllllIlllIlll]=lIIlIlIlIIllIlllllI[IlIlllIIllIlllIlIlIl[#("Mbuf")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("AE")]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{692;665;387;554};}]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("PIn")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Wh")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("kVH")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("UO")]llIlIIIIIlIlllllIlllIIlII={IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])};lIIIlIlIlIlIlIlll=0;for IlIlllIIllIlllIlIlIl=IIllllIlllIlll,IlIlllIIllIlllIlIlIl[#("neWz")]do lIIIlIlIlIlIlIlll=lIIIlIlIlIlIlIlll+1;IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=llIlIIIIIlIlllllIlllIIlII[lIIIlIlIlIlIlIlll];end lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("tLm")];end;elseif IIllllIlllIlll<=#("LKj5yUVQaQT7o717Mu1Ijno")then local IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl[#("3l")]IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl](IIlIIllIIIl[IlIlllIIllIlllIlIlIl+1])elseif IIllllIlllIlll>#("pze4zBEZPlWcH88XMAGF6JKv")then local lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("cN")]local IIllllIlllIlll={IIlIIllIIIl[lIIllIIlIlIIl](IIlIIllIIIl[lIIllIIlIlIIl+1])};local IIllIIlIIlIlllIIlIIIlIIII=0;for IlIlllIIllIlllIlIlIl=lIIllIIlIlIIl,IlIlllIIllIlllIlIlIl[#("lXss")]do IIllIIlIIlIlllIIlIIIlIIII=IIllIIlIIlIlllIIlIIIlIIII+1;IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=IIllllIlllIlll[IIllIIlIIlIlllIIlIIIlIIII];end else local IIllllIlllIlll;IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("fX")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("RS2")]][IlIlllIIllIlllIlIlIl[#("39GA")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Mm")]]=IlIlllIIllIlllIlIlIl[#("9TA")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("AB")]]=IlIlllIIllIlllIlIlIl[#("Zmr")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("QQ")]]=IlIlllIIllIlllIlIlIl[#("LfY")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#{{333;341;830;994};"1 + 1 = 111";}]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](lIIIlIlIlIlIlIlll(IIlIIllIIIl,IIllllIlllIlll+1,IlIlllIIllIlllIlIlIl[#("Lty")]))lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{724;248;366;311};{910;113;294;924};}]][IlIlllIIllIlllIlIlIl[#("CjC")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("GVtV")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("8p")]][IlIlllIIllIlllIlIlIl[#("3hO")]]=IlIlllIIllIlllIlIlIl[#("hObr")];end;elseif IIllllIlllIlll<=#("gRUv9uxvCP8P1rKl4sckYANxd5US")then if IIllllIlllIlll<=#("UQYTcrTUEQ1ARfs9iVi5scqIke")then local lIIlIlIlIIllIlllllI;local IIllllIlllIlll;IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("ll")]][IlIlllIIllIlllIlIlIl[#("EC7")]]=IlIlllIIllIlllIlIlIl[#("bDVt")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Ga")]][IlIlllIIllIlllIlIlIl[#("ko2")]]=IlIlllIIllIlllIlIlIl[#("NiFG")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Zu")]][IlIlllIIllIlllIlIlIl[#("7eu")]]=IlIlllIIllIlllIlIlIl[#("tzt4")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("l9")]][IlIlllIIllIlllIlIlIl[#("akr")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("UM0c")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("tZ")]IIlIIllIIIl[IIllllIlllIlll](lIIIlIlIlIlIlIlll(IIlIIllIIIl,IIllllIlllIlll+1,IlIlllIIllIlllIlIlIl[#("que")]))lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("3X")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#{{55;252;12;925};{258;630;769;139};{645;136;317;714};}]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("O3")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{955;231;166;78};{371;655;123;611};}]][IlIlllIIllIlllIlIlIl[#("oZcX")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("1f")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("pq8")]][IlIlllIIllIlllIlIlIl[#("1RJM")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("yW")];lIIlIlIlIIllIlllllI=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("f8r")]];IIlIIllIIIl[IIllllIlllIlll+1]=lIIlIlIlIIllIlllllI;IIlIIllIIIl[IIllllIlllIlll]=lIIlIlIlIIllIlllllI[IlIlllIIllIlllIlIlIl[#("JdEG")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("0b")]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])elseif IIllllIlllIlll==#("eyreKPMS9k5Y91BANlVgutx4jMW")then local lIIlIlIlIIllIlllllI;local IIllllIlllIlll;IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#{{842;66;88;562};{315;308;600;483};}]IIlIIllIIIl[IIllllIlllIlll](lIIIlIlIlIlIlIlll(IIlIIllIIIl,IIllllIlllIlll+1,IlIlllIIllIlllIlIlIl[#("pKT")]))lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Z4")]]=IIlIlIlIllIIlIIII[IlIlllIIllIlllIlIlIl[#("n7J")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Ug")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("8Tl")]][IlIlllIIllIlllIlIlIl[#("Sb9D")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("DK")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("1au")]][IlIlllIIllIlllIlIlIl[#("UF9V")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#{{417;737;722;865};"1 + 1 = 111";}];lIIlIlIlIIllIlllllI=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("dJF")]];IIlIIllIIIl[IIllllIlllIlll+1]=lIIlIlIlIIllIlllllI;IIlIIllIIIl[IIllllIlllIlll]=lIIlIlIlIIllIlllllI[IlIlllIIllIlllIlIlIl[#("gBA0")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("pO")]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1])lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("p7")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("P6F")]][IlIlllIIllIlllIlIlIl[#("FY89")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("Ou")];lIIlIlIlIIllIlllllI=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("tuL")]];IIlIIllIIIl[IIllllIlllIlll+1]=lIIlIlIlIIllIlllllI;IIlIIllIIIl[IIllllIlllIlll]=lIIlIlIlIIllIlllllI[IlIlllIIllIlllIlIlIl[#("lA8g")]];else do return end;end;elseif IIllllIlllIlll<=#("SAqI7LOxlMrUfxtZm6ie2MOxA7xUa")then local IIllIIlIIlIlllIIlIIIlIIII=IlIlllIIllIlllIlIlIl[#("tt")];local lIIllIIlIlIIl=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("fDK")]];IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII+1]=lIIllIIlIlIIl;IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII]=lIIllIIlIlIIl[IlIlllIIllIlllIlIlIl[#("5J2T")]];elseif IIllllIlllIlll==#("483l9J3y1zmeob3ab79IRmDRJfW3ha")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("kh")]]=llIlIIIIIlIlllllIlllIIlII(IIlIllll[IlIlllIIllIlllIlIlIl[#{{740;668;8;277};{121;938;623;201};"1 + 1 = 111";}]],nil,IIlIlIlIllIIlIIII);else local IlIlllIIllIlllIlIlIl=IlIlllIIllIlllIlIlIl[#("D9")]IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl](IIlIIllIIIl[IlIlllIIllIlllIlIlIl+1])end;elseif IIllllIlllIlll<=#("4vYRt14yU5ZfU2XyNDA5AUCQSFlN3X9p0ksS")then if IIllllIlllIlll<=#("tKjhJpN1gTZVSiBSeYj4i8YPqE65KpKKe")then if IIllllIlllIlll==#("s2pY0FZYMWx1lPJHVviYqvWF0fsRr1io")then if(IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("cr")]]~=IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{472;559;586;389};{718;370;3;662};"1 + 1 = 111";}])then lIIllIIlIlIIl=lIIllIIlIlIIl+1;else lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("LS1")];end;else local lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("yE")]IIlIIllIIIl[lIIllIIlIlIIl]=IIlIIllIIIl[lIIllIIlIlIIl](lIIIlIlIlIlIlIlll(IIlIIllIIIl,lIIllIIlIlIIl+1,IlIlllIIllIlllIlIlIl[#("Cqc")]))end;elseif IIllllIlllIlll<=#("U0JDq8OeuxcsArrxdEnBqR6gV8UmhHVNhk")then local lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("kj")]IIlIIllIIIl[lIIllIIlIlIIl]=IIlIIllIIIl[lIIllIIlIlIIl](lIIIlIlIlIlIlIlll(IIlIIllIIIl,lIIllIIlIlIIl+1,IlIlllIIllIlllIlIlIl[#("ZOQ")]))elseif IIllllIlllIlll==#("YaeFyFU69TmBXaunx5YAc3CSsnC6XLzko0E")then local IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("fl")];local IIlIlIlIllIIlIIII=IlIlllIIllIlllIlIlIl[#("SNxq")];local IIllIIlIIlIlllIIlIIIlIIII=IIllllIlllIlll+2 local IIllllIlllIlll={IIlIIllIIIl[IIllllIlllIlll](IIlIIllIIIl[IIllllIlllIlll+1],IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII])};for IlIlllIIllIlllIlIlIl=1,IIlIlIlIllIIlIIII do IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII+IlIlllIIllIlllIlIlIl]=IIllllIlllIlll[IlIlllIIllIlllIlIlIl];end;local IIllllIlllIlll=IIllllIlllIlll[1]if IIllllIlllIlll then IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII]=IIllllIlllIlll lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("6zZ")];else lIIllIIlIlIIl=lIIllIIlIlIIl+1;end;else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Hd")]]=IlIlllIIllIlllIlIlIl[#("DZR")];end;elseif IIllllIlllIlll<=#("98Z5HV7xJH7lXsyRtVz4IvmkdXiyubl6H8oyf23")then if IIllllIlllIlll<=#("6fjVqpjFnS1DBJYNVP2UMKcHvaOYe9LB2h8Cm")then IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Vi")]][IlIlllIIllIlllIlIlIl[#("eJc")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("TZry")]];elseif IIllllIlllIlll>#("4XNOkMkSF8jMMBajPvdMApMvBngBLtKxAtVeg8")then local lIIllIIlIlIIl=IlIlllIIllIlllIlIlIl[#("kL")]IIlIIllIIIl[lIIllIIlIlIIl](lIIIlIlIlIlIlIlll(IIlIIllIIIl,lIIllIIlIlIIl+1,IlIlllIIllIlllIlIlIl[#("v3B")]))else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#{{266;426;919;376};"1 + 1 = 111";}]]=llIlIIIIIlIlllllIlllIIlII(IIlIllll[IlIlllIIllIlllIlIlIl[#("jjx")]],nil,IIlIlIlIllIIlIIII);end;elseif IIllllIlllIlll<=#("AxNFPOCxkBSDMzKcOkqn6GThlzXlsP5cQ6OpWV6R")then local IIllllIlllIlll;IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("bG")]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("YO7")]][IlIlllIIllIlllIlIlIl[#("ArT3")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("FJ")]]=IlIlllIIllIlllIlIlIl[#("RGb")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("7a")]]=IlIlllIIllIlllIlIlIl[#("4bu")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("XV")]]=IlIlllIIllIlllIlIlIl[#("PvU")];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIllllIlllIlll=IlIlllIIllIlllIlIlIl[#("U1")]IIlIIllIIIl[IIllllIlllIlll]=IIlIIllIIIl[IIllllIlllIlll](lIIIlIlIlIlIlIlll(IIlIIllIIIl,IIllllIlllIlll+1,IlIlllIIllIlllIlIlIl[#("OdI")]))lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("ze")]][IlIlllIIllIlllIlIlIl[#{"1 + 1 = 111";{526;595;43;775};"1 + 1 = 111";}]]=IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("VeF1")]];lIIllIIlIlIIl=lIIllIIlIlIIl+1;IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII[lIIllIIlIlIIl];IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("MI")]][IlIlllIIllIlllIlIlIl[#{{849;40;870;37};{821;699;522;810};"1 + 1 = 111";}]]=IlIlllIIllIlllIlIlIl[#("rd2F")];elseif IIllllIlllIlll>#("05a2078Zrg3ZUD3NGsq1qeFFQWPUup3oKpgLTouBZ")then local IIllIIlIIlIlllIIlIIIlIIII=IlIlllIIllIlllIlIlIl[#("dX")]local IIllllIlllIlll={IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII](IIlIIllIIIl[IIllIIlIIlIlllIIlIIIlIIII+1])};local lIIllIIlIlIIl=0;for IlIlllIIllIlllIlIlIl=IIllIIlIIlIlllIIlIIIlIIII,IlIlllIIllIlllIlIlIl[#("lNqP")]do lIIllIIlIlIIl=lIIllIIlIlIIl+1;IIlIIllIIIl[IlIlllIIllIlllIlIlIl]=IIllllIlllIlll[lIIllIIlIlIIl];end else IIlIIllIIIl[IlIlllIIllIlllIlIlIl[#("Fz")]]={};end;lIIllIIlIlIIl=lIIllIIlIlIIl+1;end;end);end;return llIlIIIIIlIlllllIlllIIlII(true,{},IllllIlIlllIllIl())();end)(string.byte,table.insert,setmetatable);    
    end)
    btns:Seperator()

    
btns:Button(
    "AutoTime",
    function()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Click V", Text = "And it will auto time for you."})

    loadstring(game:HttpGet("https://raw.githubusercontent.com/MainHackScripts/autotime/main/README.lua"))() 
    end)
    btns:Seperator()


btns:Button(
    "Optisploit",
    function()
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "RBW3 GUI", Text = "Script is made by Sub-Sploit#4562"})

    loadstring(game:HttpGet("https://raw.githubusercontent.com/MainHackScripts/OptiSploit/main/README.lua"))()    
    end)
    btns:Seperator()

    
btns:Button(
    "ExploitGodz",
    function()
    loadstring(game:HttpGet(('https://pastebin.com/raw/n7n5ezh3'),true))()    
    end)
    btns:Seperator()


btns:Button(
    "Speed",
    function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MainHackScripts/SpeedRBW3/main/HACK.lua"))()    
    end)
    btns:Seperator()

    
btns:Button(
    "Percent.Read",
    function()
    --[[
IronBrew:tm: obfuscation; Version 2.7.2
]]
return(function(IIllIlllIlIll,llIIIIIIllIIlIIllIllIll,IIlIIIIll)local lIlIlllIIIlIIlIIIIIlll=string.char;local lIlIlllllIlIlIIIlll=string.sub;local IllIIlllllIII=table.concat;local IIlllIllIllIIlIlIlII=math.ldexp;local IlIIIIlII=getfenv or function()return _ENV end;local IIllllIllIIIll=select;local lllIlIllIllIIllII=unpack or table.unpack;local lllIlIllIlllllIlIIIl=tonumber;local function llllIlIIIlIllII(IIllIlllIlIll)local lIlIlllllIIllIlllIlIllII,IIlllIllllIlllIlllIlllIl,IlIIllIlIIllIII="","",{}local llIIIllllllllIIII=256;local lllIlIllIllIIllII={}for llIIIIIIllIIlIIllIllIll=0,llIIIllllllllIIII-1 do lllIlIllIllIIllII[llIIIIIIllIIlIIllIllIll]=lIlIlllIIIlIIlIIIIIlll(llIIIIIIllIIlIIllIllIll)end;local llIIIIIIllIIlIIllIllIll=1;local function IlIlIIIlIIIlIIlllIIlIl()local lIlIlllllIIllIlllIlIllII=lllIlIllIlllllIlIIIl(lIlIlllllIlIlIIIlll(IIllIlllIlIll,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll),36)llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll+1;local IIlllIllllIlllIlllIlllIl=lllIlIllIlllllIlIIIl(lIlIlllllIlIlIIIlll(IIllIlllIlIll,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll+lIlIlllllIIllIlllIlIllII-1),36)llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll+lIlIlllllIIllIlllIlIllII;return IIlllIllllIlllIlllIlllIl end;lIlIlllllIIllIlllIlIllII=lIlIlllIIIlIIlIIIIIlll(IlIlIIIlIIIlIIlllIIlIl())IlIIllIlIIllIII[1]=lIlIlllllIIllIlllIlIllII;while llIIIIIIllIIlIIllIllIll<#IIllIlllIlIll do local llIIIIIIllIIlIIllIllIll=IlIlIIIlIIIlIIlllIIlIl()if lllIlIllIllIIllII[llIIIIIIllIIlIIllIllIll]then IIlllIllllIlllIlllIlllIl=lllIlIllIllIIllII[llIIIIIIllIIlIIllIllIll]else IIlllIllllIlllIlllIlllIl=lIlIlllllIIllIlllIlIllII..lIlIlllllIlIlIIIlll(lIlIlllllIIllIlllIlIllII,1,1)end;lllIlIllIllIIllII[llIIIllllllllIIII]=lIlIlllllIIllIlllIlIllII..lIlIlllllIlIlIIIlll(IIlllIllllIlllIlllIlllIl,1,1)IlIIllIlIIllIII[#IlIIllIlIIllIII+1],lIlIlllllIIllIlllIlIllII,llIIIllllllllIIII=IIlllIllllIlllIlllIlllIl,IIlllIllllIlllIlllIlllIl,llIIIllllllllIIII+1 end;return table.concat(IlIIllIlIIllIII)end;local IlIlIIIlIIIlIIlllIIlIl=llllIlIIIlIllII('25224227524124B27524226D27126826X26926A26R26P26V24124427926426R27326V25J26324124727925T27227127027J27L27525E26R26826V27026E24124627M27O28028B27P25J26Z27K27925N26V27227X26D28I27525T27127X26824H24124527926S26827127325C25X25S24327927523627125U29629727924124127925C26V26U27T27925X28528628P24226526826R27026T26V29C27921E26W29B29D22A25Q2A22971I26425U28927926D26R26Z28828A27526T28C24124829M26V26E25D26V26826C26Z27I2AL29H26F2702AQ2AS2AU27J24F29H28626U2AR25D26E26V26A26A29J28W27V27Y27Z26P28828X28227226R26J2AR26924124927925E2BN2BP26825V26U2B729K24C2BU2BW2AR29I2732712AT29V2AW28Q26Y26Z27226U2BZ2C129L27527G26Z2682BR2BT27525X2AO25T2CE2CG2852702CC24225S26R26926X2AO26O26R28M24124E27925H2AE26E25W27C2CU2CF29K24A27926926Y27127126E26Z2CB2DK27527H26P26F29T26P26J29Q26A2C526824123U2AN26E25E2902BD26826E26J2CU29U29W26U25D26Z26T2702D72CK24225G2D726F26V24226P27923K23P27929Y24Y29D2422402422F124229Y29G2EZ2F32FB23K2752F429Y23M27529628A2F424I2FI24227U2812FE27928A2FD24229G2DT2F52762FV24227823K26724228A2AM27523K25W2FO2422G72422FU27L2CQ29729G27L2F42FH2FB28X29G2FU2FW2792F629G29G2G22752G62EW27527U2GH2GF2422GH29E2422GK24223M2662FB2DA2GP23X2G02FX2GT2G02GW2G52H42GZ2GB2GD2H32H52FZ2H82GM2F42B42GP2FZ2HH2FZ2GV2GE2GX24224D2EW2G427U2GM2GE2DA27L23N2F22GJ2FB2HU2422C32HX2G02FU2GI2F72IO2GQ24223L2GS2I024223Q2I22GB23R2IE2GB2F42HI29G23O2F525X2G029G2EY2402E627U29D24M2G027U2962IQ2IS2752J32422E62JM23V2FY2J82422EY2442JQ2JH2IO29C24U2FA2792JF29G2JX2JJ2IT2JS2JO2IU23S2JR2GU2JT2F32JC2FB27924T2JG2IO2JV2JS2962JZ2792F42G82ID28A2F024N2HL28A23T2J62KX2KE2KM27L2KU2IO2422K02FZ27927828A27L2JI2I323Y2HN2JX2JL2H02GB23Z2972FP2F22AH2H72HL27926Q2IO24Y2KW2782DK27U2502AM2782G429623W2G52LQ2M42M72LT2LV2J72LY2422HF23K24O2HM2F62972782BT2J22752M22MF2IX2DA24Z2F22AM2DA2MO2HM2782MG2752B424W2F22BT2B42MY2DA2AM24X2IX2C327429D2DA2C32N82422DA2JU2JQ2C32JX2F92L82HM2792NQ2GD2L72H62KI2NJ2II2L624S2G129D24424H2HL2632IO2F42462LQ2O729C25U2K12LR2752DA2762JD2422CM2CO2772AC27C27E27G2AV2FQ27N28F27S2GH2CS26E2DH2CW29P2LQ2AJ27P2BF2BM2BO2BQ2412C327525W2DR26U2PE2CO2P02CV29K2LQ2OV27J27827525I26V26I26E26626R26O28L2P72EP26Z26926Z26O27226V2F42PZ25Z2EM2Q429J2IV2EW2OK29Y2FU2962KR2JR2KO2G02F62QL2LQ2O82F22972O92972ID2JI2ID27U2OK24Y24G2GB2LO2F62QY24228X2F628X28A2FX2GB28X2F428127U2QV2FS2LQ2RH2LW2GB28A27824I25Z2HO2HM2RP2HL2DA2BT2O427928X2QI2MA2752RZ2752OE2FN2F22QJ2PB27V26Y28427H2BA2BY2C02BE2BL24228R2702BI26E2432SI2RL29Y29624Y2J72QL2RE2JQ2F92QQ2NV2QR2612QR2422KJ29629G2OD2OF2FG29E2OI2422DC2AF2DF2682P12PL27926226V26R2TJ2AI2AK2SI2BV2P92ON2GH26627126P2D72TS2BX2OO2CD2SC2BJ2AR2412IW2752672AE27025825X28C2E22BO25825D26P26826Z26A2BK28E26V25X26F28H2OK27W27Y27J2PM2AK2PP2422PR2PT2PV2PX2722AB2PQ2PS2UO2752Q92PW2Q526U24024329Q2832CX2VA2422BZ27C27Z29X2EY2JL2512L62IP2FZ2QJ2FA29G2F42FU2Q72K72F42QT2F62W42GB2W62FB27L2W92F42R72FR2F42DK2WC2O22KQ2FB2VX2SY2LJ2JS2AM2IH2AM29G2HI2F42H52QP2JR28A2GY2GM29G2DA28A2FM2FB2B42PC2FZ2TA2FB2I529G2IH2FH29Y2OF2972F82OK26A2TY28M2432OK23K2RH29Y2KM2QJ2QL2T02F224K2QQ2T82S62VU2OK2U227A2OQ27F27H28D2752PN28G2S92PD2PF2PH2692PJ2DI2V72422PN2PZ25Y26V2YH29026J2WJ2GE2FQ2F02S72JR2IN2WK2972WI2WX2WL2YY2792OK2WK2XG2Y12972SI2Z924225N2AA2OK29N26V2862ZD2A92Z91I25F2AA2FQ29S2EG2Y92ZE28L28N29F2B526U2432HF27524C2532KL2VU2OA2792LD2752LG2Z92SQ2SZ2742S02GX2LQ2M629624C2J52I129Y31082752782FJ2LQ2XF2422502NB2OH2IO2WZ2LQ2DA310T279310V242310C29D310E2962JD310G2KH2S1242310K2II2J528A2IS310P2LQ311L311F2JQ2962502I5275311Q31102LQ311V31172VU2JL2KW2QL281311D2QJ310Q311G2IO311S279311H29G3127311H311Z310D31222IO2BL31252972S531202LA29E2UY2P62GD2D12D32D52D72V62TC2TE2DE2DG2PK2412FX2DM2DO2DQ2DS2792DV2DX27H2E02FQ2UG2U12E62CR2AO2E92712EB2ED2EF29V29J2EJ2EL2EN2OK2EQ2722ES2PZ2SK2SM243313I2F5312I2FN2M131102QQ31272L531272EY2SS2SU2H62MH2G02Z32T62FB2W9314K2FU28A2Z72FR2FK2KC2IO2IK2LO29D2K4314L2I32WD2IX27L2RB2I32H82F62WZ2O22L32VY2752NQ2WN2NQ2VX2T22QR2KJ2LC2O0312O242312N2SR2Z02FV2V026P27C27126F31382UX2AC29T26A2YT2XQ2OF2RL2QS2H7311Y314U275315H2F2316B2XG316B2VX25S2WK2KR2MU2FN2Y02VU29Y2JQ2762V027B27D2Y72OT2UP2YC2X82PE2702PG2CN2YH2TI2EO313W313Y2FQ2YQ2DR26T2EO27F2722AF313427926E27131792CB29Y2582Y42V22PU2PW2PY2GD317P28R28T28V317T2V92UJ2D729J2Q72FX317P2EJ26G29X2F225Y2A629D2AA2LQ317P2ZD22Q24T2ZY27526926F26O24129Y2532YK2AD2AF2ZD22Y318I2FQ317V27C28V2SI28Z29129329529D29925U2VG24225Y2EW2B42Y12MK2WK319F2L92FR2Z12WF2LS31662W02FN2QZ316L2LR2W12R62J02YW2JS2QP2W7319O2HG2F2314K2VX2VX2JR2W728A2HI310R297314S29D2LI2JR2R52QP314S2GL2FZ2AM31A8319I2RO2FZ2BT2DA31A92O22X529G2X7314T2962I528129G25431072LQ31B22SS2KW2SY27824Y2FH2L52ID2FU27U2FX2H3319Q2LR27L2FD2R82IO2I52FU2DK2ID2G831AA31BR29727L27831A028X2JK31AB2HL28X2X12H92L12792592LV31B7312P2RL31BC2GE2I72IR2972M631582I82HB2XD2HL316329G2U82GE2IZ28A2IZ314X2FB2SS31AN2IX28A2J52WO31582EY31BE2JN2HN27L31432FU28X31432FS319U31AJ2G031AL314T31AA314O319U31AD311E31DD2W731C431BB31DI31AT31AP2422JQ31AS31AO2G031AW29D2ZD311E2Y4315T290315W2DR315Y27526D3160316231BU2KV29D2SW316N2G0242316B29D316D297316F297316H319L242316K2JY2S42T9279316P315R2OP316T2OS2ZU2YB28H316Y2YF31722YI2CG31752ER2ZU317K317B2OK317D317F2FX317I31FF318O279317N2V0317P2V4317S279317U28S318Z2CZ31852XM31822FV3184317Z26Z31872ZD318A31E2318D31FU2V9318G318I2SY318L318N318P318R2DD318U318W2BG317W2PZ31922922942Z931973199319B2G8319D2VU319H314Z31CV315Q2WO31A72YX31A0311B2K731232IX315131CV319W2KD319Y2Z42IQ3154316931A43119319L31AM31EJ2YT2HL31A52GB319W31AG31C131DP31AK2HL31DX24231AU2HM31AR31CY31I231AW2HI31AY2OG31B131B327931B5314431HP31B931DR29631BD2LK31BG27527L31BI27L31BK2JR2S331BO27531BQ2HN27831BU31092O231BY31CG29D315831C32FZ31DR2QP31C831B631IG31IF31CD2G32GB31C0312831CJ2H931CL31C52FT2ID31CP2EW31CS24231CU2IN2FF31DS2HK31D02K731D32IX27U31D931IN31D631BS319U31DC2I32RD31C531DG31HZ31CY31DK2SI2Z631DN31502IG31J731KD31JC31I22BT31DW31I52FZ31E02XI2QR');local llIIIIIIllIIlIIllIllIll=(bit or bit32);local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll and llIIIIIIllIIlIIllIllIll.bxor or function(llIIIIIIllIIlIIllIllIll,IIlllIllllIlllIlllIlllIl)local lIlIlllllIIllIlllIlIllII,llIIIllllllllIIII,lIlIlllllIlIlIIIlll=1,0,10 while llIIIIIIllIIlIIllIllIll>0 and IIlllIllllIlllIlllIlllIl>0 do local IlIIllIlIIllIII,lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll%2,IIlllIllllIlllIlllIlllIl%2 if IlIIllIlIIllIII~=lIlIlllllIlIlIIIlll then llIIIllllllllIIII=llIIIllllllllIIII+lIlIlllllIIllIlllIlIllII end llIIIIIIllIIlIIllIllIll,IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII=(llIIIIIIllIIlIIllIllIll-IlIIllIlIIllIII)/2,(IIlllIllllIlllIlllIlllIl-lIlIlllllIlIlIIIlll)/2,lIlIlllllIIllIlllIlIllII*2 end if llIIIIIIllIIlIIllIllIll<IIlllIllllIlllIlllIlllIl then llIIIIIIllIIlIIllIllIll=IIlllIllllIlllIlllIlllIl end while llIIIIIIllIIlIIllIllIll>0 do local IIlllIllllIlllIlllIlllIl=llIIIIIIllIIlIIllIllIll%2 if IIlllIllllIlllIlllIlllIl>0 then llIIIllllllllIIII=llIIIllllllllIIII+lIlIlllllIIllIlllIlIllII end llIIIIIIllIIlIIllIllIll,lIlIlllllIIllIlllIlIllII=(llIIIIIIllIIlIIllIllIll-IIlllIllllIlllIlllIlllIl)/2,lIlIlllllIIllIlllIlIllII*2 end return llIIIllllllllIIII end local function IIlllIllllIlllIlllIlllIl(lIlIlllllIIllIlllIlIllII,llIIIIIIllIIlIIllIllIll,IIlllIllllIlllIlllIlllIl)if IIlllIllllIlllIlllIlllIl then local llIIIIIIllIIlIIllIllIll=(lIlIlllllIIllIlllIlIllII/2^(llIIIIIIllIIlIIllIllIll-1))%2^((IIlllIllllIlllIlllIlllIl-1)-(llIIIIIIllIIlIIllIllIll-1)+1);return llIIIIIIllIIlIIllIllIll-llIIIIIIllIIlIIllIllIll%1;else local llIIIIIIllIIlIIllIllIll=2^(llIIIIIIllIIlIIllIllIll-1);return(lIlIlllllIIllIlllIlIllII%(llIIIIIIllIIlIIllIllIll+llIIIIIIllIIlIIllIllIll)>=llIIIIIIllIIlIIllIllIll)and 1 or 0;end;end;local llIIIIIIllIIlIIllIllIll=1;local function lIlIlllllIIllIlllIlIllII()local lIlIlllllIIllIlllIlIllII,IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll,IlIIllIlIIllIII=IIllIlllIlIll(IlIlIIIlIIIlIIlllIIlIl,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll+3);lIlIlllllIIllIlllIlIllII=llIIIllllllllIIII(lIlIlllllIIllIlllIlIllII,146)IIlllIllllIlllIlllIlllIl=llIIIllllllllIIII(IIlllIllllIlllIlllIlllIl,146)lIlIlllllIlIlIIIlll=llIIIllllllllIIII(lIlIlllllIlIlIIIlll,146)IlIIllIlIIllIII=llIIIllllllllIIII(IlIIllIlIIllIII,146)llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll+4;return(IlIIllIlIIllIII*16777216)+(lIlIlllllIlIlIIIlll*65536)+(IIlllIllllIlllIlllIlllIl*256)+lIlIlllllIIllIlllIlIllII;end;local function lllIlIllIlllllIlIIIl()local lIlIlllllIIllIlllIlIllII=llIIIllllllllIIII(IIllIlllIlIll(IlIlIIIlIIIlIIlllIIlIl,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll),146);llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll+1;return lIlIlllllIIllIlllIlIllII;end;local function IlIIllIlIIllIII()local IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII=IIllIlllIlIll(IlIlIIIlIIIlIIlllIIlIl,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll+2);IIlllIllllIlllIlllIlllIl=llIIIllllllllIIII(IIlllIllllIlllIlllIlllIl,146)lIlIlllllIIllIlllIlIllII=llIIIllllllllIIII(lIlIlllllIIllIlllIlIllII,146)llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll+2;return(lIlIlllllIIllIlllIlIllII*256)+IIlllIllllIlllIlllIlllIl;end;local function llllIlIIIlIllII()local llIIIllllllllIIII=lIlIlllllIIllIlllIlIllII();local llIIIIIIllIIlIIllIllIll=lIlIlllllIIllIlllIlIllII();local lIlIlllllIlIlIIIlll=1;local llIIIllllllllIIII=(IIlllIllllIlllIlllIlllIl(llIIIIIIllIIlIIllIllIll,1,20)*(2^32))+llIIIllllllllIIII;local lIlIlllllIIllIlllIlIllII=IIlllIllllIlllIlllIlllIl(llIIIIIIllIIlIIllIllIll,21,31);local llIIIIIIllIIlIIllIllIll=((-1)^IIlllIllllIlllIlllIlllIl(llIIIIIIllIIlIIllIllIll,32));if(lIlIlllllIIllIlllIlIllII==0)then if(llIIIllllllllIIII==0)then return llIIIIIIllIIlIIllIllIll*0;else lIlIlllllIIllIlllIlIllII=1;lIlIlllllIlIlIIIlll=0;end;elseif(lIlIlllllIIllIlllIlIllII==2047)then return(llIIIllllllllIIII==0)and(llIIIIIIllIIlIIllIllIll*(1/0))or(llIIIIIIllIIlIIllIllIll*(0/0));end;return IIlllIllIllIIlIlIlII(llIIIIIIllIIlIIllIllIll,lIlIlllllIIllIlllIlIllII-1023)*(lIlIlllllIlIlIIIlll+(llIIIllllllllIIII/(2^52)));end;local IIlllIllIllIIlIlIlII=lIlIlllllIIllIlllIlIllII;local function llllIlllllllllllI(lIlIlllllIIllIlllIlIllII)local IIlllIllllIlllIlllIlllIl;if(not lIlIlllllIIllIlllIlIllII)then lIlIlllllIIllIlllIlIllII=IIlllIllIllIIlIlIlII();if(lIlIlllllIIllIlllIlIllII==0)then return'';end;end;IIlllIllllIlllIlllIlllIl=lIlIlllllIlIlIIIlll(IlIlIIIlIIIlIIlllIIlIl,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll+lIlIlllllIIllIlllIlIllII-1);llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll+lIlIlllllIIllIlllIlIllII;local lIlIlllllIIllIlllIlIllII={}for llIIIIIIllIIlIIllIllIll=1,#IIlllIllllIlllIlllIlllIl do lIlIlllllIIllIlllIlIllII[llIIIIIIllIIlIIllIllIll]=lIlIlllIIIlIIlIIIIIlll(llIIIllllllllIIII(IIllIlllIlIll(lIlIlllllIlIlIIIlll(IIlllIllllIlllIlllIlllIl,llIIIIIIllIIlIIllIllIll,llIIIIIIllIIlIIllIllIll)),146))end return IllIIlllllIII(lIlIlllllIIllIlllIlIllII);end;local llIIIIIIllIIlIIllIllIll=lIlIlllllIIllIlllIlIllII;local function IIlllIllIllIIlIlIlII(...)return{...},IIllllIllIIIll('#',...)end local function IlIlIIIlIIIlIIlllIIlIl()local lIlIlllIIIlIIlIIIIIlll={};local IllIIlllllIII={};local llIIIIIIllIIlIIllIllIll={};local IIllIlllIlIll={[#{{386;642;741;132};"1 + 1 = 111";}]=IllIIlllllIII,[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]=nil,[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]=llIIIIIIllIIlIIllIllIll,[#{{306;256;64;142};}]=lIlIlllIIIlIIlIIIIIlll,};local llIIIIIIllIIlIIllIllIll=lIlIlllllIIllIlllIlIllII()local llIIIllllllllIIII={}for IIlllIllllIlllIlllIlllIl=1,llIIIIIIllIIlIIllIllIll do local lIlIlllllIIllIlllIlIllII=lllIlIllIlllllIlIIIl();local llIIIIIIllIIlIIllIllIll;if(lIlIlllllIIllIlllIlIllII==2)then llIIIIIIllIIlIIllIllIll=(lllIlIllIlllllIlIIIl()~=0);elseif(lIlIlllllIIllIlllIlIllII==1)then llIIIIIIllIIlIIllIllIll=llllIlIIIlIllII();elseif(lIlIlllllIIllIlllIlIllII==3)then llIIIIIIllIIlIIllIllIll=llllIlllllllllllI();end;llIIIllllllllIIII[IIlllIllllIlllIlllIlllIl]=llIIIIIIllIIlIIllIllIll;end;IIllIlllIlIll[3]=lllIlIllIlllllIlIIIl();for IIllIlllIlIll=1,lIlIlllllIIllIlllIlIllII()do local llIIIIIIllIIlIIllIllIll=lllIlIllIlllllIlIIIl();if(IIlllIllllIlllIlllIlllIl(llIIIIIIllIIlIIllIllIll,1,1)==0)then local lIlIlllllIlIlIIIlll=IIlllIllllIlllIlllIlllIl(llIIIIIIllIIlIIllIllIll,2,3);local lllIlIllIllIIllII=IIlllIllllIlllIlllIlllIl(llIIIIIIllIIlIIllIllIll,4,6);local llIIIIIIllIIlIIllIllIll={IlIIllIlIIllIII(),IlIIllIlIIllIII(),nil,nil};if(lIlIlllllIlIlIIIlll==0)then llIIIIIIllIIlIIllIllIll[#("gLP")]=IlIIllIlIIllIII();llIIIIIIllIIlIIllIllIll[#("ODaI")]=IlIIllIlIIllIII();elseif(lIlIlllllIlIlIIIlll==1)then llIIIIIIllIIlIIllIllIll[#("uJh")]=lIlIlllllIIllIlllIlIllII();elseif(lIlIlllllIlIlIIIlll==2)then llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{515;441;996;552};{94;388;378;534};}]=lIlIlllllIIllIlllIlIllII()-(2^16)elseif(lIlIlllllIlIlIIIlll==3)then llIIIIIIllIIlIIllIllIll[#("WWu")]=lIlIlllllIIllIlllIlIllII()-(2^16)llIIIIIIllIIlIIllIllIll[#("le8U")]=IlIIllIlIIllIII();end;if(IIlllIllllIlllIlllIlllIl(lllIlIllIllIIllII,1,1)==1)then llIIIIIIllIIlIIllIllIll[#{{419;959;783;242};"1 + 1 = 111";}]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll[#("nz")]]end if(IIlllIllllIlllIlllIlllIl(lllIlIllIllIIllII,2,2)==1)then llIIIIIIllIIlIIllIllIll[#("TeG")]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{787;47;472;712};{953;220;288;267};}]]end if(IIlllIllllIlllIlllIlllIl(lllIlIllIllIIllII,3,3)==1)then llIIIIIIllIIlIIllIllIll[#("l602")]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll[#("kzzM")]]end lIlIlllIIIlIIlIIIIIlll[IIllIlllIlIll]=llIIIIIIllIIlIIllIllIll;end end;for llIIIIIIllIIlIIllIllIll=1,lIlIlllllIIllIlllIlIllII()do IllIIlllllIII[llIIIIIIllIIlIIllIllIll-1]=IlIlIIIlIIIlIIlllIIlIl();end;return IIllIlllIlIll;end;local function lIlIlllIIIlIIlIIIIIlll(llIIIIIIllIIlIIllIllIll,IIllIlllIlIll,IlIIllIlIIllIII)llIIIIIIllIIlIIllIllIll=(llIIIIIIllIIlIIllIllIll==true and IlIlIIIlIIIlIIlllIIlIl())or llIIIIIIllIIlIIllIllIll;return(function(...)local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll[1];local lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[3];local IllIIlllllIII=llIIIIIIllIIlIIllIllIll[2];local IIlllIllIllIIlIlIlII=IIlllIllIllIIlIlIlII local lIlIlllllIIllIlllIlIllII=1;local lllIlIllIlllllIlIIIl=-1;local IlIIIIlII={};local llllIlIIIlIllII={...};local IIllllIllIIIll=IIllllIllIIIll('#',...)-1;local IlIlIIIlIIIlIIlllIIlIl={};local IIlllIllllIlllIlllIlllIl={};for llIIIIIIllIIlIIllIllIll=0,IIllllIllIIIll do if(llIIIIIIllIIlIIllIllIll>=lIlIlllllIlIlIIIlll)then IlIIIIlII[llIIIIIIllIIlIIllIllIll-lIlIlllllIlIlIIIlll]=llllIlIIIlIllII[llIIIIIIllIIlIIllIllIll+1];else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=llllIlIIIlIllII[llIIIIIIllIIlIIllIllIll+#{"1 + 1 = 111";}];end;end;local llIIIIIIllIIlIIllIllIll=IIllllIllIIIll-lIlIlllllIlIlIIIlll+1 local llIIIIIIllIIlIIllIllIll;local lIlIlllllIlIlIIIlll;while true do llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("N")];if lIlIlllllIlIlIIIlll<=#("TclU7GYy7DYkKKPj9HUWNnRG0LOCnT9VycBpUy")then if lIlIlllllIlIlIIIlll<=#("787h2MKexJmXC3lbFu")then if lIlIlllllIlIlIIIlll<=#("3v1xjnEc")then if lIlIlllllIlIlIIIlll<=#("Ijz")then if lIlIlllllIlIlIIIlll<=#("M")then if lIlIlllllIlIlIIIlll>#("")then local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Z9")]]=llIIIIIIllIIlIIllIllIll[#("tzN")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("tc")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{722;230;375;741};}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tZR")]][llIIIIIIllIIlIIllIllIll[#("1ujR")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("cZ")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("NpQ")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("gQ")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("3hn")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{454;196;62;523};"1 + 1 = 111";"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Yo")]]=llIIIIIIllIIlIIllIllIll[#("0pG")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sG")]]=llIIIIIIllIIlIIllIllIll[#("7au")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("JF")]]=llIIIIIIllIIlIIllIllIll[#("D1H")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Ge")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("Ary")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("lH")]][llIIIIIIllIIlIIllIllIll[#("QBG")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("53S4")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("K6")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("6vV")]][llIIIIIIllIIlIIllIllIll[#("GfIk")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Iv")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("lsc")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("US")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("g5v")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("7J")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("fK")]][llIIIIIIllIIlIIllIllIll[#("1bo")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("zFTr")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("8i")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mkr")]][llIIIIIIllIIlIIllIllIll[#("ABdJ")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("H5")]][llIIIIIIllIIlIIllIllIll[#("eks")]]=llIIIIIIllIIlIIllIllIll[#("H1XD")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("M4")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sea")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("5p")]][llIIIIIIllIIlIIllIllIll[#("2qT")]]=llIIIIIIllIIlIIllIllIll[#("tBCy")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];do return end;else local llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll[#("ZX")]IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll](IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll+1])end;elseif lIlIlllllIlIlIIIlll>#("XQ")then if IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("vo")]]then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("LqJ")];end;else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("xD")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("F2J")]][llIIIIIIllIIlIIllIllIll[#("rn6l")]];end;elseif lIlIlllllIlIlIIIlll<=#("Z3qHr")then if lIlIlllllIlIlIIIlll>#("a6H2")then local lIlIlllllIlIlIIIlll;local IIllIlllIlIll;local IlIlIIIlIIIlIIlllIIlIl,IllIIlllllIII;local lIlIlllIIIlIIlIIIIIlll;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("iJ")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("8Yv")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Od")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("G5W")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("vu")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("cjm")]][llIIIIIIllIIlIIllIllIll[#("f0nr")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("cE")];lIlIlllIIIlIIlIIIIIlll=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("im2")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lIlIlllIIIlIIlIIIIIlll;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lIlIlllIIIlIIlIIIIIlll[llIIIIIIllIIlIIllIllIll[#("xL1B")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("KI")]IlIlIIIlIIIlIIlllIIlIl,IllIIlllllIII=IIlllIllIllIIlIlIlII(IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]))lllIlIllIlllllIlIIIl=IllIIlllllIII+lIlIlllllIlIlIIIlll-1 IIllIlllIlIll=0;for llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll,lllIlIllIlllllIlIIIl do IIllIlllIlIll=IIllIlllIlIll+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=IlIlIIIlIIIlIIlllIIlIl[IIllIlllIlIll];end;lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("6P")]IlIlIIIlIIIlIIlllIIlIl={IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,lllIlIllIlllllIlIIIl))};IIllIlllIlIll=0;for llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll,llIIIIIIllIIlIIllIllIll[#("7YeK")]do IIllIlllIlIll=IIllIlllIlIll+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=IlIlIIIlIIIlIIlllIIlIl[IIllIlllIlIll];end lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("csu")];else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("rQO")];end;elseif lIlIlllllIlIlIIIlll<=#("a55dE9")then local lllIlIllIlllllIlIIIl;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("d8")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("m3a")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("DTS")]][llIIIIIIllIIlIIllIllIll[#("dfo2")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{199;448;417;327};}];lllIlIllIlllllIlIIIl=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("LNu")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIlllllIlIIIl;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIlllllIlIIIl[llIIIIIIllIIlIIllIllIll[#("mVbS")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("NM")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("ZV6")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("hT")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sMs")]][llIIIIIIllIIlIIllIllIll[#{{783;640;883;456};{942;612;888;46};"1 + 1 = 111";"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("cZ")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("ent")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("A2")];lllIlIllIlllllIlIIIl=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("zXC")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIlllllIlIIIl;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIlllllIlIIIl[llIIIIIIllIIlIIllIllIll[#("lE2Q")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Op")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];do return end;elseif lIlIlllllIlIlIIIlll>#{"1 + 1 = 111";{108;311;483;990};{97;159;449;67};"1 + 1 = 111";"1 + 1 = 111";{732;414;946;248};"1 + 1 = 111";}then do return end;else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("63")]][llIIIIIIllIIlIIllIllIll[#("HCy")]]=llIIIIIIllIIlIIllIllIll[#("RNFJ")];end;elseif lIlIlllllIlIlIIIlll<=#("jXlqfyvzGWMZK")then if lIlIlllllIlIlIIIlll<=#("jq7kKInEvh")then if lIlIlllllIlIlIIIlll==#("Sl3mBtDbd")then local lIlIlllllIlIlIIIlll;local IIllIlllIlIll;local IlIlIIIlIIIlIIlllIIlIl,IllIIlllllIII;local lIlIlllIIIlIIlIIIIIlll;local lIlIlllllIlIlIIIlll;lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Jp")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("jHv")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("bA")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("5l6")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Xt")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("C24")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("0V")];lIlIlllIIIlIIlIIIIIlll=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("2M6")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lIlIlllIIIlIIlIIIIIlll;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lIlIlllIIIlIIlIIIIIlll[llIIIIIIllIIlIIllIllIll[#("SC34")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("nr")]IlIlIIIlIIIlIIlllIIlIl,IllIIlllllIII=IIlllIllIllIIlIlIlII(IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]))lllIlIllIlllllIlIIIl=IllIIlllllIII+lIlIlllllIlIlIIIlll-1 IIllIlllIlIll=0;for llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll,lllIlIllIlllllIlIIIl do IIllIlllIlIll=IIllIlllIlIll+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=IlIlIIIlIIIlIIlllIIlIl[IIllIlllIlIll];end;lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("LT")]IlIlIIIlIIIlIIlllIIlIl={IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,lllIlIllIlllllIlIIIl))};IIllIlllIlIll=0;for llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll,llIIIIIIllIIlIIllIllIll[#("Gx1I")]do IIllIlllIlIll=IIllIlllIlIll+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=IlIlIIIlIIIlIIlllIIlIl[IIllIlllIlIll];end lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("x8Y")];else if(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("M4")]]~=llIIIIIIllIIlIIllIllIll[#("m9dX")])then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("y6U")];end;end;elseif lIlIlllllIlIlIIIlll<=#("nVpWZOHzr1j")then local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll[#("YH")]local lIlIlllllIlIlIIIlll={IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,llIIIllllllllIIII+1,lllIlIllIlllllIlIIIl))};local lIlIlllllIIllIlllIlIllII=0;for llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII,llIIIIIIllIIlIIllIllIll[#("tYFq")]do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=lIlIlllllIlIlIIIlll[lIlIlllllIIllIlllIlIllII];end elseif lIlIlllllIlIlIIIlll==#("iOMBzn79QBde")then local IIllIlllIlIll;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("xG")]]=llIIIIIIllIIlIIllIllIll[#("JMk")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Tz")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("qHX")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("CB")]][llIIIIIIllIIlIIllIllIll[#("ocg")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tpvD")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sY")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("AtC")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PL")]]();lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Ut")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("P9q")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Nl")];IIllIlllIlIll=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tYG")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IIllIlllIlIll;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("D5yT")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]]=llIIIIIIllIIlIIllIllIll[#("1lZ")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Uc")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("OS3")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("1t")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Wxd")]][llIIIIIIllIIlIIllIllIll[#("BLQm")]];else local lllIlIllIlllllIlIIIl;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("cV")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("brc")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("HP")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("eVq")]][llIIIIIIllIIlIIllIllIll[#("U2hn")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Xe")];lllIlIllIlllllIlIIIl=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("GO1")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIlllllIlIIIl;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIlllllIlIIIl[llIIIIIIllIIlIIllIllIll[#("LkXW")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Wz")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{130;554;752;542};{571;6;540;177};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("o4")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PIO")]][llIIIIIIllIIlIIllIllIll[#("lAea")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("C6")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("gyY")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("G1")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#{{223;812;862;465};"1 + 1 = 111";"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("uk")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("i2G")]][llIIIIIIllIIlIIllIllIll[#("2inM")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PU")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{480;495;272;130};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("k9")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("6vh")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("lK")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("HQr")]][llIIIIIIllIIlIIllIllIll[#("CfBE")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Tq")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{704;218;191;358};"1 + 1 = 111";}]]=llIIIIIIllIIlIIllIllIll[#("tWb")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("t6")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("RFI")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("F1")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("Ssm")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Ty")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("E6m")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{387;253;85;617};"1 + 1 = 111";"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("hr")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("qTR")]][llIIIIIIllIIlIIllIllIll[#("Lt1i")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("hYW")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("zR")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("NMC")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("x2")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Agn")]][llIIIIIIllIIlIIllIllIll[#("BRrW")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("IN")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]][llIIIIIIllIIlIIllIllIll[#("fKW")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("iDKR")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("nF")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("nJ0")]][llIIIIIIllIIlIIllIllIll[#("c1yl")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("AF")]][llIIIIIIllIIlIIllIllIll[#("trt")]]=llIIIIIIllIIlIIllIllIll[#("sxd1")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mm")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("6C4")]][llIIIIIIllIIlIIllIllIll[#("OCOm")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tZ")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]]=llIIIIIIllIIlIIllIllIll[#("McxE")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("I5")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("9Of")]][llIIIIIIllIIlIIllIllIll[#("2J6e")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];if IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("dd")]]then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("9Ns")];end;end;elseif lIlIlllllIlIlIIIlll<=#("mDlfCiYHU5GRyV3")then if lIlIlllllIlIlIIIlll>#("fepbmcpLa5pddc")then if(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("qY")]]<llIIIIIIllIIlIIllIllIll[#("k1Cq")])then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#{{741;915;560;314};"1 + 1 = 111";{491;904;131;159};}];end;else local lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Pu")];local IlIIllIlIIllIII=llIIIIIIllIIlIIllIllIll[#("8GUo")];local llIIIllllllllIIII=lIlIlllllIlIlIIIlll+2 local lIlIlllllIlIlIIIlll={IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1],IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII])};for llIIIIIIllIIlIIllIllIll=1,IlIIllIlIIllIII do IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII+llIIIIIIllIIlIIllIllIll]=lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll];end;local lIlIlllllIlIlIIIlll=lIlIlllllIlIlIIIlll[1]if lIlIlllllIlIlIIIlll then IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII]=lIlIlllllIlIlIIIlll lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("eWI")];else lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;end;elseif lIlIlllllIlIlIIIlll<=#("RkyMlvt0Tv8zSgUb")then local IIllIlllIlIll;local lllIlIllIlllllIlIIIl;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("DK")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("krL")]][llIIIIIIllIIlIIllIllIll[#("SL7j")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("aV")]]=llIIIIIIllIIlIIllIllIll[#("3cs")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("l7")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("FZB")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("9G")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("SCk")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{256;758;492;897};{750;138;533;993};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("OR")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ZAB")]][llIIIIIIllIIlIIllIllIll[#("9de1")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("rl")]]=llIIIIIIllIIlIIllIllIll[#("Fq5")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("He")]]=llIIIIIIllIIlIIllIllIll[#("qVL")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("pZ")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{912;109;536;735};{355;848;975;384};}]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("KF")]]=llIIIIIIllIIlIIllIllIll[#("3b0")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lllIlIllIlllllIlIIIl=llIIIIIIllIIlIIllIllIll[#("SK4")];IIllIlllIlIll=IIlllIllllIlllIlllIlllIl[lllIlIllIlllllIlIIIl]for llIIIIIIllIIlIIllIllIll=lllIlIllIlllllIlIIIl+1,llIIIIIIllIIlIIllIllIll[#("gggH")]do IIllIlllIlIll=IIllIlllIlIll..IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll];end;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("yr")]]=IIllIlllIlIll;lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("KI")]][llIIIIIIllIIlIIllIllIll[#("vpa")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("E5tf")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("lgx")];elseif lIlIlllllIlIlIIIlll>#("dtLxXdljnLfH3VDRj")then if IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("d7")]]then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("dSX")];end;else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Il")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("vgz")]];end;elseif lIlIlllllIlIlIIIlll<=#("GaiSuVoHQnOHFp4Y9UCz3hmD8Vos")then if lIlIlllllIlIlIIIlll<=#("LGRIrnatv8Ziqx7GQfZMeVS")then if lIlIlllllIlIlIIIlll<=#("U4yYQUKH5ReS69mc3EOW")then if lIlIlllllIlIlIIIlll>#("qNVo6rPAQV0XCYx0mNL")then if(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Li")]]<llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{309;904;1;73};{987;645;253;699};"1 + 1 = 111";}])then lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("vaA")];else lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;else local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll[#("Cnv")];local lIlIlllllIIllIlllIlIllII=IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII]for llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII+1,llIIIIIIllIIlIIllIllIll[#("iSzn")]do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII..IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll];end;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("cJ")]]=lIlIlllllIIllIlllIlIllII;end;elseif lIlIlllllIlIlIIIlll<=#("rnJspJR3WTKg6MErNJTC5")then local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("CA")]]=llIIIIIIllIIlIIllIllIll[#("6qr")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("48")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ei")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Mtz")]][llIIIIIIllIIlIIllIllIll[#("bfmE")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Sn")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("GEf")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tB")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("qVz")]][llIIIIIIllIIlIIllIllIll[#("NJaX")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("VY")]]=llIIIIIIllIIlIIllIllIll[#("yab")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Gz")]]=llIIIIIIllIIlIIllIllIll[#("4nY")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("TK")]]=llIIIIIIllIIlIIllIllIll[#("N6F")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("2U")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("jWF")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{790;951;154;267};{264;649;747;555};}]][llIIIIIIllIIlIIllIllIll[#("3mn")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("hWLI")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("9m")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ZR9")]][llIIIIIIllIIlIIllIllIll[#{{961;759;644;692};"1 + 1 = 111";"1 + 1 = 111";{731;813;948;771};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Hh")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("sIi")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ajN")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("iF")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("4v")]][llIIIIIIllIIlIIllIllIll[#("MqU")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Xr2e")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("jo")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mK2")]][llIIIIIIllIIlIIllIllIll[#("uDuR")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("k0")]][llIIIIIIllIIlIIllIllIll[#("CEd")]]=llIIIIIIllIIlIIllIllIll[#("qO1O")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mH")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ZRf")]][llIIIIIIllIIlIIllIllIll[#("b3NL")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("CT")]][llIIIIIIllIIlIIllIllIll[#("88u")]]=llIIIIIIllIIlIIllIllIll[#("44G8")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];do return end;elseif lIlIlllllIlIlIIIlll==#("o6o4EkZlQ0czucdD8yLVN7")then if(llIIIIIIllIIlIIllIllIll[#("Mb")]<=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PtnI")]])then lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}];else lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;else local lllIlIllIllIIllII;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Mx")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("aqD")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("uS")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("f6X")]][llIIIIIIllIIlIIllIllIll[#("TFGT")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{996;368;838;123};}];lllIlIllIllIIllII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("t3f")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIllIIllII;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIllIIllII[llIIIIIIllIIlIIllIllIll[#("Umi4")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("kH")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("xx")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("bd4")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("IZ")]][llIIIIIIllIIlIIllIllIll[#("uGD")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("jntO")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("aT")]][llIIIIIIllIIlIIllIllIll[#("Nt4")]]=llIIIIIIllIIlIIllIllIll[#("E561")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("pH")]]={};lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{184;877;811;868};}]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("Cz3")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("gf")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{786;979;386;250};"1 + 1 = 111";{974;675;489;378};}]][llIIIIIIllIIlIIllIllIll[#{{610;880;652;848};{484;957;91;398};"1 + 1 = 111";"1 + 1 = 111";}]];end;elseif lIlIlllllIlIlIIIlll<=#("T10tfnN4jCj9NdveGdLcTeIqB")then if lIlIlllllIlIlIIIlll>#("kLv1kFqWGdO1U8c636ldBzNs")then local lllIlIllIlllllIlIIIl=IllIIlllllIII[llIIIIIIllIIlIIllIllIll[#("5cB")]];local lllIlIllIllIIllII;local lIlIlllllIlIlIIIlll={};lllIlIllIllIIllII=IIlIIIIll({},{__index=function(lIlIlllllIIllIlllIlIllII,llIIIIIIllIIlIIllIllIll)local llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll];return llIIIIIIllIIlIIllIllIll[1][llIIIIIIllIIlIIllIllIll[2]];end,__newindex=function(IIlllIllllIlllIlllIlllIl,llIIIIIIllIIlIIllIllIll,lIlIlllllIIllIlllIlIllII)local llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll]llIIIIIIllIIlIIllIllIll[1][llIIIIIIllIIlIIllIllIll[2]]=lIlIlllllIIllIlllIlIllII;end;});for IlIIllIlIIllIII=1,llIIIIIIllIIlIIllIllIll[#("2V4h")]do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;local llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];if llIIIIIIllIIlIIllIllIll[#("v")]==60 then lIlIlllllIlIlIIIlll[IlIIllIlIIllIII-1]={IIlllIllllIlllIlllIlllIl,llIIIIIIllIIlIIllIllIll[#("hFN")]};else lIlIlllllIlIlIIIlll[IlIIllIlIIllIII-1]={IIllIlllIlIll,llIIIIIIllIIlIIllIllIll[#("RKv")]};end;IlIlIIIlIIIlIIlllIIlIl[#IlIlIIIlIIIlIIlllIIlIl+1]=lIlIlllllIlIlIIIlll;end;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("pL")]]=lIlIlllIIIlIIlIIIIIlll(lllIlIllIlllllIlIIIl,lllIlIllIllIIllII,IlIIllIlIIllIII);else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("eH")]]=lIlIlllIIIlIIlIIIIIlll(IllIIlllllIII[llIIIIIIllIIlIIllIllIll[#("MmS")]],nil,IlIIllIlIIllIII);end;elseif lIlIlllllIlIlIIIlll<=#{{881;478;657;167};{718;582;980;515};{787;385;544;375};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{210;611;978;406};{21;157;489;645};{609;477;858;326};{671;941;63;261};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{122;580;83;6};{857;960;331;960};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{621;569;379;826};{418;932;8;591};"1 + 1 = 111";}then local lllIlIllIlllllIlIIIl=IllIIlllllIII[llIIIIIIllIIlIIllIllIll[#("dbT")]];local lllIlIllIllIIllII;local lIlIlllllIlIlIIIlll={};lllIlIllIllIIllII=IIlIIIIll({},{__index=function(lIlIlllllIIllIlllIlIllII,llIIIIIIllIIlIIllIllIll)local llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll];return llIIIIIIllIIlIIllIllIll[1][llIIIIIIllIIlIIllIllIll[2]];end,__newindex=function(IIlllIllllIlllIlllIlllIl,llIIIIIIllIIlIIllIllIll,lIlIlllllIIllIlllIlIllII)local llIIIIIIllIIlIIllIllIll=lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll]llIIIIIIllIIlIIllIllIll[1][llIIIIIIllIIlIIllIllIll[2]]=lIlIlllllIIllIlllIlIllII;end;});for IlIIllIlIIllIII=1,llIIIIIIllIIlIIllIllIll[#("aoWu")]do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;local llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];if llIIIIIIllIIlIIllIllIll[#("A")]==60 then lIlIlllllIlIlIIIlll[IlIIllIlIIllIII-1]={IIlllIllllIlllIlllIlllIl,llIIIIIIllIIlIIllIllIll[#{{455;981;5;406};{698;773;421;663};{636;713;550;551};}]};else lIlIlllllIlIlIIIlll[IlIIllIlIIllIII-1]={IIllIlllIlIll,llIIIIIIllIIlIIllIllIll[#("x05")]};end;IlIlIIIlIIIlIIlllIIlIl[#IlIlIIIlIIIlIIlllIIlIl+1]=lIlIlllllIlIlIIIlll;end;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mJ")]]=lIlIlllIIIlIIlIIIIIlll(lllIlIllIlllllIlIIIl,lllIlIllIllIIllII,IlIIllIlIIllIII);elseif lIlIlllllIlIlIIIlll>#("fyWV8cWDDxv0Uf815ayLPHvK1u2")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("TO")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("dVO")]];else local llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll[#("Ba")]IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll](IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll+1])end;elseif lIlIlllllIlIlIIIlll<=#("yA4NESDFfrdGGZluFRIuQCQ9AJ5Jcl4Ok")then if lIlIlllllIlIlIIIlll<=#("edCSxcMEWO71e0vafjXIT6T5n4W4C4")then if lIlIlllllIlIlIIIlll>#("AukUi2XuFSmQccIEfnbgU0NMitHFC")then local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll[#("Z77")];local lIlIlllllIIllIlllIlIllII=IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII]for llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII+1,llIIIIIIllIIlIIllIllIll[#("Wihn")]do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII..IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll];end;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("aZ")]]=lIlIlllllIIllIlllIlIllII;else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("p3")]]={};end;elseif lIlIlllllIlIlIIIlll<=#("Sb1qHG4fnhrYrZHpR3PARRAXMJSIMYv")then local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("LL")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("N9l")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Tx")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("37O")]][llIIIIIIllIIlIIllIllIll[#("YUSa")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("gU")]]=llIIIIIIllIIlIIllIllIll[#{{616;874;687;879};{160;281;198;841};{105;541;149;223};}];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tz")]]=llIIIIIIllIIlIIllIllIll[#("R88")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("54")]]=llIIIIIIllIIlIIllIllIll[#("0ch")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("3s")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("8UJ")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Vv")]][llIIIIIIllIIlIIllIllIll[#("K5C")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("RK2h")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Kq")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("6Mf")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{310;497;307;849};{998;24;529;377};}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("pTr")]][llIIIIIIllIIlIIllIllIll[#("UxxE")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("XK")]]=llIIIIIIllIIlIIllIllIll[#{{149;807;819;454};{241;253;36;206};"1 + 1 = 111";}];elseif lIlIlllllIlIlIIIlll==#("3palYWFbK9a4Y6JYf3NNZbJaLeO7YxEz")then if(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("H0")]]<llIIIIIIllIIlIIllIllIll[#("73uj")])then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{498;340;64;594};{591;386;309;695};}];end;else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("DP")]]();end;elseif lIlIlllllIlIlIIIlll<=#("95cYuB4yN0SRG8Qa4CTlSD2Q9KUiHnmFLiY")then if lIlIlllllIlIlIIIlll==#{"1 + 1 = 111";{135;417;668;190};{421;317;185;189};"1 + 1 = 111";{241;818;240;914};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{887;360;266;637};"1 + 1 = 111";{572;834;501;945};{975;331;474;73};{524;254;955;18};{895;260;106;671};{194;889;766;107};{498;656;983;15};{225;629;217;403};"1 + 1 = 111";{787;960;772;469};"1 + 1 = 111";{2;759;372;589};"1 + 1 = 111";{299;460;516;534};{439;5;148;448};{192;307;492;685};{106;424;292;787};{790;239;643;719};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{469;827;715;487};"1 + 1 = 111";"1 + 1 = 111";{720;738;968;903};}then local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII]=IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII+1,llIIIIIIllIIlIIllIllIll[#("0Qa")]))else if(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sg")]]<llIIIIIIllIIlIIllIllIll[#("9sbb")])then lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#{{980;936;956;17};{756;94;914;129};{363;145;873;345};}];else lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;end;elseif lIlIlllllIlIlIIIlll<=#("4RqDDqSZPGPkLsrUyer7kjaV5zWGOoR5qC9n")then do return IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("SA")]]end elseif lIlIlllllIlIlIIIlll>#("ULpvGjocMphvDRt2TuURGHeFlkBYT3isepNDb")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("WF")]]=lIlIlllIIIlIIlIIIIIlll(IllIIlllllIII[llIIIIIIllIIlIIllIllIll[#("Zba")]],nil,IlIIllIlIIllIII);else if(llIIIIIIllIIlIIllIllIll[#("xg")]<=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("5B9p")]])then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("A4p")];end;end;elseif lIlIlllllIlIlIIIlll<=#("OaVStiOklHxcIhoH7mGVkuTAsShYrme00hRU5Ym60a93CRvbeIsA6qBsq")then if lIlIlllllIlIlIIIlll<=#("AMa039DHlBBFLjaK4jvZ8MxgUT4O3JQyDKyL59h9B4F4KK6")then if lIlIlllllIlIlIIIlll<=#("Axxq6CxYp4gjfZNMUcbbVzP4cxydgCGkXVnHmzCbmK")then if lIlIlllllIlIlIIIlll<=#("a374Mr2kII4xaRDoKdsRXz6xtLfAuLaYldObeDWW")then if lIlIlllllIlIlIIIlll>#("r7M2ymZUk2732IL6LKalDZ7Igl7cBjhrHDFBuE5")then if(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tF")]]~=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{469;405;834;3};{958;414;420;656};{318;562;621;964};}])then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("FSg")];end;else local lllIlIllIlllllIlIIIl;local lIlIlllllIlIlIIIlll;lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Pa")];lllIlIllIlllllIlIIIl=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("2v9")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIlllllIlIIIl;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIlllllIlIIIl[llIIIIIIllIIlIIllIllIll[#("odLM")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("nR")]]=llIIIIIIllIIlIIllIllIll[#("Q46")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("ss")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("4dL")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("6X")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("blA")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("EC")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("5xj")]][llIIIIIIllIIlIIllIllIll[#("s2WO")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("5V")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{628;529;478;683};"1 + 1 = 111";{594;41;791;224};}]][llIIIIIIllIIlIIllIllIll[#("O2s9")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("QC")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("SzO")]][llIIIIIIllIIlIIllIllIll[#("2X7Q")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("B1")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("OkJ")]][llIIIIIIllIIlIIllIllIll[#("FTRB")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Zq")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("4xF")]][llIIIIIIllIIlIIllIllIll[#("pLMd")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("AB")];lllIlIllIlllllIlIIIl=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Qcy")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIlllllIlIIIl;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIlllllIlIIIl[llIIIIIIllIIlIIllIllIll[#("7NBn")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Cm")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PY")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("472")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("P4")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Bc2")]][llIIIIIIllIIlIIllIllIll[#("3rTq")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("La")]][llIIIIIIllIIlIIllIllIll[#("Evb")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("gHx2")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("NW")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("IbP")]][llIIIIIIllIIlIIllIllIll[#("ciaY")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Rs")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("GWp")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{896;598;732;179};"1 + 1 = 111";}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("par")]][llIIIIIIllIIlIIllIllIll[#("IZd8")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("IN")]][llIIIIIIllIIlIIllIllIll[#("F7d")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Gxj8")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]][llIIIIIIllIIlIIllIllIll[#("R5n")]]=llIIIIIIllIIlIIllIllIll[#("RpTG")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Ez")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("8rk")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("p2")]][llIIIIIIllIIlIIllIllIll[#("AdX")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("aBf2")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("SF")]][llIIIIIIllIIlIIllIllIll[#("HBD")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("LdRB")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];do return end;end;elseif lIlIlllllIlIlIIIlll>#("qPkTc4sFceE2VKVDaeWmpWsaVQxzckMgOM5XOoFl2")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mZ")]]={};else if(llIIIIIIllIIlIIllIllIll[#("Lq")]<=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("8vYF")]])then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("jBe")];end;end;elseif lIlIlllllIlIlIIIlll<=#("9xPoG6ScBpSTiExj7xI3D2DxnjP8YWJKuXW6uGkAR9Tv")then if lIlIlllllIlIlIIIlll==#("5DCBEqhN89h4raxrUoORhyuRBYCmimDig8sQnItGB7v")then local lIlIlllllIlIlIIIlll;local lllIlIllIlllllIlIIIl;local IIllIlllIlIll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("uf")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("S58")]][llIIIIIIllIIlIIllIllIll[#("hLY2")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("BX")]]=llIIIIIIllIIlIIllIllIll[#("XgL")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("Qjq")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("qJ")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("9nH")]][llIIIIIIllIIlIIllIllIll[#("hKDC")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("g3")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("iii")]][llIIIIIIllIIlIIllIllIll[#("HiVO")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sv")]]=llIIIIIIllIIlIIllIllIll[#("05j")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Fl")]]=llIIIIIIllIIlIIllIllIll[#("8JV")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIllIlllIlIll=llIIIIIIllIIlIIllIllIll[#("mv")]IIlllIllllIlllIlllIlllIl[IIllIlllIlIll]=IIlllIllllIlllIlllIlllIl[IIllIlllIlIll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,IIllIlllIlIll+1,llIIIIIIllIIlIIllIllIll[#("IaK")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("55")]]=llIIIIIIllIIlIIllIllIll[#{{97;309;464;376};"1 + 1 = 111";{25;187;650;84};}];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lllIlIllIlllllIlIIIl=llIIIIIIllIIlIIllIllIll[#("6sg")];lIlIlllllIlIlIIIlll=IIlllIllllIlllIlllIlllIl[lllIlIllIlllllIlIIIl]for llIIIIIIllIIlIIllIllIll=lllIlIllIlllllIlIIIl+1,llIIIIIIllIIlIIllIllIll[#("0Y0Q")]do lIlIlllllIlIlIIIlll=lIlIlllllIlIlIIIlll..IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll];end;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("dF")]]=lIlIlllllIlIlIIIlll;lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("zp")]][llIIIIIIllIIlIIllIllIll[#("Qqd")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Mchp")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("XuR")];else local IlIIllIlIIllIII=llIIIIIIllIIlIIllIllIll[#("En")];local lIlIlllllIlIlIIIlll={};for llIIIIIIllIIlIIllIllIll=1,#IlIlIIIlIIIlIIlllIIlIl do local llIIIIIIllIIlIIllIllIll=IlIlIIIlIIIlIIlllIIlIl[llIIIIIIllIIlIIllIllIll];for lIlIlllllIIllIlllIlIllII=0,#llIIIIIIllIIlIIllIllIll do local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[lIlIlllllIIllIlllIlIllII];local llIIIllllllllIIII=lIlIlllllIIllIlllIlIllII[1];local llIIIIIIllIIlIIllIllIll=lIlIlllllIIllIlllIlIllII[2];if llIIIllllllllIIII==IIlllIllllIlllIlllIlllIl and llIIIIIIllIIlIIllIllIll>=IlIIllIlIIllIII then lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll];lIlIlllllIIllIlllIlIllII[1]=lIlIlllllIlIlIIIlll;end;end;end;end;elseif lIlIlllllIlIlIIIlll<=#("PbdFXh7VfPqHiU9QY5EWH8XtSQdl4hpkcHbzV6zaoRdBS")then do return IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("L2")]]end elseif lIlIlllllIlIlIIIlll>#("IDIORGDJrRoTXhdV07AfFLSL42GEIZ4vL7iLOqBTRDotkb")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("dp")]]=llIIIIIIllIIlIIllIllIll[#("34i")];else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("D8")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{699;121;441;163};{779;700;581;962};}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("EiNh")]];end;elseif lIlIlllllIlIlIIIlll<=#("r6D0fbMq6V6TY99bCX2i08DhKHQzbvzB2UoHe9Zu9Rl0RHMTSBXH")then if lIlIlllllIlIlIIIlll<=#("3ssEvqIunoKvG1eUD7D7HjjXNAc57QKJ1i9B6cTSqaVCMElQH")then if lIlIlllllIlIlIIIlll==#("pEuJVUjG05nNyHObFy2OYAnURHyRljoxy8BforxoqBmXFOMn")then local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("2L")]IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII]=IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII+1,llIIIIIIllIIlIIllIllIll[#("VG6")]))else local llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll[#("93")]local llIIIllllllllIIII,lIlIlllllIIllIlllIlIllII=IIlllIllIllIIlIlIlII(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll](IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll+1]))lllIlIllIlllllIlIIIl=lIlIlllllIIllIlllIlIllII+llIIIIIIllIIlIIllIllIll-1 local lIlIlllllIIllIlllIlIllII=0;for llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll,lllIlIllIlllllIlIIIl do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];end;end;elseif lIlIlllllIlIlIIIlll<=#("K8YY3kZqK2oxCtQR0oAgJWnaNxynApc4j4LlBJFXLZOzi2YgGg")then local IlIIllIlIIllIII;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("cg")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("uWv")]][llIIIIIIllIIlIIllIllIll[#("jIOx")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";}];IlIIllIlIIllIII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("JmK")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IlIIllIlIIllIII;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("fC16")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("tF")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("qVM")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{303;706;66;158};"1 + 1 = 111";"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Zk")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("cqK")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];if IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("F1")]]then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("13P")];end;elseif lIlIlllllIlIlIIIlll==#("AmhoXUXkGXM0uZumITFqrTMFTiY2VIqRtLNRcPXBNy9a89tJYPq")then local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll[#("ZN")];local IlIIllIlIIllIII=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{508;416;716;98};{287;895;93;179};}];local lIlIlllllIlIlIIIlll=llIIIllllllllIIII+2 local llIIIllllllllIIII={IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII](IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII+1],IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll])};for llIIIIIIllIIlIIllIllIll=1,IlIIllIlIIllIII do IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+llIIIIIIllIIlIIllIllIll]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll];end;local llIIIllllllllIIII=llIIIllllllllIIII[1]if llIIIllllllllIIII then IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=llIIIllllllllIIII lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("2C6")];else lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;else local IIllIlllIlIll;local lIlIlllllIlIlIIIlll;lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("bS")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("1JV")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("kC")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{461;63;647;364};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mU")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("x2H")]][llIIIIIIllIIlIIllIllIll[#("kFiK")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Zd")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("4yR")]][llIIIIIIllIIlIIllIllIll[#("eDJq")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Pd")];IIllIlllIlIll=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("U2c")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IIllIlllIlIll;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#{{722;668;464;490};{462;99;226;25};"1 + 1 = 111";{39;717;591;308};}]];end;elseif lIlIlllllIlIlIIIlll<=#("b0xQLMGP65A8G5HTmNk35eO3UMHUYpdfr3QDo7gBjhFR8bEdCKxkFx")then if lIlIlllllIlIlIIIlll>#("7mD68fV1Q1uQMpdFpHTTXJ65ThDrn23K4CTqWahvyqYZOu1YzfhOW")then local llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll[#("ax")]IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll](IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll+1])else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("fh")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ss8")]][llIIIIIIllIIlIIllIllIll[#("8Eyi")]];end;elseif lIlIlllllIlIlIIIlll<=#("OypIn1MENY8VWkHWTozyvHVgqypP3iVoXqXuanXqT4Oa12JRrMx2oyr")then lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{566;901;779;899};}];elseif lIlIlllllIlIlIIIlll==#("MjqZL7KEcT7FxlWFChOC2VoyZJxrW29A9QT177PWtj7i5dtg01BgT0o1")then local lllIlIllIlllllIlIIIl;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{898;645;153;27};"1 + 1 = 111";}]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("1rv")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("In")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("ZTY")]][llIIIIIIllIIlIIllIllIll[#("z64M")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#{{217;60;285;429};{607;558;101;283};}];lllIlIllIlllllIlIIIl=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{501;174;322;515};}]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=lllIlIllIlllllIlIIIl;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=lllIlIllIlllllIlIIIl[llIIIIIIllIIlIIllIllIll[#("OA1o")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("9d")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("VlD")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("58")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("TPP")]][llIIIIIIllIIlIIllIllIll[#("lfUh")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("91")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("ld4")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("jj")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("zYu")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("vE")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("LTZ")]][llIIIIIIllIIlIIllIllIll[#("OAey")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Ik")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("nhJ")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("aE")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{687;810;584;426};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("jT")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("KRk")]][llIIIIIIllIIlIIllIllIll[#("N3K1")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Lm")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("gN")]]=llIIIIIIllIIlIIllIllIll[#("m5x")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("ZH")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("0Ys")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("oZ")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("XDQ")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{779;956;431;468};}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("yvF")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{745;472;794;442};{370;478;145;979};}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{537;803;557;772};}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]][llIIIIIIllIIlIIllIllIll[#{{170;903;397;836};{117;782;782;6};{879;505;166;192};"1 + 1 = 111";}]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("F6")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("Qa2")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("SD")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("MyN")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("5a")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";{798;30;977;756};}]][llIIIIIIllIIlIIllIllIll[#("nLHf")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#{{420;877;608;970};"1 + 1 = 111";}]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1])lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("N0")]][llIIIIIIllIIlIIllIllIll[#("3QX")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PMti")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Eu")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("BnS")]][llIIIIIIllIIlIIllIllIll[#("3nmd")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("V3")]][llIIIIIIllIIlIIllIllIll[#("Bp2")]]=llIIIIIIllIIlIIllIllIll[#("JA9S")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Bt")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("CVQ")]][llIIIIIIllIIlIIllIllIll[#("GxdH")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Lh")]][llIIIIIIllIIlIIllIllIll[#("jdY")]]=llIIIIIIllIIlIIllIllIll[#{{140;27;762;320};"1 + 1 = 111";{270;444;270;579};"1 + 1 = 111";}];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Cl")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("qDH")]][llIIIIIIllIIlIIllIllIll[#("sltH")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];if IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("bL")]]then lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;else lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("dUF")];end;else local llIIIllllllllIIII=llIIIIIIllIIlIIllIllIll[#("aP")];local lIlIlllllIIllIlllIlIllII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("kn9")]];IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII+1]=lIlIlllllIIllIlllIlIllII;IIlllIllllIlllIlllIlllIl[llIIIllllllllIIII]=lIlIlllllIIllIlllIlIllII[llIIIIIIllIIlIIllIllIll[#("d28d")]];end;elseif lIlIlllllIlIlIIIlll<=#("2acKsSjTIGRC4IED2hTXgDVoqC5C2QiB26e6NlbBXzyINO5s6O1TFdXApYs1XS02xpK")then if lIlIlllllIlIlIIIlll<=#("EIZQfr9SfmLNHMFnYA5YiPQY2kOfIGkxd6ZzZkNmdfucmQtknMd7tWZY1aX5O4")then if lIlIlllllIlIlIIIlll<=#("JcnJKXgzOXTUduNLm0D15CndrhaHYxSJi5Va9gUygmAjLbVEozLeldnhYkr")then if lIlIlllllIlIlIIIlll==#("WKLqfjLiKNMggeUTcdCqvHszWNyfROlZZrMHMieBAN4LXF8gsFeVSafpqm")then local IlIIllIlIIllIII;local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("G2")]]=llIIIIIIllIIlIIllIllIll[#("Kk4")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Ok")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("IbL")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("k1")];IlIIllIlIIllIII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("INq")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IlIIllIlIIllIII;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("aJB7")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("sM")]]=llIIIIIIllIIlIIllIllIll[#("hhl")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("Q2")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("RD6")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("tP")];IlIIllIlIIllIII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("PJn")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IlIIllIlIIllIII;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("pA3c")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("pd")]]=llIIIIIIllIIlIIllIllIll[#("jLA")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("vg")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("TpL")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("hE")];IlIIllIlIIllIII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("pJk")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IlIIllIlIIllIII;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("I3lL")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("M7")]]=llIIIIIIllIIlIIllIllIll[#("08M")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#{{592;389;760;79};"1 + 1 = 111";}]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("DOV")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("G7")];IlIIllIlIIllIII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("mge")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IlIIllIlIIllIII;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#{{327;52;608;500};"1 + 1 = 111";{895;397;189;256};{419;951;573;166};}]];else local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("bg")]local lIlIlllllIlIlIIIlll={IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII+1,lllIlIllIlllllIlIIIl))};local llIIIllllllllIIII=0;for llIIIIIIllIIlIIllIllIll=lIlIlllllIIllIlllIlIllII,llIIIIIIllIIlIIllIllIll[#("nLi7")]do llIIIllllllllIIII=llIIIllllllllIIII+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=lIlIlllllIlIlIIIlll[llIIIllllllllIIII];end end;elseif lIlIlllllIlIlIIIlll<=#("CWGB6BXqYDng48a0TMRLrOrXlJBgYlvqzOMP4l8k9nkNfzkWRkxNKLmXFSox")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Mp")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("JNU")]];elseif lIlIlllllIlIlIIIlll==#{{487;808;34;286};"1 + 1 = 111";"1 + 1 = 111";{187;318;413;297};{94;863;359;788};{138;608;408;32};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{663;291;939;925};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{706;892;991;699};"1 + 1 = 111";"1 + 1 = 111";{132;470;195;442};{859;144;268;893};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{332;84;510;153};{948;158;447;197};{344;659;995;140};{488;721;961;664};"1 + 1 = 111";{561;436;285;348};"1 + 1 = 111";"1 + 1 = 111";{362;2;327;701};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{759;36;729;53};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{832;815;530;935};{168;349;206;176};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{254;745;920;631};{979;618;507;404};{901;251;784;569};{653;993;915;361};"1 + 1 = 111";"1 + 1 = 111";{872;21;40;624};{503;321;593;323};"1 + 1 = 111";{841;777;284;278};"1 + 1 = 111";"1 + 1 = 111";{98;356;884;143};{588;577;282;256};"1 + 1 = 111";"1 + 1 = 111";{242;915;518;891};}then if(llIIIIIIllIIlIIllIllIll[#("Ur")]<=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("S3QQ")]])then lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("rEO")];else lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;else local IlIIllIlIIllIII=llIIIIIIllIIlIIllIllIll[#("QV")];local lIlIlllllIlIlIIIlll={};for llIIIIIIllIIlIIllIllIll=1,#IlIlIIIlIIIlIIlllIIlIl do local llIIIIIIllIIlIIllIllIll=IlIlIIIlIIIlIIlllIIlIl[llIIIIIIllIIlIIllIllIll];for lIlIlllllIIllIlllIlIllII=0,#llIIIIIIllIIlIIllIllIll do local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[lIlIlllllIIllIlllIlIllII];local llIIIllllllllIIII=lIlIlllllIIllIlllIlIllII[1];local llIIIIIIllIIlIIllIllIll=lIlIlllllIIllIlllIlIllII[2];if llIIIllllllllIIII==IIlllIllllIlllIlllIlllIl and llIIIIIIllIIlIIllIllIll>=IlIIllIlIIllIII then lIlIlllllIlIlIIIlll[llIIIIIIllIIlIIllIllIll]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll];lIlIlllllIIllIlllIlIllII[1]=lIlIlllllIlIlIIIlll;end;end;end;end;elseif lIlIlllllIlIlIIIlll<=#("HkULdxss5gKgEndAaUNZsFtlFNYc6Wj1Yf3kDn5QR0yUAuEimyVNNeGb1JfAJpvi")then if lIlIlllllIlIlIIIlll>#("Ssyu27XZ6hCgKWjjPZIbHnTK1t4iGhBEoWRcfXuB8YR6d5rW5q3BYhBFJYEJcPs")then do return end;else local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("cR")]IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII+1,llIIIIIIllIIlIIllIllIll[#{{194;906;885;983};"1 + 1 = 111";"1 + 1 = 111";}]))end;elseif lIlIlllllIlIlIIIlll<=#("R82Xfhd2FgcSHXG6chmonaPgvmErtVytF1pfcERYnb6RfS7WsHG5CeLRsVB2OWITT")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("xU")]]();elseif lIlIlllllIlIlIIIlll==#("nQHB3IBzbmd8bOoS8WoD1AqJWrdYjBDm8vEro1O8FddyNuTWO6XVEq1XA8PLEMoKU1")then local llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll[#("kj")]IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll](IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll+1])else local IIllIlllIlIll;local lIlIlllllIlIlIIIlll;lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("zG")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("L4B")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("YJ")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("bdk")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Ys")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("64a")]][llIIIIIIllIIlIIllIllIll[#("QB68")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Yj")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("0Yd")]][llIIIIIIllIIlIIllIllIll[#("75fu")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("6s")];IIllIlllIlIll=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{292;988;293;265};"1 + 1 = 111";"1 + 1 = 111";}]];IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll+1]=IIllIlllIlIll;IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("MJ8R")]];end;elseif lIlIlllllIlIlIIIlll<=#{{364;554;630;525};"1 + 1 = 111";{484;985;220;876};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{237;422;359;647};{329;874;653;916};"1 + 1 = 111";{867;586;27;297};{273;676;245;37};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{896;506;823;837};{51;264;496;844};{900;575;64;250};"1 + 1 = 111";{823;690;732;337};{38;351;292;96};"1 + 1 = 111";"1 + 1 = 111";{696;525;609;102};"1 + 1 = 111";{488;512;777;866};{984;720;649;235};"1 + 1 = 111";"1 + 1 = 111";{615;909;561;827};"1 + 1 = 111";{577;277;267;762};"1 + 1 = 111";{188;756;958;760};"1 + 1 = 111";{922;592;640;211};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{637;936;289;787};"1 + 1 = 111";"1 + 1 = 111";{266;737;745;288};"1 + 1 = 111";{862;321;694;917};"1 + 1 = 111";"1 + 1 = 111";{117;371;807;500};{913;694;111;221};{555;724;721;513};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{642;422;19;274};"1 + 1 = 111";{165;235;678;586};{472;914;562;658};{218;228;465;583};{960;447;629;607};{324;967;14;140};{648;20;743;617};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{953;696;327;467};}then if lIlIlllllIlIlIIIlll<=#("dFzBpum9aqBYIMOb2iLpVIBnfHt3fHI7p78O3UoUa4fGOjvMGfNH2GmGdlvSbt4DTEJKN")then if lIlIlllllIlIlIIIlll==#("hh40o0D5J5lRx94afUUDKSzGTQaMWkLW8G8FNbqxdiMBHt74JSzZZkAATygIZ0iztAS0")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("yO")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]];else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("jL")]][llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";{887;58;686;799};{76;500;518;562};}]]=llIIIIIIllIIlIIllIllIll[#("zaTC")];end;elseif lIlIlllllIlIlIIIlll<=#{"1 + 1 = 111";"1 + 1 = 111";{459;14;602;960};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{271;40;137;390};{11;786;726;536};{896;402;601;523};"1 + 1 = 111";{777;430;499;185};{868;392;80;714};{515;964;286;211};{440;978;599;296};{460;504;511;173};{336;100;678;43};{732;877;233;13};{145;100;522;617};{239;183;765;897};"1 + 1 = 111";{351;962;349;80};"1 + 1 = 111";{109;417;255;683};{2;173;137;728};"1 + 1 = 111";"1 + 1 = 111";{35;199;437;710};"1 + 1 = 111";{348;502;589;691};"1 + 1 = 111";"1 + 1 = 111";{272;92;936;910};{888;116;898;688};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{920;718;250;815};{354;621;666;407};"1 + 1 = 111";{903;403;432;860};"1 + 1 = 111";{250;397;230;635};{405;383;554;583};{219;513;629;343};{173;159;721;592};{326;840;431;234};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{917;254;827;460};{165;12;787;553};"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";{267;672;465;358};{39;733;912;326};"1 + 1 = 111";"1 + 1 = 111";{55;915;181;553};{704;262;199;984};{239;116;329;70};{711;575;286;113};"1 + 1 = 111";"1 + 1 = 111";{980;184;505;290};{290;960;487;176};}then local lIlIlllllIlIlIIIlll;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("0C")]]=llIIIIIIllIIlIIllIllIll[#("4jt")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("EJ")]]=llIIIIIIllIIlIIllIllIll[#("BPG")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("hN")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("nCM")]))lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Jv")]][llIIIIIIllIIlIIllIllIll[#("6F8")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("G26U")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("QM")]]=IlIIllIlIIllIII[llIIIIIIllIIlIIllIllIll[#("Mb2")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("cX")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("BNn")]][llIIIIIIllIIlIIllIllIll[#("AAEx")]];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("J6")]]=llIIIIIIllIIlIIllIllIll[#("pFA")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("G2")]]=llIIIIIIllIIlIIllIllIll[#("WuY")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("Ag")]]=llIIIIIIllIIlIIllIllIll[#("iyP")];lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;llIIIIIIllIIlIIllIllIll=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];lIlIlllllIlIlIIIlll=llIIIIIIllIIlIIllIllIll[#("y8")]IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll]=IIlllIllllIlllIlllIlllIl[lIlIlllllIlIlIIIlll](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIlIlIIIlll+1,llIIIIIIllIIlIIllIllIll[#("KOr")]))elseif lIlIlllllIlIlIIIlll==#("AFchnb0n4Yz5JJOQvyHlnMLJGC2I1lE5umi81NqLs4ZcYHssmir0uHmX3ELVisxTtDKvBQY")then local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("Xa")];local llIIIllllllllIIII=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("rEX")]];IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII+1]=llIIIllllllllIIII;IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII]=llIIIllllllllIIII[llIIIIIIllIIlIIllIllIll[#("vTns")]];else local lIlIlllllIIllIlllIlIllII=llIIIIIIllIIlIIllIllIll[#("7I")]IIlllIllllIlllIlllIlllIl[lIlIlllllIIllIlllIlIllII](lllIlIllIllIIllII(IIlllIllllIlllIlllIlllIl,lIlIlllllIIllIlllIlIllII+1,llIIIIIIllIIlIIllIllIll[#("8fg")]))end;elseif lIlIlllllIlIlIIIlll<=#("h63sWIV8jKuT3OKX9ueybGC9IgSu762HtJSzN4bvSNMJ7NZQ3WvfLBRMF3VQZAbmRYzu5kjftT")then if lIlIlllllIlIlIIIlll==#("z32c4rcCkKW531g4TivGsLz2jnEUSMqW1VsSM11yX80M42GEZqA78nxXFa2QXrTItaehJys2q")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{{381;59;612;253};"1 + 1 = 111";}]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#{"1 + 1 = 111";"1 + 1 = 111";"1 + 1 = 111";}]];else local llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll[#("NR")]local llIIIllllllllIIII,lIlIlllllIIllIlllIlIllII=IIlllIllIllIIlIlIlII(IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll](IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll+1]))lllIlIllIlllllIlIIIl=lIlIlllllIIllIlllIlIllII+llIIIIIIllIIlIIllIllIll-1 local lIlIlllllIIllIlllIlIllII=0;for llIIIIIIllIIlIIllIllIll=llIIIIIIllIIlIIllIllIll,lllIlIllIlllllIlIIIl do lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll]=llIIIllllllllIIII[lIlIlllllIIllIlllIlIllII];end;end;elseif lIlIlllllIlIlIIIlll<=#("TtUW7rRa5BlsYOyFnL9kKFors4Xy5C8IQaFdcScL8XxrxblBUdkR3gxneCEdEtfEDOMXiuCFJyl")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("go")]]=IIllIlllIlIll[llIIIIIIllIIlIIllIllIll[#("aCv")]];elseif lIlIlllllIlIlIIIlll>#("i75rSxO1rqPKOq8Ko8gPS2ZSzzrzLPiF5KfhHmvhPnml9cj1x1qKrGepin2tfoqMijOdl0dcN9aF")then IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("gq")]]=llIIIIIIllIIlIIllIllIll[#("57g")];else IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("6v")]][llIIIIIIllIIlIIllIllIll[#("pzW")]]=IIlllIllllIlllIlllIlllIl[llIIIIIIllIIlIIllIllIll[#("g7nW")]];end;lIlIlllllIIllIlllIlIllII=lIlIlllllIIllIlllIlIllII+1;end;end);end;return lIlIlllIIIlIIlIIIIIlll(true,{},IlIIIIlII())();end)(string.byte,table.insert,setmetatable);    
    end)
    btns:Seperator()

    
btns:Button(
    "Rb Emotes",
    function()
    loadstring(game:HttpGet('https://pastebin.com/raw/DjsEQMxQ', true))()    
    end)
    btns:Seperator()

    
btns:Button(
    "ArmExtender",
    function()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Press k to toggle", Text = "ArmExtender!"})

_G.Resized = true
local Player = game:GetService('Players').LocalPlayer
local Mouse = Player:GetMouse()

Mouse.KeyDown:Connect(function(Key)
    if Key == 'k' then
        _G.Resized = not _G.Resized
        if _G.Resized == true then
            Player.Character['LeftHand'].Size = Vector3.new(1, 10, 1)
            Player.Character['RightHand'].Size = Vector3.new(1, 10, 1)
        elseif _G.Resized == false then
            Player.Character['LeftHand'].Size = Vector3.new(0.69334, 1.10182, 0.744331)
            Player.Character['RightHand'].Size = Vector3.new(0.69334, 1.10182, 0.744331)
        end
    end
end)     
    end)
    btns:Seperator()

-------------------------

local Credits = serv:Channel("Credits")
Credits:Label("Script by: Roblox Scripts")
Credits:Label("Design and Modification: RiskyJoip#6733")


local btns = serv:Channel("More...")

btns:Button(
    "Discord Server",
    function()
    setclipboard("https://discord.io/NitroHacks")
     game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Copied to clipboard", Text = "Press Ctrl+V in ur web browser!"})
    end)
    btns:Seperator()
    

btns:Button(
    "NitroHub RBW2",
    function()
    loadstring(game:HttpGet(('https://github.com/MainHackScripts/RiskyJoip-sHub/files/6563898/RiskyJoip.s.HUB.txt'),true))()
    end)
    btns:Seperator()    




