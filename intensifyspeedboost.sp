#pragma semicolon 1


#define PLUGIN_AUTHOR "Fishy"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <tf2>

#pragma newdecls required

ConVar OnKillDuration;
ConVar DeathMatchDuration;

public Plugin myinfo = 
{
	name = "Intensify Speed Boost",
	author = PLUGIN_AUTHOR,
	description = "Boost player speed whenever they get a kill or on deathmatch",
	version = PLUGIN_VERSION,
	url = "https://keybase.io/rumblefrog"
};

public void OnPluginStart()
{
	HookEvent("player_death", OnPlayerDeath, EventHookMode_PostNoCopy);
	OnKillDuration = CreateConVar("sm_isb_onkillduration", "2.0", "Duration of speed boost given on kill", _, true, 0.0);
	DeathMatchDuration = CreateConVar("sm_isb_deathmatchduration", "0.0", "Duration of speed given on deathmatch (1v1)", _, true, 0.0);
}

public void OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int iVictim = GetClientOfUserId(GetEventInt(event, "userid"));
	int iAttacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	if (!IsValidClient(iVictim) || !IsValidClient(iAttacker))
		return;
		
	if (GetTeamAliveCount(view_as<int>(TFTeam_Red)) == 1 && GetTeamAliveCount(view_as<int>(TFTeam_Blue)) == 1)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i, true))
			{
				TF2_AddCondition(i, TFCond_SpeedBuffAlly, getDuration(DeathMatchDuration.FloatValue), 0);
				//PrintToConsole(i, "Gave %f second(s) of speed", DeathMatchDuration.FloatValue);
			}
		}
		return;
	}
	
	if (IsValidClient(iAttacker, true))
		TF2_AddCondition(iAttacker, TFCond_SpeedBuffAlly, getDuration(OnKillDuration.FloatValue), 0);
	
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

stock int GetTeamAliveCount(int iTeamNum)
{
    int iCount;
    for(int iClient = 1; iClient <= MaxClients; iClient++ )
        if( IsClientInGame( iClient ) && GetClientTeam( iClient ) == iTeamNum && IsPlayerAlive( iClient ) )
            iCount++;
    return iCount;
}

stock float getDuration(float iDuration)
{
	if (iDuration == 0.0 || iDuration == 0) return TFCondDuration_Infinite;
	return iDuration;
}