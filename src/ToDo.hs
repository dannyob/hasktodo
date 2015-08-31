module ToDo (
     Tag(Current,Urgent,Repeat,Ignore,Context,Project)
    ,TodoEntry(TodoEntry)
    ,Recurrence
    ,TimeDate
    ,Line
    ,makeTag
    ,getText
    ,parseLineIntoTodo
        ) where

import Data.Text

type Recurrence = String 
type TimeDate = String
type Line = Text

data Tag =  Current 
          | Urgent 
          | Repeat { interval :: Recurrence }
          | Ignore { until :: TimeDate }
          | Context { name :: String } 
          | Project { name :: String } deriving (Show, Eq)

data TodoEntry = TodoEntry Text deriving (Show, Eq)

makeTag = Context

parseLineIntoTodo :: Text -> TodoEntry
parseLineIntoTodo s = TodoEntry (strip s)

getText (TodoEntry l) = l
