---
title: Scheduly API Docs

language_tabs: # must be one of https://git.io/vQNgJ
  - http
  - shell
  - python
  - go

toc_footers:
  - <a href='#'>Login / Signup into Scheduly</a>

includes:

search: true
---

# Introduction

Welcome to the Scheduly API docs!

You can use this API to schedule any task into the future. An example use case would be sending an email to a user one hour after he registers in your application.

If you find something missing or you would change something, please contact us!

# Authentication

> To authorize, setup the X-API-KEY header in your requests. The header value should be your api key.

Scheduly uses API keys to allow access to the API. 

You can register and get a new API key inside the [application](http://example.com/developers). If you forget your API key, you can create a new one also inside of the [application](http://example.com/developers).

<aside class="warning">
Make sure you save the API key in a safe place with backups, if possible. Treat it with the same importance you treat your passwords. We don't store it in our servers so that if someone steales our data, they still cannot make requests with your api key. Security first!
</aside>


Scheduly expects for the API key to be included in all API requests to the server in a header that looks like the following:

`X-API-KEY: your_api_key`

<aside class="notice">
You must replace <code>your_api_key</code> with your personal API key.
</aside>

# Json:API

Scheduly tries to adhere as much as it makes sense to the [Json:API](https://jsonapi.org/) standard. We do this because we care about you! You might find [some library](https://jsonapi.org/implementations/) in your language of choice that allows you to call our endpoints and handle the responses in a easier way.

# Schedules

## Create New Schedule

> The following request creates a new schedule

```http
POST /schedule HTTP/1.1
X-API-KEY: your_api_key
Content-Type: application/json; charset=utf-8
Host: scheduly.io
Connection: close
User-Agent: Your User Agent
Content-Length: 112

{"data":{"type":"schedule","attributes":{"trigger_at":1587890095123,"payload":{"awesome_key":"awesome_value"}}}}
```

```shell
curl -X "POST" "https://scheduly.io/schedule" \
     -H 'X-API-KEY: your_api_key' \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "data": {
    "type": "schedule",
    "attributes": {
      "payload": {
        "awesome_key": "awesome_value"
      },
      "trigger_at": 1587890095123
    }
  }
}'
```

```python
# Install the Python Requests library:
# `pip install requests`

import requests
import json


def send_request():
    # Request
    # POST https://scheduly.io/schedule

    try:
        response = requests.post(
            url="https://scheduly.io/schedule",
            headers={
                "X-API-KEY": "your_api_key",
                "Content-Type": "application/json; charset=utf-8",
            },
            data=json.dumps({
                "data": {
                    "type": "schedule",
                    "attributes": {
                        "payload": {
                            "awesome_key": "awesome_value"
                        },
                        "trigger_at": 1587890095123
                    }
                }
            })
        )
        print('Response HTTP Status Code: {status_code}'.format(
            status_code=response.status_code))
        print('Response HTTP Response Body: {content}'.format(
            content=response.content))
    except requests.exceptions.RequestException:
        print('HTTP Request failed')
```

```go
package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"bytes"
)

func sendRequest() {
	// Request (POST https://scheduly.io/schedule)

	json := []byte(`{"data": {"type": "schedule","attributes": {"payload": {"awesome_key": "awesome_value"},"trigger_at": 1587890095123}}}`)
	body := bytes.NewBuffer(json)

	// Create client
	client := &http.Client{}

	// Create request
	req, err := http.NewRequest("POST", "https://scheduly.io/schedule", body)

	// Headers
	req.Header.Add("X-API-KEY", "your_api_key")
	req.Header.Add("Content-Type", "application/json; charset=utf-8")

	// Fetch Request
	resp, err := client.Do(req)
	
	if err != nil {
		fmt.Println("Failure : ", err)
	}

	// Read Response Body
	respBody, _ := ioutil.ReadAll(resp.Body)

	// Display Results
	fmt.Println("response Status : ", resp.Status)
	fmt.Println("response Headers : ", resp.Header)
	fmt.Println("response Body : ", string(respBody))
}
```

> The request body should follow the following format:

```json
{
  "data": {
    "type": "schedule",
    "attributes": {
      "trigger_at": 1587890095123,
      "payload": {
        "awesome_key": "awesome_value"
      }
    }
  }
}
```

> The above command returns JSON structured like this:

```json
{
  "data": {
    "type": "schedule",
    "id": "56ba32c9-a4d5-431b-888f-4e5189cc996d",
    "attributes": {
      "trigger_at": 1587890095123,
      "payload": {
        "awesome_key": "awesome_value"
      }
    }
  }
}
```

### HTTP Request

`POST https://scheduly.com/api/schedule`

### Request Attributes

Attribute | Description
--------- | -----------
trigger_at | Timestamp in milliseconds from UNIX epoch format. The schedule will be sent back to you at this exact time.
payload | Optional Json object that will be sent back to you when the schedule triggers. You can put the user_id, for example, in order to retrieve the entity when you get the schedule back.

### Response Attributes

The response will include the same attributes from the request, with the extra added `id` field which corresponds to the unique identifier assigned to the particular schedule instance.

This `id` field is gonna be part of the request Scheduly will make onto your webhook. If you need to apply some piece of logic when receiving the schedules, this identifier can come handy.

### Response Status Codes

Status Code | Description
--------- | -----------
200 Ok | Happy path. Schedule has been received correctly. Sit back and enjoy.
400 Bad Request | Woops! Something is wrong in the request. Either no body has been given, the body is not valid json or some required field is missing.
401 Unauthorized | This means either the X-API-KEY header is not set, it is set with a wrong format, the API key is expired or no longer valid. Please check the [authentication](/#authentication) part.


## Receiving Triggered Schedules (Webhook Request)

When the schedules are triggered (their trigger_at timestamp is in the past), Scheduly will make a `HTTP Post` request to your configured endpoint.

You can configure which endpoint will be called inside the dashboard.

Scheduly makes requests only to HTTPS endpoints. The difference between HTTPS and HTTP is that in the first one the data is encrypted end to end so they're more secure.

> You will receive JSON data with the following format:

```json
{
  "data": {
    "type": "schedule",
    "id": "56ba32c9-a4d5-431b-888f-4e5189cc996d",
    "attributes": {
      "trigger_at": 1587890095123,
      "payload": {
        "some_key": "some_value"
      }
    }
  }
}
```

### Idempotency

Schedules are guaranteed to be triggered at least once. This means they might be triggered more than once.

This is a design decision. We could either do this or send them at most once, risking losing some of them.

Receiving an schedule twice should be very hard, but might happen under some circumstances. It is recommendable to be prepare for this case.

### HTTP Request

`POST https://your_configured_endpoint.com/some_path`

The attributes sent with the request will be the same exact ones you sent when you constructed the schedule.

### Responding to the HTTP Request

If the webhook call was successful, Scheduly expects a HTTP response with status `200 OK`.

Any other response code will be treated as an error, and the request will be retried after a brief delay.

Requests that take too long to answer will also be treated as an error and will be retried.

Any body sent with the response will be ignored.