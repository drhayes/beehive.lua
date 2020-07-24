return function(child)
  return function(entity, dt)
    local result = child(entity, dt)
    if result == 'success' then
      return 'failure'
    elseif result == 'failure' then
      return 'success'
    else
      return result
    end
  end
end
