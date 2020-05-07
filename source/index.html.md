---
title: Scheduly API Docs

language_tabs: # must be one of https://git.io/vQNgJ
  - http
  - shell

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

> To authorize, setup the following header in your requests:

```http
POST /endpoint_you_want_to_call HTTP/1.1
X-API-KEY: your_api_key
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "X-API-KEY: your_api_key"
```

> Make sure to replace `your_api_key` with your API key.

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
TODO
```

```shell
  TODO
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
payload | Optional Json object that will be sent back to you when the schedule triggers.

### Response Attributes

The response will include the same attributes from the request, with the extra added `id` field which corresponds to the unique identifier assigned to the particular schedule instance.

This `id` field is gonna be part of the request Scheduly will make onto your webhook. If you need to apply some piece of logic when receiving the schedules, this identifier can come handy.

### Response Status Codes

Status Code | Description
--------- | -----------
200 Ok | Happy path. Schedule has been received correctly. Sit back and enjoy.
400 Bad Request | Woops! Something is wrong in the request. Either no body has been given, the body is not valid json or some required field is missing.
401 Unauthorized | This means either the X-API-KEY header is not set, it is set with wrong format or the API key is expired or no longer valid. Please check the [authentication](/#authentication) part.

<!-- TODO add the webhook callback part -->