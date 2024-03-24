array<string> strSpectators;
CSpecParam g_SpecParam;

class CColor
{
	CColor() { };
	CColor(int iColorRed, int iColorGreen, int iColorBlue)
	{
		iRed = iColorRed;
		iGreen = iColorGreen;
		iBlue = iColorBlue;
	};

	int iRed;
	int iGreen;
	int iBlue;
}

class CSpecParam
{
	//0 - IsEnabled; 1 - AdminsOnly

	array<int> iSettings = {
		1,
		0,
	};
}

void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor("kek");
	g_Module.ScriptInfo.SetContactInfo("https://github.com/kekekekkek/SpectatorList");
	
	g_Hooks.RegisterHook(Hooks::Player::ClientSay, @ClientSay);
	g_Hooks.RegisterHook(Hooks::Player::ClientDisconnect, @ClientDisconnect);
	
	g_Hooks.RegisterHook(Hooks::Player::PlayerPreThink, @PlayerPreThink);
	strSpectators.resize(g_Engine.maxClients);
}

bool IsPlayerAdmin(CBasePlayer@ pPlayer)
{
	return (g_PlayerFuncs.AdminLevel(pPlayer) >= ADMIN_YES);
}

void ShowHudMsg(CBasePlayer@ pPlayer, float fX, float fY, CColor cTextColor, string strMsg)
{
	HUDTextParams pHudTextParams;
		
	pHudTextParams.x = fX;
	pHudTextParams.y = fY;
	pHudTextParams.r1 = cTextColor.iRed;
	pHudTextParams.g1 = cTextColor.iGreen;
	pHudTextParams.b1 = cTextColor.iBlue;
	pHudTextParams.holdTime = 0.0;
	pHudTextParams.effect = -1;
	
	g_PlayerFuncs.HudMessage(pPlayer, pHudTextParams, strMsg);
}

HookReturnCode ClientSay(SayParameters@ pSayParam)
{
	array<string> strCommands = 
	{
		"sl", 
		"sl_ao",
	};

	array<string> strDesc =
	{
		"[SLInfo]: Usage: .sl or /sl or !sl <enabled>. Example: !sl 1\n",
		"[SLInfo]: Usage: .sl_ao or /sl_ao or !sl_ao <adminsonly>. Example: !sl_ao 0\n",
	};
	
	bool bHide = false;
	for (uint i = 0; i < strCommands.length(); i++)
	{
		string strText = pSayParam.GetArguments().Arg(0).ToLowercase();
	
		if ((strText == ("." + strCommands[i]))
			|| (strText == ("/" + strCommands[i]))
			|| (strText == ("!" + strCommands[i])))
		{
			if (IsPlayerAdmin(pSayParam.GetPlayer()))
			{
				if (pSayParam.GetArguments().ArgC() == 1)
				{
					bHide = true;
					g_PlayerFuncs.SayText(pSayParam.GetPlayer(), strDesc[i]);
					
					break;
				}
				
				if (pSayParam.GetArguments().ArgC() == 2)
				{
					string strArg = pSayParam.GetArguments().Arg(1);
					
					if (isdigit(strArg))
					{
						g_SpecParam.iSettings[i] = Math.clamp(0, 1, atoi(strArg));
						g_PlayerFuncs.SayTextAll(pSayParam.GetPlayer(), "[SLSuccess]: The value of the variable \"" + strCommands[i] + "\" has been successfully changed to \"" + g_SpecParam.iSettings[i] + "\"!\n");
						
						bHide = true;
					}
					else
					{
						g_PlayerFuncs.SayText(pSayParam.GetPlayer(), "[SLError]: The argument is not a number!\n");
						bHide = true;
					}
				}
			}
			else
			{
				bHide = (pSayParam.GetArguments().ArgC() < 3);
				
				if (bHide)
					g_PlayerFuncs.SayText(pSayParam.GetPlayer(), "[SLError]: This command is for admins only.\n");
				
				break;
			}
		}
	}
	
	if (bHide)
	{
		pSayParam.ShouldHide = true;
		return HOOK_HANDLED;
	}

	return HOOK_CONTINUE;
}

HookReturnCode PlayerPreThink(CBasePlayer@ pPlayer, uint& out)
{
	if (g_SpecParam.iSettings[0] == 1)
	{
		string strHudMsg = "Spectators:\n";
		int iEntIndex = g_EntityFuncs.EntIndex(pPlayer.edict());

		if (pPlayer.GetObserver().IsObserver())
		{
			string strTarget = pPlayer.GetObserver().GetObserverTarget().pev.netname;	
			strSpectators[iEntIndex] = strTarget;
		}
		else
		{
			strSpectators[iEntIndex].Clear();
			string strPlayer = pPlayer.pev.netname;

			for (uint i = 0; i < strSpectators.length(); i++)
			{
				if (strSpectators[i].Length() <= 0)
					continue;
				
				if (strSpectators[i] == strPlayer)
				{
					edict_t@ pEdict = g_EntityFuncs.IndexEnt(i);
					string strSpectator = pEdict.vars.netname;
					
					strHudMsg += (strSpectator + "\n");
				}
			}
			
			if (strHudMsg.Length() > 13)
			{
				if (g_SpecParam.iSettings[1] == 1)
				{
					if (IsPlayerAdmin(pPlayer))
						ShowHudMsg(pPlayer, 1, 0.1, CColor(255, 255, 255), strHudMsg);
				}
				else
					ShowHudMsg(pPlayer, 1, 0.1, CColor(255, 255, 255), strHudMsg);
			}
		}
	}

	return HOOK_CONTINUE;
}

HookReturnCode ClientDisconnect(CBasePlayer@ pPlayer)
{
	strSpectators[g_EntityFuncs.EntIndex(pPlayer.edict())].Clear();
	return HOOK_CONTINUE;
}