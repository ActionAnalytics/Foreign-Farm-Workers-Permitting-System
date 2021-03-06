# Client
FROM node:12-alpine AS client

# Build client
RUN apk add --no-cache git python g++ make
WORKDIR /client
COPY client/package*.json ./
RUN npm set progress=false && npm ci --no-cache
COPY client/. .
RUN npm run build

# Server
FROM node:12-alpine AS server

# Static env vars
ARG VERSION
ENV VERSION $VERSION

# Configure server
RUN apk add --no-cache git
COPY --from=client /client/build /client/build/.
WORKDIR /server
COPY server/package*.json ./
RUN npm set progress=false && npm ci --no-cache
COPY server/. .

# Run app
EXPOSE 80
CMD [ "npm", "run", "start" ]
