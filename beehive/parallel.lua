return function(children)
  return function(entity, dt)
    local lastResult = 'success'
    for i = 1, #children do
      local child = children[i]
      local result = child(entity, dt)
      if result ~= 'success' then
        lastResult = result
      end
    end
    return lastResult
  end
end
