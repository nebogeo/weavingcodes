{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}

module Dyadic where

import Data.List
import Data.Maybe

{- Def. 1 A unit (monas) is that by virtue of which each of the things that
   exist is called one. -}

data Unit a = Unit

{- Def. 2 A number is a multitude composed of units. -}
type Number a = [Unit a]

instance Show (Unit a) where
  show x = "x"
instance Eq (Unit a)

{- Def. 6 An even number is that which is divisible into two equal parts. -}
isEven :: Number a -> Bool
isEven (Unit:Unit:[]) = True
isEven (Unit:[]) = False
isEven [] = False -- ?
isEven (Unit:Unit:n) = isEven n

{- Def. 7 An odd number is that which is not divisible into two equal
   parts, or that which differs by a unit from an even number.-}
isOdd :: Number a -> Bool
isOdd = isEven . (Unit:)

findIn :: (Number a -> Bool) -> Number a -> [Number a]
findIn f n = filter f (tails n)

evensIn :: Number a -> [Number a]
evensIn = findIn isEven

{- Def. 8	An even-times-even number is that which is measured by an even 				number according to an even number. -}

measure :: Number a -> Number a -> Maybe (Number a)
measure x [] = Just []
measure x y = do a <- measure' x y
                 b <- measure x a
                 return (Unit:b)

measure' :: Number a -> Number a -> Maybe (Number a)
measure' [] x = Just x
measure' x [] = Nothing
measure' x y = measure' (tail x) (tail y)

-- Had to take tail of n..
isFTimesF :: (Number a -> Bool) -> (Number a -> Bool) -> Number a -> Bool
isFTimesF f f' n = or [maybe False f' (measure x n) | x <- findIn f (tail n)]

isEvenTimesEven :: Number a -> Bool
isEvenTimesEven = isFTimesF (isEven) (isEven)

isEvenTimesOdd :: Number a -> Bool
isEvenTimesOdd = isFTimesF (isEven) (isOdd)

isOddTimesOdd :: Number a -> Bool
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
