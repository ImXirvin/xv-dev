QBCore = nil
ESX = nil

local isOutdatedInfo = false
CreateThread(function()
	--get resource state of qb-core
	if GetResourceState("qb-core") == "started" then
		QBCore = exports["qb-core"]:GetCoreObject()
	end
	--get resource state of esx
	if GetResourceState("es_extended") == "started" then
		ESX = exports["es_extended"]:getSharedObject()
	end

	--version check with github latest version
	PerformHttpRequest(
		"https://raw.githubusercontent.com/ImXirvin/xv-dev/main/fxmanifest.lua",
		function(err, text, headers)
			if err ~= 200 then
				return
			end
			local version = GetResourceMetadata(GetCurrentResourceName(), "version")
			local latestVersion = string.match(text, '%sversion \"(.-)\"')
			if version ~= latestVersion then
				print("^1[xv-dev]^7: ^1Your version of xv-dev is outdated. Please update to the latest version.^7")
				isOutdatedInfo = true
			end
		end,
		"GET"
	)
end)

function CheckPerms(source)
	local src = source
	local perms = {}
	perms.allowed = IsPlayerAceAllowed(src, "command.dev")

	if not perms.allowed then
		-- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
		SendHook(
			"Unauthorized access to dev menu",
			"Player: " .. GetPlayerName(src) .. " tried to access the dev menu",
			"red"
		)
		DropPlayer(src, "Unauthorized access to dev menu")
		return
	end

	if ConfigForXVDev.StrictMode then
		local identifierTable = GetPlayerIdentifiers(src)
		for k, v in pairs(ConfigForXVDev.Identifiers) do
			if v.licenses then
				for i, j in pairs(v.licenses) do
					for x, y in pairs(identifierTable) do
						if j == y then
							if v.client then
								perms.client = true
							end
							if v.server then
								perms.server = true
							end
							if v.remote then
								perms.remote = true
							end
							if v.manageRes then
								perms.manageRes = true
							end
							if v.editRes then
								perms.allowedEdit = true
							end
							if v.managePly then
								perms.managePly = true
							end
						end
					end
				end
			end
		end
	end

	if ConfigForXVDev.StrictResEdit then
		local identifierTable = GetPlayerIdentifiers(src)
		for k, v in pairs(ConfigForXVDev.Identifiers) do
			if v.licenses then
				for i, j in pairs(v.licenses) do
					for x, y in pairs(identifierTable) do
						if j == y then
							if v.editRes then
								perms.manageRes = true
								perms.allowedEdit = true
							end
						end
					end
				end
			end
		end
	end

	return perms
end

