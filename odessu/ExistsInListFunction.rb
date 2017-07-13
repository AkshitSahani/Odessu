module ExistsInListFunction
  def existsInList(itemChecked, listChecked)

    listChecked.each do |itemInList|

      upperCaseKey = itemChecked.strip.upcase
      upperCaseListItem = itemInList.strip.upcase

      #           puts "Key: " + itemChecked + "<br>"
      #           puts "List item: " + itemInList + "<br>"
      #           puts "Uppercase Key: " + upperCaseKey + "<br>"
      #           puts "Uppercase List Item: " + upperCaseListItem + "<br>"
#compare both strings in a safe and case-senstive way
      if(upperCaseKey <=> upperCaseListItem == 0)
        return true
      end
    end
    return false
  end
end
