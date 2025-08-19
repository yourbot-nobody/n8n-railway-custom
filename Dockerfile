FROM n8nio/n8n:latest

USER root

# Install system dependencies for Puppeteer
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    && rm -rf /var/cache/apk/*

# Copy package.json and install custom dependencies
COPY package.json /tmp/package.json
WORKDIR /tmp
RUN npm install --production --no-optional && \
    mkdir -p /usr/local/lib/node_modules/n8n/node_modules && \
    cp -R node_modules/* /usr/local/lib/node_modules/n8n/node_modules/

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

USER node
WORKDIR /home/node

CMD ["n8n", "start"]
