#!/usr/bin/env bash
echo "🧪 Testing vault container image"
vault --version

echo "🧪 Testing working certificates ca - https://vault.rachuna-net.pl/"
curl -s https://vault.rachuna-net.pl/