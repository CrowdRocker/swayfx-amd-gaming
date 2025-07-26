#!/bin/bash
count=$(checkupdates 2>/dev/null | wc -l)
[ "$count" -eq 0 ] && echo "" || echo "$count"