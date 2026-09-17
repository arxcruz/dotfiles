-- Fix Synergy mismapping shift+' (double quote) to the U key position
-- when using a Moonlander (QMK) keyboard with a US-International layout.
-- Without this, shift+' renders as a stray dead-key diaeresis (¨).
local eventtap = hs.eventtap

local quoteTap = eventtap.new({ eventtap.event.types.keyDown }, function(e)
  local kc = e:getKeyCode()
  local chars = e:getCharacters(false)

  if kc == 32 and chars == "" then
    eventtap.keyStrokes('"')
    return true
  end

  return false
end)

quoteTap:start()
