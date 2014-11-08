json.array! @user.questions do |question|
  json.id question.id
  json.review_at question.review_at
  json.type question.answer_type
  json.content question.content

  @answer_array = []
  question.answers.each do |answer|
    @answer_array.push answer.content
  end

  json.answers @answer_array
end
