import Control.Applicative ((<$>))

data Term = TmTrue
          | TmFalse
          | TmIf Term Term Term
          | TmZero
          | TmSucc Term
          | TmPred Term
          | TmIsZero Term
          deriving Show


isNumericalVal :: Term -> Bool
isNumericalVal TmZero = True
isNumericalVal (TmSucc t) = isNumericalVal(t)
isNumericalVal _ = False


isVal :: Term -> Bool
isVal TmTrue = True
isVal TmFalse = True
isVal t = isNumericalVal t


eval1 :: Term -> Maybe Term
-- TmTrue and TmFalse
eval1 t | isVal t = Just t
-- TmIf
eval1 (TmIf TmTrue t2 t3) = Just t2
eval1 (TmIf TmFalse t2 t3) = Just t3
eval1 (TmIf t1 t2 t3) = (\t1' -> TmIf t1' t2 t3) <$> (eval1 t1)
-- TmSucc
eval1 (TmSucc t1) = TmSucc <$> (eval t1)
-- TmPred
eval1 (TmPred TmZero) = Just TmZero
eval1 (TmPred (TmSucc nv1)) | isNumericalVal nv1 = Just nv1
eval1 (TmPred t1) = TmPred <$> (eval1 t1)
-- TmIsZero
eval1 (TmIsZero TmZero) = Just TmTrue
eval1 (TmIsZero (TmSucc nv1)) | isNumericalVal nv1 = Just TmFalse
eval1 (TmIsZero t1) = TmIsZero <$> (eval1 t1)
-- Invalid rule
eval1 _ = Nothing

eval :: Term -> Maybe Term
eval t | isVal t = Just t
eval t = case eval1 t of
           Nothing -> Nothing
           Just t' -> eval t'
