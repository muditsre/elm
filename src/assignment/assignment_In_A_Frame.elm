import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style, placeholder, value, src)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline  exposing (decode, required, optional)
import List
import Task
--- Define Main
main =
        toFrame




--View

toFrame =
   let
      myList =  ["Hello","World","in","a","frame"]
   in
        div[]
            [
              div[style   [("padding-left","25px")]][
              h1[][text "List"]
              ]
              ,div[style   [("padding-left","25px")]]
                  [
                  div[][
                        div[][
                              myList
                              |>toString
                              |>text
                          ]
                        ,li[][
                             div[][text "*******"]
                            ,div[][
                                myList
                                |> List.map (\x -> getHtml x)
                                |>div[]
                               ]
                            ,div[][text "********"]
                          ]
                    ]
                ]
          ]
--getFrameList:List String -> HTML Msg
getHtml x =
     div[][text <| ("*"++x++"*") ]
