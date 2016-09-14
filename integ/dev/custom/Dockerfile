FROM gliderlabs/alpine

RUN apk-install bash

COPY ./start.sh /
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

CMD ["/bin/bash","start.sh"]
