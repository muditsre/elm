import Html exposing (text)
import List

checkNumberExist =
    let
      myList = [1,4,6]
      myList2 = [2,3,5]

    in
     List.concat [myList, myList2]
     |>List.sort
     |>toString

main =
  text (checkNumberExist)
