FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache unzip openssl

COPY school-attendance-sms.zip /tmp/school-attendance-sms.zip

RUN unzip -q /tmp/school-attendance-sms.zip -d /tmp/project \
    && cp -R /tmp/project/school-sms/. /app/ \
    && rm -rf /tmp/project /tmp/school-attendance-sms.zip

RUN npm install
RUN npm run build

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

CMD ["sh", "-c", "npx prisma migrate deploy && npm start"]
