FROM node:22-bookworm-slim

WORKDIR /usr/src/app

# Update npm to get newer bundled dependencies
RUN npm install -g npm@latest

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

EXPOSE 8080

CMD ["npm", "start"]
