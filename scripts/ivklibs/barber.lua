----------------------------------------------------------------------------------
-- Frisör Skript                                                                --
--                                                                              --
-- Dieses Skript stellt Funktionalität für den Frisör zu Verfügung              --
--                                                                              --
-- Beispielaufrufe                                                              --
-- create_npc("Barber", 100, 51 * TILESIZE + 16, 38 * TILESIZE + 16,            --
-- Barber, nil)                                                                 --
--                                                                              --
-- create_npc("Barber 2", 100, 52 * TILESIZE + 16, 38 * TILESIZE + 16,          --
-- npclib.talk(Barber, {14, 15, 16}, {}), nil)                                  --
----------------------------------------------------------------------------------
--  Copyright 2009 The Invertika Development Team                               --
--                                                                              --
--  This file is part of Invertika.                                             --
--                                                                              --
--  Invertika is free software; you can redistribute it and/or modify it        --
--  under the terms of the GNU General  Public License as published by the Free --
--  Software Foundation; either version 2 of the License, or any later version. --
----------------------------------------------------------------------------------
--  Copyright 2009 The Mana World Development Team                              --
--                                                                              --
--  This file is part of The Mana World.                                        --
--                                                                              --
--  The Mana World  is free software; you can redistribute  it and/or modify it --
--  under the terms of the GNU General  Public License as published by the Free --
--  Software Foundation; either version 2 of the License, or any later version. --
----------------------------------------------------------------------------------

local barber_styles = {"Flat ponytail", "Bowl cut","Combed back", "Emo", "Mohawk",
        "Pompadour", "Center parting/Short and slick", "Long and slick", "Short and curly",
        "Pigtails", "Long and curly", "Parted", "Perky ponytail", "Wave", "Mane", "Bun"}

local barber_colors = {"Brunette", "Green", "Dark red", "Light purple", "Gray", "Blonde",
        "Teal", "Light red", "Blue", "Dark purple", "Black"}

function Barber(npc, ch, data)
    local style_ids = nil
    local color_ids = nil

    -- If extra data was passed, let's have a look at it
    if data ~= nil then
        style_ids = data[1]
        if #data > 1 then
            color_ids = data[2]
        end
    end

    -- Setup up default styles (if needed)
    if style_ids == nil then
        style_ids = {}
        for i = 1, 13 do
            style_ids[i] = i
        end
    end

    -- Setup up default colors (if needed)
    if color_ids == nil then
        color_ids = {}
        for i = 1, 11 do
            color_ids[i] = i
        end
    end

    -- Nothing to show? Then we can return
    if #color_ids == 0 and #style_ids == 0 then
        return -- Since we haven't shown any windows, we can safely
               -- return without a do_npc_close
    end

    local result = 0

    local styles = {}

    -- If we have style IDs, lets get their names
    if #style_ids > 0 then
        for i = 1, #style_ids do
            styles[i] = barber_styles[style_ids[i]]
        end
        result = 1
    end

    local colors = {}

    -- If we have color style IDs, lets get their names
    if #color_ids > 0 then
        for i = 1, #color_ids do
            colors[i] = barber_colors[color_ids[i]]
        end

        if result == 0 then
            result = 2
        else
            result = 3
        end
    end

    -- Choose an appropriate message
    if result == 1 then
        do_message(npc, ch, "Hallo, welchen Stype möchtest du heute?")
    elseif result == 2 then
        do_message(npc, ch, "Hi, welche Farbe darf es heute sein?")
    else
        do_message(npc, ch, "Na du, was kann ich für dich tun?")
    end

    print("#styles ==", #styles)

    -- Repeat until the user selects nothing
    repeat
        if (result == 1) then -- Do styles
            result = do_choice(npc, ch, "Bald", styles, "Überrasche mich", "Nichts")

            result = result -1

            --Random
            if (result == #styles + 1) then
                result = math.random(#styles + 1) - 1
                print("Random")
            end

            print("Style ==", result)

            if (result == 0) then
                tmw.chr_set_hair_style(ch, 0)
                result = 1
            elseif (result <= #styles) then
                tmw.chr_set_hair_style(ch, style_ids[result])
                result = 1
            else --"Never mind"
                result = 3
            end
        elseif (result == 2) then -- Do colors
            result = do_choice(npc, ch, colors, "Überrasche mich", "Nichts davon")

            --Random
            if (result == #colors + 1) then
                result = math.random(#colors)
            end

            if (result <= #colors) then
                tmw.chr_set_hair_color(ch, color_ids[result - 1])
                result = 2
            else --"Never mind"
                result = 3
            end
        end

        -- If we have both styles and colors, show the main menu
        if #styles > 0 and #colors > 0 then
            result = do_choice(npc, ch, "Ändere meinen Style", "Ändere meine Farbe", "Nichts davon")
        end
    until result >= 3 --While they've choosen a valid option that isn't "Never mind"

    -- Let's close up
    do_message(npc, ch, "Thank you. Come again!")
    do_npc_close(npc, ch)
end
