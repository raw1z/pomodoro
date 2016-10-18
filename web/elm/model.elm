module Model exposing (..)

type alias StatusData =
  { remainingTime: Int
  , task: TaskData
  }

type alias TaskData =
  { description: String
  , timeout: Int
  }

type alias PersistedTask =
  { data: TaskData
  , runs: Int
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

