#!/bin/bash

rsync -avr --exclude .git . root@10.0.0.1:/root/go
