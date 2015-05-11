{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}

module Dyadic where

import Data.List
import Data.Maybe

{- Def. 1 A unit (monas) is that by virtue of which each of the things that
   exist is called one. -}

data Unit = Unit

{- Def. 2 A number is a multitude composed of units. -}
type Number = [Unit]

instance Show Unit where
  show x = "x"
instance Eq Unit

{- Def 3. A number is a part of a number, the less of the greater,
   when it measures the greater -}

measure :: Number -> Number -> Maybe Number
measure x [] = Just []
measure x y = do a <- measure' x y
                 b <- measure x a
                 return (Unit:b)

measure' :: Number -> Number -> Maybe Number
measure' [] x = Just x
measure' x [] = Nothing
measure' x y = measure' (tail x) (tail y)

isPart l g = isJust (measure l g)

{- Def. 5 The greater number is a multiple of the less when it is
   measured by the less. -}

isMultiple g l = isJust (measure l g)

{- Def. 6 An even number is that which is divisible into two equal parts. -}
isEven :: Number -> Bool
isEven (Unit:Unit:[]) = True
isEven (Unit:[]) = False
isEven [] = False -- ?
isEven (Unit:Unit:n) = isEven n

{- Def. 7 An odd number is that which is not divisible into two equal
   parts, or that which differs by a unit from an even number.-}
isOdd :: Number -> Bool
isOdd = isEven . (Unit:)

findIn :: (Number -> Bool) -> Number -> [Number]
findIn f n = filter f (tails n)

evensIn :: Number -> [Number]
evensIn = findIn isEven

{- Def. 8 An even-times-even number is that which is measured by an
   even number according to an even number. -}

-- Had to take tail of n..
isFTimesF :: (Number -> Bool) -> (Number -> Bool) -> Number -> Bool
isFTimesF f f' n = or [maybe False f' (measure x n) | x <- findIn f (tail n)]

isEvenTimesEven :: Number -> Bool
isEvenTimesEven = isFTimesF (isEven) (isEven)

isEvenTimesOdd :: Number -> Bool
isEvenTimesOdd = isFTimesF (isEven) (isOdd)

isOddTimesOdd :: Number -> Bool
isOddTimesOdd = isFTimesF (isOdd) (isOdd)

addUnit = (Unit:)

one = addUnit []
two = addUnit one
three = addUnit two
four = addUnit three
five = addUnit four
six = addUnit five
seven = addUnit six
eight = addUnit seven
