# beehive.lua

A functional behavior tree implementation in lua.

## Install

Copy the `beehive` folder somewhere and start behaving.

## Example

Here is a high-level example of using these functions with custom behavior tree functions.

```lua
-- Ask some other system if this entity can see the player.
local function canSeePlayer(entity, dt)
  if lineOfSightSystem:canSeePlayer(entity) then
    return 'success'
  else
    return 'failure'
  end
end

-- Wait a bit of time before succeeding.
local function waitRandom(low, hi)
  local elapsed = 0
  local span = love.math.random(lo, hi)

  return function(entity, dt)
    elapsed = elapsed + dt
    if elapsed >= span then
      elapsed = 0
      span = love.math.random(lo, hi)
      return 'success'
    end
    return 'running'
  end
end

local function wanderOnPlatform(entity, dt)
  -- Wandering on platform left as exercise to the reader.
  -- Imagine it returns 'running' until the entity gets to
  -- the edge of the platform. Then it returns 'success'.
  return 'success'
end

local function shootBlaster(entity, dt)
  -- Makes entity shoot, then always returns 'success'.
  return 'success'
end

-- Walk to the edge of the platform, then wait a bit.
local function walkAround()
  return sequence({
    wanderOnPlatform,
    waitRandom(1, 3)
  })
end

-- If the player is visible, then shoot them 3 times in rapid succession.
local function shootPlayer()
  return sequence({
    canSeePlayer,
    repeat(3, sequence({
      shootBlaster,
      waitRandom(.3, .3)
    }))
  })
end

-- Mostly spend your time walking around. If the player pops
-- up, shoot them.
return function()
  return selector({
    shootPlayer,
    walkAround
  })
end
```

The returned function (at the end there) is a behavior tree function: it expects two arguments, `entity` and `dt`. Traverse this tree every frame to behave.

## Usage

Every node in the behavior tree is a function that is invoked every time through the tree. This library provides the basic utility functions for behavior trees and some extra ones just to be nice.

**NOTE**: This library expects each entity to receive its own instance of the tree of functions. You can't create the tree of functions once and then re-use it across seven different entities. The provided functions each maintain some state across executions and their results can't be re-used.

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
