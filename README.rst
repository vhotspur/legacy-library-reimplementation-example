Approach for reimplementing legacy library above a revised one
===============================================================

The situation that is being solved on this example is following.
There exists some library (called *legacy* in this text) that is
used by several applications but is known to have various design flaws.
Because of these flaws, new library (called *revised*) is designed
and implemented and is used for new applications.

The goal is to reimplement the legacy library above the revised one.
This could happen during some major rewrite and the motivation is to
reuse the revised library (because it is better designed, better
maintained etc.).

The problem is that the libraries are in C and they define functions
of the same name.
The question is how to re-use the revised library when implementing the
legacy one if there is a naming collision.


The solution
-------------
The solution is based on renaming symbols in compiled object files.
It expects that there is a list of colliding names and that it is
possible to produce different headers of the legacy library, depending
whether they are used when compiling the library itself or when
compiling applications.

The actual solution is then rather simple. First, compiling is described,
linking is described later.

The revised library is compiled without any change and static library
``librevised.a`` is created.
The legacy library is compiled in such way that all colliding functions
(variables, types) are prefixed with ``legacy_``.
They call revised library functions normally.
The ported application is compiled against a legacy library header
where the function names are correct (i.e. no prefix).

The situation after compilation is that everything shall be
correctly compiled but it cannot be linked.

Before linking, ``librevised.a`` is unpacked and all colliding names
are renamed: prefix ``revised_`` is added.
That is possible through ``objcopy(1)`` [via ``--redefine-sym``].
The same renaming happens in object files of the legacy library.
After this first phase, names in legacy library object files are
renamed once more: the ``legacy_`` prefix is removed.
These patched object files are then packed into a single library,
``liblegacy.a``.

The application is then linked with ``liblegacy.a`` but not with
``librevised.a`` because that library is already part of the legacy one.

Advantages
  - No need to modify sources of the original application.
  - No changes to the revised library.
  - Minimal obstacles when writing the legacy library.
  - Shall work for anything (e.g. assembler as well) that compiles into ``*.o``

Disadvantages
  - Need to produce two different headers of the legacy library
  - Revised library exists in two instances (in compiled form)
