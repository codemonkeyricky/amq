docker run --name amq -p 61616:61616 -p 8161:8161 -v /home/richard/dev/amq/broker:/var/lib/artemis-instance/etc-override --rm apache/activemq-artemis
