{-# LANGUAGE OverloadedStrings #-}
module ToDo (
     Tag(Current,Urgent,Repeat,Ignore,Context,Project)
    ,TodoEntry(TodoEntry)
    ,Recurrence
    ,TimeDate
    ,Line
    ,getText
    ,parseLine
    ,makeTag
    ,parseLineIntoTodo
        ) where
            
import qualified Data.Text as T
import qualified Data.Char as C
import Data.Attoparsec.Text
import Control.Applicative
import Data.Text

type Recurrence = String 
type TimeDate = String
type Line = Text

data Tag =  Current 
          | Urgent 
          | Repeat { interval :: Recurrence }
          | Ignore { until :: TimeDate }
          | Context { cName :: T.Text, cArgs :: T.Text } 
          | Project { pName :: T.Text } deriving (Show, Eq)

data TodoEntry = TodoEntry {
                     originalText :: Text,
                     tags :: [Tag],
                     indent :: Int
                     } deriving (Show, Eq)
                     
getText m = m.originalText

makeTag x = Context { cName = x, cArgs = "" }

data ParseElement = IndentCount Int | Description T.Text | PTag Tag deriving (Show)

current = do
    string "@CURRENT"
    return (PTag Current)
    

project = do 
    string "#"
    n <- takeWhile1 (inClass "A-Za-z_")
    return (PTag Project {pName = n} )

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
    return (PTag Context {cName = n, cArgs = b})


comment = do
    n <- takeWhile1 (not . inClass "@#")
    return (Description n)


myParser :: Parser ParseElement
myParser = current <|> project <|> tag <|> comment

indentCount = do
    x <- takeTill (not . C.isSpace)
    return (IndentCount (T.length x))
    

lineParser =  do
    i <- indentCount
    x <- many myParser
    return (i : x)

parseLineIntoTodo l = case parseLineIntoTodo' l of
    Left _ -> TodoEntry { originalText = "error", tags = [], indent =0}
    Right x -> x

parseLineIntoTodo' l = 
    case parsedLine of
       Left e -> Left e
       Right x -> Right (TodoEntry {originalText = l, tags = (Prelude.map mkTag (Prelude.filter isTag x)), indent = 0 })
    where 
        parsedLine = parseOnly lineParser l
        isTag (PTag _)  = True
        isTag _ = False
        mkTag (PTag x) = x
        
parseLine = parseLineIntoTodo          
