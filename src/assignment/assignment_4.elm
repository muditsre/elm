import Html exposing (text)
import List

checkNumberExist =
    let
      myList = [1,2,3]
    in
     List.maximum  myList
     |>toString

main =
  text (checkNumberExist)
