module StoreAndSizes
  index = _GET['index']
  storputssen = _GET['store']
  #will most likely go in the view, calling class methods and using their results as necessary------------
  if(index == 0)
    returnStores()
  else
    returnSizesForStore(storputssen)
  end
  #-----------
end
