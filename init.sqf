		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";

		_grid = ["new", [31000,31000,100,100]] call OO_GRID;
		_result = ["parseAllSectors", "isBuilding"] call _grid;
		
		hintc format ["Building sectors count: ", count _result];