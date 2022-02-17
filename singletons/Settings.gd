extends Node

var ENEMY_DEBUG := false


#Gameplay variables
var Player_Cash = 5000
var Predator_Pop = 0
var Prey_Pop  = 0
var Resource_Pop = 0
var GameRound = 1
var SpawnLocations 


enum GAME_STATES {
	PAUSE,
	DIALOG, 
	PLAY,
	LOADING,
}
var curGameState = GAME_STATES.PAUSE

var credits = 0

