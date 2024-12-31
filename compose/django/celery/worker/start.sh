#!/bin/bash

set -o errexit
set -o nounset

watchfiles --filter python 'celery -A healthaxis_drf worker --loglevel=info'