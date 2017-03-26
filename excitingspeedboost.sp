/**
MIT License

Copyright (c) 2017 RumbleFrog

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**/
#pragma semicolon 1


#define PLUGIN_AUTHOR "Fishy"
#define PLUGIN_VERSION "1.1.2"

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
	
	PrintToChatAll("Destroyed an object");
	
	if (!IsValidClient(iVictim) || !IsValidClient(iAttacker, true))
		return;
		
	TF2_AddCondition(iAttacker, TFCond_SpeedBuffAlly, getDuration(OnDestroyDuration.FloatValue), 0);
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