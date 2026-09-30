from debian
run wget http://google.com
run curl http://bing.com

from baseImage
run wget http://test.com
run curl http://bing.com
run ["curl", "http://bing.com"]
