require File.expand_path '/voluptuousCSVToHumanReadable.rb', __FILE__
require File.expand_path '/UserSizeForStore.rb', __FILE__

module readAllCSVSize
  include voluptuousCSVToHumanReadable
  include UserSizeForStore


  emailIn = _GET['email']

  serverName = "localhost"#find
  username = ""
  password = ""#find
  db = "odessu"
  dataTransfer = new mysqli(serverName,username,password,db)

  shapeSQL = "SELECT Body_Shape FROM users WHERE Email = '" + emailIn + "'"

  resultShape = mysqli_query(dataTransfer, shapeSQL)
  rowOFShape = mysqli_fetch_row(resultShape)
  bodyIn = rowOFShape[0]


  #Voluptuous. This can just go in the view, calling the class methods and then acting based on conditional statements.
  topSize = getUserSizeForStoreTop(emailIn, "VOLUPTUOUS")
  bottomSize = getUserSizeForStoreBottom(emailIn, "VOLUPTUOUS")

  if((topSize != "No Size In Store") || (bottomSize != "No Size In Store"))
    puts "<span style=\"font-size:20px text-align: center padding-left:150px\">Top: " + topSize + "</span><span style=\"font-size:40px text-align: center padding: 0 20px 0 20px\" id=\"voluptuous\">Voluptuous</span><span style=\"font-size:20px text-align: center\">Bottom: " + bottomSize + "</span>"
    readVoluptuousCSVSize(topSize, bottomSize)
  end
end
