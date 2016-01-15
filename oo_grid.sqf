	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2016 Nicolas BOITEUX

	CLASS OO_GRID STRATEGIC GRID
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	#include "oop.h"

	CLASS("OO_GRID")
		PRIVATE VARIABLE("scalar","xgrid");
		PRIVATE VARIABLE("scalar","ygrid");
		PRIVATE VARIABLE("scalar","xgridsize");
		PRIVATE VARIABLE("scalar","ygridsize");
		PRIVATE VARIABLE("scalar","xsectorsize");
		PRIVATE VARIABLE("scalar","ysectorsize");

		/*
		Create a new grid object

		Parameters:
			xgrid - x grid pos
			ygrid - y grid pos
			xgridsize - grid width
			ygridsize - grid height
			xsectorsize - sector width
			ysectorsize - sector height
		*/

		PUBLIC FUNCTION("array","constructor") {
			MEMBER("xgrid", _this select 0);
			MEMBER("ygrid", _this select 1);
			MEMBER("xgridsize", _this select 2);
			MEMBER("ygridsize", _this select 3);
			MEMBER("xsectorsize", _this select 4);
			MEMBER("ysectorsize", _this select 5);
		};

		PUBLIC FUNCTION("scalar","setXgrid") {
			MEMBER("xgrid", _this);
		};

		PUBLIC FUNCTION("scalar","setYgrid") {
			MEMBER("ygrid", _this);
		};

		PUBLIC FUNCTION("scalar","setXgridsize") {
			MEMBER("xgridsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYgridsize") {
			MEMBER("ygridsize", _this);
		};

		PUBLIC FUNCTION("scalar","setXsectorsize") {
			MEMBER("xsectorsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYsectorsize") {
			MEMBER("ysectorsize", _this);
		};

		PUBLIC FUNCTION("","getXgrid") FUNC_GETVAR("xgrid");
		PUBLIC FUNCTION("","getYgrid") FUNC_GETVAR("ygrid");
		PUBLIC FUNCTION("","getXgridsize") FUNC_GETVAR("xgridsize");
		PUBLIC FUNCTION("","getYgridsize") FUNC_GETVAR("ygridsize");
		PUBLIC FUNCTION("","getXsectorsize") FUNC_GETVAR("xsectorsize");
		PUBLIC FUNCTION("","getYsectorsize") FUNC_GETVAR("ysectorsize");

		/* 
		Call a loopback parsing function and return sectors that are concerned
		Example of string parameter: "hasBuildingsAtSector" will return sector with buildings
		Parameters: _function : string function name
		*/ 
		PUBLIC FUNCTION("string", "parseAllSectors") {
			private["_array", "_function", "_position", "_result", "_sector", "_x", "_y"];

			_function = _this;
			_array = [];

			for "_y" from MEMBER("ygrid", nil) to MEMBER("ygridsize", nil) step MEMBER("ysectorsize", nil) do {
				for "_x" from MEMBER("xgrid", nil) to MEMBER("xgridsize", nil) step MEMBER("xsectorsize", nil) do {
					_position = [_x, _y];
					_sector = MEMBER("getSectorFromPos", _position);
					if(MEMBER(_function, _sector)) then {
						_array = _array + [_sector];
					};
				};
			};
			_array;
		};

		/*
		Call a loopback parsing function and return sectors that are concerned
		Example of string parameter: "hasBuildingsAtSector" will return sector with buildings
		Parameters: [_arrayofsectors, _function]
			_arrayofsectors : array containg sectors
			_function: string name of the function to loop back
		Return : array of sectors
		*/
		PUBLIC FUNCTION("array", "parseSectors") {
			private ["_array", "_result"];

			_array = _this select 0;
			_function = _this select 1;

			{
				if(MEMBER(_function, _x)) then {
					_result = _result + [_x];
				};
			} foreach _array;
			_result;
		};

		/*
		Translate a position to a sector
		Parameters: array - position array
		Return : array - sector
		*/
		PUBLIC FUNCTION("array", "getSectorFromPos") {
			private ["_position", "_xpos", "_ypos"];

			_position = _this;

			_xpos = floor(((_position select 0) - MEMBER("xgrid",nil)) / MEMBER("xsectorsize", nil));
			_ypos = floor(((_position select 1) - MEMBER("ygrid",nil)) / MEMBER("ysectorsize", nil));
			[_xpos, _ypos];
		};

		/*
		Translate a sector to a position
		Parameters: array - sector array
		Return : array position
		*/
		PUBLIC FUNCTION("array", "getPosFromSector") {		
			private ["_sector", "_x", "_y"];

			_sector = _this;

			_x = ((_sector select 0) * MEMBER("xsectorsize", nil)) + (MEMBER("xsectorsize", nil) / 2) + MEMBER("xgrid", nil);
			_y = ((_sector select 1) * MEMBER("ysectorsize", nil)) + (MEMBER("ysectorsize", nil) / 2)+ MEMBER("ygrid", nil);;

			[_x,_y];
		};		

		/*
		Retrieve the center position of a sector, from a position
		Parameters: array - position
		Return : array position of the sector center
		*/
		PUBLIC FUNCTION("array", "getSectorCenterPos") {
			private ["_position", "_sector"];			

			_position = _this;

			_sector = MEMBER("getSectorFromPos", _position);
			_position = MEMBER("getPosFromSector", _sector);
			_position;
		};

		/*
		Get all sectors around one sector
		Parameters: array - array sector
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorsAroundSector") {
			private ["_grid"];

			//_params = [_this, 1];
			
			//_grid = MEMBER("getAllSectorsAroundSector", _params);
			//_grid;

			//_sector = _this;

			_grid = [
				[(_this select 0) -1, (_this select 1) - 1],
				[(_this select 0), (_this select 1) - 1],
				[(_this select 0) + 1, (_this select 1) -1],
				[(_this select 0)-1, (_this select 1)],
				[(_this select 0)+1, (_this select 1)],
				[(_this select 0)-1, (_this select 1) + 1],
				[(_this select 0), (_this select 1) + 1],
				[(_this select 0)+1, (_this select 1) + 1],
				];
			_grid;			
		};

		/*
		Get all sectors around one position
		Parameters: array - array position
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorsAroundPos") {
			private ["_sector"];

			_sector = MEMBER("getSectorFromPos", _this);

			MEMBER("getSectorsAroundSector", _sector);
		};

		
		/*
		Get cross sectors around a sector
		Parameters: array - array sector
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorsCrossAroundSector") {
			private ["_grid"];

			_grid = [
				[(_this select 0), (_this select 1) - 1],
				[(_this select 0)-1, (_this select 1)],
				[(_this select 0)+1, (_this select 1)],
				[(_this select 0), (_this select 1) + 1]
				];
			_grid;
		};

		/*
		Get cross sectors around a position
		Parameters: array - array position
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorsCrossAroundPos") {
			private ["_sector"];

			_sector = MEMBER("getSectorFromPos", _this);

			MEMBER("getSectorsCrossAroundSector", _sector);
		};

		/*
		Get all sectors around a sector at scale sector distance
		Parameters: array [_sector, _scale]
			_sector : array sector
			_scale : int (scale to extend)
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getAllSectorsAroundSector") {
			private ["_grid", "_scale", "_sector", "_botx", "_boty", "_topx", "_topy", "_x", "_y"];

			_sector = _this select 0;
			_scale = _this select 1;

			_botx = (_sector select 0) - _scale;
			_boty = (_sector select 1) - _scale;
			_topx = (_sector select 0) + _scale;
			_topy = (_sector select 1) + _scale;

			_grid = [];
			
			for "_y" from _boty to _topy do {
				for "_x" from _botx to _topx do {
					_grid = _grid + [[_x, _y]];
				};
			};
			_grid;
		};

		/*
		Get all sectors around a sector at scale sector distance
		Parameters: array [_position, _scale]
			_position : array position
			_scale : int (scale to extend)	
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getAllSectorsAroundPos") {
			private ["_sector", "_scale", "_array"];

			_sector = MEMBER("getSectorFromPos", _this select 0);
			_scale = _this select 1;
			_array = [_sector, _scale];
			MEMBER("getAllSectorsAroundSector", _array);
		};

		/*
		Check if sector has building
		Parameters : array - array sector
		Return : boolean
		*/		
		PUBLIC FUNCTION("array", "hasBuildingsAtSector") {
			private ["_positions", "_result", "_position"];

			_sector = _this;
			_position = MEMBER("getPosFromSector", _sector);
			_positions = MEMBER("getPositionsBuilding", _position);

			if (count _positions > 10) then { _result = true;} else { _result = false;};
			_result;
		};

		/*
		Check from a position if there are buildings in sector
		Parameters: array - array position
		Return : boolean
		*/	
		PUBLIC FUNCTION("array", "hasBuildingsAtPos") {
			private ["_positions", "_result", "_position"];

			_position = _this;
			_positions = MEMBER("getPositionsBuilding", _position);

			if (count _positions > 10) then { _result = true;} else { _result = false;};
			_result;
		};


		/*
		Retrieve indexed building in the sector position
		Parameters: array - array position
		Return : array containing all positions in building
		*/
		PUBLIC FUNCTION("array", "getPositionsBuilding") {
			private ["_index", "_buildings", "_position", "_positions", "_result"];

			_position = _this;
			_positions = [];
			
			if!(surfaceIsWater _position) then {
				_buildings = nearestObjects[_position,["House_F"], MEMBER("xsectorsize", nil)];
	
				{
					_index = 0;
					while { format ["%1", _x buildingPos _index] != "[0,0,0]" } do {
						_positions = _positions + [(_x buildingPos _index)];
						_index = _index + 1;
						sleep 0.0001;
					};
					sleep 0.0001;
				}foreach _buildings;
			};
			_positions;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("xgrid");
			DELETE_VARIABLE("ygrid");
			DELETE_VARIABLE("xgridsize");
			DELETE_VARIABLE("ygridsize");
			DELETE_VARIABLE("xsectorsize");
			DELETE_VARIABLE("ysectorsize");
		};
	ENDCLASS;