# FairPlay Competition Build - Final Test Log & Recording Guide

**Status:** Competition Build - Draft pending final freeze on Oct 27. 
**Date:** [Insert Date]

---

## PART 1: TEST LOG NOTES

### 1. Engine Break Tests (Logic & Safety)
These tests prove the engine handles bad data without crashing and respects business protections.

| Test | Input | Result | Status |
| :--- | :--- | :--- | :--- |
| **1. Ghost Customer** | Customer ID 9999 | Returned `[SEGMENT] Unknown` and Base Price. No crash. | **PASS** |
| **2. Phantom Booking** | Booking 9999 for Customer 1 | Returned `Comp=0 Perk=None`. No false money issued. | **PASS** |
| **3. Cost > Price** | List R420, Cost R999 | Returned `[FLOOR] R999.00 held`. Protected business from loss. | **PASS** |
| **4. Time Traveler** | -10 Hours Left | Math held perfectly at `R318.75`. No negative crash. | **PASS** |

### 2. Demo Environment Tests (Reliability)
These tests prove the simulator and display page are safe for a live presentation.

| Test | Action | Result | Status |
| :--- | :--- | :--- | :--- |
| **5. Bad Profile** | `run_sim.p` with 'Airplane' | Polite error box: *"Profile Airplane was not found."* No crash. | **PASS** |
| **6. Delete Feed** | Delete `feed.js` while sim runs | OS locks the file. Cannot be deleted while running. | **PASS** |
| **7. Double Run** | Run sim twice without seeds | Database cleans 20,000+ rows. Demo customers still appear. | **PASS** |

### 3. Fallback Safety Net
*   **Simulator finishes:** Badge flips to `END OF DAY`, then `REPLAY` after 25 seconds.
*   **Simulator dies (Procedure Editor closed):** Browser falls back to `REPLAY` after 6 seconds of no feed updates.

---

## PART 2: THE RECORDING GUIDE (The Fallback Clip)

You need one MP4 video. If the live demo fails on stage, you play this video and keep talking.

### Step 1: Prep Your Screen
1. Turn on **Do Not Disturb** (Windows notifications off).
2. Open `fairplay_display.html` in Chrome. Press **F** for fullscreen, then **B** for both slides and live panel.
3. Make sure the browser shows **REPLAY** (the placeholder data).
4. Open your Procedure Editor with `run_sim.p` ready to go.

### Step 2: Record
1. Start your screen recorder (Windows Game Bar `Win+G`, OBS, or even a phone camera pointed at the screen). 
2. Start recording.
3. **Wait 3 seconds.** 
4. In the Procedure Editor, run `run_sim.p` with `'Bus'`.
5. **Watch the browser.** Within 2 seconds, the badge flips to **LIVE SIMULATION**. (This is the "Aha!" moment).
6. **At 12:00 (Tick 12):** Point out Thandi Mokoena. The price drops, she gets a discount.
7. **At 13:00 (Tick 30):** Point out Sipho Ndlovu. He hits the HOLD. He pays full price.
8. **At 15:30 (Tick 45):** Point out Lerato Dlamini. She's a new customer.
9. Let it run to the end. When the **END OF DAY** popup appears, wait 2 seconds.
10. Stop recording.

### Step 3: Save and Backup (The Holy Trinity)
1. Rename the video: **`FairPlay_Fallback_Clip.mp4`**.
2. Copy it to a **USB drive**. Test that it plays on the USB drive.
3. Put the USB in your bag.

---

## PRE-DEMO CHECKLIST (The Night Before)
- [ ] USB with the video is in the bag.
- [ ] Charger is in the bag.
- [ ] Laptop is fully charged.
- [ ] The Cue Card (seed order) is printed and on the desk.
- [ ] You ran the demo successfully 3 times today.