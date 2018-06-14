import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing(..)
import Task

main =
  Html.program {
    init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
  }

-- subscriptions
subscriptions: Model-> Sub Msg
subscriptions model =
  Sub.none
type alias Model = {
      yearList: List Int
  }
init = (Model [], genrateTask)



genrateTask: Cmd Msg
genrateTask =
  Cmd.batch [ Task.perform identity (Task.succeed GetYearList) ]

view model=
  div[][
      h1[][text "Here is the list of next 20 leap years."]
      , div[][
          model.yearList
          |> List.map (\x -> getLiList x)
          |> ul[]
      ]
  ]

--getLiList: String -> Html
getLiList year=
  li[][ text(toString(year)) ]

type Msg = GetYearList
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      GetYearList ->
        nextyear model

nextyear: Model -> (Model, Cmd Msg)
nextyear model=
  let
    yearList = getleapyeat 2018 []
  in
    ({model| yearList=yearList }, Cmd.none)

getleapyeat: Int -> List Int -> List Int
getleapyeat year listofyear =
  let
    newlist = getUpdatedList year listofyear
  in
    if List.length newlist < 20 then
      getleapyeat (year+1) newlist
    else
      newlist

getUpdatedList: Int -> List Int -> List Int
getUpdatedList year listofyear =
   if isleap year then
    year::listofyear
   else
    listofyear
----------------------------------------
isleap: Int -> Bool
isleap year =
  if year % 4 == 0 then
    if year % 100 /= 0 then
      True
    else
      False
  else
    if year % 400 == 0 then
      True
    else
      False
