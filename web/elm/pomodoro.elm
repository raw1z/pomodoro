module Pomodoro exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Model exposing (..)
import Ports
import Debug exposing (..)

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- UPDATE

type Msg
  = Start Task
  | TimesUp Task

update : Msg -> Model -> (Model, Cmd Msg)
update msg {tasks} =
  case msg of
    Start task ->
      (Model (addTask task tasks), Cmd.none)

    TimesUp task ->
      (Model (updateTasks task tasks), Cmd.none)

isSameTask : Task -> Task -> Bool
isSameTask task1 task2 =
  task1.description == task2.description

updateTask : Task -> Task -> Task
updateTask newData task =
  if (isSameTask newData task) then
    newData
  else
    task

updateTasks : Task -> List Task -> List Task
updateTasks newData tasks =
  let
      updateThis : Task -> Task
      updateThis = updateTask newData
  in
      List.map updateThis tasks

addTask : Task -> List Task -> List Task
addTask newTask tasks =
  if List.any (isSameTask newTask) tasks then
     updateTasks newTask tasks
  else
    newTask :: tasks

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ (Ports.start Start)
  , (Ports.timesup TimesUp)
  ]

-- VIEW

activeTaskStyle : Attribute msg
activeTaskStyle =
  style
    [ ("color", "red")
    , ("font-weight", "900")
    ]

taskStyle : Attribute msg
taskStyle =
  style
    [ ("color", "#222")
    , ("font-weight", "400")
    ]

viewTask: Task -> Html msg
viewTask task =
  if task.timeout > 0 then
    div [ activeTaskStyle ] [ text task.description ]
  else
    div [ taskStyle ] [ text task.description ]

view : Model -> Html Msg
view model =
  div [] (List.map viewTask model.tasks)

