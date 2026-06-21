# Philosophy of Bakery

This document outlines my overall goals and visions for Bakery. I aspire to these goals, but do not always reach them.

## Bakery has no Crashes, Bugs, or Jank

First, my definitions of these terms:
- **Crash**: Any time the game unexpectedly closes or stops
- **Bug**: Any time a game object does not function as it should
- **Jank**: Any visual inconsistency or multi-object interaction that feels weird

Bakery should have absolutely no crashes, even with other mods installed (those mods may have their own crashes, but Bakery should not be involved).
Bakery should have absolutely no bugs, even with other mods installed (and it should not cause bugs in other mods). Bakery uses modern and widely-supported features to try to automatically be compatible with well-behaved mods.
Bakery should have absolutely no jank, although if other mods are installed, jank is unavoidable. This also applies in any language, and with any control scheme, i.e. controller support should be first-class.

The first two goals can be achieved with sufficient usage of Balatest. The third goal can be achieved through sufficient playtesting.

As an API, Bakery will try to be stable, slow to change, and have minimal breaking changes. This goal is low priority.

## Bakery is Vanilla+

Bakery should not trivialize the challenge of Balatro, nor should it make the game more challenging to win. Bakery does make the game slightly easier to win (particularly with charms), but any such increase should be weighed with other factors. The first 8 antes should be given much more weight than endless mode.

## Bakery is Simple and Deep

Objects in Bakery should limit complexity creep. In general, no effect should have more than four short lines of text describing it (an additional `{disabled}` line for scaling values is okay).

Effects in Bakery should have deep interactions with each other and with the vanilla game. Effects should be distinct enough that any of them can find emergent gameplay scenarios beyond the text of the effect.

# Specific Guidance

## Double-sided Jokers

Double sided jokers can have twice as much text, since they have two faces to print on. However, transformation itself is a highly complex mechanic, so any additional effects should be simple and easy to parse.

## Decks

Decks can be any power level, since a powerful or weak deck does not impact the rest of the game.

## Charms

No charm should affect scoring, i.e. all charms should be economy or utility. Bakery is intentionally hostile to any external source equipping multiple charms at once to expand the reasonable design space (e.g. without this restriction, Pedigree and Anaglyph Lens couldn't exist together without a ton of extra work or significant jank). It should be reasonable to win ante 8 with no charm, and it should be hard to force finding a particular charm.

# No-Nos

Bakery will never add any of the following without exceptional reasons to do so:
- Exponential operations or higher: These quickly skew the game towards higher power levels.
- XChips: Without exponentiation, XChips has essentially no effect and can be replaced with XMult.
- Legendary Jokers: Each legend makes the Soul significantly worse and less fun to find.
- Consumable Types: I have never found a modded consumable that I enjoy having in the game. I do not have enough hubris to think I can make one better.
- Booster Packs: Modded booster packs tend to fall into two categories: never open, or always open. Neither is fun.
- Bad Tarot Cards: Specifically, tarot cards that apply a suit or enhancement. Each one, no matter how good in isolation, makes the game more difficult to play in a way I find unfun.
- Card modifiers that only appear in Standard Packs: These heavily increase the variance of runs and rarely feel special.

In general, when an existing pool of items is small, avoid adding another item to it, since doing so heavily dilutes the pool.

Each of these restrictions also helps to keep the scope of the mod smaller, which allows focusing on making each individual addition better.

Bakery has not used and will never use generative AI in its creation.
