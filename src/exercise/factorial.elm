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
      Html.program{
      init = init
      ,view = view
      ,update = update
      ,subscriptions = subscriptions
    }

--  MODEL Alais

type alias Model = {
        myNumber :  Int
      , facNumber :  Int
    }


---init
init: (Model , Cmd Msg)
--init = (Model  100 [], Task.succeed GetFaconacciNumber  |> Task.perform identity )
init = (Model  0 0 , Cmd.none )


--View
view: Model->Html Msg
view model=
        div[]
            [
              div[][
              h1[][text "FacC List"]
              ]
              ,div[]
                  [
                  ul[][
                        li[][
                            p[][
                              input[ placeholder "Enter Number here",  onInput UpdateNumber ][]
                              ,button [onClick GetFaconacciNumber  ][text "Get Faconacci"]
                                                           ]
                        ]
                        ,li[][
                          p[][
                           model.facNumber
                          |> toString
                          |>text
                          ]
                        ]
                    ]

                ]
          ]
--

--- type MSG
type Msg = GetFaconacciNumber
         | UpdateNumber String


update msg model=
      case msg of
            GetFaconacciNumber ->
                (getFacCList model)
            UpdateNumber newNumber ->
                ({model | myNumber = Result.withDefault 0 (String.toInt newNumber) } , Cmd.none)


getFacCList :  Model -> (Model, Cmd Msg)
getFacCList model =
  let
      facNumber = getFacList model.myNumber (model.myNumber-1)
  in
    ({model | facNumber = facNumber } , Cmd.none)

getFacList:Int -> Int -> Int
getFacList number n1 =
  let
    newsum = getSum number n1
 in
    if newsum > 1 then
        getFacList newsum (n1-1)
    else
      number



getSum : Int -> Int -> Int
getSum n1 n2 =
        n1*n2


subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
