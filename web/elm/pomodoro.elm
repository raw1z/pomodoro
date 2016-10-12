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
  = Start TaskData
  | TimesUp TaskData
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

isSameTask : TaskData -> Task -> Bool
isSameTask taskData task =
  taskData.description == task.data.description

updateTask : TaskData -> Task -> Task
updateTask newData task =
  if (isSameTask newData task) then
    let
      runs = if newData.timeout == 0 then (task.runs + 1) else task.runs
    in
      { task | data = newData, runs = runs }
  else
    task

updateTasks : TaskData -> List Task -> List Task
updateTasks newData tasks =
  let
      updateThis : Task -> Task
      updateThis = updateTask newData
  in
      List.map updateThis tasks

addTask : TaskData -> List Task -> List Task
addTask newData tasks =
  if List.any (isSameTask newData) tasks then
     updateTasks newData tasks
  else
    (Task newData 0) :: tasks

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
  let
      classNames = if task.data.timeout > 0 then "task active" else "task"
      description = task.data.description
      runs = (toString task.runs)
  in
    div [ (class classNames) ]
    [ span [ class "description" ] [ text description ]
    , span [ class "runs" ] [ text runs ]
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

