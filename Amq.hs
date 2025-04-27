
import Codec.MIME.Type (nullType)
 
import qualified Data.ByteString.UTF8 as U
 
import Network.Mom.Stompl.Client.Queue
 
main = withConnection "localhost" 61616 [] [] $ \c -> do
    let conv = return . U.fromString
 
    q <- newWriter c "SampleQueue" "SampleQueue" [ONoContentLen] [] conv
 
    writeQ q nullType [] "Simples Assim"
