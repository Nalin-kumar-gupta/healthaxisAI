#!/bin/bash

set -o errexit
set -o nounset

rm -f './celerybeat.pid'
celery -A healthaxis_drf beat -l INFO