		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";
		call compilefinal preprocessFileLineNumbers "oo_node.sqf";

		_grid = ["new", [31000,31000,500,500]] call OO_GRID;

		_result = ["parseAllSectors", "isBuilding"] call _grid;

