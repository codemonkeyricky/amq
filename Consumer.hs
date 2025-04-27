import           Codec.MIME.Type                 (nullType)
import           Control.Concurrent              (threadDelay)
import           Control.Monad                   (forever)
import qualified Data.ByteString.UTF8            as U
import           Data.Char                       (toUpper)
import           Network.Mom.Stompl.Client.Queue
import           Network.Socket                  (withSocketsDo)
import           System.Environment              (getArgs)

main :: IO ()
main = do
  os <- getArgs
  case os of
    [q] -> withSocketsDo $ consumer q
    _   -> putStrLn "Usage: consumer <queue-name>"

data Ping
  = Ping
  | Pong
  deriving (Show)

strToPing :: String -> IO Ping
strToPing s =
  case map toUpper s of
    "PING" -> return Ping
    "PONG" -> return Pong
    _      -> error $ "Not a Ping: '" ++ s ++ "'"

consumer :: String -> IO ()
consumer qn =
  withConnection
    "localhost"
    61616
    [OAuth "artemis" "artemis", OHeartBeat (5000, 5000)]
    [] $ \c -> do
    let iconv _ _ _ = strToPing . U.toString
    withReader c "Q-IN" qn [] [] iconv $ \inQ -> do
      putStrLn $ "Consumer started listening to queue: " ++ qn
      forever $ do
        eiM <- try $ readQ inQ
        case eiM of
          Left e -> putStrLn $ "Error: " ++ show e
          Right m -> do
            let p =
                  case msgContent m of
                    Ping -> Pong
                    Pong -> Ping
            putStrLn
              $ "Received: "
                  ++ show (msgContent m)
                  ++ ", responding with: "
                  ++ show p
            -- threadDelay 1000000 -- 1 second delay between processing
