class Store < ApplicationRecord
  has_many :products

  def self.returnStores()
    #
    # serverName = "localhost"#find
    # username = ""
    # password = ""#find
    # db = "odessu"
    # dataTransfer = new mysqli(serverName,username,password,db)
    #
    # storeSQL = "SELECT DISTINCT store_ID FROM sizes ORDER BY store_ID ASC"
    # storesInString = ""

    storeResults = Store.order("store_name ASC").distinct.pluck(:store_name) #array of uniq stores in asc order

    # storeResults.each do |str|
    #
    #   storesInString = storesInString + "" + ucwords(strtolower(rowOfResultStore[0])) #ucwords = .capitalize | strtolower = .downcase
    #
    # end

    # puts storesInString

  end

  def self.returnSizesForStore(storeName)

    # serverName = "localhost"#find
    # username = ""
    # password = ""#find
    # db = "odessu"
    # dataTransfer = new mysqli(serverName,username,password,db)
    #
    # sizeSQL = "SELECT DISTINCT store_size FROM sizes WHERE store_ID = '" + storeName + "'"
    # sizesInString = ""

    sizeResults = Store.where(store_name: storeName).distinct.pluck(:store_size)

    if(sizeResults.count) < 1)
      "Size Currently Not Available In Store"
    else
      sizeResults
    end
  end
end
