# 1단계: 빌드 환경
FROM node:14-alpine as build-stage

# 작업 디렉토리 설정
WORKDIR /app

# 패키지 파일 복사 및 종속성 설치
COPY package*.json ./
RUN npm install

# 소스 파일 복사
COPY . .

# Vue.js 애플리케이션 빌드
RUN npm run build

# 2단계: 프로덕션 환경
FROM nginx:1.19.0-alpine

# Nginx 설정 파일 복사
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 빌드된 파일 복사
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Nginx 포트 설정
EXPOSE 80

# Nginx 실행
CMD ["nginx", "-g", "daemon off;"]
