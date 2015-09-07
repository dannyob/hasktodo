{-# LANGUAGE OverloadedStrings #-}
module ToDo (
     Tag(Current,Urgent,Repeat,Ignore,Context,Project)
    ,TodoEntry(TodoEntry,originalText,tags,indent)
    ,Recurrence
    ,TimeDate
    ,Line
    ,parseLine
        ) where

import           Control.Applicative
import           Control.Monad.State
import           Data.Attoparsec.Text
import qualified Data.Char            as C
import           Data.Text
import qualified Data.Text            as T

type Recurrence = T.Text
type TimeDate = T.Text
type Line = T.Text

data Tag =  Current
          | Urgent
          | Repeat { rInterval :: Recurrence }
          | Ignore { iUntil :: TimeDate }
          | Context { cName :: T.Text, cArgs :: T.Text }
          | Project { pName :: T.Text }
          deriving (Show, Eq)

data TodoEntry = TodoEntry {
                     originalText :: Text,
                     tags         :: [Tag],
                     indent       :: Int
                     } deriving (Show, Eq)

parseProject = do
    _ <- string "#"
    n <- takeWhile1 (inClass "A-Za-z_")
    return [Project {pName = n}]

parseArgs = do
    _ <- string "("
    a <- takeWhile1 (/= ')' )
    _ <- string ")"
    return a
    <|> return ""

parseTag = do
    _ <- string "@"
    n <- takeWhile1 (inClass "A-Za-z_")
    b <- parseArgs
    case n of
        "CURRENT"-> return [Current]
        "URGENT" -> return [Urgent]
        "IGNORE" -> return [Ignore {iUntil=b}]
        "REPEAT" -> return [Repeat {rInterval=b}]
        _ -> return [Context {cName = n, cArgs = b}]

parseComment = do
    n <- takeWhile1 (not . inClass "@#")
    return []

indentCount = do
    x <- takeTill (not . C.isSpace)
    return (T.length x)

addTag :: Tag -> TodoEntry -> TodoEntry
addTag a b = b { tags = a : tags b }

storeIndent :: Int -> TodoEntry -> TodoEntry
storeIndent a b = b { indent = a }

parseLine :: Text -> TodoEntry
parseLine l = parseLineHelper $ parseOnly (runStateT parseLine' TodoEntry { indent = 0, originalText = l, tags = []}) l
              where
              parseLineHelper (Right (_,b)) = b
              parseLineHelper (Left _) = TodoEntry { indent = 0, originalText = "Error", tags = []}
              parseLine' :: StateT TodoEntry Parser ()
              parseLine' = do
                  i <- lift indentCount
                  modify (storeIndent i)
                  _ <- many parseTags
                  pure ()

parseTags :: StateT TodoEntry Parser ()
parseTags = do
    a <- lift parseProject  <|> lift parseTag <|> lift parseComment
    case a of
        [t] -> modify (addTag t)
        _ -> pure ()
    pure ()
