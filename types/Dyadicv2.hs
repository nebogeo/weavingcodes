{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}

module Dyadic where

import Data.List
import Data.Maybe

{- Def. 1 A unit (monas) is that by virtue of which each of the things that
   exist is called one. -}

data Unit a = Unit

-- Display a Unit as an 'x'
instance Show (Unit a) where
  show x = "x"

instance Show (Number a) where
  show (Smallest u u') = show u ++ show u'
  show (AddUnit u n) = show u ++ show n

-- Units are always equal to each other (but must be of the same type
-- to compare)
instance Eq (Unit a) where
  (==) _ _ = True

{- Def. 2 A number is a multitude composed of units. -}
-- (this means that numbers start at 2, not 1)
data Number a = Smallest (Unit a) (Unit a)
              | AddUnit (Unit a) (Number a)

two = Smallest Unit Unit
three = AddUnit Unit two
four = AddUnit Unit three
five = AddUnit Unit four
six = AddUnit Unit five
seven = AddUnit Unit six

toList :: Number a -> [Unit a]
toList (Smallest u u') = [u,u']
toList (AddUnit u n) = u:(toList n)

{- Def 3. A number is a part of a number, the less of the greater,
   when it measures the greater -}

measure :: Number a -> Number a -> Maybe (Number a)
measure a b@(Smallest Unit Unit) = Just b
measure x y = do a <- sub x y
                 b <- measure x a
                 return (Unit:b)

-- Subtract one number from another, but only if the result is another
-- number
sub :: Number a -> Number a -> Maybe (Number a)
sub (Smallest Unit Unit) (AddUnit _ (AddUnit _ n)) = Just n
sub (AddUnit _ n) (AddUnit _ n') = sub n n'
sub _  _ = Nothing

--isPart l g = isJust (measure l g)
