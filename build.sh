#!/bin/bash
echo "make sure you manually create a local Python virtualenv in the .venv directory!"
source .venv/bin/activate
python -m pip install -r requirements.txt
deactivate
julia install.jl  # pre-build some packages