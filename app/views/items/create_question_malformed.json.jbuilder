errors =  []
error_descriptions = []

if @item.errors['content'].include? "can't be blank"
  errors.push 1
  error_descriptions.push 'You must supply question content.'
end

if @item.errors['answer_type'].include? "can't be blank"
  errors.push 2
  error_descriptions.push 'You must supply answer type.'
end

if @item.errors['answer_type'].include? 'is not included in the list'
  errors.push 3
  error_descriptions.push 'You must supply a valid type'
end

# We had a error saving the record, but it isn't one of the already defined
# errors, so we will return a unknown error.
if errors.empty?
  errors.push 0
  error_descriptions.push 'Unknown Error.'
end

json.errors errors
json.error_descriptions error_descriptions
