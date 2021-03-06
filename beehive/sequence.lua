return function(children)
  local index = 1
  return function(entity, dt)
    while index <= #children do
      local current = children[index]
      local result = current(entity, dt)
      if result == 'failure' then
        index = 1
        return 'failure'
      end
      if result == 'running' then
        return 'running'
      end
      index = index + 1
    end
    index = 1
    return 'success'
  end
end

