module Weave where

import Prelude
import Data.List

-- | The weaving actions that we are representing.
-- @Pull@ takes the thread in the current direction, by the given number of units.
-- @TurnIn@ turns the thread 90 degrees, in the same direction as the last turn.
-- @TurnOut@ turns the thread 90 degrees, in the opposite direction as the last turn.
data Action = Pull Int | TurnIn | TurnOut | Over | Under

instance showAction :: Show Action where
  show (Pull n) = "pull " ++ show n
  show TurnIn = "turn in"
  show TurnOut = "turn out"
  show Over = "over"
  show Under = "under"

-- | Directions that a thread can take.
data Move = TurnLeft | TurnRight | Straight

instance showMove :: Show Move where
  show TurnLeft = "turn left"
  show TurnRight = "turn right"
  show Straight = "straight"

