module Pomodoro exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
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
  | Run TaskData

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start task ->
      (Model (addTask task model.tasks) task.timeout, Cmd.none)

    TimesUp task ->
      (Model (updateTasks task model.tasks) task.timeout, Cmd.none)

    Tick newTime ->
      (Model model.tasks (updateTimeout model.currentTimeout), Cmd.none)

    Run taskData ->
      (model, Ports.run taskData)

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
      currentTimeout = newData.timeout
    in
      { task | currentTimeout = currentTimeout, runs = runs }
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
    (Task newData newData.timeout 0) :: tasks

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ (Ports.start Start)
  , (Ports.timesup TimesUp)
  , (Time.every second Tick)
  ]

-- VIEW

viewTask: Task -> Html Msg
viewTask task =
  let
      classNames = if task.currentTimeout > 0 then "task active" else "task"
      description = task.data.description
      runs = (toString task.runs)
      taskData = task.data
  in
    div [ (class classNames), (onClick (Run taskData)) ]
    [ span [ class "description" ] [ text description ]
    , span [ class "runs" ] [ text runs ]
    ]

viewTimeout: Model -> Html Msg
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

