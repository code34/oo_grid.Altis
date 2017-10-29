		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";

		_grid = ["new", [0,0,31000,31000,100,100]] call OO_GRID;

		while { true } do {
			hint format ["player sector %1", ["getSectorFromPos", position player] call _grid];
			sleep 1;
		};


		




