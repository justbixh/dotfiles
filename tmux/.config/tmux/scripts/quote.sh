#!/usr/bin/env bash
# prints one short quote, rotating daily (offline, no network)
quotes=(
  "Make it work, make it right, make it fast."
  "Simple is better than complex."
  "Premature optimization is the root of all evil."
  "Talk is cheap. Show me the code."
  "First, solve the problem. Then, write the code."
  "Done is better than perfect."
  "Stay hungry, stay foolish."
  "Programs must be written for people to read."
  "Fix the cause, not the symptom."
  "Slow is smooth, smooth is fast."
  "Small steps every day."
  "Delete code. Less is more."
  "Debugging is twice as hard as writing the code."
  "Readability counts."
)
echo "${quotes[$(( 10#$(date +%j) % ${#quotes[@]} ))]}"
