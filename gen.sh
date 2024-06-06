#!/bin/bash

set -e

helm package --destination agent charts/agent
helm repo index --url https://easyops-cn.github.io/charts/agent agent
