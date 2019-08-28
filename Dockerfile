FROM node:12.9.0-alpine

EXPOSE 80

WORKDIR /home/node/app
COPY app .

USER node
CMD ["node", "index.js"]
