#!/usr/bin/env bash

if ! python3 -c "import tap" &> /dev/null; then
    pip install typed-argument-parser
fi

if ! python3 -c "import plotly" &> /dev/null; then
    pip install plotly
fi

if ! python3 -c "import pandas" &> /dev/null; then
    pip install pandas
fi

