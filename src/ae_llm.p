USING OpenEdge.Net.HTTP.ClientBuilder.
USING OpenEdge.Net.HTTP.IHttpRequest.
USING OpenEdge.Net.HTTP.IHttpResponse.
USING OpenEdge.Net.HTTP.RequestBuilder.
USING Progress.Json.ObjectModel.*.
USING OpenEdge.Net.HTTP.IHttpClientLibrary.
USING OpenEdge.Net.HTTP.Lib.ClientLibraryBuilder.

DEFINE INPUT  PARAMETER cPrompt AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cText   AS CHARACTER NO-UNDO.

DEFINE VARIABLE oRequest  AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
DEFINE VARIABLE cApiKey   AS CHARACTER     NO-UNDO.
DEFINE VARIABLE oJson     AS JsonObject    NO-UNDO.
DEFINE VARIABLE oArr      AS JsonArray     NO-UNDO.
DEFINE VARIABLE oMsg      AS JsonObject    NO-UNDO.
DEFINE VARIABLE cUrl      AS CHARACTER     NO-UNDO INITIAL 'https://api.groq.com/openai/v1/chat/completions'.
DEFINE VARIABLE oLib      AS IHttpClientLibrary NO-UNDO.
DEFINE VARIABLE iMsg      AS INTEGER       NO-UNDO.

cText = ''.
cApiKey = OS-GETENV('agies_ai_key').
IF cApiKey = ? OR cApiKey = '' THEN RETURN.

oJson = NEW JsonObject().
oJson:Add('model', 'openai/gpt-oss-120b').
oJson:Add('temperature', 0.2).

oArr = NEW JsonArray().
oMsg = NEW JsonObject().
oMsg:Add('role', 'user').
oMsg:Add('content', cPrompt).
oArr:Add(oMsg).
oJson:Add('messages', oArr).

DO ON ERROR UNDO, LEAVE:
    oRequest = RequestBuilder:Post(cUrl, oJson)
        :AddHeader('Authorization', 'Bearer ' + cApiKey)
        :AddHeader('Content-Type', 'application/json')
        :Request.

    oLib = ClientLibraryBuilder:Build():ServerNameIndicator('api.groq.com'):Library.
    oResponse = ClientBuilder:Build():UsingLibrary(oLib):Client:Execute(oRequest).

    IF oResponse:StatusCode = 200 THEN DO:
        oJson = CAST(oResponse:Entity, JsonObject).
        oArr = oJson:GetJsonArray('choices').
        oMsg = oArr:GetJsonObject(1):GetJsonObject('message').
        cText = oMsg:GetCharacter('content').
    END.
    
    CATCH eErr AS Progress.Lang.Error:
        DO iMsg = 1 TO eErr:NumMessages:
            MESSAGE 'DEBUG CATCH: ' + eErr:GetMessage(iMsg) VIEW-AS ALERT-BOX ERROR.
        END.
        cText = ''.
    END CATCH.
END.
