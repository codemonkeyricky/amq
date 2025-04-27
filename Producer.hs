import           Codec.MIME.Type                 (nullType)
import           Control.Concurrent              (threadDelay)
import           Control.Monad                   (forever)
import qualified Data.ByteString.UTF8            as U
import           Network.Mom.Stompl.Client.Queue
import           Network.Socket                  (withSocketsDo)
import           System.Environment              (getArgs)

data Ping
  = Ping
  | Pong
  deriving (Show)

main :: IO ()
main = do
  os <- getArgs
  case os of
    [q] -> withSocketsDo $ producer q
    _   -> putStrLn "Usage: producer <queue-name>"

producer :: String -> IO ()
producer qn =
  withConnection
    "localhost"
    61616
    [OAuth "artemis" "artemis", OHeartBeat (5000, 5000)]
    [] $ \c -> do
    let oconv = return . show
    withWriter c "Q-OUT" qn [] [] oconv $ \outQ -> do
      putStrLn $ "Producer started sending to queue: " ++ qn
      forever $ do
        writeQ outQ nullType [] Pong
        -- putStrLn "Sent Pong"
        -- threadDelay 10000000 -- 10 second delay between messages
  where
    Pong = Pong -- Your Ping/Pong data type
