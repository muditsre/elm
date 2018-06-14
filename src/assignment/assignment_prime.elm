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
      , primeNumber : List Int
    }


---init
init: (Model , Cmd Msg)
--init = (Model  100 [], Task.succeed GetFibonacciNumber  |> Task.perform identity )
init = (Model  0 [] , Cmd.none )


--View
view: Model->Html Msg
view model=
        div[]
            [
              div[][
              h1[][text "Prime Number of Position"]
              ]
              ,div[]
                  [
                  ul[][
                        li[][
                            p[][
                              input[ placeholder "Enter Number here",  onInput UpdateNumber ][]
                              ,button [onClick GePrimeNumber  ][text "Get Prime Number"]
                             ]
                        ]
                      ,li[][
                          List.head model.primeNumber
                          |>toString
                          |>text
                      ]
                    ]
                ]
          ]
--

--- type MSG
type Msg = GePrimeNumber
         | UpdateNumber String


update msg model=
      case msg of
            GePrimeNumber ->
                (primeNumber model)
            UpdateNumber newNumber ->
                ({model | myNumber = Result.withDefault 0 (String.toInt newNumber) } , Cmd.none)


primeNumber :  Model -> (Model, Cmd Msg)
primeNumber model =
  let
      primeNumberList = getPrimeNumber model.myNumber 2 []
  in
    ({model | primeNumber =  primeNumberList } , Cmd.none)



getPrimeNumber:Int -> Int -> List Int -> List Int
getPrimeNumber  number n1 listofNumber  =
  let
    primeNumberList = getUpdatedList n1 listofNumber
  in
   if List.length primeNumberList < number then
      getPrimeNumber number (n1+1)  primeNumberList
   else
     primeNumberList


getUpdatedList: Int -> List Int -> List Int
getUpdatedList n1 listofNumber =
   if isPrime n1 (n1//2) then
      n1::listofNumber
   else
     listofNumber


----------------------------------------
isPrime: Int-> Int ->  Bool
isPrime n1 hn1 =
  if hn1 == 1 then
    True
  else
    if n1 % hn1 == 0 then
      False
    else
      isPrime n1 (hn1-1)


subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
