FROM debian
RUN wget http://google.com
RUN curl http://bing.com

FROM baseImage
RUN wget http://test.com
RUN curl http://bing.com
RUN ["curl", "http://bing.com"]
