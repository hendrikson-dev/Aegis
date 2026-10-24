DEFINE VARIABLE cText AS CHARACTER NO-UNDO.
RUN ae_llm.p (INPUT 'Reply with exactly: ready', OUTPUT cText).
MESSAGE 'Reply: [' + cText + ']' VIEW-AS ALERT-BOX.
