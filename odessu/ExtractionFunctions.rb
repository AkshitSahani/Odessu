=begin
    /**
     * Written By: Mateusz Raniewicz
     * Last Modified: Monday March 13 2017
     * Last Modified By: Mateusz Raniewicz
     */

    /**
     * Function used to extract only the names of the stores given by the client for tops
     * @param $listOfTops
     * @return array
     */
    function extractStoreNameTop($listOfTops) {

        $listOfPairsTop = explode(";", $listOfTops);
        $listOfStoresTop = array();

        foreach ($listOfPairsTop as $itemTop){

            list($storeName, $storeSize) = explode(" ", $itemTop);
            array_push($listOfStoresTop, $storeName);

        }

        return $listOfStoresTop;
    }

    /**
     * Function used to extract only the names of the stores given by the client for bottoms
     * @param $listOfBottoms
     * @return array
     */
    function extractStoreNameBottom($listOfBottoms) {

        $listOfPairsBottom = explode(";", $listOfBottoms);
        $listOfStoresBottom = array();

        foreach ($listOfPairsBottom as $itemBottom){

            list($storeName, $storeSize) = explode(" ", $itemBottom);
            array_push($listOfStoresBottom, $storeName);

        }

        return $listOfStoresBottom;
    }
=end
