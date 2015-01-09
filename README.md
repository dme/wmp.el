# wmp.el -- interactive window manipulation

## Introduction

Selecting and deleting windows, moving a buffer from one window to
another, etc. are all common tasks for which there are a variety of
emacs lisp packages. Unfortunately, it's usually the case that each
package implements only one part of the solution - windmove is good
for selecting windows, buffer-move is good for swapping buffers,
etc. This package attempts to provide a simple way to implement
many such schemes in a centralised manner.

To use it, this code should be loaded using `(require 'wmp)' (or
`use-package' or whatever your preference), then some bindings are
configured.

In all cases the <up>, <down>, <left> and <right> keys are used as
the last element of the binding. Bindings can be set using modifier
prefixes (for example "M-" or "C-S-") or multi-key prefix sequence
(for example "C-c s " or "M-t ").

If the binding will use a multi-key prefix, the prefix string used
_must_ have a trailing space.

Bindings are configured using `wmp-group', which is passed a
binding prefix and a function to be called when the key sequence is
used. The function should take a single argument - the window on
which to operate.

Typical functions to use are `select-window' and `delete-window'. A
function to swap the buffers in two windows (`wmp-swap-window') is
provided.

## Examples

  (wmp-group "M-S-" 'select-window)

bind "meta-shift-<direction>" to select a window in the relevant
direction. Similar to `windmove'.

  (wmp-group "C-c d " 'delete-window)

bind "C-c s <direction>" to delete a window in the relevant
direction.
