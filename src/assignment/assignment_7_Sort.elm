import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style, placeholder, value, src)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline  exposing (decode, required, optional)
import List
--- Define Main
main =
      Html.program{
      init = init
      ,view = view
      ,update = update
      ,subscriptions = subscriptions
    }

--  MODEL Alais

type alias Model = {
        myList :  String
      , sortedList : String
    }


---init
init: (Model , Cmd Msg)
init = (Model  "1,3,2" "", Cmd.none )


--View
view: Model->Html Msg
view model=
        div[]
            [
              div[][
              h1[][text "Sort List"]
              ]
              ,div[]
                  [
                  ul[][
                        li[][
                            p[][
                              input[ placeholder "Enter Number here", value model.myList, onInput UpdateList ][]
                              ,button [onClick SortListElements ][text "Sort"]
                              , text model.sortedList
                             ]
                        ]
                    ]
                ]
          ]

--- type MSG
type Msg = SortListElements
         | UpdateList String


update msg model=
      case msg of
            SortListElements ->
                (sortList model)
            UpdateList newList ->
                ({model | myList = newList} , Cmd.none)


sortList :  Model -> (Model, Cmd Msg)
sortList model =
  let
      listToSort = List.map (\x -> Result.withDefault 0 (String.toInt x) ) <|  String.split "," model.myList
  in
    ({model | sortedList = toString ( List.sort listToSort) } , Cmd.none)



subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
