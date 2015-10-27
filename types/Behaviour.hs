{-# LANGUAGE TypeSynonymInstances, FlexibleInstances,OverlappingInstances, NoMonomorphismRestriction #-}


module Behaviour where

import Data.List
import Control.Concurrent (threadDelay)

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine


-- | The weaving actions that we are representing.
-- @Pull@ takes the thread in the current direction, by the given number of units.
-- @TurnIn@ turns the thread 90 degrees, in the same direction as the last turn.
-- @TurnOut@ turns the thread 90 degrees, in the opposite direction as the last turn.

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
data Dir = L | R | U | D
instance Show Dir
   where show L = "left"
         show R = "right"
         show U = "up"
         show D = "down"

-- grid, position, last turn, direction
type State = (Grid,Position,Move,Dir)
instance Show State
   where show (g,p,m,d) = show g ++ "\n" ++ show p ++ ", " ++ show m ++ ", "
                            ++ show d ++ ", "

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
  take l (cycle actions)
  ++ [TurnOut,TurnIn]
  ++ threadWeftBy' (fs ++ [f])
                   (actionss ++ [take (length actions) $ drop l $ (cycle $ reverse $ f $ actions)])
                   l (r-1)

rot :: Int -> [a] -> [a]
rot 0 xs = xs
rot n xs | n >= 0 = rot (n-1) $ tail xs ++ [head xs]
         | otherwise = rot (n+1) $ reverse $ tail (reverse xs) ++ [head $ reverse xs]

tabby :: Int -> Int -> Weave
tabby h w = warp h w ++ [TurnIn] ++ thread ([Over,Under]) h w

twill = threadWeftBy (rot 1)

twill4 w h = warp h w ++ [TurnIn] ++ twill ([Over,Over,Under,Under]) w h

satin w h = warp h w ++ [TurnIn] ++ threadWeftBy' [drop 4,drop 1] ([pat, reverse (rot 2 pat)]) w h
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
  where grid' = withGridElem grid coords (superimpose (straightLine direction))

follow (grid, coords, move, direction) Under =
  (grid', m coords direction, move, direction)
  where grid' = withGridElem grid coords ((flip superimpose) (straightLine direction))

follow (grid, coords@(x,y), move, direction) TurnIn = (grid', m coords direction', move, direction')
  where grid' = setGridElem grid coords (turnLine direction move)
        direction' = changeDir direction move
        
follow (grid, coords@(x,y), move, direction) TurnOut = (grid', m coords direction', move', direction')
  where move' = flipMove move
        grid' = setGridElem grid coords (turnLine direction move')
        direction' = changeDir direction move'

follows :: State -> [Action] -> State
follows = foldl follow

followsIO :: State -> [Action] -> IO State
followsIO state [] = return state
followsIO state (a:as) = do let (g, _, _, _) = state
                            putStrLn $ show g
                            threadDelay 100000
                            state' <- followsIO (follow state a) as
                            return state'

changeDir :: Dir -> Move -> Dir
changeDir U TurnLeft  = L
changeDir U TurnRight = R
changeDir D TurnLeft  = R
changeDir D TurnRight = L
changeDir L TurnLeft  = D
changeDir L TurnRight = U
changeDir R TurnLeft  = U
changeDir R TurnRight = D

flipMove TurnLeft  = TurnRight
flipMove TurnRight = TurnLeft
flipMove Straight  = Straight

m :: Position -> Dir -> Position
m (x,y) U = (x,y-1)
m (x,y) D = (x,y+1)
m (x,y) L = (x-1,y)
m (x,y) R = (x+1,y)

straightLine :: Dir -> String
straightLine U = " | "
straightLine D = " | "
straightLine L = "---"
straightLine R = "---"

turnLine :: Dir -> Move -> String
turnLine R TurnLeft  = "-' "
turnLine R TurnRight = "-. "
turnLine L TurnRight = " `-"
turnLine L TurnLeft  = " .-"
turnLine D TurnLeft  = " `-"
turnLine D TurnRight = "-' "
turnLine U TurnLeft  = "-. "
turnLine U TurnRight = " .-"

setElem :: [a] -> Int -> a -> [a]
setElem xs i x = take (i) xs ++ [x] ++ drop (i+1) xs

setGridElem :: [[a]] -> (Int,Int) -> a -> [[a]]
setGridElem g (x,y) a = setElem g y (setElem (g !! y) x a)

withGridElem :: [[a]] -> (Int,Int) -> (a -> a) -> [[a]]
withGridElem g (x,y) f = setElem g y (setElem (g !! y) x a)
  where a = f ((g !! y) !! x) 

-- start w h = (grid w h,(0,0),TurnOut,D)

grid w h = take h (repeat (take w (repeat "   ")))

superimpose :: String -> String -> String
superimpose "---" " | " = "-#-"
superimpose " | " "---" = "-+-"
superimpose   a   "   " = a
superimpose "   "   a   = a
superimpose   _     _   = "xxx"

draw n = follows (grid n n, (1,1), TurnRight, D)

drawIO n = followsIO (grid n n, (1,1), TurnRight, D)

draw' _ [] = mempty
draw' s ((Pull n):xs) = hrule (fromIntegral n) <> draw' s xs

draw' s@TurnLeft (TurnIn:xs) = hrule 1 <> draw' s xs # rotateBy (-1/4)
draw' s@TurnRight (TurnIn:xs) = hrule 1 <> draw' s xs # rotateBy ((1/4)) 
draw' s@TurnLeft (TurnOut:xs) = hrule 1 <> draw' (flipMove s) xs # rotateBy ((1/4)) 
draw' s@TurnRight (TurnOut:xs) = hrule 1 <> draw' (flipMove s) xs # rotateBy (-(1/4)) 
draw' s (Over:xs) = hrule 1 <> draw' s xs
draw' s (Under:xs) = hrule 1 <> draw' s xs

--  data Action = Pull Int | TurnIn | TurnOut | Over | Under

main = mainWith $ ((frame 1 . lw medium . lc darkred . strokeT $ w ) :: Diagram B)

-- w = (hrule 1 <> hrule 1) # rotateBy (1/4) <> hrule 1
w = draw' TurnLeft (tabby 4 4)
