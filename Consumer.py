
import stomp

class ArtemisConsumer(stomp.ConnectionListener):
    def __init__(self, conn):
        self.conn = conn
        
    def on_message(self, frame):
        print(f"Received message: {frame.body}")
        # Process the message here
        # When done, you can acknowledge the message
        self.conn.ack(id=frame.headers['message-id'], subscription=frame.headers['subscription'])
        
    def on_error(self, frame):
        print(f"Error: {frame.body}")

if __name__ == "__main__":
    conn = stomp.Connection([('localhost', 61616)])
    conn.set_listener('', ArtemisConsumer(conn))
    conn.connect('artemis', 'artemis', wait=True)
    
    # Subscribe to the queue
    conn.subscribe(destination='simple', id=1, ack='client-individual')
    
    print("Waiting for messages...")
    try:
        while True:
            pass  # Keep the consumer running
    except KeyboardInterrupt:
        print("Shutting down consumer...")
    finally:
        conn.disconnect()
