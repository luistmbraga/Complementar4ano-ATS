module SemanticAnalyzer where

import Parser
import ASTandPP
import LangParser

isDecl :: It -> Bool
isDecl (Decl a) = True
isDecl _ = False

isUse :: It -> Bool
isUse (Use a) = True
isUse _ = False

isBlock :: It -> Bool
isBlock (Block a) = True
isBlock _ = False

(<||>) :: (a -> Bool) -> (a -> Bool) -> a -> Bool
(p <||> q) inp = (p inp) || (q inp)

filterDeclUse :: Its -> Its
filterDeclUse  = filter (isDecl <||> isUse )

declOfUse :: It -> [It] -> Bool
declOfUse (Use a) b = elem (Decl a) b

otherDecl :: It -> [It] -> Bool
otherDecl x xs = elem x xs

sameLevelErrors :: Its -> Its -> Its
sameLevelErrors _ [] = []
sameLevelErrors t (x:xs) | isUse x && not (declOfUse x xs || declOfUse x t )  = x : sameLevelErrors (t ++ [x]) xs 
                         | isDecl x && (otherDecl x xs)      = x : sameLevelErrors (t ++ [x]) xs -- não é necessário verificar para trás (otherDecl x xs || otherDecl x t) 
                         | otherwise = sameLevelErrors (t ++ [x]) xs

checkPdecl :: Its -> Its -> Its
checkPdecl _ [] = []
checkPdecl pdec (x:xs) | isDecl x = x : checkPdecl pdec xs
                       | otherwise = if (declOfUse x pdec) then checkPdecl pdec xs
                                                           else x : checkPdecl pdec xs

errors :: Its -> Its -> Its
errors pdecl its = checkPdecl pdecl (sameLevelErrors [] (filterDeclUse its)) 
                                    ++ concat( map (errors ((filter isDecl its) ++ pdecl ) . (\ (Block a) -> a)) (filter isBlock its))

head' :: [(P,String)] -> (P,String)
head' [] = (R [], "")
head' (x:xs) = x

semanticAnalyzer = errors [] . (\ (R a) -> a) . fst . head' . filter ( (==) "" . snd) . pP



-- Usage example:
-- semanticAnalyzer "[Use x, Decl p, [Use w], Decl p]" 
--       [Use x,Decl p,Use w]   
--       //          
--      //           "[ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j], Decl j]" 
--                  "[ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j], Decl j, [ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j], Decl j ]]" 
-- "[ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j, [ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j], Decl j, [ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j], Decl j ]]], Decl j, [ Use x, Decl x, [ Decl y, Use x, Decl e], Use x, [Decl p, Use j], Decl j ]]" 
--           \/
-- errors [] [ Use "y", Decl "x", Block [ Decl "y", Use "x", Decl "y"], Use "x", Block [Decl "p", Use "j"], Decl "j"]
-- errors [] [ Use "y", Decl "x", Block [ Decl "y", Use "x", Decl "y", Block [Use "e", Use "f", Decl "j"]], Use "x", Block [Decl "p", Use "j"]] 
--  [Use y,Decl y,Decl y,Use e,Use f,Use j]
-- errors [] [ Use "y", Decl "x", Block [ Decl "y", Use "x", Decl "y", Block [Use "e", Use "f", Decl "j"]], Use "x", Block [Decl "p", Use "j"], Decl "j"] 
--  [Use y,Decl y,Decl y,Use e,Use f]

--(satisfy (\x -> x `elem`['0'..'9'])) 