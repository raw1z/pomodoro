module Pomodoro exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Model exposing (..)
import Ports
import Debug exposing (..)
import String
import Time exposing (Time, second)

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
  | Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg {tasks, currentTimeout} =
  case msg of
    Start task ->
      (Model (addTask task tasks) task.timeout, Cmd.none)

    TimesUp task ->
      (Model (updateTasks task tasks) task.timeout, Cmd.none)

    Tick newTime ->
      (Model tasks (updateTimeout currentTimeout), Cmd.none)

updateTimeout : Int -> Int
updateTimeout currentTimeout =
  let
      timeout = currentTimeout - 1000
  in
    if timeout < 0 then
       0
    else
      timeout

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
  , (Time.every second Tick)
  ]

-- VIEW

viewTask: Task -> Html msg
viewTask task =
  if task.timeout > 0 then
    div [ (class "task active") ] [ text task.description ]
  else
    div [ (class "task") ]
      [ text task.description
      ]

viewTimeout: Model -> Html msg
viewTimeout model =
  let
      timeoutInSeconds = model.currentTimeout // 1000
      minutes = timeoutInSeconds // 60
      seconds = timeoutInSeconds - minutes * 60
      label = (String.pad 2 '0' (toString minutes)) ++ ":" ++ (String.pad 2 '0' (toString seconds))
  in
    div [ (class "timeout") ]
      [ text label
      ]

view : Model -> Html Msg
view model =
  div []
    [ (viewTimeout model)
    , div [ class "tasks" ] (List.map viewTask model.tasks)
    ]

