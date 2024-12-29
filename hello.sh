#!/bin/bash

echo "Hello Boston"
current_time=$(TZ="America/New_York" date "+%I:%M %p")
echo "Current time in Boston: $current_time"