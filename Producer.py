
import time
import stomp

class ArtemisProducer:
    def __init__(self, host='localhost', port=61616, user='artemis', password='artemis'):
        self.conn = stomp.Connection([(host, port)])
        self.conn.connect(user, password, wait=True)
        
    def send_message(self, queue_name, message):
        headers = { 
            'persistent':'true', 
            'delivery-mode':2, 
        }
        self.conn.send(body=message, destination=f'simple', headers=headers)
        print(f"Sent message to {queue_name}: {message}")
        
    def close(self):
        self.conn.disconnect()

if __name__ == "__main__":
    producer = ArtemisProducer()
    
    try:
        for i in range(1, 11):
            message = f"Test message {i}"
            producer.send_message('simple', message)
            time.sleep(1)  # Simulate some processing time
    finally:
        producer.close()
