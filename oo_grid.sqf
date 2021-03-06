	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

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
			xgrid - x grid pos - scalar
			ygrid - y grid pos - scalar
			xgridsize - grid width - scalar
			ygridsize - grid height - scalar
			xsectorsize - sector width - scalar
			ysectorsize - sector height - scalar
		*/
		PUBLIC FUNCTION("array","constructor") {
			DEBUG(#, "OO_GRID::constructor")
			MEMBER("xgrid", _this select 0);
			MEMBER("ygrid", _this select 1);
			MEMBER("xgridsize", _this select 2);
			MEMBER("ygridsize", _this select 3);
			MEMBER("xsectorsize", _this select 4);
			MEMBER("ysectorsize", _this select 5);
		};

		PUBLIC FUNCTION("scalar","setXgrid") {
			DEBUG(#, "OO_GRID::setXgrid")
			MEMBER("xgrid", _this);
		};

		PUBLIC FUNCTION("scalar","setYgrid") {
			DEBUG(#, "OO_GRID::setYgrid")
			MEMBER("ygrid", _this);
		};

		PUBLIC FUNCTION("scalar","setXgridsize") {
			DEBUG(#, "OO_GRID::setXgridsize")
			MEMBER("xgridsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYgridsize") {
			DEBUG(#, "OO_GRID::setYgridsize")
			MEMBER("ygridsize", _this);
		};

		PUBLIC FUNCTION("scalar","setXsectorsize") {
			DEBUG(#, "OO_GRID::setXsectorsize")
			MEMBER("xsectorsize", _this);
		};

		PUBLIC FUNCTION("scalar","setYsectorsize") {
			DEBUG(#, "OO_GRID::setYsectorsize")
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
		Parameters: 
			_this : function name - string
		*/ 
		PUBLIC FUNCTION("string", "parseAllSectors") {
			DEBUG(#, "OO_GRID::parseAllSector")
			private _x = 0;
			private _y = 0;
			private _sector = [];
			private _array = [];

			for "_y" from MEMBER("ygrid", nil) to MEMBER("ygridsize", nil) step MEMBER("ysectorsize", nil) do {
				for "_x" from MEMBER("xgrid", nil) to MEMBER("xgridsize", nil) step MEMBER("xsectorsize", nil) do {
					_sector = MEMBER("getSectorFromPos", [_x, _y]);
					if(MEMBER(_this, _sector)) then {
						_array pushback _sector;
					};
				};
			};
			_array;
		};

		/*
		Call a loopback parsing function and return sectors that are concerned
		Example of string parameter: "hasBuildingsAtSector" will return sector with buildings
		Parameters: 
			_this : array 
			_this select 0 : array containg sectors - array
			_this select 1 : name of the function to call back - string
		Return : array of sectors
		*/
		PUBLIC FUNCTION("array", "parseSectors") {
			DEBUG(#, "OO_GRID::parseSectors")
			private _result = [];
			{
				if(MEMBER((_this select 1), _x)) then { 	_result pushback _x; }; true;
			} count (_this select 0);
			_result;
		};

		/*
		Translate a position to a sector
		Parameters: 
			_this : position array
		Return : sector : array
		*/
		PUBLIC FUNCTION("array", "getSectorFromPos") {
			DEBUG(#, "OO_GRID::getSectorFromPos")
			private _xpos = floor(((_this select 0) - MEMBER("xgrid",nil)) / MEMBER("xsectorsize", nil));
			private _ypos = floor(((_this select 1) - MEMBER("ygrid",nil)) / MEMBER("ysectorsize", nil));
			[_xpos, _ypos];
		};

		/*
		Translate a sector to a position
		Parameters: array - sector array
		Return : array position
		*/
		PUBLIC FUNCTION("array", "getPosFromSector") {	
			DEBUG(#, "OO_GRID::getPosFromSector")	
			private _x = ((_this select 0) * MEMBER("xsectorsize", nil)) + (MEMBER("xsectorsize", nil) / 2) + MEMBER("xgrid", nil);
			private _y = ((_this select 1) * MEMBER("ysectorsize", nil)) + (MEMBER("ysectorsize", nil) / 2)+ MEMBER("ygrid", nil);;
			[_x,_y];
		};		

		/*
		Retrieve the center position of a sector, from a position
		Parameters: array - position
		Return : array position of the sector center
		*/
		PUBLIC FUNCTION("array", "getSectorCenterPos") {
			DEBUG(#, "OO_GRID::getSectorCenterPos")	
			MEMBER("getPosFromSector", MEMBER("getSectorFromPos", _this));
		};

		/*
		Get all sectors around one sector
		Parameters: array - array sector
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorsAroundSector") {
			DEBUG(#, "OO_GRID::getSectorsAroundSector")	
			private _grid = [
				[(_this select 0) -1, (_this select 1) - 1],
				[(_this select 0), (_this select 1) - 1],
				[(_this select 0) + 1, (_this select 1) -1],
				[(_this select 0)-1, (_this select 1)],
				[(_this select 0)+1, (_this select 1)],
				[(_this select 0)-1, (_this select 1) + 1],
				[(_this select 0), (_this select 1) + 1],
				[(_this select 0)+1, (_this select 1) + 1]
				];
			_grid;			
		};

		/*
		Get all sectors around one position
		Parameters: array - array position
		Return : array containing all sectors
		*/		
		PUBLIC FUNCTION("array", "getSectorsAroundPos") {
			DEBUG(#, "OO_GRID::getSectorsAroundPos")
			MEMBER("getSectorsAroundSector", MEMBER("getSectorFromPos", _this));
		};

		
		/*
		Get cross sectors around a sector
		Parameters: 
			_this: sector - array 
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getSectorsCrossAroundSector") {
			DEBUG(#, "OO_GRID::getSectorsCrossAroundSector")
			private _grid = [
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
			DEBUG(#, "OO_GRID::getSectorsCrossAroundPos")
			MEMBER("getSectorsCrossAroundSector", MEMBER("getSectorFromPos", _this));
		};

		/*
		Get all sectors around a sector at scale sector distance
		Parameters: _
			_this : array
			_this select 0 : _sector - array
			_this select 1: _scale - int 
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getAllSectorsAroundSector") {
			DEBUG(#, "OO_GRID::getAllSectorsAroundSector")
			private _botx = ((_this select 0) select 0) - (_this select 1);
			private _boty = ((_this select 0) select 1) - (_this select 1);
			private _topx = ((_this select 0) select 0) + (_this select 1);
			private _topy = ((_this select 0) select 1) + (_this select 1);
			private _grid = [];
			private _x = 0;
			private _y = 0;
			
			for "_y" from _boty to _topy do {
				for "_x" from _botx to _topx do {
					_grid pushBack [_x, _y]; 
				};
			};
			_grid = _grid - [(_this select 0)];
			_grid;
		};

		/*
		Get all sectors around a sector at scale sector distance
		Parameters: 
			_this select 0 : position array
			_this select 1 : scale int
		Return : array containing all sectors
		*/
		PUBLIC FUNCTION("array", "getAllSectorsAroundPos") {
			DEBUG(#, "OO_GRID::getAllSectorsAroundPos")
			private _array = [MEMBER("getSectorFromPos", _this select 0), _this select 1];
			MEMBER("getAllSectorsAroundSector", _array);
		};

		/*
		Check if sector has building
		Parameters : _this : sector array
		Return : boolean
		*/		
		PUBLIC FUNCTION("array", "hasBuildingsAtSector") {
			DEBUG(#, "OO_GRID::hasBuildingsAtSector")
			private _positions = MEMBER("getPositionsBuilding", MEMBER("getPosFromSector", _this));
			if (count _positions > 10) then { true;} else { false;};
		};

		/*
		Check from a position if there are buildings in sector
		Parameters: _this : position array
		Return : boolean
		*/	
		PUBLIC FUNCTION("array", "hasBuildingsAtPos") {
			DEBUG(#, "OO_GRID::hasBuildingsAtPos")
			if(count MEMBER("getPositionsBuilding", _this) > 10) then { true;} else { false;};
		};


		/*
		Retrieve indexed building in the sector position
		Parameters: _this : position array
		Return : array containing all positions in building
		*/
		PUBLIC FUNCTION("array", "getPositionsBuilding") {
			DEBUG(#, "OO_GRID::getPositionsBuilding")
			private _positions = [];
			private _buildings = [];
			private _index = 0;
			
			if!(surfaceIsWater _this) then {
				_buildings = nearestObjects[_this,["House_F"], MEMBER("xsectorsize", nil)];
				sleep 0.5;
				{
					_index = 0;
					while { !((_x buildingPos _index) isEqualTo [0,0,0]) } do {
						_positions pushBack (_x buildingPos _index);
						_index = _index + 1;
						sleep 0.0001;
					};
					sleep 0.0001;
				}foreach _buildings;
			};
			_positions;
		};

		// Check distance cost between tow sectors
		PUBLIC FUNCTION("array", "GetEstimateCost") {
			DEBUG(#, "OO_GRID::GetEstimateCost")
			private _start = _this select 0;	
			private _goal = _this select 1;

			private _dx = abs((_start select 0) - (_goal select 0));
			private _dy = abs((_start select 1) - (_goal select 1));

			_dy max _dx;
		};	

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_GRID::deconstructor")
			DELETE_VARIABLE("xgrid");
			DELETE_VARIABLE("ygrid");
			DELETE_VARIABLE("xgridsize");
			DELETE_VARIABLE("ygridsize");
			DELETE_VARIABLE("xsectorsize");
			DELETE_VARIABLE("ysectorsize");
		};
	ENDCLASS;