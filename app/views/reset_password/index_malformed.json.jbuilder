errors = []
error_descriptions = []

unless params.key? 'reset_token'
  errors.push 1
  error_descriptions.push 'Reset Token is required.'
end

unless params.key? 'password'
  errors.push 2
  error_descriptions.push 'Password is required.'
end

json.errors errors
json.error_descriptions error_descriptions
