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
		PRIVATE VARIABLE("scalar","xmaporigin");
		PRIVATE VARIABLE("scalar","ymaporigin");
		PRIVATE VARIABLE("scalar","xmapsize");
		PRIVATE VARIABLE("scalar","ymapsize");
		PRIVATE VARIABLE("scalar","xsectorsize");
		PRIVATE VARIABLE("scalar","ysectorsize");

		PUBLIC FUNCTION("array","constructor") {
			private ["_xmaporigin", "_ymaporigin"];

			_xmaporigin = (_this select 0) + ((_this select 2) / 2);
			_ymaporigin = (_this select 1) + ((_this select 3) / 2);

			MEMBER("xmaporigin", _xmaporigin);
			MEMBER("ymaporigin", _ymaporigin);
			MEMBER("xmapsize", _this select 2);
			MEMBER("ymapsize", _this select 3);
			MEMBER("xsectorsize", _this select 4);
			MEMBER("ysectorsize", _this select 5);
		};

		PUBLIC FUNCTION("scalar","setXmaporigin") {
			MEMBER("xmaporigin", _this);
		};

		PUBLIC FUNCTION("scalar","setYmaporigin") {
			MEMBER("ymaporigin", _this);
		};

		PUBLIC FUNCTION("scalar","setXmapsize") {
			MEMBER("xmapsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYmapsize") {
			MEMBER("ymapsize", _this);
		};

		PUBLIC FUNCTION("scalar","setXsectorsize") {
			MEMBER("xsectorsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYsectorsize") {
			MEMBER("ysectorsize", _this);
		};

		PUBLIC FUNCTION("","getXmaporigin") FUNC_GETVAR("xmaporigin");
		PUBLIC FUNCTION("","getYmaporigin") FUNC_GETVAR("ymaporigin");
		PUBLIC FUNCTION("","getXmapsize") FUNC_GETVAR("xmapsize");
		PUBLIC FUNCTION("","getYmapsize") FUNC_GETVAR("ymapsize");
		PUBLIC FUNCTION("","getXsectorsize") FUNC_GETVAR("xsectorsize");
		PUBLIC FUNCTION("","getYsectorsize") FUNC_GETVAR("ysectorsize");

		/* 
		Call a loopback parsing function and return sectors that are concerned
		Example of string parameter: "isBuilding" will return sector wihi buildings
		*/ 
		PUBLIC FUNCTION("string", "parseAllSectors") {
			private["_array", "_function", "_position", "_result", "_sector", "_x", "_y"];

			_function = _this;
			_array = [];

			for "_y" from MEMBER("ymaporigin", nil) to MEMBER("ymapsize", nil) step MEMBER("ysectorsize", nil) do {
				for "_x" from MEMBER("xmaporigin", nil) to MEMBER("xmapsize", nil) step MEMBER("xsectorsize", nil) do {
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
		Translate a position into a sector
		*/
		PUBLIC FUNCTION("array", "getSectorFromPos") {
			private ["_position", "_xpos", "_ypos"];

			_position = _this;

			_xpos = floor(((_position select 0) - MEMBER("xmaporigin",nil)) / MEMBER("xsectorsize", nil));
			_ypos = floor(((_position select 1) - MEMBER("ymaporigin",nil)) / MEMBER("ysectorsize", nil));
			[_xpos, _ypos];
		};

		/*
		Get the center of a sector from the position of the sector
		Return the center of a sector from a position
		*/
		PUBLIC FUNCTION("array", "getCenterPos") {
			private ["_position", "_sector"];			

			_position = _this;

			_sector = MEMBER("getSectorFromPos", _position);
			_position = MEMBER("getPosFromSector", _sector);
			_position;
		};

		/*
		Get all sectors around a sector
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorAround") {
			private ["_grid", "_params", "_sector"];

			_sector = _this;	
			_params = [_sector, 1];
			
			_grid = MEMBER("getSectorAllAround", _params);
			_grid;
		};

		
		/*
		Get cross sectors around a sector
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorCrossAround") {
			private ["_grid", "_sector"];

			_sector = _this select 0;

			_grid = [
				[(_sector select 0), (_sector select 1) - 1],
				[(_sector select 0)-1, (_sector select 1)],
				[(_sector select 0)+1, (_sector select 1)],
				[(_sector select 0), (_sector select 1) + 1]
				];
			_grid;
		};

		/*
		Get all sectors around a sector at scale sector distance
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorAllAround") {
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
		Check if there is buildings in the sector
		Return : boolean
		*/		
		PUBLIC FUNCTION("array", "isBuilding") {
			private ["_positions", "_result"];

			_sector = _this;
			_positions = MEMBER("getPositionsBuilding", _sector);
			if (count _positions > 10) then { _result = true;} else { _result = false;};
			_result;
		};

		/*
		Retrieve indexed building in the sector position
		Return : array containing all positions in building
		*/
		PUBLIC FUNCTION("array", "getPositionsBuilding") {
			private ["_index", "_buildings", "_position", "_positions", "_result"];

			_sector = _this;
			_position = MEMBER("getPosFromSector", _sector);
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

		/*
		Get the position from a sector
		Return : array position of the sector
		*/
		PUBLIC FUNCTION("array", "getPosFromSector") {		
			private ["_sector", "_x", "_y"];

			_sector = _this;

			_x = ((_sector select 0) * MEMBER("xsectorsize", nil)) + (MEMBER("xsectorsize", nil) / 2) + MEMBER("xmaporigin", nil);
			_y = ((_sector select 1) * MEMBER("ysectorsize", nil)) + (MEMBER("ysectorsize", nil) / 2)+ MEMBER("ymaporigin", nil);;

			[_x,_y];
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DELETE_VARIABLE("xmaporigin");
			DELETE_VARIABLE("ymaporigin");
			DELETE_VARIABLE("xmapsize");
			DELETE_VARIABLE("ymapsize");
			DELETE_VARIABLE("xsectorsize");
			DELETE_VARIABLE("ysectorsize");
		};
	ENDCLASS;