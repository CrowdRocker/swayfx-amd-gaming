#!/bin/bash
COUNT=$(dunstctl count waiting)
[ "$COUNT" -eq 0 ] && echo "" || echo "$COUNT"