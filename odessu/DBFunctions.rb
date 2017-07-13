require File.expand_path '/ExistsInListFunction.rb', __FILE__
module DBFunctions
  include 'ExistsInListFunction'




  

  def saveUserBWH(calcBust, calcWaist, calcHip, userMail, prefTopIn, prefBottomIn)

    serverName = "localhost"
    username = ""
    password = ""
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    saveSQL = "UPDATE users SET Bust = '" + calcBust + "', Waist = '" + calcWaist + "', Hip = '" + calcHip + "', Fit_Top = '" + prefTopIn + "', Fit_Bottom = '" + prefBottomIn + "' WHERE Email = '" + userMail + "'"

    mysqli_query(dataTransfer, saveSQL)

    if(dataTransfer = query(saveSQL))
      #puts "Succesful Save"
    else
      puts "Fail Saving"
    end
    dataTransfer = close()

  end

  def saveUserAccount(storesShoped, calcBust, calcWaist, calcHip, userMail, prefTopIn, prefBottomIn, bodyShape, userBodyShape, issuesTop, issuesBottom)

    serverName = ""
    username = ""
    password = ""
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    saveSQL = "UPDATE users SET Bust = '" + calcBust + "', Waist = '" + calcWaist + "', Hip = '" + calcHip + "', Fit_Top = '" + prefTopIn + "', Fit_Bottom = '" + prefBottomIn + "', Body_Shape = '" + bodyShape + "', Stores_Shopped = '" + storesShoped + "', UserThinksShape = '" + userBodyShape + "', IssuesTop = '" + issuesTop + "', IssuesBottoms = '" + issuesBottom + "' WHERE Email = '" + userMail + "'"

    mysqli_query(dataTransfer, saveSQL)

    if(dataTransfer = query(saveSQL))
      #puts "Succesful Save"
    else
      puts "Fail Saving"
    end

    dataTransfer = close()
  end

  def signInUser(email)

    serverName = "localhost"
    username = ""
    password = ""
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    signInTrue = "UPDATE users SET isSignedIn = TRUE WHERE Email = '" + email + "'"

    if(dataTransfer = query(signInTrue))
      puts "SignIn Successful"
    else
      puts "Failed SignIn"
    end
    dataTransfer = close()
  end

  def signOutUser(email)

    serverName = "localhost"
    username = ""
    password = ""
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    signInFalse = "UPDATE users SET isSignedIn = FALSE WHERE Email = '" + email + "'"

    if(dataTransfer = query(signInFalse))
      puts "SignOut Successful"

    else
      puts "Failed SignIn"
    end


    dataTransfer = close()
  end

  def checkIsSignedIn(email)

    serverName = "localhost"
    username = ""
    password = ""
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    checkIsIn = "SELECT isSignedIn FROM user WHERE Email = '" + email + "'"

    resultOFIn = mysqli_query(dataTransfer, checkIsIn)

    if(resultOFIn != nil)
      while(rowOfResult = mysqli_fetch_row(resultOFIn)) do
        if(rowOfResult[0] == TRUE)
          puts "True"

        else
          puts "False"
        end
      end
    end

    dataTransfer = close()

  end

  def loadDataForClient(email)

    serverName = "localhost"
    username = ""
    password = ""
    db = "odessu"
    dataTransfer = new mysqli(serverName,username,password,db)

    loadSQL = "SELECT Bust, Waist, Hip, Fit_Top, Fit_Bottom, Body_Shape, Stores_Shopped FROM users WHERE Email = '" + email + "'"

    userDataPulled = mysqli_query(dataTransfer, loadSQL)
    rowOfData = mysqli_fetch_row(userDataPulled)

    if((rowOfData[0] == nil) || (rowOfData[1] == nil) || (rowOfData[2] == nil) || (rowOfData[3] == nil) || (rowOfData[4] == nil) || (rowOfData[5] == nil) || (rowOfData[6] == nil))
      return "Missing Data"
    else
      #     Bust                  Waist                 Hip                   Fit_Top               Fit_Bottom            Body_Shape            Stores_Shopped
      return rowOfData[0] + "&" + rowOfData[1] + "&" + rowOfData[2] +"&" + rowOfData[3] + "&" + rowOfData[4] + "&" + rowOfData[5] + "&" + rowOfData[6]
    end
  end
end
