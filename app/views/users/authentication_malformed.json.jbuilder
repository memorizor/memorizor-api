errors = []
error_descriptions = []

unless params.has_key?(:name)
  errors.push 2
  error_descriptions.push "Username or email is required."
end

unless params.has_key?(:password)
  errors.push 3
  error_descriptions.push "Password is required."
end

json.errors errors
json.error_descriptions error_descriptions