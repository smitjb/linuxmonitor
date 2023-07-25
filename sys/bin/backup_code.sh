#!/bin/bash

cd /cygdrive/l/backups

rsync --recursive --update --verbose --times  jim@mercury:/var/code dev


