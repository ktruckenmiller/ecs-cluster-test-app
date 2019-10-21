FROM node:alpine
WORKDIR /work
COPY package.json /work
RUN npm install
COPY index.js /work
CMD ["node","index.js"]
