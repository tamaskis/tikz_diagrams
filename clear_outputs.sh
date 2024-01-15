#!/bin/bash

# Check if pdf_outputs exists and delete if it does
if [ -d "pdf_outputs" ]; then
    rm -r "pdf_outputs"
    echo "pdf_outputs deleted."
fi

# Check if eps_outputs exists and delete if it does
if [ -d "eps_outputs" ]; then
    rm -r "eps_outputs"
    echo "eps_outputs deleted."
fi