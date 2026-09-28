FROM node:20-alpine

WORKDIR /app

# ZIP file is kept in the GitHub repository.
RUN apk add --no-cache unzip
RUN apk add --no-cache unzip openssl
COPY school-attendance-sms.zip /tmp/school-attendance-sms.zip

# Extract the Claude-generated project. The ZIP contains a top-level school-sms folder.
RUN unzip -q /tmp/school-attendance-sms.zip -d /tmp/project \
    && cp -R /tmp/project/school-sms/. /app/ \
    && rm -rf /tmp/project /tmp/school-attendance-sms.zip

# Install dependencies and build Next.js.
RUN npm install
RUN npm run build

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

# Apply Prisma migrations when the container starts, then start Next.js.
CMD ["sh", "-c", "npx prisma migrate deploy && npm start"]
