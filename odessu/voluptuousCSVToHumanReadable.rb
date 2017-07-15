module voluptuousCSVToHumanReadable
  def readVoluptuousCSV(bodyShape)
    require 'csv'
    #specify file_location
    csv_text = File.read(file_location)
    csv = CSV.parse(csv_text, :headers => true )
    #
    # topFilter = array()
    # bottomFilter = array()

    #TOP
    TopHourglassFilter = ["off-the-shoulder", "off the shoulder", "peplum", "fit and flare", "fit & flare", "jeweled neckline", "jeweled neck", "tie waist", "drawstring", "cinched", "nipped", "crop", "cowl", "wrap", "wrapped", "fitted", "sweetheart", "boat neck", "boatneck", "bateau", "boat neckline", "sharkbite", "shark-bite", "handkerchief", "camisole", "cami", "tank", "Tube dress", "bandeau dress", "sheath dress", "shift dress", "blouson dress", "tunic dress", "pencil dress", "assymetric dress", "wrap dress", "trench dress", "hi-lo dress", "high-low dress", "empire dress", "empire waist dress", "bodycon dress", "fitted dress", "maxi dress", "midi dress", "kaftan dress", "shirt dress", "sweater dress", "cinched waist dress", "nipped waist dress", "waist paneled dress", "sash waist dress", "tie waist dress", "tie-waist dress", "peplum dress", "fringe dress", "a-line dress", "a line dress", "layered dress", "lace up dress", "denim dress", "dungaree", "pinafore dress", "cape dress", "fit and flare dress", "slit dress", "t-shirt dress", "tulle dress", "tuxedo dress", "tweed dress", "knee length dress"]

    TopOvalFilter = ["peplum", "fit and flare", "empire", "wrap", "cinched peasant", "square neckline", "v-neck", "v neck", "v neckline", "v-neckline deep v", "u-neck", "u neckline", "u-neckline", "deep u", "u neck", "cowl neck", "cowl neckline", "sweetheart neckline", "hi-lo", "vertical details", "ruching", "ruched", "woven", "embroidered", "lace", "Tunic dress", "wrap dress", "trench dress", "hi-lo dress", "high-low dress", "empire dress", "empire waist dress", "maxi dress", "midi dress", "kaftan dress", "shirt dress", "denim dress", "dungaree", "pinafore dress", "cape dress", "shift dress", "slit dress", "t-shirt dress", "square neck dress", "square neckline dress", "u-neck dress", "u neck dress", "v neck dress", "scoopneck dress", "scoop neckline dress", "v-neck dress", "v neckline dress", "v-neckline dress", "cowl neck dress", "cowl neckline dress", "sweetheart neck dress", "sweetheart neckline dress", "colorblock sheath dress", "peplum dress"]

    TopLeanColumnFilter = ["sweetheart", "portrait", "peplum", "fit and flare", "fit & flare", "drawstring", "cinched", "nipped", "ruffle neck", "tie neck", "tie neckline", "turtle neck", "turtle neckline", "cinched peasant", "one-shoulder", "boat neck", "bateau", "boat-neck", "boat neckline", "boat-neckline", "v-neck", "v neck", "v neckline", "v-neckline", "u neck", "u neckline", "u-neckline", "u-neck", "deep u", "deep v", "scoop neck", "scoop neckline", "lace details", "lace detailing", "lace", "halter neck", "halter neckline", "halter", "Asymmetric dress", "wrap dress", "trench dress", "hi-lo dress", "high-low dress", "empire dress", "empire waist dress", "skater dress", "maxi dress", "midi dress", "kaftan dress", "shirt dress", "cinched waist dress", "nipped waist dress", "waist paneled dress", "sash waist dress", "tie waist dress", "tie-waist dress", "peplum dress", "fringe dress", "pop over dress", "a-line dress", "a line dress", "layered dress", "lace up dress", "denim dress", "cape dress", "fit and flare dress", "shift dress", "slit dress", "t-shirt dress", "tuxedo dress", "ruffle neck dress", "ruffle-neck dress", "ruffle neckline dress", "tie neck dress", "tie neckline dress", "scoopneck dress", "scoop neckline dress", "deep u neckline dress", "u-neck dress", "u neck dress", " turtleneck dress", "boat neck dress", "boat neckline dress", "bateau neckline dress", "bateau neck dress", "v neck dress", "v-neck dress", "v neckline dress", "v-neckline dress", "one-shoulder dress", "one shoulder dress", "halter neck dress", "halter dress", "sweetheart neck dress", "sweetheart neckline dress", "lace dress", "portrait neck dress", "portrait neckline dress", "ruching dress", "ruched dress", "cinch dress", "side-cutout dress", "panel dress", "colorblock dress", "drop waist dress", "drop-waist dress", "drop-waisted dress", "princess dress", "curved darts dress"]

    TopTriangleFilter = ["peplum", "fit and flare", "wrap", "surplice", "tie neckline", "tie", "v neck", "v-neck", "deep v", "puffed sleeves", "puff sleeves", "bell sleeves", "flared sleeves", "draped sleeves", "butterfly sleeves", "flare", "u-neck", "deep u", "scoop-neck", "scoop neckline", "scoop neck", "ruching", "ruched", "circle sleeves", "blouse", "flowy top", "jeweled neckline", "jeweled neck", "embelished neck", "embellished neckline", "boat neck", "boat-neck", "boat neckline", "shirred neckline", "shirred neck", "gauged neckline", "cap sleeve", "capped sleeve", "empire", " 3/4 length sleeves", "shoulder pads", "straight yoke", "breast pockets", "big collars", "angel sleeves", "circular flounce sleeves", "ruffle sleeves", "Tube dress", "bandeau dress", "blouson dress", "hi-lo dress", "high-low dress", " strapless dress", "a-line dress", "a line dress", "wrap dress", "off-the-shoulder dress", "off the shoulder dress", "princess dress", "hostess dress", "fit and flare dress", "tunic dress", "pencil dress", "asymmetric dress", "trench dress", "empire dress", "empire waist dress", "maxi dress", "midi dress", "kaftan dress", "shirt dress", "sweater dress", "cinched waist dress", "nipped waist dress", "waist paneled dress", "sash waist dress", "tie waist dress", "tie-waist dress", "peplum dress", "fringe dress", "layered dress", "lace up detail dress", "denim dress", "dungaree", "pinafore dress", "cape dress", "shift dress", "slit dress", "t-shirt dress", "tuxedo dress", "u-neck dress", "u neck dress", "v neck dress", "scoopneck dress", "scoop neckline dress", "v-neck dress", "v neckline dress", "v-neckline dress", "cowl neck dress", "cowl dress", "cowl neckline dress", "sweetheart dress", "puffed sleeve dress", "cap sleeve dress", "strapless dress", "off-the-shoulder fit and flare dress"]

    TopInvertedTriangleFilter = ["cold shoulder", "open shoulder", "cut out shoulder", "shoulder cut out", "shoulder cut-out", "cut-out shoulder", "cutout shoulder", "shoulder cutout", "widestraps", "wide strap", "wide strapped", "collar less", "collar-less", "collarless", "no collar", "peplum", "fit and flare", "fit & flare", "fit", "flare", "cinched", "nipped", "cinch", "raglan", "dropped shoulder", "drop shoulder", "dropped sleeve", "drop sleeve", "dart drop sleeve", "sharkbite", "handkerchief", "u-neck", "v-neck", "deep u neckline", "deep v neckline", "shawl lapel", "shawl collar", "empire", "shoulder slits", "collarless", "collar less", "collar-less", "dolman sleeves", "dolman", "kimono", "v-neck dress", "belted dress", "trench dress", "fit and flare dress", "flare-hemmed dress", "wrap dress", "empire dress", "empire waist dress", "cinched waist dress", "nipped waist dress", "waist paneled dress", "sash waist dress", "tie waist dress", "tie-waist dress", "blouson dress", "princess dress", "shirt dress", "skimmer dress", "a-line dress", "a line dress", "tunic dress", "hi-lo dress", "high-low dress", "skater dress", "maxi dress", "midi dress", "kaftan dress", "denim dress", "dungaree", "pinafore dress", "cape dress", "shift dress", "slit dress", "t-shirt dress", "simple straight line dress", "pleat dress", "pleated dress"]

    #BOTTOM
    BottomHourglassFilter = ["classic pleated", "flat front", "drop-waisted", "drop-waist", "drop waist", "skinny jeans", "skinny-fit", "cargo", "military", "flare", "fit and flare", "fit & flare", "culottes", "culotte", "mid-rise", "straight", "high-waisted", "high-waist", "bootcut", "boot-cut", "sash", "straight", "palazzo", "straight-legged", "capri", "3/4", "d-ring", "pleated", "pleats", "classic pleats", "classic pleated belted", "flat front", "flat-front", "cargo", "utility", "military", "sailor", "retro", "a-line", "a line", "scallop", "scalloped", "tie-waist", "tie waist", "sash", "drawstring", "tailored", "high-waisted", "high waisted", "highwaisted", "high waist", "high-waist", "high-waisted", "mid-rise", "sash", "relaxed fit", "boyfriend", "colour-block", "colour block", "color-block", "color block", "vertical stripes", "vertical pattern", "prints", "print", "printed", "patterned", "pattern", "textured", "texture", "eyelet short", "assymetric print", "assymetrical print", "abstract print", "polka dot shorts", "polka-dot shorts", "polka dot print shorts", "tribal print", "floral print", "tile print", "foliage print", "aztec print", "flower", " exposed pockets", "embellished", "textured", "texture", "straight leg", "straight-legged shorts", "straight-cut", "Maxi skirt", "midi skirt", "slit skirt", "high waisted skirt", "high-waisted skirt", "high waist skirt", "high-waist skirt", "a-line skirt", "a line skirt", "flounce skirt", "empire skirt", "gore skirt", "sheath skirt", "wrap skirt", "trumpet skirt", "tunic skirt", "circular skirt", "soft pleat skirt", "soft pleated skirt", "full skirt", "pencil skirt", "lace skirt", "knee length skirt"]

    BottomOvalFilter = ["flat-front", "oxford", "flare", "straight", "bootcut", "boot-cut", "wide leg", "wide-legged", "wide legged", "cargo", "military", "flap-style pockets", "embellished pockets", "whiskering", "whiskered", "sailor", "sash", "gaucho", "culotte", "culottes", "bermuda", "tailored shorts", "cut-off shorts", "cutoff shorts", "cut off shorts", "frayed shorts", "frayed hem shorts", "fringe shorts", "fringed shorts", "fringe hem shorts", "fringed hem shorts", "ragged edges", "ragged edge", "raw edge", "flat front", "flat-front", "tapered cuffs", "whiskering", "a-line", "a line", "classic pleated", "pleated", "pleats", "cargo", "military", "utility", "culotte shorts", "sailor", "eyelet", "patterned", "printed", "print", "pattern", "drawstring", "skimmers", "sash", "tie waist", "tie", "boyfriend", "sailor", "textured", "texture", "Maxi skirt", "midi skirt", "slit skirt", "high-waisted flouncy skirt", " high-waisted circle skirt", "mesh skirt", "skater skirt", "pleated skirt", "pleat skirt", "full skirt", "circle skirt", "tiered skirt", "flared skirt", "short skirt", "mini skirt"]

    BottomLeanColumnFilter = ["pedal pushers", "oxford", "peplum", "jodhpurs", "pegged pants", "micro-pleated", "sash", "harem", "carrot", "cigarette", "capri", "clamdiggers", "skinny", "skinny-fit", "skinny", "detail casual shorts", "leggings", "tapered ", "cargo", "military", "balloon shorts", "balloon", "bubble shorts", "bubble", "ripped destruction", "repaired destruction", "distressed", "slashed", "rolled", "roll-ups", "roll up", "roll ups", "roll-up,turn up", "turn-up", "turnup", "cargo", "cuffs", "cuffed shorts", "military", "utility", "frayed", "fringe", "cut-off shorts", "cutoff shorts", "cut off shorts", "frayed shorts", "frayed hem shorts", "fringe shorts", "fringed shorts", "fringe hem shorts", "fringed hem shorts", "distressed shorts", "ragged edges", "ragged edge", "raw edge", "destroyed shorts", "destructed cutoff shorts", "scallop", "scalloped", "tie waist", "drawstring", "sash", "tie", "elasticized waist", "elastic band", "wide band", "sailor", "crochet", "lace", "embroidered", "embellished", "embroidery", "embellishment", "high-waisted", "high-waist", "high waisted", "high waist", "a-line", "a line", "pleats", "pleated", "classic pleated", "print", "printed", "patterned", "pattern", "textured", "texture", "eyelet short", "assymetric print", "assymetrical print", "abstract print", "polka dot shorts", "polka-dot shorts", "polka dot print shorts", "tribal print", "floral print", "tile print", "foliage print", "aztec print", "flower", " exposed pockets", "embellished", "flap style pockets", "embroidered", "embroidery", "embellishment,plaid", "houndstooth", "skorts", "skort", "wrap tie skort", "retro", "textured", "texture", "Maxi skirt", "midi skirt", "slit skirt", "pleated skirt", "pleat skirt", "box pleated skirt", "patterned skirt", "printed skirt", "print skirt", "pattern skirt", "embroidered skirt", "bead skirt", "embellished skirt", "latice skirt", "floral skirt", "uneven hem skirt", "asymmetric skirt", "flip skirt", "bias skirt", "wrap skirt", "circular skirt", "dirndl skirt", "dome skirt", "peg-top skirt", "peplum skirt", "pleated skirt", "tiered skirt", "mini skirt", "short skirt", "pencil skirt", "a line skirt", "a-line skirt"]

    BottomTriangleFilter = ["straight", "straight-legged", "straight leg", "oxford", "palazzo", "flare", "wide leg", "wide-legged", "wide legged", "gauchos", "culottes", "bell bottoms", "bootcut", "flat front", "flat-front", "high-waisted shorts", "high waisted shorts", "highwaisted shorts", "high waist", "high-waist", "highwaist", "bermuda", "knee-length shorts", "a line", "a-line", "flat front shorts", "flat-front shorts", "mid-length shorts", "mid length", "roll ups", "roll up", "rolled", "turn-ups", "turn up", "cuffs", "cuffed shorts", "welt pockets", "chinos", "tailored", "exposed pocket", "cut-off shorts", "cutoff shorts", "cut off shorts", "frayed shorts", "frayed hem shorts", "fringe shorts", "fringed shorts", "fringe hem shorts", "fringed hem shorts", "distressed shorts", "ragged edges", "ragged edge", "raw edge", "destroyed shorts", "destructed cutoff shorts", "straight leg", "straight-legged shorts", "straight-cut", "skimmers", "sash", "tie waist", "tie", "drawstring", "Tulip skirt", "a-line skirt", "a line skirt", "wrap skirt", "hi-lo skirt", "maxi skirt", "midi skirt", "slit skirt", "eyelet skirt", "full skirt", "gathered skirt", "drape skirt", "draped skirt", "bias cut skirt", "bias skirt", "straight skirt", "panella skirt", "circle skirt"]

    BottomInvertedTriangleFilter = ["pedal pusher", "oxford", "palazzo", "gauchos", "culottes shorts", "culottes pant", "culottes", "bootcut", "boot cut", "boot-cut", "distressed", "bootleg", "bell-bottoms", "bell bottoms", "flare", "flared", "wide-leg", "wide leg", "wide legged", "utility shorts", "cargo shorts", "military shorts", "paisley shorts", "bandana print with pompoms", "tribal print shorts ", "culotte shorts", "cut-off shorts", "cutoff shorts", "cut off shorts", "frayed shorts", "frayed hem shorts", "fringe shorts", "fringed shorts", "fringe hem shorts", "fringed hem shorts", "distressed shorts", "ragged edges", "ragged edge", "raw edge", "destroyed shorts", "destructed cutoff shorts", "assymetric print", "assymetrical print", "abstract print", "polka dot shorts", "polka-dot shorts", "polka dot print shorts", "tribal print", "floral print", "tile print", "foliage print", "aztec print", "flower", "short shorts", "high waisted shorts", "high-waisted shorts", "highwaisted shorts", "high waist", "high-waist", "highwaist", "a line", "a-line", "skort", "skimmer", "knee-length", "tailored", "exposed pockets", "embellished", "flap style pockets", "embroidered", "embroidery", "embellishment", "flowy", "wrap tie skort", "lace trim shorts", "lace shorts", "plaid", "houndstooth", "eyelet short", "belted shorts", "wide band shorts", "textured", "texture", "Full skirt", "balloon skirt", " high-waisted flouncy skirt", "high-waisted circle skirt", "high-waist skirt", "sailor skirt", "Dirndl skirt", "A-line skirt", "Circular skirt", "Gored skirt", "peplum skirt", "tulip skirt", "flounce skirt", "patio skirt", "bias cut skirt", "bias skirt", "trumpet skirt", "pleated skirt", "pleat skirt", "tiered skirt", "sarong skirt", "yoke skirt", "skater skirt", "button-up skirt", "high rise skirt", "maxi skirt", "midi skirt", "slit skirt", "mesh skirt", "skater skirt", "short skirt", "mini skirt"]

    if (bodyShape == "Hourglass")
      topFilter = TopHourglassFilter
      bottomFilter = BottomHourglassFilter
    elsif (bodyShape == "Oval")
      topFilter = TopOvalFilter
      bottomFilter = BottomOvalFilter
    elsif (bodyShape == "Rectangle")
      topFilter = TopLeanColumnFilter
      bottomFilter = BottomLeanColumnFilter
    elsif (bodyShape == "Inverted Triangle")
      topFilter = TopInvertedTriangleFilter
      bottomFilter = BottomInvertedTriangleFilter
    elsif (bodyShape == "Triangle")
      topFilter = TopTriangleFilter
      bottomFilter = BottomTriangleFilter
    elsif (bodyShape = "Test")
      topFilter = array(" ")
      bottomFilter = array(" ")
    end


    filteredClothes = []
    names = []
    #
    # puts "<table>"
    # puts "<tr>"

