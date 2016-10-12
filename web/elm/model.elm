module Model exposing (..)

type alias Task =
  { description: String
  , timeout: Int
  }

type alias Model =
  { tasks: List Task
  , currentTimeout: Int
  }

init : (Model, Cmd msg)
init =
  (Model [] 0, Cmd.none)

