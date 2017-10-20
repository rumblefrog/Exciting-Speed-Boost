/*
 *  Exciting Speed Boost - Boost player speed whenever they get a kill or on deathmatch
 *
 *  Copyright (C) 2017 RumbleFrog
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma semicolon 1


#define PLUGIN_AUTHOR "Fishy"
#define PLUGIN_VERSION "1.1.4"

#include <sourcemod>
#include <sdktools>
#include <tf2>

#pragma newdecls required

ConVar OnKillDuration;
ConVar OnDestroyDuration;

public Plugin myinfo =
{
	name = "Exciting Speed Boost",
	author = PLUGIN_AUTHOR,
	description = "[TF2] Boost player speed whenever they get a kill or destruction of a building",
	version = PLUGIN_VERSION,
	url = "https://keybase.io/rumblefrog"
};

public void OnPluginStart()
{
	HookEvent("player_death", OnPlayerDeath, EventHookMode_Post);
	HookEvent("object_destroyed", OnObjectDestroyed, EventHookMode_Post);
	HookEvent("ctf_flag_captured", OnFlagCaptured, EventHookMode_Post);
	CreateConVar("esb_version", PLUGIN_VERSION, "Exciting Speed Boost", FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY);
	OnKillDuration = CreateConVar("esb_onkillduration", "2.0", "Duration of speed boost given on kill", FCVAR_REPLICATED | FCVAR_NOTIFY, true, 0.0);
	OnDestroyDuration = CreateConVar("esb_ondestroyduration", "3.0", "Duration of speed boost given on destruction of buildings", FCVAR_REPLICATED | FCVAR_NOTIFY, true, 0.0);
}

public void OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int iVictim = GetClientOfUserId(GetEventInt(event, "userid"));
	int iAttacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (!IsValidClient(iVictim) || !IsValidClient(iAttacker, true))
		return;

	TF2_AddCondition(iAttacker, TFCond_SpeedBuffAlly, getDuration(OnKillDuration.FloatValue), 0);
}

public void OnObjectDestroyed(Event event, const char[] name, bool dontBroadcast)
{
	int iVictim = GetClientOfUserId(GetEventInt(event, "userid"));
	int iAttacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (!IsValidClient(iVictim) || !IsValidClient(iAttacker, true))
		return;

	TF2_AddCondition(iAttacker, TFCond_SpeedBuffAlly, getDuration(OnDestroyDuration.FloatValue), 0);
}

public void OnFlagCaptured(Event event, const char[] name, bool dontBroadcast)
{
	int iTeam = view_as<TFTeam>(Event.GetInt("capping_team"));
}

stock void GiveTeamSpeed(TFTeam iTeam)
{
	for (int i = 0; i < MaxClients; i++)
	{
		// Assign speed to user if conditional matches
	}
}

stock bool IsValidClient(int iClient, bool bAlive = false)
{
	if (iClient >= 1 &&
	iClient <= MaxClients &&
	IsClientConnected(iClient) &&
	IsClientInGame(iClient) &&
	(bAlive == false || IsPlayerAlive(iClient)))
	{
		return true;
	}

	return false;
}

stock float getDuration(float iDuration)
{
	if (iDuration == 0.0 || iDuration == 0) return TFCondDuration_Infinite;
	return iDuration;
}
