#!/bin/bash

tail -f -n 0 .gemini/telemetry.log | jq -c --unbuffered '
  if .attributes?."event.name" then
    {
      "event_name": .attributes."event.name"
    } +
    (if .attributes."event.name" == "gemini_cli.user_prompt" then
      {
        "prompt": .attributes.prompt,
      }
    elif .attributes."event.name" == "gemini_cli.api_request" then
      {
        "prompt_id": .attributes.prompt_id,
        "model": .attributes.model,
        "request": (.attributes.request_text | fromjson)
      }
    elif .attributes."event.name" == "gemini_cli.api_response" then
      {
        "prompt_id": .attributes.prompt_id,
        "model": .attributes.model,
        "status_code": .attributes.status_code,
        "duration_ms": .attributes.duration_ms,
        "total_token_count": .attributes.total_token_count,
        "response": (.attributes.response_text | fromjson)
      }
    elif .attributes."event.name" == "gemini_cli.next_speaker_check" then
      {
        "prompt_id": .attributes.prompt_id,
        "result": .attributes.result,
        "finish_reason": .attributes.finish_reason
      }
    elif .attributes."event.name" == "gemini_cli.tool_call" then
      {
        "prompt_id": .attributes.prompt_id,
        "function_name": .attributes.function_name,
        "function_args": (.attributes.function_args | fromjson),
        "success": .attributes.success,
        "decision": .attributes.decision,
        "metadata": .attributes.metadata
      }
    else
      {}
    end)
  else
    empty
  end
'
