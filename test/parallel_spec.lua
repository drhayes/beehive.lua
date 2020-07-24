local parallel = require 'beehive.parallel'

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

describe('parallel', function()
  before_each(function()
    successCount = 0
    failCount = 0
    runCount = 0
  end)

  it('runs everything', function()
    local tree = parallel({ succeed, succeed, succeed, run, run })
    local result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(successCount, 3)
    assert.are.equal(runCount, 2)
  end)

  it('stops on failure', function()
    local tree = parallel({ succeed, succeed, fail, succeed })
    local result = tree()
    assert.are.equal(result, 'failure')
    assert.are.equal(successCount, 3)
    assert.are.equal(failCount, 1)
  end)
end)
