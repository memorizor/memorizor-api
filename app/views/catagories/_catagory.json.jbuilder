json.id catagory.id
json.name catagory.name
json.color catagory.color

json.items catagory.questions.page(1).per(items_max), partial: 'items/item',
                                                      as: :question
