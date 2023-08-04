# Synapse

a distributed reputation system for the propagation of truthful information

## Principles
1. Peers can be considered information channels. The information coming through a given channel can be on a scale of "completely false" to "complete noise" to "completely true", therefore the scale which makes the most sense is `[-1, 1]` where `-1` is completely false, `0` is complete noise, and `1` is completely true.
2. Two peers who are completely trusted but who disagree should vote. In general the vote of a peer should be weighted by your degree of trust in them.
3. Your weighting of a peer IS your evaluation of their ability to propagate truthful information on a topic. In other words if you give someone a `0.5`, their contribution to a vote on a third party will be in proportion to this weight. This makes it less likely for weightings to be arbitrary and instead forces them to reflect something real.
4. Peers should be evaluated topic-wise. You do not give people one all-encompassing weight, but instead evaluate their ability to propagate truthful information across many different kinds of information.
5. Direct evaluation (by a trusted peer) of a person's ability to propagate true information on a topic is preferable to evaluations which are automatically extracted from social metadata.
6. Topics should be generated in a decentralized manner. Individuals should be a single-source-of-truth for categories they define. Categories spread and are adopted organically.

## User Stories for an Eventual Fully Operational App
1. I can create and manage my own categories (tags).
2. I can see the categories commonly used by my peers.
3. I can weight other ships on a scale of -1 to 1 on any given category.
4. I can see my network's weighting of a ship either as a weighted distribution or a weighted average.
5. I can sort by category and see my and my network's weightings of different ships on this category.
6. I can sort by ship and see my and my network's weightings of a ship on different categories.
