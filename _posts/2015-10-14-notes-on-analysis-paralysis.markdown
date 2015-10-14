---
layout: post
title: Notes on "Analysis Paralysis"
date: 2015-10-14
categories:
  - project management
  - planning
  - methodology and process
preview: another commentary on iterative development processes
---

## waterfall

We sometimes spend too much time analyzing a problem rather than solving a problem. This may be due to uneasiness around the problem domain: its unfamiliar, its hard, the consequences of being wrong outweigh the consequences of doing nothing. So we analyze the problem until it goes away, and nobody knows what has actually been achieved.

> By prolonging the analysis and design phases, they avoid risking accountability for results

So maybe one way to identify susceptibility to this pattern is to maintain the feedback loop with stakeholders.

> A key indicator of Analysis Paralysis is that the analysis documents no longer make sense to the domain experts

> If the domain model defines unexpected software concepts, categories, and specializations, the analysis modeling has probably gone too far. If the meaning of these new classes has to be explained in detail to the people intimately familiar with the current system, it is likely that the problem has been overanalyzed.

But even so, process changes are needed to ensure stakeholder feedback is positive and that any constructive feedback is enacted upon.

## iterative development

We have all heard of iterative development, but the concept remains useful mainly as an antipode. When you develop iteratively, you run a full development cycle -- more quickly and often.

> In incremental development, all phases of the object-oriented process occur with each iteration—analysis, design, coding, test, and validation. Initial analysis comprises a high-level review of the system so that the goals and general functionality of the system can be validated with the users. Each increment fully details a part of the system.

It is helpful to distinguish between internal and external phases, otherwise it may seem at times that the team gets "stuck" with no "visible" output.

> An internal increment builds software that is essential to the infrastructure of the implementation... In general, internal increments minimize rework.

> An external increment comprises user-visible functionality.

> External increments are essential to winning political consensus for the project by showing progress. External increments are also essential for user validation. They usually involve some throwaway coding to simulate missing parts of the infrastructure and back-end tiers.

What's left to do then? First, pick a project. Any will do. Yes, that one. Next:
  - determine what external results you can show. to whom can they be shown? how early can you show them to get feedback?
  - determine what you need to do to show those results. try breaking those tasks into smaller phases, then block your calendar to do them.
  - too many phases from the second step above? maybe you've comitted to too much externally and you need to go back to the first step and reduce scope.

Give it a try, see how it goes, then adjust for the next iteration; but be careful not to keep the initial stakes low so that you don't tie yourself into an overwrought analysis phase.

reference: [SourceMaking - Antipatterns: Analysis Paralysis](https://sourcemaking.com/antipatterns/analysis-paralysis)
