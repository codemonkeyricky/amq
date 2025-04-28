import           Codec.MIME.Type                 (nullType)
import           Common
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

consumer :: String -> IO ()
consumer qn =
  withConnection
    "localhost"
    61616
    [OAuth "artemis" "artemis", OHeartBeat (5000, 5000)]
    [] $ \c -> do
    let iconv _ _ _ = return . deserialize
    withReader c "Q-IN" qn [] [] iconv $ \inQ -> do
      putStrLn $ "Consumer started listening to queue: " ++ qn
      forever $ do
        eiM <- try $ readQ inQ
        case eiM of
          Left e -> putStrLn $ "Error: " ++ show e
          Right msg -> do
            case msgContent msg of
              Nothing  -> return ()
              Just evt -> print evt
            -- threadDelay 1000000 -- 1 second delay between processing
