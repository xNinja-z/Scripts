--[[Autor:Laysiks]]--
--[[Zakaza zmiany autora]]--


--[[
Po stronie klienta zrobione będzie:
    * Teleportowanie się do graczy o danym ID, **Zrobione**
    * Namierzanie/Oznaczanie blipem graczy, **Zrobione**
    * Kilka Opcji dla Administracji. **Niedługo**
]]--


function tpto (cmd,wpisane) -- Teleportowanie do gracza
local gracze = getElementsByType("player") --Pobiera wszystkich graczy
	for _,p in ipairs(gracze) do
		local ID = getElementData(p,"ID") -- Pobiera ID graczy
	if tonumber(ID) == tonumber(wpisane) then --Sprawdza czy wpisane id = id gracza
		local x,y,z = getElementPosition(p) --Sprawdza pozycje tego gracza /|\
		local lp = getLocalPlayer() --Pobiera gracza, który wpisał komendę
		setElementPosition(lp,x+1,y,z) --Zmienia naszą pozycje na pozycje gracza do ktorego sie teleportujemy
		outputChatBox("Zostałeś przeteleportowany do gracza o ID [ "..wpisane.." ]") --Zwykły output
	else outputChatBox("Na serwerze nie ma gracza o danym ID") return
	end
end
end
addCommandHandler("tpto",tpto)


function namierz (cmd,wpisane) -- Namierzanie gracza
 local gracze = getElementsByType("player") --Pobiera wszystkich graczy
	for _,p in ipairs (gracze) do
		local ID = getElementData (p,"ID") -- Pobiera ID graczy
	if tonumber(ID) == tonumber (wpisane) then --Sprawdza czy wpisane id = id gracza
		local x,y,z = getElementPosition (p) --Sprawdza pozycje tego gracza /|\
		local blip = createBlip( x, y, z, 0, 2, 0, 0, 255 ) --Tworzy Blip
		outputChatBox("Gracz został namierzony i oznaczony blipem na mapie, który zniknie po 10 sekundach.")
	    attachElements ( blip, p, 0, 0, 0 )  --Przyczepia blip do gracza
		setTimer(destroyElement,10000,1,blip ) --Timer 10sekund
	else
		outputChatBox("Na serwerze nie ma gracza o danym ID") return
	end
end
end
addCommandHandler("namierz", namierz )
