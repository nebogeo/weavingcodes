{-# LANGUAGE TypeSynonymInstances, FlexibleInstances,OverlappingInstances #-}

module Behaviour where

import Data.List
import Control.Concurrent (threadDelay)

data Action = Pull Int | TurnIn | TurnOut | Over | Under

data Move = TurnLeft | TurnRight | Straight
instance Show Move where
  show TurnLeft = "turn left"
  show TurnRight = "turn right"
  show Straight = "straight"

instance Show Action where
  show (Pull n) = "pull " ++ show n
  show TurnIn = "turn in"
  show TurnOut = "turn out"
  show Over = "over"
  show Under = "under"

type Weave = [Action]

type Grid = [[String]]
instance Show Grid
   where show g = concat $ intercalate ["\n"] g

type Position = (Int,Int)
data Direction = L | R | U | D
instance Show Direction
   where show L = "left"
         show R = "right"
         show U = "up"
         show D = "down"

-- grid, position, last turn, direction
type State = (Grid,Position,Move,Direction)
instance Show State
   where show (g,p,m,d) = show g ++ "\n" ++ show p ++ ", " ++ show m ++ ", "
                            ++ show d ++ ", "

--tabby = [Pull 2,TurnBack,Turn R,Pull 2,Turn L,Turn L,Turn L,
--         Under,Over,Turn R,Turn R,Under,Over]

warp :: Int -> Int -> Weave
warp n l = take (n*3) $ cycle [Pull l,TurnOut,TurnIn]

thread :: [Action] -> Int -> Int -> Weave
thread _ 0 _ = []
thread _ _ 0 = []
thread actions l r = take l (cycle actions) ++ [TurnOut,TurnIn] ++ thread (take (length actions) $ drop l (cycle actions)) l (r-1)

threadWeftBy :: ([Action] -> [Action]) -> [Action] -> Int -> Int -> Weave
threadWeftBy _ _ 0 _ = []
threadWeftBy _ _ _ 0 = []
threadWeftBy f actions l r =
  take l (cycle actions) ++ [TurnOut,TurnIn] ++ threadWeftBy f (take (length actions) $ drop l (cycle $ f $ reverse $ actions)) l (r-1)

threadWeftBy' :: [[Action] -> [Action]] -> [[Action]] -> Int -> Int -> Weave
threadWeftBy' _ _ 0 _ = []
threadWeftBy' _ _ _ 0 = []
threadWeftBy' (f:fs) (actions:actionss) l r =
  take l (cycle actions) ++ [TurnOut,TurnIn] ++ threadWeftBy' (fs ++ [f]) (actionss ++ [take (length actions) $ drop l $ (cycle $ reverse $ f $ actions)]) l (r-1)

rotate :: Int -> [a] -> [a]
rotate 0 xs = xs
rotate n xs | n >= 0 = rotate (n-1) $ tail xs ++ [head xs]
            | otherwise = rotate (n+1) $ reverse $ tail (reverse xs) ++ [head $ reverse xs]

tabby :: Int -> Int -> Weave
tabby h w = warp h w ++ [TurnIn] ++ thread ([Over,Under]) h w

twill = threadWeftBy (rotate 1)

twill4 w h = warp h w ++ [TurnIn] ++ twill ([Over,Over,Under,Under]) w h

satin w h = warp h w ++ [TurnIn] ++ threadWeftBy' [drop 4,drop 1] ([pat, reverse (rotate 2 pat)]) w h
  where pat = [Over,Under,Under,Under,Under]

-- trace w h = start w h
--   where 

follow :: State -> Action -> State

follow state (Pull 0) = state

follow (grid, (x,y), move, D) (Pull n) = follow state' (Pull (n-1))
  where state' = (setGridElem grid (x,y) (" | "), (x,y+1),move,D)
follow (grid, (x,y), move, U) (Pull n) = follow state' (Pull (n-1))
  where state' = (setGridElem grid (x,y) (" | "), (x,y-1),move,U)
follow (grid, (x,y), move, L) (Pull n) = follow state' (Pull (n-1))
  where state' = (setGridElem grid (x,y) ("---"), (x-1,y),move,L)
follow (grid, (x,y), move, R) (Pull n) = follow state' (Pull (n-1))
  where state' = (setGridElem grid (x,y) ("---"), (x+1,y),move,R)

follow (grid, coords, move, direction) Over =
  (grid', m coords direction, move, direction)
  where grid' = withGridElem grid coords (superimpose (straight direction))

follow (grid, coords, move, direction) Under =
  (grid', m coords direction, move, direction)
  where grid' = withGridElem grid coords ((flip superimpose) (straight direction))

follow (grid, coords@(x,y), move, direction) TurnIn = (grid', m coords direction', move, direction')
  where grid' = setGridElem grid coords (turn direction move)
        direction' = changeDirection direction move
        
follow (grid, coords@(x,y), move, direction) TurnOut = (grid', m coords direction', move', direction')
  where move' = flipMove move
        grid' = setGridElem grid coords (turn direction move')
        direction' = changeDirection direction move'

follows :: State -> [Action] -> State
follows state [] = state
follows state (a:as) = follows (follow state a) as

followsIO :: State -> [Action] -> IO State
followsIO state [] = return state
followsIO state (a:as) = do let (g, _, _, _) = state
                            putStrLn $ show g
                            threadDelay 100000
                            state' <- followsIO (follow state a) as
                            return state'

changeDirection :: Direction -> Move -> Direction
changeDirection U TurnLeft  = L
changeDirection U TurnRight = R
changeDirection D TurnLeft  = R
changeDirection D TurnRight = L
changeDirection L TurnLeft  = D
changeDirection L TurnRight = U
changeDirection R TurnLeft  = U
changeDirection R TurnRight = D

flipMove TurnLeft  = TurnRight
flipMove TurnRight = TurnLeft
flipMove Straight  = Straight

m :: Position -> Direction -> Position
m (x,y) U = (x,y-1)
m (x,y) D = (x,y+1)
m (x,y) L = (x-1,y)
m (x,y) R = (x+1,y)

straight :: Direction -> String
straight U = " | "
straight D = " | "
straight L = "---"
straight R = "---"

turn :: Direction -> Move -> String
turn R TurnLeft  = "-' "
turn R TurnRight = "-. "
turn L TurnRight = " `-"
turn L TurnLeft  = " .-"
turn D TurnLeft  = " `-"
turn D TurnRight = "-' "
turn U TurnLeft  = "-. "
turn U TurnRight = " .-"

setElem :: [a] -> Int -> a -> [a]
setElem xs i x = take (i) xs ++ [x] ++ drop (i+1) xs

setGridElem :: [[a]] -> (Int,Int) -> a -> [[a]]
setGridElem g (x,y) a = setElem g y (setElem (g !! y) x a)

withGridElem :: [[a]] -> (Int,Int) -> (a -> a) -> [[a]]
withGridElem g (x,y) f = setElem g y (setElem (g !! y) x a)
  where a = f ((g !! y) !! x) 

start w h = (grid w h,(0,0),TurnOut,D)

grid w h = take h (repeat (take w (repeat "   ")))

superimpose :: String -> String -> String
superimpose "---" " | " = "-#-"
superimpose " | " "---" = "-+-"
superimpose   a   "   " = a
superimpose "   "   a   = a
superimpose   _     _   = "xxx"

draw n = follows (grid n n, (1,1), TurnRight, D)

drawIO n = followsIO (grid n n, (1,1), TurnRight, D)
