module ASTandPP where

data P = R Its

type Its = [It]

data It = Block Its
        | Decl String
        | Use String

instance Eq It where 
    Use a    == Use b   =  a == b
    Decl a   == Decl b  =  a == b
    Block a  == Block b =  a == b
    _        == _       =  False

instance Show P where
    show = pp_P

pp_P (R its) = "[" ++ pp_Its its ++ "]"

instance Show It where
    show = pp_It

pp_Its [] = ""
pp_Its [it] = pp_It it
pp_Its (it:its) = pp_It it ++ " , " ++ pp_Its its

pp_It (Decl n) = "Decl " ++ n
pp_It (Use n) = "Use " ++ n
pp_It (Block is) = "[" ++ pp_Its is ++ "]"