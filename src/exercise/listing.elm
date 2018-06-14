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
      id:Int
      ,userId:Int
      ,title:String
      ,body:String
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
        div[]
            [
              div[][
              h1[][text "User Details"]
              ]
              ,div[]
                  [
                  model.apiData
                  |> List.map (\x -> getHtml x)
                  |> table[style [("cellpadding", "5") , ("width", "100%"), ("border", "1px solid blue")]]
                ]
          ]


getHtml x =
    tr[][
      td[][text <| toString x.id]
      ,td[][text <| toString x.userId]
      ,td[][text <|  x.title]
      ,td[][text <|  x.body]
    ]

--- type MSG
type Msg = FetchUserDetails
      --   | UpdateFindId String
         | OnHttpResponse (Result Http.Error (List ApiData))

update msg model=
      case msg of
            FetchUserDetails ->
                (model ,  getMoreData )
            OnHttpResponse (Ok newApiData ) ->
                ( {model | apiData = newApiData } , Cmd.none)
            OnHttpResponse (Err _) ->
                (model,Cmd.none)
            --UpdateFindId newid ->
            --  ({model | findId = Result.withDefault 0 (String.toInt newid )} , Cmd.none)



getMoreData =
      let
        url= "https://jsonplaceholder.typicode.com/posts/"
      in
        Http.send OnHttpResponse(Http.get url (Decode.list decodeUrlData))

decodeUrlData:Decode.Decoder ApiData
decodeUrlData =
    decode ApiData
        |> required "id" Decode.int
        |> required "userId" Decode.int
        |> required "title" Decode.string
        |> required "body" Decode.string


subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