=begin
        puts "<th><b>Picture</b></th>"
        puts "<th><b>Name</b></th>"
        puts "<th><b>Details</b></th>"
        puts "<th><b>Size</b></th>"
        puts "<th><b>Price</b></th>"
        puts "<th><b>Link To Item</b></th>"
        puts "</tr>"
=end

    # while (!feof(file))  do

      csv.each do |lineOfCSV|

      isDress = lineOfCSV[0]
      isBlouse = lineOfCSV[2]
      isJean = lineOfCSV[4]
      isJacket = lineOfCSV[6]
      isJumpsuit = lineOfCSV[8]
      isSwimsuit = lineOfCSV[10]
      linkToItem = lineOfCSV[13]
      name = lineOfCSV[14]
      oldPrice = lineOfCSV[15]
      newPrice = lineOfCSV[16]
      description = lineOfCSV[18]
      sizes = lineOfCSV[20]
      picSRC = lineOfCSV[23]

      if (names.include?(name))

        #for (i = 0 i < count(filteredClothes) i++) {
        #if (filteredClothes[i][3] == name) {
        #newDetails = filteredClothes[i][4] . "<br>" . lineOfCSV[10]
        # filteredClothes[i][4] = newDetails
        #}
        #}
      else
        #   0		1	2	   3	     4		5		6	7	8		9	10	11		12
        contents = [picSRC, isDress, isBlouse, isJean, isJacket, isJumpsuit, isSwimsuit, name, description, sizes, oldPrice, newPrice, linkToItem]
        filteredClothes << contents
        names << name
      end
    end

