local repeatIt = require 'beehive.repeat'

local successCount = 0
local function success()
  successCount = successCount + 1
  return 'success'
end

local failCount = 0
local function fail()
  failCount = failCount + 1
  return 'failure'
end

describe('repeat', function()
  before_each(function()
    successCount = 0
    failCount = 0
  end)

  it('repeats upon success', function()
    local tree = repeatIt(5, success)
    local result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(1, successCount)
    result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(2, successCount)
    result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(3, successCount)
    result = tree()
    assert.are.equal(result, 'running')
    assert.are.equal(4, successCount)
    result = tree()
    assert.are.equal(result, 'success')
    assert.are.equal(5, successCount)
  end)

  it('just keeps on failing', function()
    local tree = repeatIt(5, fail)
    local result = tree()
    assert.are.equal(result, 'failure')
    assert.are.equal(1, failCount)
    for i = 2, 10 do
      result = tree()
      assert.are.equal(result, 'failure')
      assert.are.equal(i, failCount)
    end
  end)

  it('passes variadic args to its children', function()
    local sum = 0
    local function count(one, two, three)
      sum = one + two + three
    end
    local tree = repeatIt(5, count)
    tree(1, 2, 3)
    assert.are.equal(sum, 6)
  end)

end)

