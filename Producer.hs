import           Codec.MIME.Type                 (nullType)
import           Control.Concurrent              (threadDelay)
import           Control.Monad
import qualified Data.ByteString.Char8           as B
import qualified Data.ByteString.UTF8            as U
import           Network.Mom.Stompl.Client.Queue
import           Network.Socket                  (withSocketsDo)
import           System.Environment              (getArgs)

import           Common

main :: IO ()
main = do
  os <- getArgs
  case os of
    [q] ->
      withSocketsDo
        $ producer q Event {uid = 0, event = "security", action = "time"}
    _ -> putStrLn "Usage: producer <queue-name>"

producer :: String -> Event -> IO ()
producer qn evt =
  withConnection
    "localhost"
    61616
    [OAuth "artemis" "artemis", OHeartBeat (5000, 5000)]
    [] $ \c -> do
    let oconv = return . serialize
    withWriter c "Q-OUT" qn [] [] oconv $ \outQ -> do
      putStrLn $ "Producer started sending to queue: " ++ qn
      forM_ [1 .. 1] $ \_ -> do
        writeQ outQ nullType [] evt
      -- forever $ do
      --   writeQ outQ nullType [] "Pong"
      -- replicateM_ 10000 $ writeQ outQ nullType [] "Pong"
      threadDelay 100000
