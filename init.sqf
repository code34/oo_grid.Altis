		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";

		_grid = ["new", [31000,31000,500,500]] call OO_GRID;

		sleep 4;

		toto = ["getSectorFromPos", position player] call _grid;
		toto = ["getPosFromSector", toto] call _grid;

		hintc format["%1", toto];