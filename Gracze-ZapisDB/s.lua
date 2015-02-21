--[[Autor:Laysiks]]--
--[[Zakaz zmiany autora]]--
--[[Zezwolenie na małe edycj]]--

conn = dbConnect("sqlite","gracze.db") --Łączenie z bazą danych w pliku gracze.db, który się utworzy sam po włączeniui skryptu
if conn then
	outputDebugString("Polaczono")
else
	outputDebugString("Blad Polaczenia")
end

addEventHandler("onResourceStart",resourceRoot, --Tworzenie tabeli i kolumn w pliku gracze.db
	function()
	if conn then
		local tabela = dbExec(conn,"CREATE TABLE IF NOT EXISTS gracze(login TEXT,pieniadze INT, health FLOAT NOT NULL, armor FLOAT NOT NULL,skin INT(3) NOT NULL, posx FLOAT, posy FLOAT,posz FLOAT,wanted INT(1) NOT NULL,serial TEXT NOT NULL)")
	else
	return
end
end
)

addEventHandler("onPlayerLogin",getRootElement(),
	function()
	local login = getAccountName ( source:getAccount() )
	local q = dbQuery(conn,"SELECT rowid,* FROM gracze WHERE login=?",login) --Pobiera wszystkie wartości gracza o loginie zadefiniowanym jako "login"
	local result = dbPoll(q,-1)
	if result then
		for _,row in ipairs(result) do
			source:setData("ID",row["rowid"]) --Ustalenie id gracza -- Przykłady OOP
			source:setMoney(row["pieniadze"]) --Zmiana pieniadzy gracza
			source:setHealth(row["health"])   --Zmiana zycia gracza
			source:setArmor(row["armor"])     --Zmiana armora/pancerza gracza
			source:setModel(row["skin"])      --Zmiana skina gracza
			source:setPosition(row["posx"],row["posy"],row["posz"]) --Zmiana ostatniej pozycji gracza
			source:setWanted(row["wanted"]) --Zmiana ilości gwiazdek -- Koniec OOP
		end
	end
end
)
	
	

addEventHandler("onPlayerQuit",root,
	function()
	local lp = source --Definicja source zmieniona na lp
	local pl = getPlayerAccount( lp ) --Pobiera "konto gracza"
	local login = getAccountName ( pl ) --Pobiera login gracza
	local pieniadze = getPlayerMoney (lp) --Pobiera pieniadze gracza
	local health = getElementHealth (lp) --Pobiera ilosc zycia gracza
	local skin = getElementModel (lp) --Pobiera ID skina gracza
	local x,y,z = getElementPosition (lp) --Pobiera pozycje gracza	
	local armor = getPedArmor (lp) --Pobiera armor/pancerz gracza
	local wanted = getPlayerWantedLevel (lp) --Pobiera poziom gwiazdek
	local serial = getPlayerSerial (lp) --Pobiera serial gracza
	local q = dbQuery(conn, "SELECT * FROM gracze WHERE login=?",login) --Pobiera wszystkie wartości dotyczące gracza o loginie zadefiniowanym jako "login"
	local result = dbPoll(q,-1)
	dbFree(q)
	if #result == 0 then
		dbQuery(conn,"INSERT INTO gracze (login,pieniadze,health,armor,skin,posx,posy,posz,wanted,serial) VALUES (?,?,?,?,?,?,?,?,?,?)",login,pieniadze,health,armor,skin,x,y,z,wanted,serial) --Wysyła pierwszy raz dane do bazy danych
		outputDebugString("wyslano")
	elseif #result == 1 then
		dbExec(conn,"UPDATE gracze SET pieniadze=?,health=?,armor=?,skin=?,posx=?,posy=?,posz=?,wanted=? WHERE login=?",pieniadze,health,armor,skin,x,y,z,wanted,login) --Uaktualnia dane gracza
	end
end
)
