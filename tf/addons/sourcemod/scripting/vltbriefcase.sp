#include <sourcemod>
#include <sdktools>

public Plugin myinfo = 
{

	name = "VLT Briefcase",
	author = "harriperhana",
	description = "Team Fortress 2 statistics in the most simplest way",
	version = "1.0",
	url = "https://github.com/harriperhana/vltbriefcase"
	
};

public void OnPluginStart()
{

	CheckDirectories();

}

public void OnMapStart()
{
	
	CreateTimer(1.0, UpdateIntelligence, _, TIMER_REPEAT);

}

public Action UpdateIntelligence(Handle Timer)
{

	WriteMapIntelligence();
	WriteTeamIntelligence(2);
	WriteTeamIntelligence(3);
	
	for (int i = 1; i <= MaxClients; i++)
	{
	
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
		
			WritePlayerIntelligence(i);
		
		}
	
	}

	return Plugin_Continue;

}

void WriteMapIntelligence()
{

	char MapIntelligence[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, MapIntelligence, sizeof(MapIntelligence), "data/vltbriefcase/map");

	char Map[64];
	GetCurrentMap(Map, sizeof(Map));

	int TimeLeft;
	GetMapTimeLeft(TimeLeft);
	
	int Humans, Bots;
	GetPlayerCount(0, Humans, Bots);

	Handle FileHandle = OpenFile(MapIntelligence, "w");

	WriteFileLine(FileHandle, "name=%s", Map);
	WriteFileLine(FileHandle, "left=%d", TimeLeft);
	WriteFileLine(FileHandle, "players=%d", Humans + Bots);
	WriteFileLine(FileHandle, "humans=%d", Humans);
	WriteFileLine(FileHandle, "bots=%d", Bots);
	
	CloseHandle(FileHandle);

}

void WriteTeamIntelligence(int TeamId)
{

	char TeamStat[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, TeamStat, sizeof(TeamStat), "data/vltbriefcase/team/%d", TeamId);
	
	int Humans, Bots;
	GetPlayerCount(TeamId, Humans, Bots);

	int Score = GetTeamScore(TeamId);
	
	Handle FileHandle = OpenFile(TeamStat, "w");
	
	WriteFileLine(FileHandle, "id=%d", TeamId);
	WriteFileLine(FileHandle, "score=%d", Score);
	WriteFileLine(FileHandle, "players=%d", Humans + Bots);
	WriteFileLine(FileHandle, "humans=%d", Humans);
	WriteFileLine(FileHandle, "bots=%d", Bots);
	
	CloseHandle(FileHandle);
	
}

void WritePlayerIntelligence(int Client)
{

	if (!IsClientConnected(Client))
		return;

    int Serial = GetClientSerial(Client);

	char SteamId[64];
	GetClientAuthId(Client, AuthId_Steam2, SteamId, sizeof(SteamId));
	ReplaceString(SteamId, sizeof(SteamId), ":", "");
	
	char PlayerIntelligence[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, PlayerIntelligence, sizeof(PlayerIntelligence), "data/vltbriefcase/player/%d", Serial);
	
	Handle FileHandle = OpenFile(PlayerIntelligence, "w");
	
	char Name[64];
	GetClientName(Client, Name, sizeof(Name));
	
	char IP[32];
	GetClientIP(Client, IP, sizeof(IP));

	char Weapon[64];
	GetClientWeapon(Client, Weapon, sizeof(Weapon));

	int Team = GetClientTeam(Client);
	int Class = GetEntProp(Client, Prop_Send, "m_iClass");
	int Health = GetClientHealth(Client);
	int Kills = GetClientFrags(Client);
	int Deaths = GetClientDeaths(Client);
	bool Alive = IsPlayerAlive(Client);
	int Time = RoundToNearest(GetClientTime(Client));

	WriteFileLine(FileHandle, "steamid=%s", SteamId);
	WriteFileLine(FileHandle, "ip=%s", IP);
	WriteFileLine(FileHandle, "name=%s", Name);
	WriteFileLine(FileHandle, "health=%d", Health);
	WriteFileLine(FileHandle, "kills=%d", Kills);
	WriteFileLine(FileHandle, "deaths=%d", Deaths);
	WriteFileLine(FileHandle, "alive=%d", Alive);
	WriteFileLine(FileHandle, "weapon=%s", Weapon);
	WriteFileLine(FileHandle, "time=%d", Time);
	WriteFileLine(FileHandle, "class=%d", Class);
	WriteFileLine(FileHandle, "team=%d", Team);

	CloseHandle(FileHandle);

}

public void OnClientDisconnect(int Client)
{

	if (IsFakeClient(Client)) return;

	int Serial = GetClientSerial(Client);

	char PlayerIntelligence[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, PlayerIntelligence, sizeof(PlayerIntelligence), "data/vltbriefcase/player/%d", Serial);

	DeleteFile(PlayerIntelligence);

}


void CheckDirectories()
{

	char DirBase[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, DirBase, sizeof(DirBase), "data/vltbriefcase/");
	CreateDirectory(DirBase);

	char DirPlayer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, DirPlayer, sizeof(DirPlayer), "data/vltbriefcase/player/");
	CreateDirectory(DirPlayer);

	char DirTeam[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, DirTeam, sizeof(DirTeam), "data/vltbriefcase/team/");
	CreateDirectory(DirTeam);

}

void GetPlayerCount(int TeamId, int &Humans, int &Bots)
{

	Humans = 0;
	Bots = 0;

	for (int i = 1; i <= MaxClients; i++)
	{
	
		if (!IsClientInGame(i))
			continue;
		
		int Team = GetClientTeam(i);
		
		if (TeamId == 0)
		{
		
			if (Team < 2)
				continue;
		
		}
		else
		{
		
			if (Team != TeamId)
				continue;
		
		}
		
		if (IsFakeClient(i))
			Bots++;
		else
			Humans++;
		
	}
	
}