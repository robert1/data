----------------------------------------------------------------------------------
-- Map File                                                                     --
--                                                                              --
-- In dieser Datei stehen die entsprechenden externen NPC's, Trigger und        --
-- anderer Dinge.                                                               --
--                                                                              --
----------------------------------------------------------------------------------
--  Copyright 2008 The Invertika Development Team                               --
--                                                                              --
--  This file is part of Invertika.                                             --
--                                                                              --
--  Invertika is free software; you can redistribute it and/or modify it        --
--  under the terms of the GNU General  Public License as published by the Free --
--  Software Foundation; either version 2 of the License, or any later version. --
----------------------------------------------------------------------------------

require "scripts/lua/npclib"
require "scripts/libs/sign"
require "scripts/libs/invertika"

dofile("data/scripts/libs/warp.lua")

atinit(function()
    create_inter_map_warp_trigger(97, 107, 95, 85) --- Intermap warp

    sign_entrance = "Narva"
    sign.create_sign(154, 128, sign_entrance) --- Schild Ortseingang
    sign.create_sign(62, 106, sign_entrance) --- Schild Ortseingang
    sign.create_sign(95, 47, sign_entrance) --- Schild Ortseingang

    create_npc("Awond", 120, 159 * TILESIZE, 40 * TILESIZE, awond_talk, nil)
    create_npc("Mordyno", 141, 101 * TILESIZE + 16, 109 * TILESIZE + 16, mordyno_talk, mordyno_update)
    mordyno_random_talk = invertika.create_random_talk_function(
          "Kauft Leute! Kauft!", 
          "Hier gibt es nur beste Ware!",
          "Kommen sie meine Herren, Kommen sie meine Damen!",
          "Messer von feinster Qualität, nur 50 Aki das Stück! 140 Aki in der Luxusvariante!",
          "Dolche, der stetige Begleiter gegen die Gefahren der Wüste, nur 1000 Aki!",
          "Einen Holzstab zum Üben im Umgang mit Stabwaffen, nur 1690 Aki!",
          "Baumwollkleidung, in allen Farben, nur 250 Aki das Stück!",
          "Die neuste Mode zu Spottpreisen! Kaufen sie, so lange der Vorrat reicht.",
          "Messer jetzt reduziert für nur 50 Aki das Stück! Greifen sie zu!")
end)

function awond_talk(npc, ch)
    do_message(npc, ch, invertika.get_random_element("Sei gegrüßt Reisender!",
      "Das war ein harter Tag.",
      "Ich hoffe meine Frau macht schonmal das Abendessen.",
      "Setz dich doch zu mir."))
    do_npc_close(npc, ch)
end

function mordyno_talk(npc, ch)
    mana.npc_trade(npc, ch, false, {
      {10001, 30, 50},
      {10013, 30, 140},
      {10002, 30, 1000},
      {10009, 30, 1690},
      {20001, 30, 250},
      {20002, 30, 250},
      {20011, 30, 250},
      {20012, 30, 250},
      {20013, 30, 250},
      {20014, 30, 250},
      {20015, 30, 250},
      {20016, 30, 250},
      {20017, 30, 250},
      {20018, 30, 250},
      {20009, 30, 500} })
    do_npc_close(npc, ch)
end

function mordyno_update(npc)
    npclib.walkaround_wide(npc)
    mordyno_random_talk()
end
