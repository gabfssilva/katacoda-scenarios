First of all, you need to set the environment up.

## Run localstack

```
docker run -d=true -p 4575-4576:4575-4576 -e SERVICES=sqs,sns localstack/localstack:latest
```{{execute}}

## Creating a queue

```
aws --endpoint-url http://localhost:4576/ \
    sqs create-queue \
    --queue-name test
```{{execute}}

## Sending a message

```
aws --endpoint-url http://localhost:4576/ \
    sqs send-message \
    --queue-url http://localhost:4576/queue/test \
    --message-body "hello from home!"
```{{execute}}

## Receiving messages

```
aws --endpoint-url http://localhost:4576/ \
    sqs receive-message \
    --queue-url http://localhost:4576/queue/test \
    --attribute-names All \
    --message-attribute-names All \
    --max-number-of-messages 10
```{{execute}}

## Deleting a message

You will need the receipt handle from the last receive message try in order to delete a message:

```
aws --endpoint-url http://localhost:4576/ \
    sqs delete-message \
    --queue-url http://localhost:4576/queue/test \
    --receipt-handle {{receipt_handle_here}}
```{{copy}}

## Changing the message visibility

For this one you also will need the receipt handle:

```
aws --endpoint-url http://localhost:4576/ \
    sqs change-message-visibility \
    --queue-url http://localhost:4576/queue/test \
    --visibility-timeout 10 \
    --receipt-handle {{receipt_handle_here}}
```{{copy}}

```
aws --endpoint-url http://localhost:4575/ \
    sns create-topic \
    --name topic_test
```{{execute}}

```
aws --endpoint-url http://localhost:4575/ sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:000000000000:topic_test \
    --protocol sqs \
    --attributes '{"RawMessageDelivery": "true"}' \
    --notification-endpoint http://localhost:4576/queue/test
```{{execute}}

```
aws --endpoint-url http://localhost:4575/ \
    sns publish \
    --topic-arn arn:aws:sns:us-east-1:000000000000:topic_test \
    --message "Hi from home!"
```{{execute}}

```
aws --endpoint-url http://localhost:4576/ \
    sqs receive-message \
    --queue-url http://localhost:4576/queue/test \
    --attribute-names All \
    --message-attribute-names All \
    --max-number-of-messages 10
```{{execute}}


```
aws --endpoint-url http://localhost:4575/ \
    sns create-topic \
    --name product_updated
```{{execute}}

```
aws --endpoint-url http://localhost:4576/ \
    sqs create-queue \
    --queue-name datajet_product
```{{execute}}

```
aws --endpoint-url http://localhost:4576/ \
    sqs create-queue \
    --queue-name akamai_product
```{{execute}}

```
aws --endpoint-url http://localhost:4575/ sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:000000000000:product_updated \
    --protocol sqs \
    --attributes '{"RawMessageDelivery": "true"}' \
    --notification-endpoint http://localhost:4576/queue/datajet_product
```{{execute}}

```
aws --endpoint-url http://localhost:4575/ sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:000000000000:product_updated \
    --protocol sqs \
    --attributes '{"RawMessageDelivery": "true"}' \
    --notification-endpoint http://localhost:4576/queue/akamai_product
```{{execute}}


```
aws --endpoint-url http://localhost:4575/ \
    sns publish \
    --topic-arn arn:aws:sns:us-east-1:000000000000:product_updated \
    --message '
      {                      \
        "id": 1,             \
        "name": "Allstar"    \
        "version": 20,       \
        "price": 120.00,     \
        "stock": 20,         \
      }                      \
    '
```{{execute}}

```
aws --endpoint-url http://localhost:4576/ \
    sqs receive-message \
    --queue-url http://localhost:4576/queue/datajet_product \
    --attribute-names All \
    --message-attribute-names All \
    --max-number-of-messages 10
```{{execute}}

```
aws --endpoint-url http://localhost:4576/ \
    sqs receive-message \
    --queue-url http://localhost:4576/queue/akamai_product \
    --attribute-names All \
    --message-attribute-names All \
    --max-number-of-messages 10
```{{execute}}