type Thread a = Int -> a

numbers :: Thread Int
numbers = id

data Pick = Front | Back


--type Heddle = Pick

type Size = (Int, Int)

data Weave a = Weave {warp :: Thread a,
                      weft :: Thread a,
                      picks :: [Pick],
                      width :: Int,
                      height :: Int
                     }

type Shaft = [Pick]

type Lift = [(Shaft, Pick)]

-- instance (Show a) => Show (Weave a) where
--   show w = 

plain :: Shaft
plain = cycle [Front, Back]

tabby :: Weave Int
tabby = Weave {warp = numbers,
               weft = numbers,
               picks = plain,
               width = 8,
               height = 8
              }

draft :: Weave a -> [[(a,a)]]
draft w = [[(warp w a, weft w b) | a <- [0 .. (width w) - 1]] | b <- [0 .. (height w) - 1]]




--backforth [a] = 

--instance (Show a) => Show (Weave a) where
--  show p@(Pattern _) = show $ arc p (0, 1)
