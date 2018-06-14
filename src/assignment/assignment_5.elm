import Html exposing (text)
import List

checkNumberExist number =
      String.split  "" number
      |>toString

main =
  text (checkNumberExist "123456")
