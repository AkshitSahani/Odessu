module StoreAndSizes
  index = _GET['index']
  storputssen = _GET['store']

  if(index == 0)
    returnStores()
  else
    returnSizesForStore(storputssen)
  end

  def returnStores()

    serverName = "localhost"#find
    username = ""
    password = ""#find
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    storeSQL = "SELECT DISTINCT store_ID FROM sizes ORDER BY store_ID ASC"
    storesInString = ""

    storeResults = mysqli_query(dataTransfer, storeSQL)

    while (rowOfResultStore = mysqli_fetch_row(storeResults)) do

      storesInString = storesInString + "" + ucwords(strtolower(rowOfResultStore[0]))

    end

    puts storesInString

  end

  def returnSizesForStore(storeName)

    serverName = "localhost"#find
    username = ""
    password = ""#find
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    sizeSQL = "SELECT DISTINCT store_size FROM sizes WHERE store_ID = '" + storeName + "'"
    sizesInString = ""

    sizeResults = mysqli_query(dataTransfer, sizeSQL)

    if(mysqli_num_rows(sizeResults) > 1)
      while (rowOfResultSize = mysqli_fetch_row(sizeResults)) do

        sizesInString = sizesInString . "" . ucwords(strtolower(rowOfResultSize[0]))

      end

      puts sizesInString
    else 
      puts "Store Currently Not Available"
    end

  end
end
