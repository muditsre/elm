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
      name:String
      ,phone:Int

    }

type alias Model = {
      apiData:(List ApiData),
      searchKeyword:String

    }
---init
init: (Model , Cmd Msg)
init = (Model  [] "", getMoreData )


--View
view: Model->Html Msg
view model=
        div[style [("padding-left", "20px")]]
            [
              div[][
              h1[][text "User Details"]
              ]
              ,div[][
                input[ placeholder "Enter Search Keyword " , onInput SearchKeyword ][]
              --  ,button[ onClick SearchData ][text "Search"]
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
      td[][text <|   x.name]
      ,td[][text <|  toString x.phone]

    ]

--- type MSG
type Msg = GetContactDetails
          --| SearchData
          | SearchKeyword String
          | OnHttpResponse (Result Http.Error (List ApiData))

update msg model=
      case msg of
            GetContactDetails ->
                (model ,  getMoreData )
            -- SearchData ->
            --     ({model | apiData =  searchData model } , Cmd.none)
            SearchKeyword newkeyword ->
                    ({model | apiData =  searchData model } , Cmd.none)
            OnHttpResponse (Ok newApiData ) ->
                ( {model | apiData = newApiData } , Cmd.none)
            OnHttpResponse (Err _) ->
                (model,Cmd.none)

getMoreData =
      let
        url= "http://localhost:8000/src/test/contacts.json"
      in
        Http.send OnHttpResponse(Http.get url (Decode.list decodeUrlData))

searchData model =
      let
         newApiData =  List.filter(\x -> containKeyword x model ) model.apiData
      in
          newApiData


containKeyword x model =
          let
            strlenth = String.length model.searchKeyword
            newstr = String.slice 0 1 x.name
          in
          if newstr == model.searchKeyword then
            True
          else
            False


decodeUrlData:Decode.Decoder ApiData
decodeUrlData =
    decode ApiData
        |> required "name" Decode.string
        |> required "phone" Decode.int



subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none
