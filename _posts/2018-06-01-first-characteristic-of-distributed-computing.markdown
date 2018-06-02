---
layout: post
title: "first characteristic of distributed computing"
date: 2018-06-01
preview: viewed from the outside, distributed computing is characterized by a collection of autonomous computing elements
---

Viewed from the outside, distributed computing is characterized by a collection of autonomous computing elements. The first lesson from [_Distributed Systems_](https://www.distributed-systems.net/index.php/books/distributed-systems-3rd-edition-2017/) unpacks this definition. Intuitively, it makes sense as it contrasts the distributed system from the monolith by pointing out where a distributed system's components _might_ be isolated, a monolith's components _might not_.

This characterization leads directly to a topological ( in the mathematical sense ) perspective on distributed systems. For one, components or nodes in a distributed system may be related to each other; typically this relation merely expresses logically the physical interaction between nodes by means of message passing. So long as a pair of nodes can freely pass messages, they are considered members of an **open** group ( in Steen & Tanenbaum's glossary ) a.k.a. neighbors. Contrawise, nodes that may not pass messages to each other are considered members of a **closed** group.

For example, processes on a single VM may regard each other as members of an open group. These processes may (generally) create a UNIX socket to pass data between each other; the operating system handles the details. By contrast, processes on separate VMs may regard each other as members of a closed group. These processes may not (generally) pass data between each other without explicitly opening a connection, say, via a port on a networked interface.

Speaking of networked interfaces, we needn't presume a particular implementation. Mathematically, we can be less precise about these implementation details since our interest will be in the concept involed. Tanenbaum calls this concept an **overlay network**:

- **structured** overlays define an open group with a discrete data structure (eg. a tree or a [logical ring](https://en.wikipedia.org/wiki/Ring_network))
- **unstructured** overlays define an open group arbitrarily (eg. hardcoded IP addresses)

Lastly, the authors close this section by mentioning **connectedness**, which also has strong influence from mathematical topology. Very simply, in the context of distributed systems, connectedness implies the existence of a communication pathway between two nodes. Connectedness is an important property of both structured and unstructured overlay networks: it implies that no two nodes cannot comprise a closed group. (In mathematical topology, we say that the space cannot be the union of disjoint open sets.)

#### Summary

The first characteristic of distributed systems says that these systems consist of a collection of autonomous computing elements. These elements (or nodes) may be open to communication with each other or closed to communication with each other; furthermore, open groups of nodes may be structured by well-defined neighborhood or unstructured (arbitrary grouping). These properties of open groups describe the groups' overlay network, and we note, crucially, that the overlay network ought to be connected in the sense that no two nodes cannot comprise a closed group.