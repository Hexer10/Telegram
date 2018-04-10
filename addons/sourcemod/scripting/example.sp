/*
 * Telegram - API Example Plugin.
 * by: Hexer10
 * 
 * 
 * Copyright (C) 2018 Mattia (Hexer10 | Hexah | Papero)
 *
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include <sourcemod>
#include <telegram>

#define PLUGIN_AUTHOR "Hexah"
#define PLUGIN_VERSION "1.00"

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo = 
{
    name = "Telegram API Example",
    author = PLUGIN_AUTHOR,
    description = "Send message to Telegram by command",
    version = PLUGIN_VERSION,
    url = "github.com/Hexer10/Telegram"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_send", Cmd_Send);
}

public Action Cmd_Send(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Invalid args: sm_send <message>");
		return Plugin_Handled;
	}
	
	char sMessage[128];
	GetCmdArgString(sMessage, sizeof(sMessage));
	
	if (!Telegram_SendMessage(sMessage, "56xxxxxx:AAGgLrtxTgB_cMBr0ZNUxxxxxxxxxxxxxxx", "-1001xxxxxxxxx"))
	{
		ReplyToCommand(client, "[SM] Failed to send the message!");
		return Plugin_Handled;
	}
	
	ReplyToCommand(client, "[SM] Sent: '%s' successfully", sMessage);
	return Plugin_Handled;
}