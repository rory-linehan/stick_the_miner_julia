#!/bin/bash

number=$1

for number in {1..${number}}
do
julia stick.jl &
done