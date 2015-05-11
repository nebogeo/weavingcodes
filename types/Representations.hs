-- Thread should be continuous?

type Thread a = Int -> a

data Unit = Warp | Weft

data Weave = Weave {
                   }



-- Weave as a raster
data Weave = Weave {draft :: [[Bool]]}

-- Construction of a weave as change of state
type Pick = Weave -> Weave

-- Construction of a weave as a sequence of movements (turtle)
data Move = Over | Under | TurnLeft | TurnRight
type Weave = [Move]

-- Weave as path - coordinate based
data Weave = Weave {thread :: [(Int,Int,Bool)]}

-- Structure of weft relative to state
data Change = Up | Down | Toggle | Same Int | Different Int
data Weave = Weave [Change]
tabby = Weave (Up:repeat Toggle)

-- Lift plan
data Pull = Up | Down
data HeddleRod = HeddleRod [Pull]
data Weave = Weave [[HeddleRod]]

-- Unweave
data Untangle = Pull | Unloop
data Unweave = [Untangle]

-- Discrete thread
data Direction = Left | Right
data Thread = Straight | Turn Direction | Loop Direction | Over | Under

-- Weave as action
data Direction = Left90 | Right90 | Left180 | Right180
data Action = Pull Int | Turn Direction | Over | Under

-- Weave as behaviour
data Action = Pull Int | TurnIn | TurnOut | Over | Under
type Weave = [Action]
type Grid = [[String]]
type Position = (Int,Int)
data Move = TurnLeft | TurnRight | Straight
data Direction = L | R | U | D
type State = (Grid,Position,Move,Direction)
