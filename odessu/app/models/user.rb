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

    #       puts "Weight in KG: " + weightKG + "<br>"
    #       puts "Height in M: " + heightM + "<br>"
    #       puts "BMI: " + bmi + "<br>"
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

     #        puts "Bust vs Waist Ratio: " + bustWaistRatio + "<br>"
     #        puts "Hip vs Waist Ratio: " + hipWaistRatio + "<br>"
     #
     #        puts "BMI Output: " + bodyCategory + "<br>"
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

  def self.calcAvrgFromStore(user)
    if user.height_cm
      getHeight = (user.height_cm.to_f) * 0.393701
    elsif user.height_ft
      getHeight = (user.height_ft.to_f * 12) + user.height_in.to_f
    end
    if user.weight_type == "Lbs"
      getWeight = user.weight.to_f
    else
      getWeight = ((user.weight.to_f) * 2.20462)
    end
    getBraBust = user.bust #(bra size)
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

      resultTopBust = Store.where(store_name: storeName, feature: 'BUST')
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND feature = 'bust')"
      resultTopWaist = Store.where(store_name: storeName, feature: 'WAIST')
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND feature = 'waist')"
      resultTopHip = Store.where(store_name: storeName, feature: 'HIP')
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND feature = 'hip')"

      #Get Data For Top Bust
      # resultTopBust = mysqli_query(dataTransfer, queryTopBust)
      numRowsTopBust = resultTopBust.count
      i = 0
      while i < resultTopBust.count

        #puts "Top StoreSize: " + resultTopBust[i].store_size + ", Size Min: " + resultTopBust[i].size_min + ", Size Max: " + resultTopBust[i].size_max + "<br>"

        countTopBustLoops+= 1

        if((resultTopBust[i].store_size.include?(storeSizeTop)) && (resultTopBust[i].store_size.include?("X" + storeSizeTop) == false) && (resultTopBust[i].store_size.include?("0" + storeSizeTop) == false) && (resultTopBust[i].store_size.include?( "1" + storeSizeTop) == false) && (resultTopBust[i].store_size.include?( "2" + storeSizeTop) == false))

          #puts "Match Long StoreSize: " + resultTopBust[i].store_size + ", Size Min: " + resultTopBust[i].size_min + ", Size Max: " + resultTopBust[i].size_max + "<br>"

          topBustMin = topBustMin + resultTopBust[i].size_min
          topBustMax = topBustMax + resultTopBust[i].size_max

          countTopMinBust += 1
          countTopMaxBust +=1
          break

        elsif(resultTopBust[i].store_size == storeSizeTop)

          #puts "Match Short StoreSize: " + resultTopBust[i].store_size + ", Size Min: " + resultTopBust[i].size_min + ", Size Max: " + resultTopBust[i].size_max + "<br>"

          topBustMin = topBustMin + resultTopBust[i].size_min
          topBustMax = topBustMax + resultTopBust[i].size_max

          countTopMinBust+= 1
          countTopMaxBust+= 1

        elsif(numRowsTopBust == countTopBustLoops)
          puts storeSizeTop + " not found in " + storeName + "<br>"
        end
      end


      #Get Data For Top Waist
      # resultTopWaist = mysqli_query(dataTransfer, queryTopWaist)
      numRowsTopWaist = resultTopWaist.count
      j = 0
      while j < resultTopWaist.count

        countTopWaistLoops+=1

        if((resultTopWaist[j].store_size.include?(storeSizeTop)) && (resultTopWaist[j].store_size.include?("X" + storeSizeTop) == false) && (resultTopWaist[j].store_size.include?("0" + storeSizeTop) == false) && (resultTopWaist[j].store_size.include?( "1" + storeSizeTop) == false) && (resultTopWaist[j].store_size.include?( "2" + storeSizeTop) == false))
          topWaistMin = topWaistMin + resultTopWaist[j].store_size
          topWaistMax = topWaistMax + resultTopWaist[j].store_size

          countTopMinWaist+=1
          countTopMaxWaist+=1

          break
        elsif(resultTopWaist[j].store_size == storeSizeTop)

          topWaistMin = topWaistMin + resultTopWaist[j].size_min
          topWaistMax = topWaistMax + resultTopWaist[j].size_max

          countTopMinWaist+=1
          countTopMaxWaist+=1

        elsif(numRowsTopWaist == countTopWaistLoops)
          puts storeSizeTop + " not found in " + storeName + "<br>"
        end
      end

      # resultTopHip = mysqli_query(dataTransfer, queryTopHip)
      numRowsTopHip = resultTopHip.count
      k = 0
      while k < resultTopHip.count

        countTopHipLoops+=1
        if((resultTopHip[k].store_size.include?(storeSizeTop)) && (resultTopHip[k].store_size.include?("X" + storeSizeTop) == false) && (resultTopHip[k].store_size.include?("0" + storeSizeTop) == false) && (resultTopHip[k].store_size.include?( "1" + storeSizeTop) == false) && (resultTopHip[k].store_size.include?( "2" + storeSizeTop) == false))

          topHipMin = topHipMin + resultTopHip[k].size_min
          topHipMax = topHipMax + resultTopHip[k].size_max

          countTopMinHip+=1
          countTopMaxHip+=1

          break
        elsif(resultTopHip[k].store_size == storeSizeTop)
          topHipMin = topHipMin + resultTopHip[k].size_min
          topHipMax = topHipMax + resultTopHip[k].size_max

          countTopMinHip+=1
          countTopMaxHip+=1

        elsif(numRowsTopHip == countTopHipLoops)
          puts storeSizeTop + " not found in " + storeName + "<br>"
        end
      end
    # end

    # arrayOfBottoms.each do |bottomValue|
    #
    #   bottomValueSplit = bottomValue.strip.split('')
    #
    #   storeSizeBottom = bottomValueSplit[bottomValueSplit.count - 2]
    #   storeSizeBottom = storeSizeBottom.upcase
    #   storeName = ""
    #
    #   bottomValueSplit.each_with_index do|element, index|
    #     if index < bottomValueSplit.count - 2
    #       storeName = storeName + element
    #       if(index < (bottomValueSplit.count - 3))
    #         storeName = storeName + " "
    #       end
    #     end
    #   end
      storeName = user.bottoms_store.upcase
      storeSizeBottom = user.bottoms_size

      resultBottomBust = Store.where(store_name: storeName, feature: "BUST")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND feature = 'bust')"
      resultBottomWaist = Store.where(store_name: storeName, feature: "WAIST")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND feature = 'waist')"
      resultBottomHip = Store.where(store_name: storeName, feature: "HIP")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND feature = 'hip')"

      # resultBottomBust = mysqli_query(dataTransfer, queryBottomBust)
      numRowsBottomBust = resultBottomBust.count
      a = 0
      while a < resultBottomBust.count

        #puts "Bottom StoreSize: " + rowBottomBust[0] + ", Size Min: " + rowBottomBust[1] + ", Size Max: " + rowBottomBust[2] + "<br>"

        countBottomBustLoops+=1
        if((resultBottomBust[a].store_size.include?(storeSizeBottom)) &&
          !(resultBottomBust[a].store_size.include?("X" + storeSizeBottom)) &&
          !(resultBottomBust[a].store_size.include?("0" + storeSizeBottom)) &&
          !(resultBottomBust[a].store_size.include?( "1" + storeSizeBottom)) &&
          !(resultBottomBust[a].store_size.include?( "2" + storeSizeBottom)))

          #puts "Match Long StoreSize: " + res_btm_bust.store_size + ", Size Min: " + res_btm_bust.size_min + ", Size Max: " + res_btm_bust.size_max + "<br>"

          bottomBustMin = bottomBustMin + resultBottomBust[a].size_min
          bottomBustMax = bottomBustMax + resultBottomBust[a].size_max

          countBottomMinBust+=1
          countBottomMaxBust+=1

          break
        elsif(resultBottomBust[a].store_size == storeSizeBottom)

          #puts "Match Short StoreSize: " + res_btm_bust.store_size + ", Size Min: " + res_btm_bust.size_min + ", Size Max: " + res_btm_bust.size_max + "<br>"

          bottomBustMin = bottomBustMin + resultBottomBust[a].size_min
          bottomBustMax = bottomBustMax + resultBottomBust[a].size_max

          countBottomMinBust+=1
          countBottomMaxBust+=1
        elsif(numRowsBottomBust == countBottomBustLoops)
          puts storeSizeBottom + " not found in " + storeName + "<br>"
        end
      end

      # resultBottomWaist = mysqli_query(dataTransfer, queryBottomWaist)
      numRowsBottomWaist = resultBottomWaist.count
      b = 0
      while b < resultBottomWaist.count

        countBottomWaistLoops+=1

        if((resultBottomWaist[b].store_size.include?(storeSizeBottom)) &&
            !(resultBottomWaist[b].store_size.include?("X" + storeSizeBottom)) &&
            !(resultBottomWaist[b].store_size.include?("0" + storeSizeBottom)) &&
            !(resultBottomWaist[b].store_size.include?( "1" + storeSizeBottom)) &&
            !(resultBottomWaist[b].store_size.include?( "2" + storeSizeBottom)))

          bottomWaistMin = bottomWaistMin + resultBottomWaist[b].size_min
          bottomWaistMax = bottomWaistMax + resultBottomWaist[b].size_max

          countBottomMinWaist+=1
          countBottomMaxWaist+=1

          break
        elsif(resultBottomWaist[b].store_size == storeSizeBottom)
          bottomWaistMin = bottomWaistMin + resultBottomWaist[b].size_mix
          bottomWaistMax = bottomWaistMax + resultBottomWaist[b].size_max

          countBottomMinWaist+=1
          countBottomMaxWaist+=1
        elsif(numRowsBottomWaist == countBottomWaistLoops)
          puts storeSizeBottom + " not found in " + storeName + "<br>"
        end
      end

      # resultBottomHip = mysqli_query(dataTransfer, queryBottomHip)
      numRowsBottomHip = resultBottomHip.count
      c = 0
      while c < resultBottomHip.count

        countBottomHipLoops+=1
        if((resultBottomHip[c].store_size.include?(storeSizeBottom)) &&
            !(resultBottomHip[c].store_size.include?("X" + storeSizeBottom)) &&
            !(resultBottomHip[c].store_size.include?("0" + storeSizeBottom)) &&
            !(resultBottomHip[c].store_size.include?( "1" + storeSizeBottom)) &&
            !(resultBottomHip[c].store_size.include?( "2" + storeSizeBottom)))

          bottomHipMin = bottomHipMin + resultBottomHip[c].size_min
          bottomHipMax = bottomHipMax + resultBottomHip[c].size_max

          countBottomMinHip+=1
          countBottomMaxHip+=1

          break
        elsif(resultBottomHip[c].store_size == storeSizeBottom)
          bottomHipMin = bottomHipMin + resultBottomHip[c].size_min
          bottomHipMax = bottomHipMax + resultBottomHip[c].size_max

          countBottomMinHip+=1
          countBottomMaxHip+=1
        elsif(numRowsBottomHip == countBottomHipLoops)
          puts storeSizeBottom + " not found in " + storeName + "<br>"
        end
      end
    # end

    averageTopBustMin = (topBustMin / countTopMinBust)
    #       puts "Top Bust Min Sum: " + topBustMin
    #       puts "<br>"
    #       puts "Top Bust Min Count: " + countTopMinBust
    #       puts "<br>"
    #       puts "Average Top Bust Min: " + averageTopBustMin
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
    averageBottomHipMax = (bottomHipMax.to_f / countBottomMaxHip)

    averageTopBust = (((averageTopBustMin.to_f * 6) + (averageTopBustMax * 4)) / 10)
    averageTopWaist = (((averageTopWaistMin.to_f * 6) + (averageTopWaistMax * 4)) / 10)
    averageTopHip = (((averageTopHipMin.to_f * 6) + (averageTopHipMax * 4)) / 10)

    averageBottomBust = (((averageBottomBustMin.to_f * 6) + (averageBottomBustMax * 4)) / 10)
    averageBottomWaist = (((averageBottomWaistMin.to_f * 6) + (averageBottomWaistMax * 4)) / 10)
    averageBottomHip = (((averageBottomHipMin.to_f * 6) + (averageBottomHipMax * 4)) / 10)

    averageBust = (((averageTopBust.to_f * 9) + averageBottomBust) / 10)
    averageWaist = (((averageTopWaist.to_f * 2) + (averageBottomWaist * 8)) / 10)
    averageHip = ((averageTopHip.to_f + (averageBottomHip * 9)) / 10)

    predictedBust = (39.8828 + (getHeight.to_f * (-0.303664)) + (getWeight * 0.120713))
    predictedWaist = (37.9338 + (getHeight.to_f * (-0.427647)) + (getWeight * 0.139814))
    predictedHip = (33.4630 + (getHeight.to_f * (-0.163644)) + (getWeight * 0.118256))

    #        puts "Store Predict Bust: " + averageBust
    #        puts "<br>"
    #        puts "Store Predict Waist: " + averageWaist
    #        puts "<br>"
    #        puts "Store Predict Hip: " + averageHip
    #
    #        puts "<br>"
    #        puts "<br>"
    #
    #        puts "Predict Bust: " + predictedBust
    #        puts "<br>"
    #        puts "Predict Waist: " + predictedWaist
    #        puts "<br>"
    #        puts "Predict Hip: " + predictedHip
    #        puts "<br>"
    #        puts "<br>"

    trueBust = (((predictedBust.to_f * 3) + (averageBust * 3) + (getBraBust * 4)) / 10)
    trueWaist = (((predictedWaist.to_f * 4) + (averageWaist * 6)) / 10)
    trueHip = (((predictedHip.to_f * 4) + (averageHip * 6)) / 10)

    #        puts "Final Bust: " . trueBust
    #        puts "<br>"
    #        puts "Final Waist: " . trueWaist
    #        puts "<br>"
    #        puts "Final Hip: " . trueHip
    #        puts "<br>"
    #        puts "<br>"
    results_hash = {}
    results_hash[:true_bust] = trueBust
    results_hash[:true_waist] = trueWaist
    results_hash[:true_hip] = trueHip

    return results_hash
  end

  def calcAvrgFromStoreKnownMeasure(user)

    getBust = user.bust
    getWaist = user.waist
    getHip = user.hip

    getBraSize = user.bra_size + (['AA', 'A', 'B', 'C', 'D', 'DD or E', 'DDD or F', 'G', 'H', 'I', 'J'].find_index(user.bra_cup))
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

    #Input Splitting
    # arrayOfTops = topsArray.split('')
    # arrayOfBottoms = bottomsArray.split('')
    #
    # arrayOfTops.each do |topValue|
    #
    #   topValueSplit = topValue.strip.split(' ')
    #
    #   storeSizeTop = topValueSplit[topValueSplit.count - 2]
    #   storeSizeTop = storeSizeTop.upcase
    #   storeName = ""
    #
    #   topValueSplit.each_with_index do|element, index|
    #     if index < topValueSplit.count - 2
    #       storeName = storeName + element
    #       if(index < (topValueSplit.count - 3))
    #         storeName = storeName + " "
    #       end
    #     end
    #   end

    storeName = user.tops_store.upcase
    storeSizeTop = user.tops_size

      resultTopBust = Store.where(store_name: storeName, feature: "BUST")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND type = 'bust')"
      resultTopWaist = Store.where(store_name: storeName, feature: "WAIST")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND type = 'waist')"
      resultTopHip = Store.where(store_name: storeName, feature: "HIP")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND type = 'hip')"

      #Get Data For Top Bust
      # resultTopBust = mysqli_query(dataTransfer, queryTopBust)
      numRowsTopBust = resultTopBust.count
      a = 0
      while a < resultTopBust.count

        #puts "Top StoreSize: " + res_top_bust.store_size + ", Size Min: " + res_top_bust.size_min + ", Size Max: " + res_top_bust.size_max + "<br>"

        countTopBustLoops+= 1

        if((resultTopBust[a].store_size.include?(storeSizeTop)) &&
          !(resultTopBust[a].store_size.include?("X" + storeSizeTop)) &&
          !(resultTopBust[a].store_size.include?("0" + storeSizeTop)) &&
          !(resultTopBust[a].store_size.include?( "1" + storeSizeTop)) &&
          !(resultTopBust[a].store_size.include?( "2" + storeSizeTop)))

          #puts "Match Long StoreSize: " + rowTopBust[0] + ", Size Min: " + rowTopBust[1] + ", Size Max: " + rowTopBust[2] + "<br>"

          topBustMin = topBustMin + resultTopBust[a].size_min
          topBustMax = topBustMax + resultTopBust[a].size_max

          countTopMinBust += 1
          countTopMaxBust +=1
          break

        elsif(resultTopBust[a].store_size == storeSizeTop)

          #puts "Match Short StoreSize: " + res_top_bust.store_name + ", Size Min: " + res_top_bust.size_min + ", Size Max: " + res_top_bust.size_max + "<br>"

          topBustMin = topBustMin + resultTopBust[a].size_min
          topBustMax = topBustMax + resultTopBust[a].size_max

          countTopMinBust+= 1
          countTopMaxBust+= 1
        elsif(numRowsTopBust == countTopBustLoops)
          puts storeSizeTop + " not found in " + storeName + "<br>"
        end
      end


      #Get Data For Top Waist
      # resultTopWaist = mysqli_query(dataTransfer, queryTopWaist)
      numRowsTopWaist = resultTopWaist.count
      b = 0
      while b < resultTopWaist.count

        countTopWaistLoops+=1
        if((resultTopWaist[b].store_size.include?(storeSizeTop)) &&
          !(resultTopWaist[b].store_size.include?("X" + storeSizeTop)) &&
          !(resultTopWaist[b].store_size.include?("0" + storeSizeTop)) &&
          !(resultTopWaist[b].store_size.include?( "1" + storeSizeTop)) &&
          !(resultTopWaist[b].store_size.include?( "2" + storeSizeTop)))

          topWaistMin = topWaistMin + resultTopWaist[b].size_min
          topWaistMax = topWaistMax + resultTopWaist[b].size_max

          countTopMinWaist+=1
          countTopMaxWaist+=1

          break
        elsif(resultTopWaist[b].store_size == storeSizeTop)

          topWaistMin = topWaistMin + resultTopWaist[b].size_min
          topWaistMax = topWaistMax + resultTopWaist[b].size_max

          countTopMinWaist+=1
          countTopMaxWaist+=1
        elsif(numRowsTopWaist == countTopWaistLoops)
          puts storeSizeTop + " not found in " + storeName + "<br>"
        end
      end

      # resultTopHip = mysqli_query(dataTransfer, queryTopHip)
      numRowsTopHip = resultTopHip.count
      c = 0
      while c < resultTopHip.count

        countTopHipLoops+=1
        if((resultTopHip[c].store_size.include?(storeSizeTop)) &&
          !(resultTopHip[c].store_size.include?("X" + storeSizeTop)) &&
          !(resultTopHip[c].store_size.include?("0" + storeSizeTop)) &&
          !(resultTopHip[c].store_size.include?( "1" + storeSizeTop)) &&
          !(resultTopHip[c].store_size.include?( "2" + storeSizeTop)))

          topHipMin = topHipMin + resultTopHip[c].size_min
          topHipMax = topHipMax + resultTopHip[c].size_max

          countTopMinHip+=1
          countTopMaxHip+=1

          break
        elsif(resultTopHip[c].store_size == storeSizeTop)
          topHipMin = topHipMin + resultTopHip[c].size_min
          topHipMax = topHipMax + resultTopHip[c].size_max

          countTopMinHip+=1
          countTopMaxHip+=1
        elsif(numRowsTopHip == countTopHipLoops)
          puts storeSizeTop + " not found in " + storeName + "<br>"
        end
      end

    # arrayOfBottoms.each do |bottomValue|
    #
    #   bottomValueSplit = bottomValue.strip.split('')
    #
    #   storeSizeBottom = bottomValueSplit[bottomValueSplit.count - 2]
    #   storeSizeBottom = storeSizeBottom.upcase
    #   storeName = ""
    #
    #   bottomValueSplit.each_with_index do|element, index|
    #     if index < bottomValueSplit.count - 2
    #       storeName = storeName + element
    #       if(index < (bottomValueSplit.count - 3))
    #         storeName = storeName + " "
    #       end
    #     end
    #   end
    storeName = user.bottoms_store.upcase
    storeSizeBottom = user.bottoms_size

      resultBottomBust = Store.where(store_name: storeName, feature: "BUST")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND type = 'bust')"
      resultBottomWaist = Store.where(store_name: storeName, feature: "WAIST")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND type = 'waist')"
      resultBottomHip = Store.where(store_name: storeName, feature: "HIP")
      # "SELECT store_size, size_min, size_max FROM sizes WHERE (store_id = '" + storeName + "' AND type = 'hip')"

      # resultBottomBust = mysqli_query(dataTransfer, queryBottomBust)
      numRowsBottomBust = resultBottomBust.count
      i = 0
      while i < resultBottomBust.count

        #puts "Bottom StoreSize: " + res_btm_bust.store_size + ", Size Min: " + res_btm_bust.size_min + ", Size Max: " + res_btm_bust.size_max + "<br>"

        countBottomBustLoops+=1
        if((resultBottomBust[i].store_size.include?(storeSizeBottom)) &&
          !(resultBottomBust[i].store_size.include?("X" + storeSizeBottom)) &&
          !(resultBottomBust[i].store_size.include?("0" + storeSizeBottom)) &&
          !(resultBottomBust[i].store_size.include?( "1" + storeSizeBottom)) &&
          !(resultBottomBust[i].store_size.include?( "2" + storeSizeBottom)))

          #puts "Match Long StoreSize: " + res_btm_bust.store_size + ", Size Min: " + res_btm_bust.size_min + ", Size Max: " + res_btm_bust.size_max + "<br>"

          bottomBustMin = bottomBustMin + resultBottomBust[i].size_min
          bottomBustMax = bottomBustMax + resultBottomBust[i].size_max

          countBottomMinBust+=1
          countBottomMaxBust+=1

          break
        elsif(resultBottomBust[i].store_size == storeSizeBottom)

          #puts "Match Short StoreSize: " + res_btm_bust.store_name + ", Size Min: " + res_btm_bust.size_min + ", Size Max: " + res_btm_bust.size_max + "<br>"

          bottomBustMin = bottomBustMin + resultBottomBust[i].size_max
          bottomBustMax = bottomBustMax + resultBottomBust[i].size_min

          countBottomMinBust+=1
          countBottomMaxBust+=1
        elsif(numRowsBottomBust == countBottomBustLoops)
          puts storeSizeBottom + " not found in " + storeName + "<br>"
        end
      end

      # resultBottomWaist = mysqli_query(dataTransfer, queryBottomWaist)
      numRowsBottomWaist = resultBottomWaist.count
      j = 0
      while j < resultBottomWaist.count

        countBottomWaistLoops+=1

        if((resultBottomWaist[j].store_size.include?(storeSizeBottom)) &&
            !(resultBottomWaist[j].store_size.include?("X" + storeSizeBottom)) &&
            !(resultBottomWaist[j].store_size.include?("0" + storeSizeBottom)) &&
            !(resultBottomWaist[j].store_size.include?( "1" + storeSizeBottom)) &&
            !(resultBottomWaist[j].store_size.include?( "2" + storeSizeBottom)))

          bottomWaistMin = bottomWaistMin + resultBottomWaist[j].size_min
          bottomWaistMax = bottomWaistMax + resultBottomWaist[j].size_max

          countBottomMinWaist+=1
          countBottomMaxWaist+=1

          break
        elsif(resultBottomWaist[j].store_size == storeSizeBottom)
          bottomWaistMin = bottomWaistMin + resultBottomWaist[j].size_min
          bottomWaistMax = bottomWaistMax + resultBottomWaist[j].size_max

          countBottomMinWaist+=1
          countBottomMaxWaist+=1
        elsif(numRowsBottomWaist == countBottomWaistLoops)
          puts storeSizeBottom + " not found in " + storeName + "<br>"
        end
      end

      # resultBottomHip = mysqli_query(dataTransfer, queryBottomHip)
      numRowsBottomHip = resultBottomHip.count
      k = 0
      while k < resultBottomHip.count

        countBottomHipLoops+=1
        if((resultBottomHip[k].store_size.include?(storeSizeBottom)) &&
            !(resultBottomHip[k].store_size.include?("X" + storeSizeBottom)) &&
            !(resultBottomHip[k].store_size.include?("0" + storeSizeBottom)) &&
            !(resultBottomHip[k].store_size.include?( "1" + storeSizeBottom)) &&
            !(resultBottomHip[k].store_size.include?( "2" + storeSizeBottom)))

          bottomHipMin = bottomHipMin + resultBottomHip[k].size_min
          bottomHipMax = bottomHipMax + resultBottomHip[k].size_max

          countBottomMinHip+=1
          countBottomMaxHip+=1

          break
        elsif(resultBottomHip[k].store_size == storeSizeBottom)
          bottomHipMin = bottomHipMin + resultBottomHip[k].size_min
          bottomHipMax = bottomHipMax + resultBottomHip[k].size_max

          countBottomMinHip+=1
          countBottomMaxHip+=1
        elsif(numRowsBottomHip == countBottomHipLoops)
          puts storeSizeBottom + " not found in " + storeName + "<br>"
        end
      end

    averageTopBustMin = ((topBustMin.to_f) / countTopMinBust)
    #       puts "Top Bust Min Sum: " + topBustMin
    #       puts "<br>"
    #       puts "Top Bust Min Count: " + countTopMinBust
    #       puts "<br>"
    #       puts "Average Top Bust Min: " + averageTopBustMin
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

    predictedBust = getBust
    predictedWaist = getWaist
    predictedHip = getHip

    #        puts "Store Predict Bust: " + averageBust
    #        puts "<br>"
    #        puts "Store Predict Waist: " + averageWaist
    #        puts "<br>"
    #        puts "Store Predict Hip: " + averageHip
    #
    #        puts "<br>"
    #        puts "<br>"
    #
    #        puts "Predict Bust: " + predictedBust
    #        puts "<br>"
    #        puts "Predict Waist: " + predictedWaist
    #        puts "<br>"
    #        puts "Predict Hip: " + predictedHip
    #        puts "<br>"
    #        puts "<br>"

    trueBust = (((predictedBust.to_f * 3) + (averageBust * 3) + (getBraBust * 4)) / 10)
    trueWaist = (((predictedWaist.to_f * 4) + (averageWaist * 6)) / 10)
    trueHip = (((predictedHip.to_f * 4) + (averageHip * 6)) / 10)

    #        puts "Final Bust: " . trueBust
    #        puts "<br>"
    #        puts "Final Waist: " . trueWaist
    #        puts "<br>"
    #        puts "Final Hip: " . trueHip
    #        puts "<br>"
    #        puts "<br>"
    results_hash = {}
    results_hash[:true_bust] = trueBust
    results_hash[:true_waist] = trueWaist
    results_hash[:true_hip] = trueHip

    return results_hash
  end

  def getUserSizeForStoreTop(user, storeName)
    #
    # userBWHSQL = "SELECT Bust, Waist FROM users WHERE Email = '" + emailIn + "'"
    #
    # resultMeasure = mysqli_query(dataTransfer, userBWHSQL)
    # rowOFMeasure = mysqli_fetch_row(resultMeasure)
    bustIn = user.bust
    waistIn = user.waist

    resultBust = Store.where(store_name: storeName, feature: "BUST")
    # "SELECT STORE_ID, store_size, size_Min, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'BUST')"
    resultWaist = Store.where(store_name: storeName, feature: "WAIST")
    # "SELECT STORE_ID, store_size, size_Min, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'WAIST')"

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

      if ((res_bust.size_min < bustIn) && (res_bust.size_max > bustIn))

        perfectBustArray[res_bust.id] = res_bust.store_size
      else
        if (res_bust.size_min == bustIn)

          looseBustArray[res_bust.id = res_bust.store_size]
        elsif (res_bust.size_max == bustIn)

          tightBustArray[res_bust.id] = res_bust.store_size
        elsif ((bustIn > previousMaxBust) && (bustIn < res_bust.size_min))
          if (((previousMaxBust + res_bust.size_min) / 2) == bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
            tightBustArray[res_bust.id] = res_bust.store_size
          elsif (((previousMaxBust + res_bust.size_min) / 2) > bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
          elsif (((previousMaxBust + res_bust.size_min) / 2) < bustIn)

            tightBustArray[res_bust.id] = res_bust.store_size
          end
        elsif ((previousStoreNameBust != res_bust.id) && ((bustIn - 1) == previousMaxBust))

          tightBustArray[previousStoreNameBust] = previousStoreSizeBust
        elsif ((countBustLoops == sizeOfResultBust) && ((bustIn - 1) == res_bust.size_max))

          tightBustArray[res_bust.id] = res_bust.store_size
        end
      end

      previousStoreNameBust = res_bust.id
      previousStoreSizeBust = res_bust.store_size
      previousMinBust = res_bust.size_min
      previousMaxBust = res_bust.size_max

    end

    # resultWaist = mysqli_query(dataTransfer, waistStoreSizeSQL)
    sizeOfResultWaist = resultWaist.count
    if(sizeOfResultWaist < 1)
      return "Bad Read Waist"
    end
    countWaistLoops = 0
    resultWaist.each do |res_waist|

      countWaistLoops+=1

      if ((res_waist.size_min < bustIn) && (res_waist.size_max > bustIn))

        perfectBustArray[res_waist.id] = res_waist.store_size
      else
        if (res_waist.size_min == bustIn)

          looseBustArray[res_waist.id] = res_waist.store_size
        elsif (res_waist.size_max == bustIn)

          tightBustArray[res_waist.id] = res_waist.store_size
        elsif ((bustIn > previousMaxBust) && (bustIn < res_waist.size_min))
          if (((previousMaxBust + res_waist.size_min) / 2) == bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
            tightBustArray[res_waist.id] = res_waist.store_size
          elsif (((previousMaxBust + res_waist.size_min) / 2) > bustIn)

            looseBustArray[previousStoreNameBust] = previousStoreSizeBust
          elsif (((previousMaxBust + res_waist.size_min) / 2) < bustIn)

            tightBustArray[res_waist.id] = res_waist.store_size
          end
        elsif ((previousStoreNameBust != res_waist.id) && ((bustIn - 1) == previousMaxBust))

          tightBustArray[previousStoreNameBust] = previousStoreSizeBust
        elsif ((countBustLoops == sizeOfResultBust) && ((bustIn - 1) == res_waist.size_max))

          tightBustArray[res_waist.id] = res_waist.store_size
        end
      end

      previousStoreNameWaist = res_waist.id
      previousStoreSizeWaist = res_waist.store_size
      previousMinWaist = res_waist.size_min
      previousMaxWaist = res_waist.size_max
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
    # "SELECT STORE_ID, store_size, size_Min, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'WAIST')"
    resultHip = Store.where(store_name: storeName, feature: "hip")
    # "SELECT STORE_ID, store_size, size_Min, size_Max FROM sizes WHERE (store_ID = '" + storeName + "' AND type = 'HIP')"

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

      if ((res_waist.size_min < waistIn) && (res_waist.size_max > waistIn))

        perfectWaistArray[res_waist.id] = res_waist.store_size

      else
        if (res_waist.size_min == waistIn)

          looseWaistArray[res_waist.id] = res_waist.store_size
        elsif (res_waist.size_max == waistIn)

          tightWaistArray[res_waist.id] = res_waist.store_size
        elsif ((waistIn > previousMaxWaist) && (waistIn < res_waist.size_min))

          if (((previousMaxWaist + res_waist.size_min) / 2) == waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
            tightWaistArray[res_waist.id] = res_waist.store_size
          elsif (((previousMaxWaist + res_waist.size_min) / 2) > waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
          elsif (((previousMaxWaist + res_waist.size_min) / 2) < waistIn)

            tightWaistArray[res_waist.id] = res_waist.store_size
          end
        elsif ((previousStoreNameWaist != res_waist.id) && ((waistIn - 1) == previousMaxWaist))

          tightWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
        elsif ((countWaistLoops == sizeOfResultWaist) && ((waistIn - 1) == res_waist.size_max))

          tightWaistArray[res_waist.id] = res_waist.store_size
        end
      end

      previousStoreNameWaist = res_waist.id
      previousStoreSizeWaist = res_waist.store_size
      previousMinWaist = res_waist.size_min
      previousMaxWaist = res_waist.size_max

    end

    # resultHip = mysqli_query(dataTransfer, hipStoreSizeSQL)
    sizeOfResultHip = resultHip.count
    if(sizeOfResultHip < 1)
      return "Bad Read Hip"
    end
    countHipLoops = 0

    resultHip.each do |res_hip|

      countWaistLoops+= 1

      if ((res_hip.size_min < waistIn) && (res_hip.size_max > waistIn))

        perfectWaistArray[res_hip.id] = res_hip.store_size

      else
        if (res_hip.size_min == waistIn)

          looseWaistArray[res_hip.id] = res_hip.store_size
        elsif (res_hip.size_max == waistIn)

          tightWaistArray[res_hip.id] = res_hip.store_size
        elsif ((waistIn > previousMaxWaist) && (waistIn < res_hip.size_min))

          if (((previousMaxWaist + res_hip.size_min) / 2) == waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
            tightWaistArray[res_hip.id] = res_hip.store_size
          elsif (((previousMaxWaist + res_hip.size_min) / 2) > waistIn)

            looseWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
          elsif (((previousMaxWaist + res_hip.size_min) / 2) < waistIn)

            tightWaistArray[res_hip.id] = res_hip.store_size
          end
        elsif ((previousStoreNameWaist != res_hip.id) && ((waistIn - 1) == previousMaxWaist))

          tightWaistArray[previousStoreNameWaist] = previousStoreSizeWaist
        elsif ((countWaistLoops == sizeOfResultWaist) && ((waistIn - 1) == res_hip.size_max))

          tightWaistArray[res_hip.id] = res_hip.store_size
        end
      end

      previousStoreNameWaist = res_hip.id
      previousStoreSizeWaist = res_hip.store_size
      previousMinWaist = res_hip.size_min
      previousMaxWaist = res_hip.size_max

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
