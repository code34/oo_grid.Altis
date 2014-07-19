		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";

		_grid = ["new", [31000,31000,500,500]] call OO_GRID;

		//sleep 4;

		//["Draw", ""] call _grid;
		//toto = ["getSectorFromPos", position player] call _grid;
		//toto = ["getSectorAround", toto] call _grid;

		//hintc format["%1", toto];

		(findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw"," (_this select 0) drawLine [ getPos player, [0,0,0], [6000,6000,0] ]; "];