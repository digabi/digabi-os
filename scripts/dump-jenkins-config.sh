#!/bin/sh

set -e

# Dump Jenkins config for digabi-os job

JOB="digabi-os"
CI_URL="http://ci.local/"

jenkins-cli -s "${CI_URL}" get-job "${JOB}" |sed 's,<flowToken>\(.*\)</flowToken>,<flowToken>FIXME</flowToken>,g'
