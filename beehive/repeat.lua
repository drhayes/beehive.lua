return function(times, child)
  local count = 1
  return function(...)
    local result = child(...)
    if result == 'failure' then
      count = 1
      return 'failure'
    elseif result == 'success' then
      count = count + 1
    end
    if count > times then
      count = 1
      return 'success'
    else
      return 'running'
    end
  end
end
