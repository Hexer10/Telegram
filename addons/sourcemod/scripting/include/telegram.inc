/*
 * Telegram - API Include.
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

/*
**
*/
#if defined _telegram_included
 #endinput
#endif
#define _telegram_included

public SharedPlugin __pl_telegram =
{
	name = "telegram",
	file = "telegram.smx",
	#if defined REQUIRE_PLUGIN
	required = 1,
	#else
	required = 0,
	#endif
};

/**
 * Sends a message thru a Telegram bot.
 *
 * @param message		The message to send.
 * @param bot			The bot token. (without 'bot').
 * @param chat			The chat id.
 *
 * @return				True if the request was sent successfully, false otherwise.
 */
native bool Telegram_SendMessage(const char[] message, char[] bot, const char[] chat);

#if !defined REQUIRE_PLUGIN
public __pl_Telegram_SetNTVOptional()
{
	MarkNativeAsOptional("Telegram_SendMessage");
}
#endif