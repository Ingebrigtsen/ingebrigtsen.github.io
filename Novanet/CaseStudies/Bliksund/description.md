# Description

We need a case study for a product we've been part of, write it in Norwegian.
The format needs to be something like the following: https://novanet.no/referanser/ncb/

The product we worked on was EWA - Emergency Worker Assistant : https://bliksund.com/ewa
What we did was together with the team rebuild most of their existing client from scratch to
support multiple platforms; iOS/iPadOS, Android, Windows and Web.
Their existing solution was Windows only and could not be ported to reuse the code.

## Background

EWA is a digitalization of manual workflows that involved manual paper forms.
With EWA the users can register everything on the device and it gets synchronized.

## Constraints

We had a few constraints:

- Small team; the existing team had to maintain existing solution
  - we had one from that team for somewhere between 50-75%
  - A consultant in Netherlands
  - Me (Einar) for 50% of my time
  - November/December we got a new team member from Bliksund
- Time to delivery for customer acceptance was January 2026 and we started in August 2025
- Knowledge wise, we had to stay somewhat within the knowledge of the team which was primarily C# and .NET
- Solution had to work with on-prem installations, not just the cloud

## Things we had to solve

The record of the patient needs to be the same across all parties involved in a mission.
From the dispatch at the hospital to each of the ambulances; for instance if the mission involves
a helicopter picking up someone in the mountain and it needs to transfer the patient to a regular
car based ambulance.

All this while also supporting offline. The solution was built with an "offline first" mindset.

With the requirement of perfect audit trail of everything that needed to be done in combination with
the requirement for synchronization, it was a fairly easy decision to make to make it event based.
With the requirement of everything having to be auditable, the step to think in terms of event sourcing
was also pretty close. Although, we didn't go full event sourcing, we went for a hybrid approach where
everything is event first and we project immediately to state we could then use for display and for
decision making.

## Technically

We landed on doing it all with C# and .NET for the backend and React Native for the frontend, which gave
use the opportunity to target all the platforms we needed.

We used SQLite as database on the devices and supporting MSSQL and PostgreSQL when running on premise,
leveraging the power of a library I am part of maintaining; Cratis Arc (https://www.cratis.io/docs/Arc/index.html).

For event sourcing we leveraged building blocks from Cratis Chronicle (https://www.cratis.io/docs/Chronicle/index.html)
with a custom projection engine, dynamically projecting on top of EntityFramework Core.

## Illustrations

The following image shows all the resources involved, illustrating synchronization and offline capabilities.
![](FullSolution.png)

The following illustration shows an overview of what Event Sourcing is all about. Summarize Event Sourcing briefly,
look at the Event Sourcing resource.

![](EventSourcing.png)

The following illustration shows concretely what events we modeled.

![](Events.png)

## Resources

I've written about Event Sourcing, we should link to it in the right context:
https://novanet.no/stop-losing-information-event-sourcing/