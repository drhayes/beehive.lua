local sequence = require 'beehive.sequence'

local successCount, failCount, runCount

local function succeed()
  successCount = successCount + 1
  return 'success'
end

local function fail()
  failCount = failCount + 1
  return 'failure'
end

local function running()
  runCount = runCount + 1
  return 'running'
end

describe('sequence', function()
  before_each(function()
    successCount = 0
    failCount = 0
    runCount = 0
  end)

  it('stops on first failure', function()
    local tree = sequence({ succeed, succeed, fail, succeed })
    local result = tree()
    assert.are.equal(result, 'failure')
    assert.are.equal(successCount, 2)
    assert.are.equal(failCount, 1)
  end)

  it('returns to running thing', function()
    local tree = sequence({ succeed, succeed, running, succeed })
    local result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(successCount, 2)
    assert.are.equal(runCount, 1)

    successCount = 0
    runCount = 0
    result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(successCount, 0)
    assert.are.equal(runCount, 1)
  end)

  it('runs them all', function()
    local tree = sequence({ succeed, succeed, succeed })
    local result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(successCount, 3)
  end)
end)
