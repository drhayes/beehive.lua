# beehive.lua

A functional behavior tree implementation in lua.

## Install

Copy the `beehive` folder somewhere and start behaving.

## Usage

Every node in the behavior tree is a function that is invoked every time through the tree. This library provides the basic utility functions for behavior trees and some extra ones just to be nice.

The main three are:

* selector
* sequence
* parallel

The nice-to-have ones are:

* fail
* repeat
* invert

Each of these will return one of `'success'`, `'failure'`, or `'running'` as strings after its execution.

In beehive, a "behavior tree function" is a function that takes two arguments: `entity` and `dt`. When invoked, that function will return one of `'success'`, `'failure'`, or `'running'`.

Since none of the below functions do anything with `entity` and `dt` you are free to use them for whatever you wish.

Each of the functions below, when run, returns a behavior tree function.

### `selector`

This function takes one argument, a list of behavior tree functions.

This function will run each of its children until it finds one that returns `'success'`. It will start from the beginning of its list of children the next time it is executed if it succeeded last time.

If one of its children returns `'running'` it will return `'running'`. On its next invocation, it will run *only that child* until it either succeeds or fails.

### `sequence`

This function takes one argument, a list of behavior tree functions.

This function will run each of its children until it finds one that returns `'failure'`. It will start from the beginning of its list of children the next time it is executed if it failed last time.

If one of its children returns `'running'` it will return `'running'`. On its next invocation, it will run *only that child* until it either succeeds or fails.

### `parallel`

This function takes one argument, a list of behavior tree functions.

This function will run all of its children when invoked. If it receives any result other than `'success'` it will return that value. If all its children succeed, then it will return `'success'`.

**NB**: `parallel` will return the last non-`'success'` value that it receives from its children, i.e. if the second-to-last returns `'failure'` but the last returns `'running'` then this function will return `'running'`.

### `fail`

Returns `'failure'` unconditionally.

### `repeat`

This function takes two arguments: a number (`times`) and a behavior tree function.

On every invocation is will run its child function and increment a counter. If the counter is less than the `times` argument, this function will return `'running'`. Once the counter exceeds the `times` argument it will return `'success'`.

If its child returns `'failure'` it will reset its counter.

### `invert`

This function takes one argument, a behavior tree function.

It will invoke its child function. If its result is `'success'`, this will return `'failure'`. If the result is `'failure'` this will return `'success'`. Otherwise, it returns the result received from its child function (hopefully the last case is `'running'`).

## Dev

The unit tests require `busted`. The `Makefile` just calls `busted`.
