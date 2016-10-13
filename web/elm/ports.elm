port module Ports exposing (..)

import Model exposing (..)

port start : (TaskData -> msg) -> Sub msg
port timesup : (TaskData -> msg) -> Sub msg
port run : TaskData -> Cmd msg

