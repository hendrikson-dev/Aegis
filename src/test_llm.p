DEFINE VARIABLE cOut AS CHARACTER NO-UNDO.

MESSAGE 'Calling Groq AI... (This may take a few seconds)' VIEW-AS ALERT-BOX.
RUN ae_llm.p (INPUT 'Reply with exactly: Aegis AI is live.', OUTPUT cOut).

IF cOut = '' OR cOut = ? THEN
    MESSAGE 'AI CALL FAILED. Fallback triggered.' VIEW-AS ALERT-BOX ERROR.
ELSE
    MESSAGE cOut VIEW-AS ALERT-BOX INFO TITLE "Real AI Response".
