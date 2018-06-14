import Html exposing (text)
import String
import List


countChar =
    let
    --  myString = "JJJTTQPPMMMMYYYYYYYYYVVVVVV"
      myString = "JJJTT"
    in
      getCountChar (String.toList myString) 0
      |>toString


getCountChar:List Char -> Int -> List Char
getCountChar myString  i  =
    let
      newStringList = checkSameChar myString 0
    in
      if  i < List.length myString   then
           getCountChar myString (i+1)
      else
          newStringList

checkSameChar string cnt =
        let
          sstring = string
        in
          sstring



main =
   countChar
   |>text
