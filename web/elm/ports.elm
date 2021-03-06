port module Ports exposing (..)

import Model exposing (..)

port start : (TaskData -> msg) -> Sub msg
port timesup : (TaskData -> msg) -> Sub msg
port run : TaskData -> Cmd msg
port requestStatus: () -> Cmd msg
port getStatus: (StatusData -> msg) -> Sub msg
port saveTasks: List PersistedTask -> Cmd msg
port getPersistedState: (List PersistedTask -> msg) -> Sub msg

