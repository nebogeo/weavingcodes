-- Thread should be continuous?
type Thread a = Int -> a





data Pick = Up | Down

data Movement

type Heddle = Pick

type Size = (Int, Int)

data Weave a = Weave {warp :: [a],
                      weft :: [a],
                      picks :: [Pick]
                     }

type Shaft = [Pick]
type Lift = [(Shaft, Pick)]

instance (Show a) => Show (Weave a) where
  show w = take (warps w) (repeat 'x' )

plain :: [Pick]
plain = cycle [Front, Back]

tabby :: Weave Int
tabby = Weave {warp = numbers,
               weft = numbers,
               picks = plain,
               warps = 8
              }

block :: Weave Int -> [[(Int,Int)]]
block w = [[backforth (warp w a, weft w b) | a <- [0 .. (warps w) - 1]] | b <- [0..]]
  where backforth (a,b) | b `mod` 2 == 1 = (a, invertRow b)
                        | otherwise = (a,b)
        invertRow b = b - (b `mod` (warps w)) + (warps w - (b `mod` (warps w)))


--backforth [a] = 

--instance (Show a) => Show (Weave a) where
--  show p@(Pattern _) = show $ arc p (0, 1)
