# Video Script: Stop Guessing. Start Modeling.

**Duration:** ~2 minutes  
**Tone:** Direct, confident, conversational

---

## [HOOK — 0:00–0:10]

Most software projects don't fail because of bad code.
They fail because the team built the wrong thing — or built the right thing, but nobody agreed on what it actually does.

---

## [PROBLEM — 0:10–0:22]

A product owner, a developer, and a domain expert sit in a meeting.
They all walk out thinking they understood each other.
Three weeks later, the code shows up — and reality proves otherwise.

That's expensive. And it's avoidable.

---

## [WHAT IS IT — 0:22–0:38]

Event Modeling is a way to design systems using a shared timeline.
Instead of describing what your system *is* — you describe what it *does*, as a story that unfolds over time.

Three building blocks:
**Events** — things that happened. `RoomBooked`. `PaymentProcessed`.
**Commands** — things a user wants to do. `BookRoom`. `ProcessPayment`.
**Read Models** — how the system shows the user what's going on.

---

## [THE FOUR PATTERNS — 0:38–1:05]

Those three blocks combine into four patterns — and that's the entire vocabulary.

**State Change** — a user fires a command, it gets validated, an event is recorded.
*[show: CheckIn → CheckinCompleted]*

**State View** — events are projected into a read model the UI displays. Rebuild it at any time just by replaying the events.
*[show: RoomAssigned + CheckinCompleted → Visitor read model]*

**Automation** — a processor watches a read model, picks up items, fires a command. No human involved.
*[show: CleaningSchedule read model → ScheduleCleaning command]*

**Translator** — when an external system feeds you events you don't own, you translate them into your own language.
*[show: GPS coordinates → GuestLeftHotel]*

Any workflow in any system is some combination of these four. Once you recognise them, you see them everywhere.

---

## [QUICK MODELING DEMO — 1:05–1:40]

Let's model something right now. A hotel check-in. Two slices.

*[screen: blank canvas]*

Slice one — Assign Room.
Command: `AssignRoom`. It goes in, gets validated — is the room available? — and if so, we record: `RoomAssigned`.

*[show AssignRoom → RoomAssigned on timeline]*

Slice two — Check In.
Command: `CheckIn`. We read the `RoomAssigned` event to validate the guest is expected, and record: `CheckinCompleted`.

*[show CheckIn → CheckinCompleted]*

Now the read side. We project `RoomAssigned` and `CheckinCompleted` into a `Visitor` read model — that's what the front desk screen displays.

*[show events → Visitor read model]*

Two slices. A developer knows exactly what to build. A product owner can point at the screen and say "what shows up here?" Everyone's looking at the same thing.

---

## [BUSINESS VALUE — 1:40–1:52]

Done right, each new workflow step costs roughly the same — regardless of how much has already been built.
Reliable estimates. Predictable delivery. No more "it depends."

---

## [CALL TO ACTION — 1:52–2:00]

Reach out to us at Novanet if you'd like to explore this.
We run workshops. We're happy to help you get started.

Stop guessing. Start modeling.
