import Html exposing (text)
import List

checkNumberExist =
    let
      myList = ["a","b","c"]
      myList2 = [1,2,3]

    in
     List.map2 (,)  myList myList2
     |>toString

main =
  text (checkNumberExist)
