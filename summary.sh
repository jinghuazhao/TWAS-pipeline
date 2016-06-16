grep -H gene bmd/twas/*imp | grep gene_exp | awk '!/nan/' \
|sed 's\bmd/twas/\\g'|sed 's\:gene_exp\\g'|sed 's\.imp\\g' > bmd.imp
    
awk '($1=="ARG2"||$1=="KCNJ13")' bmd.imp

  
