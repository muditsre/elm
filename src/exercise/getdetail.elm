import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (style, placeholder, value, src)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline  exposing (decode, required, optional)

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
    apiData:ApiData
    ,findId:Int
    }


---init
init: (Model , Cmd Msg)
init = (Model  {id=0 , title="Test Title", body="Test Body", userId=0} 0 , Cmd.none )


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
                  ul[][
                      li[][
                          p[][
                            b[][text "Id: "]
                            ,text (toString(model.apiData.id))
                          ]
                      ]
                      ,li[][
                            p[][
                              b[][text "User ID: "]
                              ,text (toString(model.apiData.userId))
                            ]
                        ]
                        ,li[][
                            p[][
                              b[][text "Title: "]
                              ,text model.apiData.title
                            ]
                        ]
                        ,li[][
                            p[][
                              b[][text "Body: "]
                              ,text model.apiData.body
                            ]
                        ]
                        ,li[][
                            p[][
                              input[ placeholder "Enter User Id here", value (toString(model.findId)),  onInput UpdateFindId ][]
                              ,button [onClick FetchUserDetails ][text "Get Info"]
                             ]
                        ]
                    ]
                ]
          ]

--- type MSG
type Msg = FetchUserDetails
         | UpdateFindId String
         | OnHttpResponse (Result Http.Error ApiData)

update msg model=
      case msg of
            FetchUserDetails ->
                (model , model.findId |> toString |> getMoreData )
            OnHttpResponse (Ok newApiData ) ->
                ( {model | apiData = newApiData } , Cmd.none)
            OnHttpResponse (Err _) ->
                (model,Cmd.none)
            UpdateFindId newid ->
              ({model | findId = Result.withDefault 0 (String.toInt newid )} , Cmd.none)



getMoreData id =
      let
        url= "https://jsonplaceholder.typicode.com/posts/" ++ id
      in
        Http.send OnHttpResponse(Http.get url decodeUrlData)

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
