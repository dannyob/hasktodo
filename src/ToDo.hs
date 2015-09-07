{-# LANGUAGE OverloadedStrings #-}
module ToDo (
     Tag(Current,Urgent,Repeat,Ignore,Context,Project)
    ,TodoEntry(TodoEntry,originalText,tags,indent)
    ,Recurrence
    ,TimeDate
    ,Line
    ,parseLine
    ,makeTag
        ) where
            
import qualified Data.Text as T
import qualified Data.Char as C
import Data.Attoparsec.Text
import Control.Applicative
import Control.Monad.State
import Data.Text

type Recurrence = String 
type TimeDate = String
type Line = Text

data Tag =  Current 
          | Urgent 
          | Repeat { interval :: Recurrence }
          | Ignore { until :: TimeDate }
          | Context { cName :: T.Text, cArgs :: T.Text } 
          | Project { pName :: T.Text } 
          deriving (Show, Eq)

data TodoEntry = TodoEntry {
                     originalText :: Text,
                     tags :: [Tag],
                     indent :: Int
                     } deriving (Show, Eq)
                     
makeTag x = Context { cName = x, cArgs = "" }

current = do
    string "@CURRENT"
    return [Current]
 
project = do 
    string "#"
    n <- takeWhile1 (inClass "A-Za-z_")
    return [Project {pName = n}]

args = do
    string "("
    a <- takeWhile1 (/= ')' )
    string ")"
    return a
    <|> return ""
   
tag = do
    string "@"
    n <- takeWhile1 (inClass "A-Za-z_")
    b <- args
    return [Context {cName = n, cArgs = b}]

comment = do
    n <- takeWhile1 (not . inClass "@#")
    return []

indentCount = do
    x <- takeTill (not . C.isSpace)
    return (T.length x)

addTags :: [Tag] -> TodoEntry -> TodoEntry
addTags a b = b { tags = a ++ tags b }

addTag :: Tag -> TodoEntry -> TodoEntry
addTag a b = b { tags = a : tags b }

storeIndent :: Int -> TodoEntry -> TodoEntry
storeIndent a b = b { indent = a }

parseLine l = parseOnly (runStateT parseLine' TodoEntry { indent = 0, originalText = l, tags = []}) l

parseLine' :: StateT TodoEntry Parser ()
parseLine' = do
    i <- lift indentCount
    (modify (storeIndent i))
    many parseTags
    pure ()

parseTags :: StateT TodoEntry Parser ()
parseTags = do
    a <- (lift current  <|> lift project  <|> lift tag <|> lift comment)
    case a of
        [t] -> (modify (addTag t))
        _ -> pure ()
    pure ()
