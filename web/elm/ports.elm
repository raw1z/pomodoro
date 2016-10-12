port module Ports exposing (..)

import Model exposing (..)

port start : (Task -> msg) -> Sub msg
port timesup : (Task -> msg) -> Sub msg

