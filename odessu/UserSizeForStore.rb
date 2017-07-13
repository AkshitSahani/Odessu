module UserSizeForStore


  def getUserSizeForStoreBottom(user, storeName)

    userBWHSQL = "SELECT Waist, Hip FROM users WHERE Email = '" + emailIn + "'"

    resultMeasure = mysqli_query(dataTransfer, userBWHSQL)
    rowOFMeasure = mysqli_fetch_row(resultMeasure)
    waistIn = rowOFMeasure[0]
    hipIn = rowOFMeasure[1]

    waistStoreSizeSQL = "SELECT STORE_ID, store_size, size_Min, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'WAIST')"
    hipStoreSizeSQL = "SELECT STORE_ID, store_size, size_Min, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'HIP')"

    previousMinWaist = 0
    previousMaxWaist = 0
    previousMinHip = 0
    previousMaxHip = 0

    previousStoreSizeWaist = ""
    previousStoreSizeHip = ""

    previousStoreNameWaist = ""
    previousStoreNameHip = ""

    perfectWaistArray = array()
    perfectHipArray = array()

    tightWaistArray = array()
    tightHipArray = array()

    looseWaistArray = array()
    looseHipArray = array()

    resultWaist = mysqli_query(dataTransfer, waistStoreSizeSQL)
    sizeOfResultWaist = mysqli_num_rows(resultWaist)
    if(sizeOfResultWaist < 1)
      return "Bad Read Waist"
    end
    countWaistLoops = 0

    while(rowOfWaist = mysqli_fetch_row(resultWaist)) do

      countWaistLoops+= 1

      if ((rowOfWaist[2] < waistIn) && (rowOfWaist[3] > waistIn))

        perfectWaistArray[rowOfWaist[0]] = rowOfWaist[1]

      else
        if (rowOfWaist[2] == waistIn)

          looseWaistArray[rowOfWaist[0]] = rowOfWaist[1]
        elsif (rowOfWaist[3] == waistIn)

          tightWaistArray[rowOfWaist[0]] = rowOfWaist[1]
        elsif ((waistIn > previousMaxWaist) && (waistIn < rowOfWaist[2]))

          if (((previousMaxWaist + rowOfWaist[2]) / 2) == waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
            tightWaistArray[rowOfWaist[0]] = rowOfWaist[1]
          elsif (((previousMaxWaist + rowOfWaist[2]) / 2) > waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
          elsif (((previousMaxWaist + rowOfWaist[2]) / 2) < waistIn)

            tightWaistArray[rowOfWaist[0]] = rowOfWaist[1]
          end
        elsif ((previousStoreNameWaist != rowOfWaist[0]) && ((waistIn - 1) == previousMaxWaist))

          tightWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
        elsif ((countWaistLoops == sizeOfResultWaist) && ((waistIn - 1) == rowOfWaist[3]))

          tightWaistArray[rowOfWaist[0]] = rowOfWaist[1]
        end
      end

      previousStoreNameWaist = rowOfWaist[0]
      previousStoreSizeWaist = rowOfWaist[1]
      previousMinWaist = rowOfWaist[2]
      previousMaxWaist = rowOfWaist[3]

    end

    resultHip = mysqli_query(dataTransfer, hipStoreSizeSQL)
    sizeOfResultHip = mysqli_num_rows(resultHip)
    if(sizeOfResultHip < 1)
      return "Bad Read Hip"
    end
    countHipLoops = 0

    while(rowOfHip = mysqli_fetch_row(resultHip)) do

      countWaistLoops+= 1

      if ((rowOfHip[2] < waistIn) && (rowOfHip[3] > waistIn))

        perfectWaistArray[rowOfHip[0]] = rowOfHip[1]

      else
        if (rowOfHip[2] == waistIn)

          looseWaistArray[rowOfHip[0]] = rowOfHip[1]
        elsif (rowOfHip[3] == waistIn)

          tightWaistArray[rowOfHip[0]] = rowOfHip[1]
        elsif ((waistIn > previousMaxWaist) && (waistIn < rowOfHip[2]))

          if (((previousMaxWaist + rowOfHip[2]) / 2) == waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
            tightWaistArray[rowOfHip[0]] = rowOfHip[1]
          elsif (((previousMaxWaist + rowOfHip[2]) / 2) > waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
          elsif (((previousMaxWaist + rowOfHip[2]) / 2) < waistIn)

            tightWaistArray[rowOfHip[0]] = rowOfHip[1]
          end
        elsif ((previousStoreNameWaist != rowOfHip[0]) && ((waistIn - 1) == previousMaxWaist))

          tightWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
        elsif ((countWaistLoops == sizeOfResultWaist) && ((waistIn - 1) == rowOfHip[3]))

          tightWaistArray[rowOfHip[0]] = rowOfHip[1]
        end
      end

      previousStoreNameWaist = rowOfHip[0]
      previousStoreSizeWaist = rowOfHip[1]
      previousMinWaist = rowOfHip[2]
      previousMaxWaist = rowOfHip[3]

    end
    #Perfect vs All
    #Perfect vs Perfect
    perfectWaistArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))

        perfectBustSize = perfectHipArray[storeNameKey]
        perfectWaistSize = storeSizeValue

        if (perfectBustSize == perfectWaistSize)
          return perfectBustSize
        elsif (perfectBustSize > perfectWaistSize)
          return perfectBustSize
        elsif (perfectBustSize < perfectWaistSize)
          return perfectWaistSize
        end

      end
    end

    #Perfect vs Tight
    perfectWaistArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))

        tightBustSize = tightHipArray[storeNameKey]
        perfectWaistSize = storeSizeValue

        if (tightBustSize == perfectWaistSize)
          return tightBustSize
        elsif (tightBustSize > perfectWaistSize)
          return tightBustSize
        elsif (tightBustSize < perfectWaistSize)
          return perfectWaistSize
        end

      end
    end

    perfectHipArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))



        tightWaistSize = tightWaistArray[storeNameKey]
        perfectBustSize = storeSizeValue

        if (perfectBustSize == tightWaistSize)
          return perfectBustSize
        elsif (perfectBustSize > tightWaistSize)
          return perfectBustSize
        elsif (perfectBustSize < tightWaistSize)
          return tightWaistSize
        end
      end
    end

    #Perfect vs Loose
    perfectWaistArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))

        looseBustSize = looseHipArray[storeNameKey]
        perfectWaistSize = storeSizeValue

        if (looseBustSize == perfectWaistSize)
          return looseBustSize
        elsif (looseBustSize > perfectWaistSize)
          return perfectWaistSize
        elsif (looseBustSize < perfectWaistSize)
          return looseBustSize
        end

      end
    end

    perfectHipArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))
        looseWaistSize = looseWaistArray[storeNameKey]
        perfectBustSize = storeSizeValue

        if (perfectBustSize == looseWaistSize)
          return perfectBustSize
        elsif (perfectBustSize > looseWaistSize)
          return looseWaistSize
        elsif (perfectBustSize < looseWaistSize)
          return perfectBustSize
        end
      end
    end

    #Tight vs All
    #Tight vs Tight
    tightWaistArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))
        tightBustSize = tightHipArray[tightStoreNameKey]
        tightWaistSize = tightStoreSizeValue

        if (tightWaistSize > tightBustSize)
          return tightWaistSize
        elsif (tightWaistSize < tightBustSize)
          return tightBustSize
        elsif (tightWaistSize == tightBustSize)
          return tightBustSize
        end

      end
    end

    #Tight vs Loose
    tightHipArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))
        looseWaistSize = looseWaistArray[tightStoreNameKey]
        tightBustSize = tightStoreSizeValue

        if (looseWaistSize > tightBustSize)
          return looseWaistSize
        elsif (looseWaistSize < tightBustSize)
          return tightBustSize
        elsif (looseWaistSize == tightBustSize)
          return tightBustSize
        end

      end
    end

    tightWaistArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))

        looseBustSize = looseHipArray[tightStoreNameKey]
        tightWaistSize = tightStoreSizeValue

        if (tightWaistSize > looseBustSize)
          return looseBustSize
        elsif (tightWaistSize < looseBustSize)
          return looseBustSize
        elsif (tightWaistSize == looseBustSize)
          return looseBustSize
        end
      end
    end

    #Loose vs All
    #Loose vs Loose
    looseWaistArray.each do |storeNameKey,storeSizeValue|

      if (array_key_exists(storeNameKey, perfectBustArray))

        looseBustSize = looseHipArray[looseStoreNameKey]
        looseWaistSize = looseStoreSizeValue

        if (looseWaistSize > looseBustSize)
          return looseBustSize
        elsif (looseWaistSize < looseBustSize)
          return looseWaistSize
        elsif (looseWaistSize == looseBustSize)
          return looseBustSize
        end
      end
    end

    return "No Size In Store"
  end
end
