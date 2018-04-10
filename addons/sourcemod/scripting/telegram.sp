#include <sourcemod>
#include <SteamWorks>
#include <telegram>


#define PLUGIN_AUTHOR "Hexah"
#define PLUGIN_VERSION "1.01"

#pragma newdecls required
#pragma semicolon 1

bool bProcessing;

public Plugin myinfo = 
{
    name = "Telegram",
    author = PLUGIN_AUTHOR,
    description = "",
    version = PLUGIN_VERSION,
    url = "github.com/Hexer10"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    RegPluginLibrary("telegram");
    CreateNative("Telegram_SendMessage", Native_SendMessage);
}

public int Native_SendMessage(Handle plugin, int args)
{
	if (bProcessing)
		return 0;
		
    char sURL[128];
    
    int iSize;
    GetNativeStringLength(1, iSize);
    
    char[] sMessage = new char[iSize++];
    char sBot[64];
    char sChatID[64];
    
    GetNativeString(1, sMessage, iSize);
    GetNativeString(2, sBot, sizeof(sBot));
    GetNativeString(3, sChatID, sizeof(sChatID));
    
    Format(sURL, sizeof(sURL), "https://api.telegram.org/bot%s/sendMessage?", sBot);
    
    //Create the request
    Handle HTTPRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, sURL);
    SteamWorks_SetHTTPRequestNetworkActivityTimeout(HTTPRequest, 10);
    
    //Set the GET parameters
    SteamWorks_SetHTTPRequestGetOrPostParameter(HTTPRequest, "text", sMessage);
    SteamWorks_SetHTTPRequestGetOrPostParameter(HTTPRequest, "chat_id", sChatID);

    SteamWorks_SetHTTPRequestContextValue(HTTPRequest, 5);
     
    //Set the callback function
    SteamWorks_SetHTTPCallbacks(HTTPRequest, HTTPRequest_Callback);
    
    //Start the request
    
    bProcessing = true;
    bool bRequest = SteamWorks_SendHTTPRequest(HTTPRequest);
    if(!bRequest) 
    {
        
        HTTPRequest.Close();
        return 0;
    }
    
    //Send the request to the front of the queue
    SteamWorks_PrioritizeHTTPRequest(HTTPRequest);
    
    return 1;
}

public int HTTPRequest_Callback(Handle hRequest, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode) {

    if(!bRequestSuccessful) 
    {
        LogError("[TELEGRAM API] There was an error in the request");
    }
    else if(eStatusCode == k_EHTTPStatusCode304NotModified) 
    {
        LogError("[TELEGRAM API] The request did not return new data, but did not error, http code 304");
    } 
    else if(eStatusCode == k_EHTTPStatusCode404NotFound) 
    {
        LogError("[TELEGRAM API] The requested URL could not be found, http code 404");
    } 
    else if(eStatusCode == k_EHTTPStatusCode500InternalServerError) 
    {
        LogError("[TELEGRAM API] The requested URL had an internal error, http code 500");
    } 
    else if (eStatusCode != k_EHTTPStatusCode200OK)
    {
        LogError("[TELEGRAM API] The requested returned with an unexpected HTTP Code %d", eStatusCode);
    }
    bProcessing = false;
    hRequest.Close();
}