json.partial! 'catagories/catagory', catagory: @catagory,
                                     items_max: @catagory.questions.count
