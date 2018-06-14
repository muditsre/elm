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
        myList : List Int
        ,findId: Int
        , message : String
    }


---init
init: (Model , Cmd Msg)
init = (Model  [1,2,3,4]  0 "", Cmd.none )


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
                            model.myList |> toString |> text
                            ]
                        ]
                        ,li[][
                            p[][
                              input[ placeholder "Enter Number here",  onInput UpdateNumber ][]
                              ,button [onClick FetchNumberDetails ][text "Get Info"]
                              , text model.message
                             ]
                        ]
                    ]
                ]
          ]

--- type MSG
type Msg = FetchNumberDetails
         | UpdateNumber String


update msg model=
      case msg of
            FetchNumberDetails ->
                (findMember model)

            UpdateNumber newid ->
              ({model | findId = Result.withDefault 0 (String.toInt newid)} , Cmd.none)


findMember :  Model -> (Model, Cmd Msg)
findMember model=
  let
      y = List.member (model.findId) model.myList

 in
    ({model | message = toString y} , Cmd.none)



subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
