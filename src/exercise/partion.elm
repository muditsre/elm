import Html exposing (..)
import List

 
checkReversed =
    let
      myList = [1,7,1]
    in
      myList == List.reverse myList
      |>toString

main =
  text (checkReversed)
