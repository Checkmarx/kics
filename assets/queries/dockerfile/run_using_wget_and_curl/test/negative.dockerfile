FROM debian
RUN curl http://google.com
RUN curl http://bing.com
RUN ["curl", "http://bing.com"]
