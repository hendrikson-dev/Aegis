Lesson 10 — Live Display Page
Built

    fairplay_display.html — slides on the left, live dashboard on the right

    Modified sim_day.p to write feed.js every tick

Logic

    feed.js holds one line: time, price, seats, revenue, compensation, withheld, holds, overrides, avg price, events, done

    Browser reads feed.js once a second via a cache-busting script tag

    If feed stops changing for 6 seconds, page falls back to REPLAY mode

    Badge shows REPLAY, LIVE SIMULATION, or END OF DAY

Challenges

    feed.js wasn't created at first. The PROCEDURE WriteFeed: block was missing from sim_day.p. The page silently fell back to REPLAY the whole time.

    Syntax errors in WriteFeed. A + before SKIP breaks the parser. SKIP is a keyword, not a value — it can't be concatenated.

    Number formats. TRIM(STRING(x, '>>>>>9.99')) avoids thousands separators. Plain STRING adds commas that break the JSON array.

    Browser caching. feed.js?_=<timestamp> was usually enough, but Chrome sometimes ignores it. Ctrl+Shift+R forces a re-read. Long-term fix: serve via localhost.

Notes

    The page works offline — no server, no internet needed.

    The REPLAY fallback is a feature, not a bug. It keeps the screen alive even when the sim isn't running.