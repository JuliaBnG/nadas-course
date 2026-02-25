#!/usr/bin/env bash

julia --startup-file=no build.jl
scp index.html *png genie:/var/www/html/podcast/nadas
