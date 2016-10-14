port module Ports exposing (..)

import Model exposing (..)

port start : (TaskData -> msg) -> Sub msg
port timesup : (TaskData -> msg) -> Sub msg
port run : TaskData -> Cmd msg
port requestStatus: () -> Cmd msg
port getStatus: (StatusData -> msg) -> Sub msg
port saveTasks: List TaskData -> Cmd msg
port getPersistedState: (List TaskData -> msg) -> Sub msg