RegisterNetEvent("xv-dev:server:verifyExec", function(code, eventType, selectedSrc)
	local src = source

	if isOutdatedInfo then
		local red = true
		local output =
			"Your version of xv-dev is outdated. Please update to the latest version to ensure it is safe as possible."
		TriggerClientEvent("xv-dev:client:updateOutput", src, output, "INFO", red)
		isOutdatedInfo = false
	end

	--check if code includes ConfigForXVDev thats not in a string
	if code ~= nil then
		if string.find(code, "ConfigForXVDev") then
			SendHook("Attemped Config Edit", "Player: " .. GetPlayerName(src) .. " tried to edit the config", "red")
			local red = true
			local output = "You are not allowed to edit the config."
			TriggerClientEvent("xv-dev:client:updateOutput", src, output, "server", red)
			return
		end
	end

	-- local selectedSrc = nil
	local srcTable = {}
	--turn selectedSrc into a number or table of numbers
	if eventType == "client" then
		selectedSrc = source
	elseif eventType == "source" then
		local tempSrc = selectedSrc
		-- seperate tempSrc by comma
		for i in string.gmatch(tempSrc, "([^,]+)") do
			table.insert(srcTable, tonumber(i))
		end
	end

	local perms = CheckPerms(src)
	if not perms.allowed then
		return
	end
	if code == nil then
		TriggerClientEvent("openDevMenu", src)
		return
	end
	if eventType == "client" then
		if not perms.client and ConfigForXVDev.StrictMode then
			TriggerClientEvent(
				"chatMessage",
				src,
				"Dev Menu",
				{ 255, 0, 0 },
				"You are not allowed to execute client side code"
			)
			-- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
			SendHook(
				"Unauthorized Client execution using Dev Menu",
				"Player: " .. GetPlayerName(src) .. " tried to execute client side code",
				"red"
			)
			return
		end
		TriggerClientEvent("xv-dev:client:ExecLua", src, code)
	elseif eventType == "server" then
		if not perms.server and ConfigForXVDev.StrictMode then
			TriggerClientEvent(
				"chatMessage",
				src,
				"Dev Menu",
				{ 255, 0, 0 },
				"You are not allowed to execute server side code"
			)
			-- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
			SendHook(
				"Unauthorized Sever execution using Dev Menu",
				"Player: " .. GetPlayerName(src) .. " tried to execute server side code",
				"red"
			)
			return
		end
		TriggerEvent("xv-dev:server:ExecLua", src, code)
	elseif eventType == "both" then
		if not perms.client and not perms.server and ConfigForXVDev.StrictMode then
			TriggerClientEvent(
				"chatMessage",
				src,
				"Dev Menu",
				{ 255, 0, 0 },
				"You are not allowed to execute client side code"
			)
			-- print('Unauthorized access to dev menu by ' .. GetPlayerName(src))
			SendHook(
				"Unauthorized Client or Server execution using Dev Menu",
				"Player: " .. GetPlayerName(src) .. " tried to execute client and server side code",
				"red"
			)
			return
		end
		TriggerClientEvent("xv-dev:client:ExecLua", src, code)
		TriggerEvent("xv-dev:server:ExecLua", src, code)
	elseif eventType == "source" then
		if not perms.remote and ConfigForXVDev.StrictMode then
			TriggerClientEvent(
				"chatMessage",
				src,
				"Dev Menu",
				{ 255, 0, 0 },
				"You are not allowed to execute server side code"
			)
			SendHook(
				"Unauthorized Client execution using Dev Menu",
				"Player: "
					.. GetPlayerName(src)
					.. " tried to execute remote Sources ("
					.. json.encode(srcTable)
					.. ") side code",
				"red"
			)
			return
		end
		for k, v in pairs(srcTable) do
			TriggerClientEvent("xv-dev:client:ExecLua", v, code)
		end
	end
end)

RegisterNetEvent("xv-dev:server:ExecLua", function(source, code)
	local src = source
	local perms = CheckPerms(src)
	if not perms.server and ConfigForXVDev.StrictMode then
		TriggerClientEvent(
			"chatMessage",
			src,
			"Dev Menu",
			{ 255, 0, 0 },
			"You are not allowed to execute server side code"
		)
		SendHook(
			"Unauthorized Sever execution using Dev Menu",
			"Player: " .. GetPlayerName(src) .. " tried to execute server side code",
			"red"
		)
		return
	end
	local red = false
	local output = ""
	local func, err = load("return " .. code, "@xv-dev")
	if func then
		local status, result = pcall(func, "@xv-dev")
		if status then
			output = tostring(result or "Executed")
			red = false
		else
			output = "Error: " .. (result or "Unknown")
			red = true
		end
	else
		output = "Error: " .. err
		red = true
	end
	TriggerClientEvent("xv-dev:client:updateOutput", src, output, "server", red)
end)

function SendHook(title, message, color)
	if not ConfigForXVDev.Webhook then
		print("No webhook set in config")
		--send a chat message saying no webhook set
		TriggerEvent("chatMessage", "Dev Menu", { 255, 0, 0 }, "No webhook set in config")
		return
	end
	local embedData = {
		{
			["title"] = title,
			["color"] = ConfigForXVDev.Colors[color] or ConfigForXVDev.Colors["red"],
			["footer"] = {
				["text"] = os.date("%c"),
			},
			["description"] = message,
		},
	}
	PerformHttpRequest(
		ConfigForXVDev.Webhook,
		function(err, text, headers) end,
		"POST",
		json.encode({ username = ConfigForXVDev.HookName, embeds = embedData, avatar_url = ConfigForXVDev.HookAvatar }),
		{ ["Content-Type"] = "application/json" }
	)
end
