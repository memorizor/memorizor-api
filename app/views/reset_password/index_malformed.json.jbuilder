errors = []
error_descriptions = []

if not params.has_key? 'reset_token'
  errors.push 1
  error_description.push "Reset Token is required."
end

if not params.has_key? 'password'
  errors.push 2
  error_description.push "Password is required."
end
