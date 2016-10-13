module Model exposing (..)

type alias TaskData =
  { description: String
  , timeout: Int
  }

type alias Task =
  { data: TaskData
  , currentTimeout: Int
  , runs: Int
  }

type alias Model =
  { tasks: List Task
  , currentTimeout: Int
  }

init : (Model, Cmd msg)
init =
  (Model [] 0, Cmd.none)

