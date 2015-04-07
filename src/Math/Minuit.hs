{-# LANGUAGE ForeignFunctionInterface #-}

module Math.Minuit where

import Control.Monad
import System.IO.Unsafe

import Foreign
import Foreign.C.Types
import Foreign.C.String

type Minimum = (Bool, Double, [Double], [Double])
type FcnFunction = [Double] -> Double
type FcnFunctionIO = [Double] -> IO Double

type CFcnFunctionIO = CInt -> Ptr CDouble -> Ptr () -> IO CDouble

foreign import ccall "minuit-c.h migrad"
    c_migradIO :: CInt
        -> FunPtr CFcnFunctionIO
        -> Ptr CString
        -> Ptr CDouble -> Ptr CDouble
        -> Ptr CDouble -> Ptr CDouble
        -> Ptr CDouble -> Ptr CInt
        -> Ptr ()
        -> IO CInt

foreign import ccall "wrapper"
    mkFunPtr_CFcnFunctionIO :: CFcnFunctionIO
        -> IO (FunPtr CFcnFunctionIO)

cFcnFunctionIO :: FcnFunctionIO -> CFcnFunctionIO
cFcnFunctionIO fcnFuncIO c_comp c_pVals _ = do
    let comp = fromIntegral c_comp
    c_vals <- peekArray comp c_pVals
    let vals = map realToFrac c_vals
    liftM realToFrac $ fcnFuncIO vals

migradIO :: FcnFunctionIO -> [String] -> [Double] -> [Double] -> IO Minimum
migradIO fcnFuncIO names initVals initErrs =
    let comp = length names in
    alloca $ \ p_isValid ->
    alloca $ \ p_fcn ->
    allocaArray comp $ \ p_names ->
    allocaArray comp $ \ p_initVals ->
    allocaArray comp $ \ p_initErrs ->
    allocaArray comp $ \ p_miniVals ->
    allocaArray comp $ \ p_miniErrs -> do
        c_fcnFuncIO <- mkFunPtr_CFcnFunctionIO $ cFcnFunctionIO fcnFuncIO
        c_names <- mapM newCString names
        pokeArray p_names c_names
        pokeArray p_initVals $ map realToFrac initVals
        pokeArray p_initErrs $ map realToFrac initErrs
        _ <- c_migradIO (fromIntegral comp) c_fcnFuncIO p_names
            p_initVals p_initErrs
            p_miniVals p_miniErrs
            p_fcn p_isValid nullPtr
        c_isValid <- peek p_isValid
        c_fcn <- peek p_fcn
        let isValid = if c_isValid == 0 then False else True
            fcn = realToFrac c_fcn
        miniVals <- liftM (map realToFrac) $ peekArray comp p_miniVals
        miniErrs <- liftM (map realToFrac) $ peekArray comp p_miniErrs
        mapM_ free c_names
        freeHaskellFunPtr c_fcnFuncIO
        return (isValid, fcn, miniVals, miniErrs)

migrad :: FcnFunction -> [String] -> [Double] -> [Double] -> Minimum
migrad fcnFunc names initVals initErrs = unsafePerformIO $
    migradIO funcFuncIO names initVals initErrs where
    funcFuncIO vs = return $ fcnFunc vs

