{-# LANGUAGE ForeignFunctionInterface #-}

module Minuit where

import Foreign
import Foreign.C.String
import Foreign.C.Types

type Minimum = (Bool, Double, [Double], [Double])
type FcnFunction = [Double] -> Double

type CFcnFunction = CInt -> Ptr CDouble -> Ptr () -> CDouble

foreign import ccall "minuit-c.h migrad"
    c_migrad :: CInt
        -> FunPtr CFcnFunction
        -> Ptr CString
        -> Ptr CDouble -> Ptr CDouble
        -> Ptr CDouble -> Ptr CDouble
        -> Ptr CDouble -> Ptr CInt
        -> Ptr ()
        -> CInt

foreign import ccall "wrapper"
    mkFunPtr_CFcnFunction :: CFcnFunction
        -> IO (FunPtr CFcnFunction)

cFcnFunction :: FcnFunction -> CFcnFunction
cFcnFunction fcnFunc c_comp c_pVals _ = unsafePerformIO $ do
    let comp = fromIntegral c_comp
    c_vals <- peekArray comp c_pVals
    let vals = map realToFrac c_vals
    return $ realToFrac $ fcnFunc vals

funcTest :: FcnFunction
funcTest [x, y] = 2 + (x-0.4)**2 + 3*(y-4.2)**2
funcTest _ = error ""

migrad :: FcnFunction -> [Double] -> [Double] -> Minimum 
migrad fcnFunc vals errs = (isValid, fcn, miniVals, miniErrs) where
    isValid = True
    fcn = fcnFunc vals
    miniVals = vals
    miniErrs = errs



