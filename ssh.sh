#!/bin/bash

ssh -p 122 1.119.5.181 <<EOD
ls
echo $reverse
echo $PATH
exit
EOD
