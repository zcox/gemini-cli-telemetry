## Overview

GC collects [telemetry](https://github.com/google-gemini/gemini-cli/blob/main/docs/telemetry.md) (logs, metrics, and traces) and can export that telemetry.

## Sophisticated OTLP Export

The approaches in the GC telemetry docs currently don't work well. I hope to change this in future work.

## Local File Export

To configure GC to export telemetry to a local file, use `.gemini/settings.json` like the following:

```
{
    "telemetry": {
        "enabled": true,
        "target": "local",
        "otlpEndpoint": "",
        "outfile": ".gemini/telemetry.log"
    }
}
```

This repo already has those settings.

GC will write json objects to that outfile, and you can use tools like `jq` to explore it.

Let's say we want to know _exactly_ the prompts that GC sends to Gemini, and the responses from Gemini back to GC. The `process_telemetry.sh` script shows one way to do this.

In one terminal, run this, to clear the outfile and start processing it:

```sh
echo -n "" > .gemini/telemetry.log
./process_telemetry.sh
```

In another terminal, run something like this, to have GC run a simple prompt:

```sh
gemini -p "write a haiku about your favorite animal"
```

In the first terminal, you'll see output similar to this:

```
{"event_name":"gemini_cli.user_prompt","prompt":"write a haiku about your favorite animal"}
{"event_name":"gemini_cli.api_request","prompt_id":"46f81064cdb8c","model":"gemini-2.5-pro","request":[{"role":"user","parts":[{"text":"This is the Gemini CLI. We are setting up the context for our chat.\nToday's date is Saturday, August 16, 2025.\nMy operating system is: darwin\nI'm currently working in the directory: /Users/ZCox/code/zcox/gemini-cli-telemetry\nHere is the folder structure of the current working directories:\n\nShowing up to 200 items (files + folders).\n\n/Users/ZCox/code/zcox/gemini-cli-telemetry/\n├───process_telemetry.sh\n├───README.md\n└───.gemini/\n    ├───settings.json\n    └───telemetry.log"}]},{"role":"model","parts":[{"text":"Got it. Thanks for the context!"}]},{"role":"user","parts":[{"text":"write a haiku about your favorite animal"}]}]}
{"event_name":"gemini_cli.api_response","prompt_id":"46f81064cdb8c","model":"gemini-2.5-pro","status_code":200,"duration_ms":3250,"total_token_count":5444,"response":{"candidates":[{"content":{"parts":[{"thoughtSignature":"CiQBy73w8BFGF/S8w/fmBYxf4xMp8SJrxAfjj4OpGsWWJBkOlQ0KaQHLvfDwwldYvD4DtufnMg571njd/xrdoq5jufXvkpOTrKOLYZDgb+diUJtqMKSLhK8ks3aW7puUEfDyXkSRIKhVPVrYfjh45GHQZ2imRWOIEmLDKUHzpTfa/NBIAsc9g4wQ53E/WXl9+QpZAcu98PBtbXhGmRMCMGYWjyBCjLnwi13ahnbu738HtmPRRART1Fdis2Q5cmVoiXr/eFU9sdapJmi78Wrd/jJDtULeXj/mGV+thfwBEmMgxxD4Idj6ecQm/VgKlAEBy73w8AwWYDR/G4I3KtVbTikHmqdJOAlYSb9X5MYgGBbUzOTQciimRRl71UuV3cW9f5vi2laFvjTrbcPt4efQfG7neBT4Rbkk9xOmEULNUW50ZIrnlNOnssfSZDB3pmDV4MYS/lFGtsPFxzeQLs7fwDt6JKqRAOf/KO/VPW9yDCCnQ0TJeRJ9HUZm3EIJsfYiuvviCoYBAcu98PAzBiDqjrAU1MeZhMfoHl+mWRHVQo1EPbQDP191vMVF/MLFAdCmJsfEPLwRKj8Bq98/IuUr3Hvau93c5Y2FKFDqW1jgBhfyuvrFS6BrE7HMiu5J+5bRp5RGiJSAQuSCrqwjiVyj1wXvLhynwgs+pTJ02f6McXtwISmsO/pPbwbAIxgKuwEBy73w8GshHO+JGVvrq3RbJotjhHgOh5C8w0AgjDUna/dG1nOxzZOJchhGpJy7VT17GCXDUwn5UXBIyyBZStkNamit70jD3fM6P97m+W9M0+2Ug6QGijoTzVWLVjztwpeqoZCy4s0Hf4uqGpD/25Ix0DG1eUWhRTlxMv2mCoN+G/8VsESrBE1LUqiX5i/MvqIdTMcgJMYa/KkUkH3im0p4rbVFYUcJxqhMnYU9RezycPCtz3NiXercWBLrCl0By73w8LxdI1u76mWKy0W7PNxfynK/d27tYDIDLCqfZNOXLjbpPMDi1yZTnkhAk3FxIgfRNywtHBnDhBS4soU/WNdj5iWpMaO2CXScOtbZmqFSb8Gy3S7TEkAtf80=","text":"Soft fur, rumbling purr,\nSunlight naps and gentle dreams,\nSilent paws now sleep."}],"role":"model"},"finishReason":"STOP"}],"createTime":"2025-08-16T17:59:03.958141Z","modelVersion":"gemini-2.5-pro","responseId":"58agaL29OvKonvgPm4qiIQ","usageMetadata":{"promptTokenCount":5255,"candidatesTokenCount":20,"totalTokenCount":5444,"trafficType":"ON_DEMAND","promptTokensDetails":[{"modality":"TEXT","tokenCount":5255}],"candidatesTokensDetails":[{"modality":"TEXT","tokenCount":20}],"thoughtsTokenCount":169},"sdkHttpResponse":{"headers":{"alt-svc":"h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000","content-disposition":"attachment","content-type":"text/event-stream","date":"Sat, 16 Aug 2025 17:59:05 GMT","server":"scaffolding on HTTPServer2","transfer-encoding":"chunked","vary":"Origin, X-Origin, Referer","x-content-type-options":"nosniff","x-frame-options":"SAMEORIGIN","x-xss-protection":"0"}}}}
{"event_name":"gemini_cli.api_request","prompt_id":"46f81064cdb8c","model":"gemini-2.5-flash","request":[{"role":"user","parts":[{"text":"This is the Gemini CLI. We are setting up the context for our chat.\nToday's date is Saturday, August 16, 2025.\nMy operating system is: darwin\nI'm currently working in the directory: /Users/ZCox/code/zcox/gemini-cli-telemetry\nHere is the folder structure of the current working directories:\n\nShowing up to 200 items (files + folders).\n\n/Users/ZCox/code/zcox/gemini-cli-telemetry/\n├───process_telemetry.sh\n├───README.md\n└───.gemini/\n    ├───settings.json\n    └───telemetry.log"}]},{"role":"model","parts":[{"text":"Got it. Thanks for the context!"}]},{"role":"user","parts":[{"text":"write a haiku about your favorite animal"}]},{"parts":[{"thoughtSignature":"CiQBy73w8BFGF/S8w/fmBYxf4xMp8SJrxAfjj4OpGsWWJBkOlQ0KaQHLvfDwwldYvD4DtufnMg571njd/xrdoq5jufXvkpOTrKOLYZDgb+diUJtqMKSLhK8ks3aW7puUEfDyXkSRIKhVPVrYfjh45GHQZ2imRWOIEmLDKUHzpTfa/NBIAsc9g4wQ53E/WXl9+QpZAcu98PBtbXhGmRMCMGYWjyBCjLnwi13ahnbu738HtmPRRART1Fdis2Q5cmVoiXr/eFU9sdapJmi78Wrd/jJDtULeXj/mGV+thfwBEmMgxxD4Idj6ecQm/VgKlAEBy73w8AwWYDR/G4I3KtVbTikHmqdJOAlYSb9X5MYgGBbUzOTQciimRRl71UuV3cW9f5vi2laFvjTrbcPt4efQfG7neBT4Rbkk9xOmEULNUW50ZIrnlNOnssfSZDB3pmDV4MYS/lFGtsPFxzeQLs7fwDt6JKqRAOf/KO/VPW9yDCCnQ0TJeRJ9HUZm3EIJsfYiuvviCoYBAcu98PAzBiDqjrAU1MeZhMfoHl+mWRHVQo1EPbQDP191vMVF/MLFAdCmJsfEPLwRKj8Bq98/IuUr3Hvau93c5Y2FKFDqW1jgBhfyuvrFS6BrE7HMiu5J+5bRp5RGiJSAQuSCrqwjiVyj1wXvLhynwgs+pTJ02f6McXtwISmsO/pPbwbAIxgKuwEBy73w8GshHO+JGVvrq3RbJotjhHgOh5C8w0AgjDUna/dG1nOxzZOJchhGpJy7VT17GCXDUwn5UXBIyyBZStkNamit70jD3fM6P97m+W9M0+2Ug6QGijoTzVWLVjztwpeqoZCy4s0Hf4uqGpD/25Ix0DG1eUWhRTlxMv2mCoN+G/8VsESrBE1LUqiX5i/MvqIdTMcgJMYa/KkUkH3im0p4rbVFYUcJxqhMnYU9RezycPCtz3NiXercWBLrCl0By73w8LxdI1u76mWKy0W7PNxfynK/d27tYDIDLCqfZNOXLjbpPMDi1yZTnkhAk3FxIgfRNywtHBnDhBS4soU/WNdj5iWpMaO2CXScOtbZmqFSb8Gy3S7TEkAtf80=","text":"Soft fur, rumbling purr,\nSunlight naps and gentle dreams,\nSilent paws now sleep."}],"role":"model"},{"role":"user","parts":[{"text":"Analyze *only* the content and structure of your immediately preceding response (your last turn in the conversation history). Based *strictly* on that response, determine who should logically speak next: the 'user' or the 'model' (you).\n**Decision Rules (apply in order):**\n1.  **Model Continues:** If your last response explicitly states an immediate next action *you* intend to take (e.g., \"Next, I will...\", \"Now I'll process...\", \"Moving on to analyze...\", indicates an intended tool call that didn't execute), OR if the response seems clearly incomplete (cut off mid-thought without a natural conclusion), then the **'model'** should speak next.\n2.  **Question to User:** If your last response ends with a direct question specifically addressed *to the user*, then the **'user'** should speak next.\n3.  **Waiting for User:** If your last response completed a thought, statement, or task *and* does not meet the criteria for Rule 1 (Model Continues) or Rule 2 (Question to User), it implies a pause expecting user input or reaction. In this case, the **'user'** should speak next."}]}]}
{"event_name":"gemini_cli.api_response","prompt_id":"46f81064cdb8c","model":"gemini-2.5-pro","status_code":200,"duration_ms":1104,"total_token_count":4680,"response":{"sdkHttpResponse":{"headers":{"alt-svc":"h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000","content-encoding":"gzip","content-type":"application/json; charset=UTF-8","date":"Sat, 16 Aug 2025 17:59:08 GMT","server":"scaffolding on HTTPServer2","transfer-encoding":"chunked","vary":"Origin, X-Origin, Referer","x-content-type-options":"nosniff","x-frame-options":"SAMEORIGIN","x-xss-protection":"0"}},"candidates":[{"content":{"parts":[{"text":"{\n  \"next_speaker\": \"user\",\n  \"reasoning\": \"My last response was a complete answer to the user's request (a haiku) and did not ask a question or indicate an immediate next action. Therefore, it is waiting for the user's next input.\"\n}"}],"role":"model"},"finishReason":"STOP","avgLogprobs":-0.25323460594056146}],"createTime":"2025-08-16T17:59:07.358185Z","modelVersion":"gemini-2.5-flash","responseId":"68agaKnuFait698PxprM8AQ","usageMetadata":{"promptTokenCount":4572,"candidatesTokenCount":63,"totalTokenCount":4680,"trafficType":"ON_DEMAND","promptTokensDetails":[{"modality":"TEXT","tokenCount":4572}],"candidatesTokensDetails":[{"modality":"TEXT","tokenCount":63}],"thoughtsTokenCount":45}}}
{"event_name":"gemini_cli.next_speaker_check","prompt_id":"46f81064cdb8c","result":"user","finish_reason":"STOP"}
```

First, as expected, we see the prompt to write a haiku, followed by the Gemini api request to write the haiku, and the Gemini api response that contains the haiku.

But notice that the request starts with this user message:

> This is the Gemini CLI. We are setting up the context for our chat...

Followed by various initial context, and then a hard-coded model response:

> Got it. Thanks for the context!

You don't see this when using GC, but it's interesting to know how GC is providing some initial context behind the scenes.

Next, after that initial Gemini request/response to write the haiku, there is another Gemini request/response. The request has all of the messages so far in the session (initial context, instruction to write the haiku, and the generated haiku), followed by this synthetic user message, that we did not type ourselves:

> Analyze *only* the content and structure of your immediately preceding response (your last turn in the conversation history). Based *strictly* on that response, determine who should logically speak next: the 'user' or the 'model' (you).\n**Decision Rules (apply in order):**\n1.  **Model Continues:** If your last response explicitly states an immediate next action *you* intend to take (e.g., \"Next, I will...\", \"Now I'll process...\", \"Moving on to analyze...\", indicates an intended tool call that didn't execute), OR if the response seems clearly incomplete (cut off mid-thought without a natural conclusion), then the **'model'** should speak next.\n2.  **Question to User:** If your last response ends with a direct question specifically addressed *to the user*, then the **'user'** should speak next.\n3.  **Waiting for User:** If your last response completed a thought, statement, or task *and* does not meet the criteria for Rule 1 (Model Continues) or Rule 2 (Question to User), it implies a pause expecting user input or reaction. In this case, the **'user'** should speak next.

What is this? It appears to be a way for GC to either continue prompting Gemini for further model output, or to stop and wait for the next user input. Again, super interesting to see how GC operates behind the scenes.

The response to that "next speaker" prompt is a structured json output:

```json
{
    "next_speaker": "user",
    "reasoning": "My last response was a complete answer to the user's request (a haiku) and did not ask a question or indicate an immediate next action. Therefore, it is waiting for the user's next input."
}
```

This is a classic chain-of-thought (CoT) output, but notice that it's backwards: the `reasoning` should be generated first, so those output tokens guide the model to generate the actual `next_speaker` result. This prompt probably needs to use [`propertyOrdering`](https://x.com/zcox/status/1912919709642883201).

Also notice that the "next speaker" request specifies `"model":"gemini-2.5-flash"` but the response contains `"model":"gemini-2.5-pro"`. I suspect there's a bug in GC's logging. It makes sense to use `flash` for a simple classification like this; it's probably not using `pro`.

Another observation is that while the api response logs seem to include the _entire_ Gemini http response payload (it contains `headers`, the full `candidates` with `avgLogprobs`, and `usageMetadata`), the api request logs only contain the user and model messages. Other important request information like temperature, function declarations, and structured output response schema are missing. This appears to be an asymmetry in GC's logging, where only a small part of the Gemini api request is logged.

One solution to this would be looking at GC's traces, instead of logs. GC appears to instrument its node http client, which _should_ expose all details of every http request and response it makes, but either it's not actually creating spans, or is not able to export them correctly. I have only ever observed logs from GC, but never any traces.

_TODO another example that shows tool calls_