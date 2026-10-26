DEFINE VARIABLE cKey AS CHARACTER NO-UNDO.
cKey = OS-GETENV('aegis_ai_key').
IF cKey = ? OR cKey = '' THEN
    MESSAGE 'Key NOT found in OpenEdge environment.' VIEW-AS ALERT-BOX ERROR.
ELSE
    MESSAGE 'Key found! Starts with: ' + SUBSTRING(cKey, 1, 4) VIEW-AS ALERT-BOX INFO.
