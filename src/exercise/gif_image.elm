-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode



----------------------------------------------
  -- MODEL
----------------------------------------------

type alias Model =
  {
    keyword : String
  , gifUrl : String
  }


----------------------------------------------
  -- VIEW
----------------------------------------------

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.keyword]
      , input [ type_ "text", placeholder "Name", onInput Name ] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , img [src model.gifUrl] []
    ]


----------------------------------------------
  -- UPDATE
----------------------------------------------

type Msg
  = Name String
  | MorePlease
  | NewGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
        MorePlease ->
          (model, getRandomGif model)

        Name newkeyword ->
          ( { model | keyword = newkeyword }, Cmd.none )

        NewGif (Ok newUrl) ->
            (Model model.keyword newUrl, Cmd.none)

        NewGif (Err _) ->
          (model, Cmd.none)

----------------------------------------------
  -- HTTP
----------------------------------------------

getRandomGif : Model -> Cmd Msg
getRandomGif model =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ model.keyword
  in
    Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string


----------------------------------------------
-- SUBSCRIPTIONS
------------------------------------------

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

----------------------------------------------------
init : String -> (Model, Cmd Msg)
init keyword = ( Model keyword "waiting.gif" , getRandomGif { keyword = "cats" , gifUrl="waiting.gif"} )


---------------------------------------------------------
main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
