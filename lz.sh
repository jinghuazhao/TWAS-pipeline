# 19-7-2016 MRC-Epid JHZ

parallel -j4 -Sb01,b02,b03,b04,b05,b06 -C' ' 'export chr={}; cd /genetics/data/CGI/locuszoom;stata do lz.do' ::: $(seq 22)
