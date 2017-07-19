class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  has_many :authored_conversations, class_name: "Conversation", foreign_key: 'author_id'
  has_many :received_conversations, class_name: "Conversation", foreign_key: 'receiver_id'
  has_many :sent_messages, class_name: "Message", foreign_key: 'author_id', dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: 'receiver_id', dependent: :destroy
  has_many :orders
  has_one :wish_list
  has_many :issues
  accepts_nested_attributes_for :issues, reject_if: :all_blank?
  has_many :insecurities
  accepts_nested_attributes_for :insecurities, reject_if: :all_blank?

  def self.get_results(search)
    results_hash = {}
    results_stores = Store.where('lower(store_name) LIKE lower(?)', "%#{search}%") #change LIKE to ILIKE and remove lower term for deployment
    results_products = Product.where('lower(name) LIKE (?) OR lower(description1) LIKE lower(?)
    OR lower(description2) LIKE lower(?) OR lower(description3) LIKE lower(?) OR lower(description4) LIKE lower(?)
    OR lower(description5) LIKE lower(?)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    results_hash[:store_results] = results_stores #heroku uses postgres which uses ILIKE for case-insensitive searches.
    results_hash[:product_results] = results_products
    return results_hash
  end

  def self.bmiCalculator(user)
    if user.weight_type == "Kg"
      weightKg = user.weight.to_i
    else
      weightKG = ((user.weight.to_i) * 0.453592)
    end

    if user.height_cm
      heightM = ((user.height_cms).to_f)/100
    elsif user.height_ft
      personHeight = (user.height_ft * 12) + user.height_in
      heightM = (personHeight.to_f * 0.0254)
    end

    bmi = (weightKG.to_f / (heightM * heightM))

    data_hash = {weight_kg: weightKG, height_m: heightM, bmi: bmi}

    if (bmi < 19)
      data_hash[:bmi_state] = "under"
    elsif ((bmi >= 19) && (bmi <= 24.999))
      data_hash[:bmi_state] = "healthy"
    elsif ((bmi >= 25) && (bmi <= 29.999))
      data_hash[:bmi_state] = "over"
    elsif (bmi >= 30)
      data_hash[:bmi_state] = "obese"
    end

    return data_hash
  end

  def self.guessBodyShapeNew(user, calculated_bmi)
     bustSize = user.bust.to_f
     waistSize = user.waist.to_f
     hipSize = user.hip.to_f
     bustWaistRatio = (bustSize / waistSize)
     hipWaistRatio = (hipSize / waistSize)
     waistRatio = 1

     diffInterBustWaist = (bustSize - waistSize).abs
     diffInterHipWaist = (hipSize - waistSize).abs
     diffInterBustHip = (bustSize - hipSize).abs

     bodyCategory = calculated_bmi

     results_hash = {bust_waist_ratio: bustWaistRatio, hip_waist_ratio: hipWaistRatio, body_category: bodyCategory}

     if((diffInterBustWaist <= 3) && (diffInterHipWaist <= 3) && (diffInterBustHip <= 3))
       #puts "<h4>Rectangle</h4>"
       results_hash[:body_shape] = "Rectangle"
     elsif((waistRatio > bustWaistRatio) && (waistRatio > hipWaistRatio))
       #puts "<h4>Oval</h4>"
       results_hash[:body_shape] = "Oval"
     elsif ((waistRatio < bustWaistRatio) && (waistRatio < hipWaistRatio))
       #puts "<h4>Hourglass</h4>"
       results_hash[:body_shape] = "Hourglass"
     elsif ((waistRatio < bustWaistRatio) && (waistRatio > hipWaistRatio))
       #puts "<h4>Inverted Triangle</h4>"
       results_hash[:body_shape] = "Inverted Triangle"
     elsif ((waistRatio > bustWaistRatio) && (waistRatio < hipWaistRatio))
       #puts "<h4>Triangle</h4>"
       results_hash[:body_shape] = "Triangle"
     end
     return results_hash
  end

  def self.calcAvrgFromHeightWeight(user) #when you only have height and weight from the user.
    if user.height_cm
      getHeight = (user.height_cm.to_f) * 0.393701
    elsif user.height_ft
      getHeight = (user.height_ft.to_f * 12) + user.height_in.to_f
    end

    if user.weight_type == "Lbs"
      getWeight = user.weight.to_f
    elsif user.weight_type == "Kg"
      getWeight = ((user.weight.to_f) * 2.20462)
    end
    # getBraBust = user.bust #(bra size)

    predictedBust = (39.8828 + (getHeight.to_f * (-0.303664)) + (getWeight * 0.120713))
    predictedWaist = (37.9338 + (getHeight.to_f * (-0.427647)) + (getWeight * 0.139814))
    predictedHip = (33.4630 + (getHeight.to_f * (-0.163644)) + (getWeight * 0.118256))

    results_hash = {}
    results_hash[:true_bust] = predictedBust
    results_hash[:true_waist] = predictedWaist
    results_hash[:true_hip] = predictedHip

    return results_hash
  end

  def self.calcAvrgForKnownStoresAndSizes(user) # when you only know the stores and sizes in each store for the user.

    #Variable Instantiation
    topBustMax = 0
    topBustMin = 0
    topWaistMax = 0
    topWaistMin = 0
    topHipMax = 0
    topHipMin = 0

    bottomBustMax = 0
    bottomBustMin = 0
    bottomWaistMax = 0
    bottomWaistMin = 0
    bottomHipMax = 0
    bottomHipMin = 0

    countTopMinBust = 0
    countTopMaxBust = 0
    countTopMinWaist = 0
    countTopMaxWaist = 0
    countTopMinHip = 0
    countTopMaxHip = 0

    countTopBustLoops = 0
    countTopWaistLoops = 0
    countTopHipLoops = 0

    countBottomMinBust = 0
    countBottomMaxBust = 0
    countBottomMinWaist = 0
    countBottomMaxWaist = 0
    countBottomMinHip = 0
    countBottomMaxHip = 0

    countBottomBustLoops = 0
    countBottomWaistLoops = 0
    countBottomHipLoops = 0

    storeName = user.tops_store.upcase
    storeSizeTop = user.tops_size

    resultTopBust = Store.where(store_name: storeName, feature: "BUST")
    resultTopWaist = Store.where(store_name: storeName, feature: "WAIST")
    resultTopHip = Store.where(store_name: storeName, feature: "HIP")

    #Get Data For Top Bust

    numRowsTopBust = resultTopBust.count
    a = 0
    while a < resultTopBust.count

      countTopBustLoops+= 1

      if((resultTopBust[a].store_size.include?(storeSizeTop)) &&
        !(resultTopBust[a].store_size.include?("X" + storeSizeTop)) &&
        !(resultTopBust[a].store_size.include?("0" + storeSizeTop)) &&
        !(resultTopBust[a].store_size.include?( "1" + storeSizeTop)) &&
        !(resultTopBust[a].store_size.include?( "2" + storeSizeTop)))

        topBustMin = topBustMin + resultTopBust[a].size_min.to_f
        topBustMax = topBustMax + resultTopBust[a].size_max.to_f

        countTopMinBust += 1
        countTopMaxBust +=1
        break

      elsif(resultTopBust[a].store_size == storeSizeTop)

        topBustMin = topBustMin + resultTopBust[a].size_min.to_f
        topBustMax = topBustMax + resultTopBust[a].size_max.to_f

        countTopMinBust+= 1
        countTopMaxBust+= 1
        break
      elsif(numRowsTopBust == countTopBustLoops)
        puts storeSizeTop + " not found in " + storeName + "<br>"
        break
      else
        a += 1
      end
    end


    #Get Data For Top Waist
    numRowsTopWaist = resultTopWaist.count
    b = 0
    while b < resultTopWaist.count

      countTopWaistLoops+=1
      if((resultTopWaist[b].store_size.include?(storeSizeTop)) &&
        !(resultTopWaist[b].store_size.include?("X" + storeSizeTop)) &&
        !(resultTopWaist[b].store_size.include?("0" + storeSizeTop)) &&
        !(resultTopWaist[b].store_size.include?( "1" + storeSizeTop)) &&
        !(resultTopWaist[b].store_size.include?( "2" + storeSizeTop)))

        topWaistMin = topWaistMin + resultTopWaist[b].size_min.to_f
        topWaistMax = topWaistMax + resultTopWaist[b].size_max.to_f

        countTopMinWaist+=1
        countTopMaxWaist+=1

        break
      elsif(resultTopWaist[b].store_size == storeSizeTop)

        topWaistMin = topWaistMin + resultTopWaist[b].size_min.to_f
        topWaistMax = topWaistMax + resultTopWaist[b].size_max.to_f

        countTopMinWaist+=1
        countTopMaxWaist+=1
        break
      elsif(numRowsTopWaist == countTopWaistLoops)
        puts storeSizeTop + " not found in " + storeName + "<br>"
        break
      else
        b += 1
      end
    end

    numRowsTopHip = resultTopHip.count
    c = 0
    while c < resultTopHip.count

      countTopHipLoops+=1
      if((resultTopHip[c].store_size.include?(storeSizeTop)) &&
        !(resultTopHip[c].store_size.include?("X" + storeSizeTop)) &&
        !(resultTopHip[c].store_size.include?("0" + storeSizeTop)) &&
        !(resultTopHip[c].store_size.include?( "1" + storeSizeTop)) &&
        !(resultTopHip[c].store_size.include?( "2" + storeSizeTop)))

        topHipMin = topHipMin + resultTopHip[c].size_min.to_f
        topHipMax = topHipMax + resultTopHip[c].size_max.to_f

        countTopMinHip+=1
        countTopMaxHip+=1

        break
      elsif(resultTopHip[c].store_size == storeSizeTop)
        topHipMin = topHipMin + resultTopHip[c].size_min.to_f
        topHipMax = topHipMax + resultTopHip[c].size_max.to_f

        countTopMinHip+=1
        countTopMaxHip+=1
        break
      elsif(numRowsTopHip == countTopHipLoops)
        puts storeSizeTop + " not found in " + storeName + "<br>"
        break
      else
        c += 1
      end
    end

    storeName = user.bottoms_store.upcase
    storeSizeBottom = user.bottoms_size

    resultBottomBust = Store.where(store_name: storeName, feature: "BUST")
    resultBottomWaist = Store.where(store_name: storeName, feature: "WAIST")
    resultBottomHip = Store.where(store_name: storeName, feature: "HIP")

    numRowsBottomBust = resultBottomBust.count
    i = 0
    while i < resultBottomBust.count

      countBottomBustLoops+=1
      if((resultBottomBust[i].store_size.include?(storeSizeBottom)) &&
        !(resultBottomBust[i].store_size.include?("X" + storeSizeBottom)) &&
        !(resultBottomBust[i].store_size.include?("0" + storeSizeBottom)) &&
        !(resultBottomBust[i].store_size.include?( "1" + storeSizeBottom)) &&
        !(resultBottomBust[i].store_size.include?( "2" + storeSizeBottom)))

        bottomBustMin = bottomBustMin + resultBottomBust[i].size_min.to_f
        bottomBustMax = bottomBustMax + resultBottomBust[i].size_max.to_f

        countBottomMinBust+=1
        countBottomMaxBust+=1

        break
      elsif(resultBottomBust[i].store_size == storeSizeBottom)

        bottomBustMin = bottomBustMin + resultBottomBust[i].size_max.to_f
        bottomBustMax = bottomBustMax + resultBottomBust[i].size_min.to_f

        countBottomMinBust+=1
        countBottomMaxBust+=1
        break
      elsif(numRowsBottomBust == countBottomBustLoops)
        puts storeSizeBottom + " not found in " + storeName + "<br>"
        break
      else
        i += 1
      end
    end

    numRowsBottomWaist = resultBottomWaist.count
    j = 0
    while j < resultBottomWaist.count

      countBottomWaistLoops+=1

      if((resultBottomWaist[j].store_size.include?(storeSizeBottom)) &&
        !(resultBottomWaist[j].store_size.include?("X" + storeSizeBottom)) &&
        !(resultBottomWaist[j].store_size.include?("0" + storeSizeBottom)) &&
        !(resultBottomWaist[j].store_size.include?( "1" + storeSizeBottom)) &&
        !(resultBottomWaist[j].store_size.include?( "2" + storeSizeBottom)))

        bottomWaistMin = bottomWaistMin + resultBottomWaist[j].size_min.to_f
        bottomWaistMax = bottomWaistMax + resultBottomWaist[j].size_max.to_f

        countBottomMinWaist+=1
        countBottomMaxWaist+=1

        break
      elsif(resultBottomWaist[j].store_size == storeSizeBottom)
        bottomWaistMin = bottomWaistMin + resultBottomWaist[j].size_min.to_f
        bottomWaistMax = bottomWaistMax + resultBottomWaist[j].size_max.to_f

        countBottomMinWaist+=1
        countBottomMaxWaist+=1
        break
      elsif(numRowsBottomWaist == countBottomWaistLoops)
        puts storeSizeBottom + " not found in " + storeName + "<br>"
        break
      else
        j += 1
      end
    end

    numRowsBottomHip = resultBottomHip.count
    k = 0
    while k < resultBottomHip.count

      countBottomHipLoops+=1
      if((resultBottomHip[k].store_size.include?(storeSizeBottom)) &&
        !(resultBottomHip[k].store_size.include?("X" + storeSizeBottom)) &&
        !(resultBottomHip[k].store_size.include?("0" + storeSizeBottom)) &&
        !(resultBottomHip[k].store_size.include?( "1" + storeSizeBottom)) &&
        !(resultBottomHip[k].store_size.include?( "2" + storeSizeBottom)))

        bottomHipMin = bottomHipMin + resultBottomHip[k].size_min.to_f
        bottomHipMax = bottomHipMax + resultBottomHip[k].size_max.to_f

        countBottomMinHip+=1
        countBottomMaxHip+=1

        break
      elsif(resultBottomHip[k].store_size == storeSizeBottom)
        bottomHipMin = bottomHipMin + resultBottomHip[k].size_min.to_f
        bottomHipMax = bottomHipMax + resultBottomHip[k].size_max.to_f

        countBottomMinHip+=1
        countBottomMaxHip+=1
        break
      elsif(numRowsBottomHip == countBottomHipLoops)
        puts storeSizeBottom + " not found in " + storeName + "<br>"
        break
      else
        k += 1
      end
    end

    averageTopBustMin = ((topBustMin.to_f) / countTopMinBust)
    averageTopBustMax = (topBustMax.to_f / countTopMaxBust)
    averageTopWaistMin = (topWaistMin.to_f / countTopMinWaist)
    averageTopWaistMax = (topWaistMax.to_f / countTopMaxWaist)
    averageTopHipMin = (topHipMin.to_f / countTopMinHip)
    averageTopHipMax = (topHipMax.to_f / countTopMaxHip)

    averageBottomBustMin = (bottomBustMin.to_f / countBottomMinBust)
    averageBottomBustMax = (bottomBustMax.to_f / countBottomMaxBust)
    averageBottomWaistMin = (bottomWaistMin.to_f / countBottomMinWaist)
    averageBottomWaistMax = (bottomWaistMax.to_f / countBottomMaxWaist)
    averageBottomHipMin = (bottomHipMin.to_f / countBottomMinHip)
    averageBottomHipMax = (bottomHipMax.to_f/ countBottomMaxHip)

    averageTopBust = (((averageTopBustMin.to_f * 6) + (averageTopBustMax * 4)) / 10)
    averageTopWaist = (((averageTopWaistMin.to_f * 6) + (averageTopWaistMax * 4)) / 10)
    averageTopHip = (((averageTopHipMin.to_f * 6) + (averageTopHipMax * 4)) / 10)

    averageBottomBust = (((averageBottomBustMin.to_f * 6) + (averageBottomBustMax * 4)) / 10)
    averageBottomWaist = (((averageBottomWaistMin.to_f * 6) + (averageBottomWaistMax * 4)) / 10)
    averageBottomHip = (((averageBottomHipMin.to_f * 6) + (averageBottomHipMax * 4)) / 10)

    averageBust = (((averageTopBust.to_f * 9) + averageBottomBust) / 10)
    averageWaist = (((averageTopWaist.to_f * 2) + (averageBottomWaist * 8)) / 10)
    averageHip = ((averageTopHip.to_f + (averageBottomHip * 9)) / 10)

    results_hash = {}
    results_hash[:bust] = averageBust
    results_hash[:waist] = averageWaist
    results_hash[:hip] = averageHip

    return results_hash
  end

  def self.calcAvrgFromKnownStoreAndBWHMeasure(user, averageBust, averageWaist, averageHip) #when you get both bust, waist, hip measurements and stores with sizes from the user
    getBust = user.bust #here instead of repeating the code above in this function, we can just get the avg_bust, avg_waist and avg_hip as results
    getWaist = user.waist #of the function above.
    getHip = user.hip

    getBraBust = user.bra_size.to_f + (['AA', 'A', 'B', 'C', 'D', 'DD or E', 'DDD or F', 'G', 'H', 'I', 'J'].find_index(user.bra_cup))

    predictedBust = getBust
    predictedWaist = getWaist
    predictedHip = getHip

    trueBust = (((predictedBust.to_f * 3) + (averageBust * 3) + (getBraBust * 4)) / 10)
    trueWaist = (((predictedWaist.to_f * 4) + (averageWaist * 6)) / 10)
    trueHip = (((predictedHip.to_f * 4) + (averageHip * 6)) / 10)

    results_hash = {}
    results_hash[:true_bust] = trueBust
    results_hash[:true_waist] = trueWaist
    results_hash[:true_hip] = trueHip

    return results_hash
  end


  def getUserSizeForStoreTop(user, storeName)
    bustIn = user.bust
    waistIn = user.waist

    resultBust = Store.where(store_name: storeName, feature: "BUST")
    # "SELECT STORE_ID, store_size, size_min.to_f, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'BUST')"
    resultWaist = Store.where(store_name: storeName, feature: "WAIST")
    # "SELECT STORE_ID, store_size, size_min.to_f, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'WAIST')"

    previousMinBust = 0
    previousMaxBust = 0
    previousMinWaist = 0
    previousMaxWaist = 0

    previousStoreSizeBust = ""
    previousStoreSizeWaist = ""

    previousStoreNameBust = ""
    previousStoreNameWaist = ""

    perfectBustArray = {}
    perfectWaistArray = {}

    tightBustArray = {}
    tightWaistArray = {}

    looseBustArray = {}
    looseWaistArray = {}

    sizeOfResultBust = resultBust.count
    if(sizeOfResultBust < 1)
      return "Bad Read Bust"
    end
    countBustLoops = 0

    resultBust.each do |res_bust|

      countBustLoops+=1

      if ((res_bust.size_min.to_f < bustIn) && (res_bust.size_max.to_f > bustIn))

        perfectBustArray[res_bust.id] = res_bust.store_size
      else
        if (res_bust.size_min.to_f == bustIn)

          looseBustArray[res_bust.id = res_bust.store_size]
        elsif (res_bust.size_max.to_f == bustIn)

          tightBustArray[res_bust.id] = res_bust.store_size
        elsif ((bustIn > previousMaxBust) && (bustIn < res_bust.size_min.to_f))
          if (((previousMaxBust + res_bust.size_min.to_f) / 2) == bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
            tightBustArray[res_bust.id] = res_bust.store_size
          elsif (((previousMaxBust + res_bust.size_min.to_f) / 2) > bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
          elsif (((previousMaxBust + res_bust.size_min.to_f) / 2) < bustIn)

            tightBustArray[res_bust.id] = res_bust.store_size
          end
        elsif ((previousStoreNameBust != res_bust.id) && ((bustIn - 1) == previousMaxBust))

          tightBustArray[previousStoreNameBust] = previousStoreSizeBust
        elsif ((countBustLoops == sizeOfResultBust) && ((bustIn - 1) == res_bust.size_max.to_f))

          tightBustArray[res_bust.id] = res_bust.store_size
        end
      end

      previousStoreNameBust = res_bust.id
      previousStoreSizeBust = res_bust.store_size
      previousMinBust = res_bust.size_min.to_f
      previousMaxBust = res_bust.size_max.to_f

    end

    # resultWaist = mysqli_query(dataTransfer, waistStoreSizeSQL)
    sizeOfResultWaist = resultWaist.count
    if(sizeOfResultWaist < 1)
      return "Bad Read Waist"
    end
    countWaistLoops = 0
    resultWaist.each do |res_waist|

      countWaistLoops+=1

      if ((res_waist.size_min.to_f < bustIn) && (res_waist.size_max.to_f > bustIn))

        perfectBustArray[res_waist.id] = res_waist.store_size
      else
        if (res_waist.size_min.to_f == bustIn)

          looseBustArray[res_waist.id] = res_waist.store_size
        elsif (res_waist.size_max.to_f == bustIn)

          tightBustArray[res_waist.id] = res_waist.store_size
        elsif ((bustIn > previousMaxBust) && (bustIn < res_waist.size_min.to_f))
          if (((previousMaxBust + res_waist.size_min.to_f) / 2) == bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
            tightBustArray[res_waist.id] = res_waist.store_size
          elsif (((previousMaxBust + res_waist.size_min.to_f) / 2) > bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
          elsif (((previousMaxBust + res_waist.size_min.to_f) / 2) < bustIn)

            tightBustArray[res_waist.id] = res_waist.store_size
          end
        elsif ((previousStoreNameBust != res_waist.id) && ((bustIn - 1) == previousMaxBust))

          tightBustArray[previousStoreNameBust] = previousStoreSizeBust
        elsif ((countBustLoops == sizeOfResultBust) && ((bustIn - 1) == res_waist.size_max.to_f))

          tightBustArray[res_waist.id] = res_waist.store_size
        end
      end

      previousStoreNameWaist = res_waist.id
      previousStoreSizeWaist = res_waist.store_size
      previousMinWaist = res_waist.size_min.to_f
      previousMaxWaist = res_waist.size_max.to_f
    end

    #Perfect vs All
    #Perfect vs Perfect
    perfectWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

        perfectBustSize = perfectBustArray[storeNameKey]
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
    perfectWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

        tightBustSize = tightBustArray[storeNameKey]
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

    perfectBustArray.each do |storeNameKey,storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

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
    perfectWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

        looseBustSize = looseBustArray[storeNameKey]
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

    perfectBustArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
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
    tightWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
        tightBustSize = tightBustArray[tightStoreNameKey]
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
    tightBustArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
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

    tightWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

        looseBustSize = looseBustArray[tightStoreNameKey]
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

      if (perfectBustArray.key?(storeNameKey))

        looseBustSize = looseBustArray[looseStoreNameKey]
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

  def getUserSizeForStoreBottom(user, storeName)

    # userBWHSQL = "SELECT Waist, Hip FROM users WHERE Email = '" + emailIn + "'"
    #
    # resultMeasure = mysqli_query(dataTransfer, userBWHSQL)
    # rowOFMeasure = mysqli_fetch_row(resultMeasure)
    waistIn = user.waist
    hipIn = user.hip

    resultWaist = Store.where(store_name: storeName, feature: "waist")
    # "SELECT STORE_ID, store_size, size_min.to_f, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'WAIST')"
    resultHip = Store.where(store_name: storeName, feature: "hip")
    # "SELECT STORE_ID, store_size, size_min.to_f, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'HIP')"

    previousMinWaist = 0
    previousMaxWaist = 0
    previousMinHip = 0
    previousMaxHip = 0

    previousStoreSizeWaist = ""
    previousStoreSizeHip = ""

    previousStoreNameWaist = ""
    previousStoreNameHip = ""

    perfectWaistArray = {}
    perfectHipArray = {}

    tightWaistArray = {}
    tightHipArray = {}

    looseWaistArray = {}
    looseHipArray = {}

    # resultWaist = mysqli_query(dataTransfer, waistStoreSizeSQL)
    sizeOfResultWaist = resultWaist.count
    if(sizeOfResultWaist < 1)
      return "Bad Read Waist"
    end
    countWaistLoops = 0

    resultWaist.each do |res_waist|

      countWaistLoops+= 1

      if ((res_waist.size_min.to_f < waistIn) && (res_waist.size_max.to_f > waistIn))

        perfectWaistArray[res_waist.id] = res_waist.store_size

      else
        if (res_waist.size_min.to_f == waistIn)

          looseWaistArray[res_waist.id] = res_waist.store_size
        elsif (res_waist.size_max.to_f == waistIn)

          tightWaistArray[res_waist.id] = res_waist.store_size
        elsif ((waistIn > previousMaxWaist) && (waistIn < res_waist.size_min.to_f))

          if (((previousMaxWaist + res_waist.size_min.to_f) / 2) == waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
            tightWaistArray[res_waist.id] = res_waist.store_size
          elsif (((previousMaxWaist + res_waist.size_min.to_f) / 2) > waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
          elsif (((previousMaxWaist + res_waist.size_min.to_f) / 2) < waistIn)

            tightWaistArray[res_waist.id] = res_waist.store_size
          end
        elsif ((previousStoreNameWaist != res_waist.id) && ((waistIn - 1) == previousMaxWaist))

          tightWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
        elsif ((countWaistLoops == sizeOfResultWaist) && ((waistIn - 1) == res_waist.size_max.to_f))

          tightWaistArray[res_waist.id] = res_waist.store_size
        end
      end

      previousStoreNameWaist = res_waist.id
      previousStoreSizeWaist = res_waist.store_size
      previousMinWaist = res_waist.size_min.to_f
      previousMaxWaist = res_waist.size_max.to_f

    end

    # resultHip = mysqli_query(dataTransfer, hipStoreSizeSQL)
    sizeOfResultHip = resultHip.count
    if(sizeOfResultHip < 1)
      return "Bad Read Hip"
    end
    countHipLoops = 0

    resultHip.each do |res_hip|

      countWaistLoops+= 1

      if ((res_hip.size_min.to_f < waistIn) && (res_hip.size_max.to_f > waistIn))

        perfectWaistArray[res_hip.id] = res_hip.store_size

      else
        if (res_hip.size_min.to_f == waistIn)

          looseWaistArray[res_hip.id] = res_hip.store_size
        elsif (res_hip.size_max.to_f == waistIn)

          tightWaistArray[res_hip.id] = res_hip.store_size
        elsif ((waistIn > previousMaxWaist) && (waistIn < res_hip.size_min.to_f))

          if (((previousMaxWaist + res_hip.size_min.to_f) / 2) == waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
            tightWaistArray[res_hip.id] = res_hip.store_size
          elsif (((previousMaxWaist + res_hip.size_min.to_f) / 2) > waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
          elsif (((previousMaxWaist + res_hip.size_min.to_f) / 2) < waistIn)

            tightWaistArray[res_hip.id] = res_hip.store_size
          end
        elsif ((previousStoreNameWaist != res_hip.id) && ((waistIn - 1) == previousMaxWaist))

          tightWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
        elsif ((countWaistLoops == sizeOfResultWaist) && ((waistIn - 1) == res_hip.size_max.to_f))

          tightWaistArray[res_hip.id] = res_hip.store_size
        end
      end

      previousStoreNameWaist = res_hip.id
      previousStoreSizeWaist = res_hip.store_size
      previousMinWaist = res_hip.size_min.to_f
      previousMaxWaist = res_hip.size_max.to_f

    end
    #Perfect vs All
    #Perfect vs Perfect
    perfectWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

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
    perfectWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

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

    perfectHipArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
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
    perfectWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

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

    perfectHipArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
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
    tightWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
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
    tightHipArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))
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

    tightWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

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
    looseWaistArray.each do |storeNameKey, storeSizeValue|

      if (perfectBustArray.key?(storeNameKey))

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
