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

init : (Model, Cmd msg)
init =
  (Model [] 0, Ports.requestStatus())

-- UPDATE

type Msg
  = Start TaskData
  | TimesUp TaskData
  | Tick Time
  | Run TaskData
  | ResetCount TaskData
  | Status StatusData
  | Restore (List TaskData)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Start task ->
      let
          newTasks = (addTask task model.tasks)
          newTaskData = List.map (\t -> t.data) newTasks
      in
        (Model newTasks task.timeout, Ports.saveTasks newTaskData)

    TimesUp task ->
      let
          newTasks = (updateTasks updateTaskFromBackend task model.tasks)
          newTaskData = List.map (\t -> t.data) newTasks
      in
        (Model newTasks task.timeout, Ports.saveTasks newTaskData)

    Tick newTime ->
      (Model model.tasks (updateTimeout model.currentTimeout), Cmd.none)

    Run taskData ->
      if model.currentTimeout == 0 then
        (model, Ports.run taskData)
      else
        (model, Cmd.none)

    ResetCount task ->
      let
          newTasks = (updateTasks resetTaskRuns task model.tasks)
          newTaskData = List.map (\t -> t.data) newTasks
      in
        (Model newTasks model.currentTimeout, Ports.saveTasks newTaskData)

    Status statusData ->
      let
          newTasks = (addTask statusData.task model.tasks)
          newTaskData = List.map (\t -> t.data) newTasks
      in
        (Model newTasks statusData.remainingTime, Ports.saveTasks newTaskData)

    Restore tasks ->
      let
          newTasks = List.map (\newData -> (Task newData 0 0)) tasks
      in
        (Model newTasks 0, Cmd.none)

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

resetTaskRuns : TaskData -> Task -> Task
resetTaskRuns newData task =
  if (isSameTask newData task) then
    { task | runs = 0 }
  else
    task

updateTaskFromBackend : TaskData -> Task -> Task
updateTaskFromBackend newData task =
  if (isSameTask newData task) then
    let
      runs = if newData.timeout == 0 then (task.runs + 1) else task.runs
      currentTimeout = newData.timeout
    in
      { task | currentTimeout = currentTimeout, runs = runs }
  else
    task

updateTasks : (TaskData -> Task -> Task) -> TaskData -> List Task -> List Task
updateTasks modifier newData tasks =
  let
      updateThis : Task -> Task
      updateThis = modifier newData
  in
      List.map updateThis tasks

addTask : TaskData -> List Task -> List Task
addTask newData tasks =
  if List.any (isSameTask newData) tasks then
     updateTasks updateTaskFromBackend newData tasks
  else
    (Task newData newData.timeout 0) :: tasks

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ (Ports.start Start)
  , (Ports.timesup TimesUp)
  , (Ports.getStatus Status)
  , (Time.every second Tick)
  , (Ports.getPersistedState Restore)
  ]

-- VIEW

formatTime: Int -> String
formatTime time =
  String.pad 2 '0' (toString time)

formatTaskElapsedTime: Task -> String
formatTaskElapsedTime task =
  let
      elapsedTime = (task.runs * (task.data.timeout // 1000))
      hour = elapsedTime // 36000
      minutes = (elapsedTime - hour*3600) // 60
      seconds = (elapsedTime - hour*3600 - minutes*60)
  in
     if hour > 0 then
      (toString hour) ++ "h " ++ (toString minutes) ++ "min " ++ (toString seconds) ++ "s"
     else
       if minutes > 0 then
         if seconds == 0 then
            (toString minutes) ++ "min"
         else
           (toString minutes) ++ "min " ++ (toString seconds) ++ "s"
       else
         (toString seconds) ++ "s"

viewTaskDescription: Task -> Html Msg
viewTaskDescription task =
  let
      description = task.data.description
      taskData = task.data
  in
    span [ (class "description") ]
      [ span [ (class "description-label"), (onClick (Run taskData)) ] [ text description ]
      , span [ class "description-elapsed-time"] [ text (formatTaskElapsedTime task) ]
      , span [ class "description-runs", (onClick (ResetCount taskData)) ] [ text (toString task.runs) ]
      ]

isTaskActive: Task -> Bool
isTaskActive task =
  (task.currentTimeout > 0)

viewTaskActions: Task -> Html Msg
viewTaskActions task =
  if isTaskActive(task) then
     a [ class "task-btn cancel-btn" ] [ text "cancel" ]
  else
     a [ class "task-btn archive-btn" ] [ text "archive" ]

viewTask: Task -> Html Msg
viewTask task =
  let
      classNames = if isTaskActive(task) then "task active" else "task"
  in
    div [ class classNames ]
      [ viewTaskDescription task
      , viewTaskActions task
      ]

viewTimeout: Model -> Html Msg
viewTimeout model =
  let
      timeoutInSeconds = model.currentTimeout // 1000
      minutes = timeoutInSeconds // 60
      seconds = timeoutInSeconds - minutes * 60
      label =
        if minutes == 0 && seconds == 0 then
          "--:--"
        else
          (formatTime minutes) ++ ":" ++ (formatTime seconds)
  in
    div [ (class "timeout") ]
      [ text label
      ]

view : Model -> Html Msg
view model =
  let
      nonActiveTasks = List.filter (\task -> isTaskActive(task) == False) model.tasks
      activeTasks = (List.filter isTaskActive model.tasks)
  in
    div [ class "app-content" ]
      [ (viewTimeout model)
      , div [ class "active-task" ] (List.map viewTask activeTasks)
      , div [ class "tasks" ] (List.map viewTask nonActiveTasks)
      ]

