		call compilefinal preprocessFileLineNumbers "oo_grid.sqf";
		call compilefinal preprocessFileLineNumbers "oo_node.sqf";

		_grid = ["new", [31000,31000,500,500]] call OO_GRID;

		_start = ["getSectorFromPos", position player] call _grid;
		_goal = [54,50];

		_goalnode = ["new", [nil, nil, 0, 54,50]] call OO_NODE;
		_startnode = ["new", [nil, _goalnode, 0, 0,0]] call OO_NODE;


		_cost = "getEstimateCost" call _startnode;

		sleep 2;

		hintc format["estimate: %1", _cost];


		//{
		//	["DrawSector", _x] call _grid;
		//}foreach _path;

