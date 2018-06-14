import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style, placeholder, value, src)
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
          number: Int
         ,power: Int
        ,message : Int
    }


---init
init: (Model , Cmd Msg)
init = (Model  0 0 0 , Cmd.none )


--View
view: Model->Html Msg
view model=
        div[]
            [
              div[][
              h1[][text "Number Details"]
              ]
              ,div[]
                  [
                  ul[][
                         li[][
                            p[][
                              input[ placeholder "Enter Number here",  onInput UpdateNumber ][]
                              ,br[][]
                              ,br[][]
                              ,input[ placeholder "Enter Power here",  onInput UpdatePower ][]
                              ,br[][]
                              ,button [onClick FetchNumberDetails ][text "Calculate"]
                              ,br[][]
                              ,p[][
                              span[][text "Result: "]
                              , text (toString(model.message))
                              ]
                             ]
                        ]
                    ]
                ]
          ]

--- type MSG
type Msg = FetchNumberDetails
         | UpdateNumber String
         | UpdatePower String


update msg model=
      case msg of
          FetchNumberDetails ->
                (findMember model)
          UpdateNumber newnumber ->
              ({model | number = Result.withDefault 0 (String.toInt newnumber)} , Cmd.none)
          UpdatePower newpower ->
                ({model | power = Result.withDefault 0 (String.toInt newpower)} , Cmd.none)


findMember :  Model -> (Model, Cmd Msg)
findMember model=
  let
     powerOutPut = getPower model.number 2 model

 in
    ({model | message =  powerOutPut} , Cmd.none)

getPower:Int->Int->Model->Int
getPower number power model =
    let
      newpower = getNewPower number model
    in
      if model.power > power then
            getPower newpower (power+1) model
      else
        newpower


getNewPower:Int->Model ->Int
getNewPower newnumber  model =
            newnumber * model.number

subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
