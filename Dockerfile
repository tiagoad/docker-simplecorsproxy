FROM nginx

ENV TARGET https://kanye.rest/

COPY entrypoint.sh .
CMD ["./entrypoint.sh"]