#!/bin/bash

echo "currently installed on this image are the following softwares :"
echo "> $(ls /usr/local/bin | tr "\n" " ")"
echo ""
echo "current versions are :"
printenv | grep VERSION | sort
echo ""
echo "=================================================="
echo ""
/bin/bash