import Html exposing (..)
import Html.Attributes exposing (style, id, placeholder, value, src)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)





----------------------------------------------
  -- MODEL
----------------------------------------------
type alias Model =
    { user : String
    , name : Maybe String
    , avtar : Maybe String
    , bio : Maybe String
    , company : Maybe String
    , blog : Maybe String
    , location : Maybe String
    }


----------------------------------------------
  -- VIEW
----------------------------------------------

view model =
    div
        [ style [ ( "text-align", "center" ) ]
        ]
        [ h1 []
            [ text "Github User Details"
            ]
        , div []
            [ input [ id "user", placeholder "Enter Username", value model.user, inputDesign, onInput UpdateUserName ] []
            ]
        , div []
            [ button [ onClick FetchGithubUserDetails ]
                [ text "Fetch Details"
                ]
            ]
        , div []
            [ img [ src  (Maybe.withDefault "" model.avtar)  ] []
            , div []
                [ b [] [ text  (Maybe.withDefault "" model.name)  ]
                , text ", (@"
                , i [] [ text   model.user ]
                , text ")"
                , blockquote [] [ text (Maybe.withDefault "" model.bio) ]
                , div [] [ text ("Works at " ++ (Maybe.withDefault "" model.company) ++
                                                                                " in " ++ (Maybe.withDefault "" model.location)) ]
                , div [] [ text ("Website : " ++ (Maybe.withDefault "" model.blog)) ]
                ]
            ]
        ]

----------------------------------------------
  -- STYLE

inputDesign =
    style
        [ ( "font-size", "1.5em" )
        , ( "padding", "7px" )
        , ( "font-family", "Segoe UI" )
        ]

----------------------------------------------
  -- UPDATE
----------------------------------------------

type Msg
    = UpdateUserName String
    | FetchGithubUserDetails
    | OnHttpResponse (Result Http.Error Model)
    | GetModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchGithubUserDetails ->
            ( model, getGithubDetails model )

        OnHttpResponse (Ok model) ->
            ( model, Cmd.none )

        OnHttpResponse (Err _) ->
            ( model, Cmd.none )

        UpdateUserName newUser ->
            ( { model | user = newUser }, Cmd.none )

        GetModel ->
            ( model, Cmd.none )

----------------------------------------------
  -- HTTP
----------------------------------------------

getGithubDetails : Model -> Cmd Msg
getGithubDetails model =
    let
        url =
            "https://api.github.com/users/" ++   model.user
    in
        Http.send OnHttpResponse (Http.get url fetchDetails)


fetchDetails : Decode.Decoder Model
fetchDetails =
    decode Model
        |> required "login"  Decode.string
        |> optional "name" (Decode.map Just Decode.string) Nothing
        |> optional "avatar_url"  (Decode.map Just Decode.string) Nothing
        |> optional "bio" (Decode.map Just Decode.string) Nothing
        |> optional "company" (Decode.map Just Decode.string) Nothing
        |> optional "blog" (Decode.map Just Decode.string) Nothing
        |> optional "location" (Decode.map Just Decode.string) Nothing


----------------------------------------------------
-- SUBSCRIPTIONS
--------------------------------------------

subscription : Model -> Sub Msg
subscription model =
    Sub.none

------------------------------------------
init : String -> ( Model, Cmd Msg )
init user = ( Model user Nothing Nothing Nothing Nothing Nothing Nothing, getGithubDetails { user = "shubham4701",  name = Nothing, avtar = Nothing, bio = Nothing, company = Nothing, blog = Nothing, location = Nothing } )



-------------------------------------------------
main =
    program
        { init = init "shubham4701"
        , view = view
        , update = update
        , subscriptions = subscription
        }
