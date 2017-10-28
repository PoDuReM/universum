{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE IncoherentInstances    #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TypeFamilies           #-}
{-# LANGUAGE UndecidableInstances   #-}

-- | Provides operator of variable-arguments function composition.

module VarArg
    ( SuperComposition(..)
    ) where

class SuperComposition a b c | a b -> c where
    -- | Allows to apply function to result of another function with multiple
    -- arguments.
    --
    -- >>> (show ... (+)) 1 2
    -- "3"
    -- >>> show ... 5
    -- "5"
    -- >>> (null ... zip5) [1] [2] [3] [] [5]
    -- True
    --
    -- Inspired by <http://stackoverflow.com/questions/9656797/variadic-compose-function>.
    --
    -- ==== Performance
    -- To check the performance there was done a bunch of benchmarks. Benchmarks were made on
    -- examples given above and also on a function of many arguments.
    -- The results are showing that the operator ('...') performs as fast as
    -- plain applications of the operator ('Prelude..') on all the tests.
    --
    -- But keep in mind that providing explicit type declarations for functions is very
    -- important here. Slow behavior was noticed on functions without type specifications.
    -- Relying on type inference will lead to the situation when all optimizations
    -- disappear due to very general inferred type. However, functions without type
    -- specification but with applied @INLINE@ pragma are fast again.
    --
    (...) :: a -> b -> c

infixl 8 ...

instance (a ~ c, r ~ b) =>
         SuperComposition (a -> b) c r where
    f ... g = f g
    {-# INLINE (...) #-}

instance (SuperComposition (a -> b) d r1, r ~ (c -> r1)) =>
         SuperComposition (a -> b) (c -> d) r where
    (f ... g) c = f ... g c
    {-# INLINE (...) #-}
