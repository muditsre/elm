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
      , fibNumberList : List Int
    }


---init
init: (Model , Cmd Msg)
--init = (Model  100 [], Task.succeed GetFibonacciNumber  |> Task.perform identity )
init = (Model  100 [], Cmd.none )


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
      fibNumberList = getFibList model.myNumber 0 1 []
  in
    ({model | fibNumberList = List.reverse fibNumberList } , Cmd.none)

getFibList:Int -> Int -> Int-> List Int -> List Int
getFibList number n1 n2 listoffib =
  let
    newsum = getSum n1 n2
 in
    if newsum < number then
      let
          newList = checkList newsum n2 n1 listoffib
      in
          getFibList number  n2 newsum newList
    else
      listoffib

getSum:Int -> Int -> Int
getSum n1 n2 =
      n1+n2

checkList:Int ->Int -> Int -> List Int -> List Int
checkList newsum n2 n1 listoffib =
  if List.isEmpty listoffib then
    [newsum,n2,n1]
  else
    newsum :: listoffib


subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
