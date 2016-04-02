#!/usr/bin/python
import numpy as np
import urllib2
import re

data = []
with open('/home/houdao/.conky/script/stocks.lst') as f:
    for x in f:
        data.append(x.rstrip('\r\n'))

url = 'http://hq.sinajs.cn/list=%s'%(','.join(x for x in data))
request = urllib2.Request(url)
response = urllib2.urlopen(request)
pageinfo = response.read()
detail = re.findall(r'="(.*?)";',pageinfo)
for x in detail:
    name, point, price, increase, amount, money = x.split(',')
    point = float(point)
    if point>10000:
        print name.decode('gbk').encode('utf-8'), '%12.3f'%float(point), '%9.2f%%'%float(increase)
    elif point>1000:
        print name.decode('gbk').encode('utf-8'), '%13.3f'%float(point), '%9.2f%%'%float(increase)
    elif point>100:
        print name.decode('gbk').encode('utf-8'), '%14.3f'%float(point), '%9.2f%%'%float(increase)
    elif point>10:
        print name.decode('gbk').encode('utf-8'), '%15.3f'%float(point), '%9.2f%%'%float(increase)
    else:
        print name.decode('gbk').encode('utf-8'), '%16.3f'%float(point), '%9.2f%%'%float(increase)

#import urllib
#urllib.urlretrieve ('http://image.sinajs.cn/newchart/min/n/sh000001.gif', '/home/houdao/.conky/images/sh000001.gif')
#from PIL import Image 
#Image.open('/home/houdao/.conky/images/sh000001.gif').convert('RGB').save('/home/houdao/.conky/images/sh000001.png')
