json.id catagory.id
json.name catagory.name
json.color catagory.color

json.questions catagory.questions[0..(items_max)], partial: 'items/item',
                                                   as: :question
