module ToDo (
     Tag(Current,Urgent,Repeat,Ignore,Context,Project)
    ,TodoEntry(TodoEntry)
    ,Recurrence
    ,TimeDate
    ,Line
    ,makeTag
        ) where

type Recurrence = String 
type TimeDate = String
type Line = String

data Tag =  Current 
          | Urgent 
          | Repeat { interval :: Recurrence }
          | Ignore { until :: TimeDate }
          | Context { name :: String } 
          | Project { name :: String } deriving (Show, Eq)

data TodoEntry = TodoEntry Line deriving (Show, Eq)

makeTag = Context
