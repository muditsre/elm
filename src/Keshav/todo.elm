import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main =
  Html.program{
    init =init
    , view = view
    , update = update
    , subscriptions = subscriptions
  }

subscriptions m =
  Sub.none

type alias Todo={
  id: Int
  , title: String
  , detail: String
}

type alias Model={
  todo: List Todo
  , currentTittle: String
  , currentDetail: String
  , currentid: Int
}

init =
  ( Model [] "" "" 0, Cmd.none )

view: Model->Html Msg
view model=
  div[][
    div[][
      --p[][ text <| toString <| model ]
      p[][
        span[][text "Title: "]
          , input[value model.currentTittle, onInput UpdateTitle][]
      ]
      , p[][
        span[][text "Detail: "]
        , textarea[value model.currentDetail, onInput UpdateDetail][]
      ]
      , p[][
        span[][text "Add: "]
        , button[onClick AddTodo][text "Add"]
        , button[onClick DeleteAll][text "Delete All"]
      ]

    ]
    , div[][
      p[][text "List of todo items: "]
      , div[][
        model.todo |> List.map(\x -> produceli x) |> ol[]
      ]
    ]
  ]

--produceli: Todo
produceli todo=  li[][
    p[][
      b[][
        text (todo.title++": ")
      ], text todo.detail
    ]
    , p[][
      button[onClick <|(DeleteTodo todo.id) ][text "Delete"]
      , button[onClick <|(EditTodo todo.id) ][text "Edit"]
    ]
  ]

type Msg=
    UpdateTitle String
    | UpdateDetail String
    | AddTodo
    | DeleteTodo Int
    | DeleteAll
    | EditTodo Int


update: Msg->Model->(Model, Cmd Msg)
update msg model=
    case msg of
        UpdateTitle t ->
            ({model | currentTittle=t }, Cmd.none)
        UpdateDetail d ->
            ({model | currentDetail=d }, Cmd.none)
        AddTodo ->
            if model.currentid == 0 then
              insertTodo model
            else
              updateTodo model
        DeleteTodo i ->
            deleteTodo i model
        DeleteAll  ->
            ({ model | todo=[]} , Cmd.none)
        EditTodo i ->
            editTodo i model

-- Insert todo
insertTodo: Model -> (Model, Cmd Msg)
insertTodo model=
    let
      firstelement=List.head model.todo
      newId = case firstelement of
              Just todo ->
                todo.id+1
              Nothing ->
                1
      newtodo={id=newId, title=model.currentTittle, detail=model.currentDetail}::model.todo
    in
      ({ model | todo=newtodo, currentTittle="", currentDetail="", currentid=0} , Cmd.none)

-- Update todo
updateTodo: Model -> (Model, Cmd Msg)
updateTodo model=
    let
      newtodo=List.map ( getUpdatedTodo model.currentid model.currentTittle model.currentDetail ) model.todo
      --newtodo={id=newId, title=model.currentTittle, detail=model.currentDetail}::model.todo
    in
      ({ model | todo=newtodo, currentTittle="", currentDetail="", currentid=0} , Cmd.none)

getUpdatedTodo: Int -> String -> String -> Todo -> Todo
getUpdatedTodo i t d todo =
    if i == todo.id then
      {todo| title=t, detail=d}
    else
      todo

--Delete function
deleteTodo: Int-> Model -> (Model, Cmd Msg)
deleteTodo id model=
  let
    newtodo=List.filter (removeid id) model.todo
  in
    ({ model | todo=newtodo} , Cmd.none)

removeid: Int -> Todo -> Bool
removeid id todo=
  if todo.id ==id then
    False
  else
    True

--Edit function
editTodo: Int -> Model -> (Model, Cmd Msg)
editTodo id model=
  let
    todoToEdit=List.filter (findCurrent id) model.todo
    toedit=List.head todoToEdit
    edittext = case toedit of
            Just todo ->
              {t=todo.title, d=todo.detail, i=todo.id}
            Nothing ->
              {t="", d="", i=0}
  in
    ({ model | currentTittle=edittext.t, currentDetail=edittext.d, currentid=edittext.i } , Cmd.none)

findCurrent: Int -> Todo -> Bool
findCurrent id todo=
  if todo.id ==id then
    True
  else
    False
