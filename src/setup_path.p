DEFINE VARIABLE cBaseDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cParam   AS CHARACTER NO-UNDO.

cParam = SESSION:PARAMETER.
IF cParam = "" OR cParam = ? THEN 
    cBaseDir = ".".
ELSE 
    cBaseDir = cParam.

PROPATH = PROPATH + "," + cBaseDir + "\src," + cBaseDir + "\seed," + OS-GETENV('DLC') + '\gui\netlib\OpenEdge.Net.pl'.
MESSAGE "PROPATH successfully set to: " + PROPATH VIEW-AS ALERT-BOX INFO.
