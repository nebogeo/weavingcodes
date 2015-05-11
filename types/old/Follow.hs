module Follow where

data Direction = L | R
instance Show Direction where
  show L = "left"
  show R = "right"
  
data Action = Pull Int | Turn Direction | Over | Under
instance Show Action where
  show (Pull n) = "pull " ++ show n
  show (Turn d) = "turn " ++ show d
  show Over = "over"
  show Under = "under"

type Weave = [Action]

--tabby = [Pull 2,Turn R,Turn R,Pull 2,Turn L,Turn L,Turn L,
--         Under,Over,Turn R,Turn R,Under,Over]

warp :: Int -> Int -> Weave
warp 0 _ = []
warp 1 l = [Pull l]
warp n l | even n = (warp (n-1) l) ++ [Turn L,Turn L] ++ (warp 1 l)
         | otherwise = (warp (n-1) l) ++ [Turn R,Turn R] ++ (warp 1 l)

tabby :: Int -> Int -> Weave
tabby r l = warp r l ++ 
-- Don't know whether to turn left or right
