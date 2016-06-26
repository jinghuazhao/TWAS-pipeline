#!/bin/sh
# 20-6-2016 MRC-Epid JHZ

parallel -j8 -S b01,b02,b03,b04,b05,b06,b07,b08 /genetics/data/CGI/TWAS-pipeline/twas2.sh {1} {2} {3} {4} ::: bmi.txt ::: ALL EUR ::: MET NTR YFS ::: $(seq 1000) 
