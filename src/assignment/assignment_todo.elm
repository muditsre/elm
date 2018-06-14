import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List

--- Define Main
main =
      Html.program{
      init = init
      ,view = view
      ,update = update
      ,subscriptions = subscriptions
    }
----------------------------------------------------
subscriptions:Model -> Sub Msg
subscriptions model =
      Sub.none

----------------------------------------------------
--Alias TodoOutPut
type alias TodoOutPut = {
      uid : Int
    ,title:String
    ,description : String
}
--Alias Model
type alias Model = {
         uid : Int
        ,title:String
        ,description : String
        ,todoOutPut :List TodoOutPut
    }


---init
init: (Model , Cmd Msg)
init = (Model 0 "" "" [] , Cmd.none )


--View
view: Model->Html Msg
view model=
        div[style [ ( "padding-left", "20px" ) ] ]
            [
              div[][
              h1[][text "TO DO List"]
              ]
              ,div[]
                  [
                  div[][
                        div[][
                            table[][
                              tr[][
                                td[][label[][text "Title: "]]
                                ,td[][input[ placeholder "Enter Title here", value model.title, onInput UpdateTitle ][]]
                              ]
                              ,tr[][
                                td[][label[][text "Description: "]]
                                ,td[][textarea [ cols 30, rows 5,  placeholder "Enter Description here", value model.description , onInput UpdateDescription ] [ ]]
                               ]
                              ,tr[][
                                td[][button [onClick SaveToDo  ][text "SAVE TO LIST"]]
                              ]
                             ]
                        ]
                        ,div[][
                            p[][
                            h2[  style [ ( "float", "left") ,("margin" , "0 10px") ] ][text "List"]
                            ,a[ href "javascript:;", onClick DeleteAll ][text "Delete All"]
                            ]
                            ,p[][
                                if List.isEmpty model.todoOutPut then
                                  p[][text("No Record Found....!!!!")]
                               else
                                model.todoOutPut
                                |> List.map (\x -> gettodo x)
                                |> ol[ inputDesign ]
                              ]
                      ]
                  ]
              ]
          ]
--
inputDesign =
    style
        [ ( "font-size", "15px" )
          , ( "width", "100%" )
        , ( "font-family", "Segoe UI" )
        ]
inputDesignTr =
  style  [
    ( "width", "100%" )
    ,( "padding", "7px" )
  ]
--------------------------------------
gettodo:TodoOutPut  ->  Html Msg
gettodo x =
  li[][
      -- span[inputDesignTr][ text(toString(x.uid)) ]
      span[inputDesignTr][ text(x.title) ]
      ,span[inputDesignTr][ text(x.description) ]
      ,span[inputDesignTr][ a[ href "javascript:;", onClick (EditToDo x.uid) ][text "Edit"] ]
      ,span[inputDesignTr][ a[ href "javascript:;", onClick (Delete x.uid) ][text "X"] ]
   ]
--- type MSG
type Msg = SaveToDo
         | UpdateTitle String
         | UpdateDescription String
         | Delete Int
         | DeleteAll
         | EditToDo Int

update msg model=
      case msg of
            SaveToDo ->
               (getNewToDoList model )
            DeleteAll ->
              (deleteAllToDo model )
            UpdateTitle newtodoTitle ->
                 ({model | title = newtodoTitle } , Cmd.none)
            UpdateDescription newTodoDescription ->
                ({model | description =  newTodoDescription } , Cmd.none)
            Delete  uid ->
              ({ model | todoOutPut = deleteFromToDoList uid model }, Cmd.none)
            EditToDo  uid ->
                 ( editData uid model   )


 -----------------------------------------------
-- getNewToDoList

getNewToDoList :  Model -> (Model, Cmd Msg)
getNewToDoList model =
  let
      newTodoList = getToDoList  model
 in
    ({model | todoOutPut = newTodoList ,title = "", description = "", uid=0   } , Cmd.none)


-- getToDoList
----------------------------------------------
getToDoList: Model  -> List TodoOutPut
getToDoList model  =
              if model.uid > 0 then
                  model.todoOutPut
                  |> List.map (\todo_output -> updateToDo model todo_output )
              else
                  saveToDoList model


-----------------------------------------------
-- saveToDoList
----------------------------------------------
saveToDoList:Model -> List TodoOutPut
saveToDoList model =
  {
  uid = (Maybe.withDefault  (TodoOutPut 0 "" "")  (List.head model.todoOutPut)).uid+1
  ,title=model.title
  ,description=model.description
  }::model.todoOutPut


-----------------------------------------------
-- editData

editData :Int->  Model -> (Model, Cmd Msg)
editData uid model =
    let
      newmodel = List.filter (\t -> t.uid == uid) model.todoOutPut
                  |> List.head
                  |> Maybe.withDefault (TodoOutPut 0 "" "")
    in
      ({ model | uid = newmodel.uid , title = newmodel.title, description=newmodel.description   } , Cmd.none)



-- updateToDo
----------------------------------------------
updateToDo:Model -> TodoOutPut ->  TodoOutPut
updateToDo  model todo_output =
  if todo_output.uid == model.uid then
       { todo_output | title=model.title, description=model.description  }
  else
        todo_output

-----------------------------------------------
-- deleteFromToDo
----------------------------------------------
deleteFromToDoList:Int -> Model -> List TodoOutPut
deleteFromToDoList  uid model =
    let
      todoouput =  List.filter (\t -> t.uid /= uid) model.todoOutPut
   in
     todoouput
-----------------------------------------------
-- deleteAllToDo
----------------------------------------------
deleteAllToDo:  Model -> (Model, Cmd Msg)
deleteAllToDo model=
  ({model | todoOutPut = []   } , Cmd.none)
