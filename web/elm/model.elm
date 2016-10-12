module Model exposing (..)

type alias Task =
  { description: String
  , timeout: Int
  }

type alias Model =
  { tasks: List Task
  }

init : (Model, Cmd msg)
init =
  (Model [], Cmd.none)

