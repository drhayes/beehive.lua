return function(children)
  return function(...)
    local lastResult = 'success'
    for i = 1, #children do
      local child = children[i]
      local result = child(...)
      if result ~= 'success' then
        lastResult = result
      end
    end
    return lastResult
  end
end
