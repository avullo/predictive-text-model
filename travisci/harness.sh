#!/bin/bash

echo "Running test suite"
Rscript --vanilla ../src/run_tests.R

rt=$?
echo $rt
