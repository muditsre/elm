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
        myNumber :  Int
      , fibNumberList : List Int
    }


---init
init: (Model , Cmd Msg)
init = (Model  0 [], Cmd.none )


--View
view: Model->Html Msg
view model=
        div[]
            [
              div[][
              h1[][text "FibC List"]
              ]
              ,div[]
                  [
                  ul[][
                        li[][
                            p[][
                              input[ placeholder "Enter Number here",  onInput UpdateNumber ][]
                              ,button [onClick GetFibonacciNumber  ][text "Get Fibonacci"]
                                                           ]
                        ]
                    ]
                    , model.fibNumberList
                    |> List.map (\x -> getLiList x)
                    |> ul[]
                ]
          ]
--
getLiList x=
  li[][ text(toString(x)) ]

--- type MSG
type Msg = GetFibonacciNumber
         | UpdateNumber String


update msg model=
      case msg of
            GetFibonacciNumber ->
                (getFibCList model)
            UpdateNumber newNumber ->
                ({model | myNumber = Result.withDefault 0 (String.toInt newNumber) } , Cmd.none)


getFibCList :  Model -> (Model, Cmd Msg)
getFibCList model =
  let
      fibNumberList = getFibList model.myNumber []
  in
    ({model | fibNumberList = List.reverse fibNumberList } , Cmd.none)

getFibList:Int -> List Int -> List Int
getFibList number listoffib =
  let
    newlist =  number::listoffib
  in
    if List.length newlist < 20 then
      getFibList (number+1) newlist
    else
      newlist



subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
