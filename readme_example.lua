local selector = require 'beehive.selector'
local sequence = require 'beehive.sequence'
local repeatNode = require 'beehive.repeat'

local lineOfSightSystem = {
  canSeePlayer = function(self, entity)
    if not self.yup then
      self.yup = true
      return false
    end
    return true
  end,
}

-- Ask some other system if this entity can see the player.
local function canSeePlayer(entity, dt)
  print('canSeePlayer           called every frame!')
  if lineOfSightSystem:canSeePlayer(entity) then
    print('can see the player now!')
    return 'success'
  else
    print('cannot see player yet')
    return 'failure'
  end
end

-- Wait a bit of time before succeeding.
local function waitRandom(low, hi)
  local elapsed = 0
  local span = math.random(low, hi)

  return function(entity, dt)
    elapsed = elapsed + dt
    if elapsed >= span then
      elapsed = 0
      span = math.random(low, hi)
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
  print('shootBlaster           called every frame, three times!')
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
  print('shootPlayer            called once at beginning and that is it!')
  return sequence({
    canSeePlayer,
    repeatNode(3, sequence({
      shootBlaster,
      waitRandom(1, 1)
    }))
  })
end

-- Mostly spend your time walking around. If the player pops
-- up, shoot them.
local function makeBrain()
  return selector({
    shootPlayer(),
    walkAround()
  })
end

local brain = makeBrain()

local e = {}

print('                       about to run brain 7 frames')
brain(e, 1)
brain(e, 1)
brain(e, 1)
brain(e, 1)
brain(e, 1)
brain(e, 1)
brain(e, 1)
