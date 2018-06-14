import Html exposing (text)
import List

checkNumberExist =
    let
      myList = [1,2,3,4,5]
    in
     List.sum  myList
     |>toString

main =
  text (checkNumberExist)
