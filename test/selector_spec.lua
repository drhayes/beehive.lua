local selector = require 'beehive.selector'

local successCount, failCount, runCount

local function succeed()
  successCount = successCount + 1
  return 'success'
end

local function fail()
  failCount = failCount + 1
  return 'failure'
end

local function run()
  runCount = runCount + 1
  return 'running'
end

describe('selector', function()
  before_each(function()
    successCount = 0
    failCount = 0
    runCount = 0
  end)

  it('stops on first success', function()
    local tree = selector({ fail, fail, succeed, fail })
    local result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(failCount, 2)
    assert.are.equal(successCount, 1)
  end)

  it('starts from beginning after succeeding', function()
    local tree = selector({ fail, fail, succeed, fail })
    local result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(failCount, 2)
    assert.are.equal(successCount, 1)

    result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(failCount, 4)
    assert.are.equal(successCount, 2)
  end)

  it('re-runs running things only', function()
    local tree = selector({ fail, fail, run, succeed })
    local result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(failCount, 2)
    assert.are.equal(runCount, 1)

    failCount = 0
    runCount = 0
    result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(failCount, 0)
    assert.are.equal(runCount, 1)
  end)

  it('returns failure if nothing succeeds', function()
    local tree = selector({ fail, fail, fail })
    local result = tree()
    assert.are.equal(result, 'failure')
    assert.are.equal(failCount, 3)
  end)

  it('looks at the failed stuff again later', function()
    local tree = selector({ fail, fail, succeed })
    local result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(failCount, 2)
    assert.are.equal(successCount, 1)

    result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(failCount, 4)
    assert.are.equal(successCount, 2)
  end)
end)
