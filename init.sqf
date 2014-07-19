		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";

		_grid = ["new", [31000,31000,500,500]] call OO_GRID;

		_sector = ["getSectorFromPos", position player] call _grid;
		_goal = [54,50];

		_array = [_sector, _goal];
		_path = ["getPathToSector", _array] call _grid;

		{
			["DrawSector", _x] call _grid;
		}foreach _path;

