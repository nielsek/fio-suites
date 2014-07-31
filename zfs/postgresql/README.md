* 7200rpm 1tb SATA

||1 disk|2 disk mirror|4 disk mirror|3 disk raidz|5 disk raidz
----|------|------|------|------|----
compression LZ4||||			
random read|1246|1180|**2560**|948|820
random write|21856|15877|20048|28057|**32277**
read write|10229|12256|**24244**|14564|16340
sequential read|**45166**|30597|30880|37028|30552
sequential write|100713|85210|124886|118022|**125096**
compression off||||					
random read|1119|1049|**2359**|869|723
random write|14616|14493|13764|20029|**32915**
read write|13297|15674|**33314**|16401|20148
sequential read|**54247**|44554|43283|44833|37181
sequential write|91850|77036|157628|156832|**227029**
