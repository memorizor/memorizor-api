require 'test_helper'

class CatagoryTest < ActiveSupport::TestCase
  test 'Should not add a question without owning it' do
    @catagory = catagories(:test_catagory)
    @question = questions(:nother_test)
    @catagory.add_questions [@question.id], users(:active_user)
    assert_not @catagory.questions.include?(@question)
  end

  test 'Should add a question when the user owns it' do
    @catagory = catagories(:test_catagory)
    @question_1 = questions(:test)
    @question_2 = questions(:a_hitchhikers_guide_to_the_galaxy)
    @catagory.add_questions [@question_1.id, @question_2.id],
                            users(:active_user)
    assert @catagory.questions.include?(@question_1)
    assert @catagory.questions.include?(@question_2)
  end
end