=begin
        for (j = 0 j < count(filteredClothes) j++) {
            if ([1] != "") {
                foreach (topFilter as filterElementTop) {
                    if (stripos(filteredClothes[j][4], filterElementTop)) {
                        puts "<tr>"
                        puts "<td><img src='" . filteredClothes[j][0] . "'></td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][3] . "</td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][4] . "</td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][5] . "</td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][6] . "</td>"
                        puts "<td style='min-width: 50px'><a href='" . filteredClothes[j][7] . "' target='_blank'>Buy Now</a></td>"
                        puts "</tr>"

                        break
                    }
                }
            }
            else if (filteredClothes[j][2] != "") {
                foreach (bottomFilter as filterElementBottom) {
                    if (stripos(filteredClothes[j][4], filterElementBottom)) {
                        puts "<tr>"
                        puts "<td><img src='" . filteredClothes[j][0] . "'></td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][3] . "</td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][4] . "</td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][5] . "</td>"
                        puts "<td style='min-width: 50px'>" . filteredClothes[j][6] . "</td>"
                        puts "<td style='min-width: 50px'><a href='" . filteredClothes[j][7] . "' target='_blank'>Buy Now</a></td>"
                        puts "</tr>"

                        break
                    }
                }
            }
        }
=end

    #3 By X Version
    results_top = []
    results_bottom = []
    counter = 0

    filteredClothes.each do |element|
      if ((element[1] != "") || (element[2] != "") || (element[4] != ""))
        topFilter.each do |filterElementTop|
          if ((element[7].index(filterElementTop) != nil) || (element[8].index(filterElementTop) != nil))
            # puts "<td>"
            # puts "<table onclick=\"loadFullInfo('Voluptuous', '" + element[7] + "')\">"
            # puts "<tr><td  colspan='2'><img src='" + element[0] + "'></td></tr>"
            # puts "<tr><td colspan='2'  style='min-width: 50px'>" + element[7] + "</td></tr>"
            # puts "<tr><td><s>" + element[10] + "</s> " + element[11] + "</td></tr>"
            # puts "</table>"
            # puts "</td>"
            results_top << element

            # counter+=1
            #
            # break
          end
        end
      elsif (element[3] != "")
        bottomFilter.each do |filterElementBottom|
          if ((element[7].index(filterElementBottom) != nil) || (element[8].index(filterElementBottom) != nil))
            # puts "<td>"
            # puts "<table onclick=\"loadFullInfo('Voluptuous', '" + element[7] + "')\">"
            # puts "<tr><td colspan='2' ><img src='" + element[0] + "'></td></tr>"
            # puts "<tr><td colspan='2'  style='min-width: 50px'>" + element[7] + "</td></tr>"
            # puts "<tr><td><s>" + element[10] + "</s> " + element[11] + "</td></tr>"
            # puts "</table>"
            # puts "</td>"
            results_bottom << element

            # counter+=1
            #
            # break
          end
        end
        # if(counter % 3 == 0)
        #   puts "</tr>"
        #   puts "<tr>"
        # end
      end
    end
    # puts "</tr>"
    # puts "</table>"
  end

  def loadMoreVoluptuous(nameIn)
    require 'csv'
    #specify file_location
    csv_text = File.read(file_location)
    csv = CSV.parse(csv_text, :headers => true )

    filteredClothes = []
    names = []

    puts "<table>"
    puts "<tr>"

    csv.each do |lineOfCSV|

      # lineOfCSV = fgetcsv(file, null, ",", "\"")

      isDress = lineOfCSV[0]
      isBlouse = lineOfCSV[2]
      isJean = lineOfCSV[4]
      isJacket = lineOfCSV[6]
      isJumpsuit = lineOfCSV[8]
      isSwimsuit = lineOfCSV[10]
      linkToItem = lineOfCSV[13]
      name = lineOfCSV[14]
      oldPrice = lineOfCSV[15] #These are currently both in the same column. You could create your own splitting function or
      newPrice = lineOfCSV[16] #get the store to give it to you in diff columns.
      description = lineOfCSV[18]
      sizes = (lineOfCSV[20].gsub('Choose an option', '')).gsub('X', 'X ')
      picSRC = lineOfCSV[23]

      if (names.include?(name))
        filteredClothes.each do |element|
          if (element[7] == name)
            newDetails = element[8] + "<br>" + lineOfCSV[18]
            element[8] = newDetails
          end
        end
      else
        #   0		1	2	   3	     4		5		6	7	8		9	10	11		12
        contents = [picSRC, isDress, isBlouse, isJean, isJacket, isJumpsuit, isSwimsuit, name, description, sizes, oldPrice, newPrice, linkToItem]
        filteredClothes << contents
        names << name
      end
    end

    fil_ter = []

    filteredClothes.each do |element_j|

      if (element_j[7] == nameIn)
        fil_ter << element
        # puts "<table>"
        # puts "<tr><td colspan='2' style='min-width: 50px font-size: 45px'>" + filteredClothes[j][7] + "</td></tr>"
        # puts "<tr><td rowspan='4'><img src='" + filteredClothes[j][0] + "'></td></tr>"
        # puts "<tr><td style='min-width: 50px max-width: 300px'>" + filteredClothes[j][8] + "</td></tr>"
        # puts "<tr><td style='min-width: 50px'>" + filteredClothes[j][9] +"</td></tr>"
        # puts "<tr><td style='min-width: 50px'><s>" + filteredClothes[j][10] + "</s> " + filteredClothes[j][11] + "</td></tr>"
        # puts "</table>"
        #
        # break

      end
      #else{
      #puts "Name From List: " . filteredClothes[j][3] . ", Passed Name: " . nameIn . "<br>"
      #}
    end

  end

  def readVoluptuousCSVSize(topSize, bottomSize)
    require 'csv'
    #specify file_location
    csv_text = File.read(file_location)
    csv = CSV.parse(csv_text, :headers => true )

    filteredClothes = []
    names = []

    # puts "<table border='1'>"
    #
    # puts "<tr>"
    # puts "<th><b>Picture</b></th>"
    # puts "<th><b>Name</b></th>"
    # puts "<th><b>Details</b></th>"
    # puts "<th><b>Size</b></th>"
    # puts "<th><b>Price</b></th>"
    # puts "<th><b>Link To Item</b></th>"
    # puts "</tr>"

    csv.each do |lineOfCSV|

      # lineOfCSV = fgetcsv(file, null, ",", "\"")

      isDress = lineOfCSV[0]
      isBlouse = lineOfCSV[2]
      isJean = lineOfCSV[4]
      isJacket = lineOfCSV[6]
      isJumpsuit = lineOfCSV[8]
      isSwimsuit = lineOfCSV[10]
      linkToItem = lineOfCSV[13]
      name = lineOfCSV[14]
      oldPrice = lineOfCSV[15] #These are currently both in the same column. You could create your own splitting function or
      newPrice = lineOfCSV[16] #get the store to give it to you in diff columns.
      description = lineOfCSV[18]
      sizes = (lineOfCSV[20].gsub('Choose an option', '')).gsub('X', 'X ')
      picSRC = lineOfCSV[23]

      if (names.include?(name))
        filteredClothes.each do |element_i|
          if (element_i[7] == name)
            newDetails = element_i[8] + "<br>" + lineOfCSV[18]
            element_i[8] = newDetails
          end
        end
      else
        contents = [picSRC, isDress, isBlouse, isJean, isJacket, isJumpsuit, isSwimsuit, name, description, sizes, oldPrice, newPrice, linkToItem]
        filteredClothes << contents
        names << name
      end
    end

    filteredClothes.each do |element_k|
      if (element_k[1] != "" || element_k[2] != "" || element_k[4] != "")
        #make your own method for ruby version of strspn
        if (strspn(element_k[9], topSize) >= 2)
          # puts "<tr>"
          # puts "<td><img src='" + element_k[0] + "'></td>"
          # puts "<td style='min-width: 50px'>" + element_k[3] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[4] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[5] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[6] + "</td>"
          # puts "<td style='min-width: 50px'><a href='"+ element_k[7] + "' target='_blank'>Buy Now</a></td>"
          # puts "</tr>"
          #do something, most likely store this element in some array.
        elsif (strspn(topSize, element_k[9]) >= 2)
          # puts "<tr>"
          # puts "<td><img src='" + element_k[0] + "'></td>"
          # puts "<td style='min-width: 50px'>" + element_k[3] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[4] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[5] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[6] + "</td>"
          # puts "<td style='min-width: 50px'><a href='" + element_k[7] + "' target='_blank'>Buy Now</a></td>"
          # puts "</tr>"
          #do something
        end
      elsif (element_k[3] != "")
        if (strspn(element_k[9], bottomSize) >= 2)
          # puts "<tr>"
          # puts "<td><img src='" + element_k[0] + "'></td>"
          # puts "<td style='min-width: 50px'>" + element_k[3] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[4] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[5] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[6] + "</td>"
          # puts "<td style='min-width: 50px'><a href='" + element_k[7] + "' target='_blank'>Buy Now</a></td>"
          # puts "</tr>"
          #do something
        elsif (strspn(bottomSize, element_k[9]) >= 2)
          # puts "<tr>"
          # puts "<td><img src='" + element_k[0] + "'></td>"
          # puts "<td style='min-width: 50px'>" + element_k[3] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[4] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[5] + "</td>"
          # puts "<td style='min-width: 50px'>" + element_k[6] + "</td>"
          # puts "<td style='min-width: 50px'><a href='" + element_k[7] + "' target='_blank'>Buy Now</a></td>"
          # puts "</tr>"
          #do something.
        end
      end
    end

    # puts "</table>"
  end
end
