errors =  []
error_descriptions = []

if @catagory.errors['name'].include? "can't be blank"
  errors.push 1
  error_descriptions.push 'You must supply catagory name.'
end

color_blank = @catagory.errors['color'].include? "can't be blank"

if color_blank
  errors.push 2
  error_descriptions.push 'You must supply catagory color.'
end

if @catagory.errors['color'].include?('is invalid') && !color_blank

  errors.push 3
  error_descriptions.push 'You must supply valid hex catagory color.'
end
# We had a error saving the record, but it isn't one of the already defined
# errors, so we will return a unknown error.
if errors.empty?
  errors.push 0
  error_descriptions.push 'Unknown Error.'
end

json.errors errors
json.error_descriptions error_descriptions
