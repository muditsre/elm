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

type alias ApiData = {
      login:String
      ,id:Int
      ,type_:String
      ,avatar_url:String
    }

type alias Model = {
      apiData:(List ApiData)
    }
---init
init: (Model , Cmd Msg)
init = (Model  [] , getMoreData )


--View
view: Model->Html Msg
view model=
        div[style [("padding-left", "20px")]]
            [
              div[][
              h1[][text "User Details"]
              ]
              ,div[]
                  [
                  model.apiData
                  |> List.map (\x -> getHtml x)
                  |> table[style [("padding-left", "20px") , ("width", "100%")]]
                ]
          ]


getHtml x =
    tr[][
      td[][text <|   x.login]
      ,td[][text <| toString x.id]
      ,td[][text <|  x.type_]
      ,td[][img [ src x.avatar_url ] []  ]
    ]

--- type MSG
type Msg = FetchUserDetails
          | OnHttpResponse (Result Http.Error (List ApiData))

update msg model=
      case msg of
            FetchUserDetails ->
                (model ,  getMoreData )
            OnHttpResponse (Ok newApiData ) ->
                ( {model | apiData = newApiData } , Cmd.none)
            OnHttpResponse (Err _) ->
                (model,Cmd.none)




getMoreData =
      let
        url= "http://localhost:8000/src/test/users.json"
      in
        Http.send OnHttpResponse(Http.get url (Decode.list decodeUrlData))

decodeUrlData:Decode.Decoder ApiData
decodeUrlData =
    decode ApiData
        |> required "login" Decode.string
        |> required "id" Decode.int
        |> required "type" Decode.string
        |> required "avatar_url" Decode.string


subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
