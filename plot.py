#!/usr/bin/env python3

import pandas as pd
import plotly.graph_objects as go
from tap import Tap
from pathlib import Path

class Arg(Tap):
    exps_dir = './exp'
    remove_warmup: bool = False


args = Arg().parse_args()

with open('./selected-commits.txt') as f:
    commit_list = [l.strip() for l in f.readlines()]
print(commit_list)


def plot_exp(exp_path):
    data = [
        pd.read_csv(
            f'{exp_path}/{commit}.txt',
            skiprows=1,
            delimiter=' ',
            usecols=[0],
        ).to_numpy()[:, 0].tolist()
        for commit in commit_list
    ]

    if args.remove_warmup:
        for i in range(len(data)):
            data[i] = data[i][len(data[i]) // 4:]

    fig = go.Figure()
    for idx, commit in enumerate(commit_list):
        fig.add_trace(go.Box(y=data[idx], name=commit))
    fig.update_layout(title=str(exp_path))
    fig.show()

for exp_path in Path(args.exps_dir).glob('*'):
    plot_exp(exp_path)
