if @user.invalid?
  errors =  []
  error_descriptions = []

  if @user.errors['email'].include?("can't be blank")
    errors.push 1
    error_descriptions.push "You must supply a email."
  end

  if @user.errors['password'].include?("can't be blank")
    errors.push 2
    error_descriptions.push "You must supply a password."
  end

  if @user.errors['name'].include?("can't be blank")
    errors.push 3
    error_descriptions.push "You must supply a username."
  end

  if @user.errors['email'].include?("is not an email") or @user.errors['email'].include?("has already been taken")
    errors.push 4
    error_descriptions.push "Your email is invalid or already has a account associated with it."
  end

  if @user.errors['name'].include?("has already been taken")
    errors.push 5
    error_descriptions.push "This username has already been taken."
  end

  if errors.empty?
    errors.push 0
    error_descriptions.push "Unknown Error."
  end

  json.errors errors
  json.error_descriptions error_descriptions

else
  json.status "ok"
end