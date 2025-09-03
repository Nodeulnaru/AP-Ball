AP-Ball
=====
Container Image of Apache-PHP Ball of each PHP Versions(To run Pukiwiki engine or etc.)

# 개요
지난날 홈 페이지 만들기 서버의 정석처럼 통했던 APM(Apache Web Server·PHP·Mysql)의 AP 환경을 로컬 PC에서 컨테이너로 재현하였습니다.  
브랜치명은 PHP의 각 버전별로 마련하였으며, 기본적으로 bitnami에서 docker hub에 제공하는 [php-fpm debian 기반 공식 이미지](https://hub.docker.com/r/bitnami/php-fpm)를 사용해 제작하였습니다.

# 이미지(`Dockerfile`)파일에 대한 해설
각 브랜치별 Dockerfile을 열어서 확인 가능하지만, 한국어 해설을 덧붙였습니다. 
```Docker
## PHP 7.4 from docker hub bitnami
## 개요 문단에서 해설하였듯, bitnami에서 docker hub에 제공하는 php-fpm 기반 공식 이미지를 사용하였으며, 운영체제는 debian 기반입니다.
FROM bitnami/php-fpm:7.4-debian-11

## Install Apache Web Server and php module
## APT에서 Apache Web Server와 PHP 호환 모듈을 받아 설치시킵니다.
RUN apt update; apt upgrade -y; apt install apache2 libapache2-mod-php -y;

## Copy Apache Web Server-PHP 7.4 contact Configure File
## 다른 문단에서 소개할 '별도 사용 파일'입니다. 이것을 Apache Web Server의 설정파일 디렉터리에 집어넣습니다.
COPY php74.conf /etc/apache2/conf-enabled/php74.conf

## Use TCP Port for Web Server
## HTTP 및 HTTPS 개방시 필요한 TCP 포트 번호이며, PHP-FPM 확인을 위해 추가로 9000번 포트도 정의해 두었습니다.
EXPOSE 80
EXPOSE 443
EXPOSE 9000

## Use Volume of Pukiwiki Files
## Pukiwiki나 PHP 애플리케이션(별도 사용 파일)을 기동시킬 볼륨 마운트 영역입니다. 실제 컨테이너 실행시에 -v 옵션으로 지정하게 되므로 활성화시키지는 않았으나, 컨테이너에서는 아래 경로에 마운트되어야 하므로 정의하였습니다. 
# VOLUME /var/www/html

## Run Apache Web Server and PHP at the same time
## Apache Web Server 및 PHP-FPM을 동시에 백그라운드에서 기동하도록 지정한 Entrypoint입니다.
ENTRYPOINT bash -c "source /etc/apache2/envvars && apache2 && php-fpm -F --pid /opt/bitnami/php/tmp/php-fpm.pid -y /opt/bitnami/php/etc/php-fpm.conf"
```

# 별도 사용 파일
## `php74.conf`
이 저장소에서 동명의 파일을 열어서 확인 가능합니다.  
Apache Web Server에서 PHP 애플리케이션 파일을 기동시킬 수 있게 하기 위한 설정파일입니다.

## Pukiwiki 혹은 PHP 애플리케이션
이 저장소에서는 별도 제공해 드리지 않으나 여러분께서 테스트를 위한 예제를 소개드립니다.  
[Pukiwiki 1.5.4 다운로드](https://pukiwiki.sourceforge.io/?PukiWiki/Download/1.5.4)  

제공해 드린 링크에서 `pukiwiki-1.5.4_utf8.zip`라고 쓴 파일 링크를 클릭하시면 SourceForge 페이지로 넘어가 몇 초 뒤 자동 다운로드가 됩니다.  
해당 Zip 파일을 압축풀기하신 뒤 나온 디렉터리를 컨테이너의 `/var/www/html` 경로에 마운트하면, Pukiwiki 1.5.4 버전을 기동할 수 있습니다.  

또 그 외 PHP로 개발된 웹 애플리케이션이 있을 경우 역시 `/var/www/html` 경로에 마운트하셔서 기동하실 수 있습니다.  
해당 애플리케이션이 별도 데이터베이스 서버에 의존하는 경우, 데이터베이스 서버 혹은 컨테이너를 먼저 기동한 뒤 네트워크, 환경 변수를 추가 정의하여 기동하셔야 합니다.  

# 이미지 생성 후 컨테이너 실행 방법
- 컨테이너 이름은 'origami'로 지었다고 전제했습니다.
- Pukiwiki 등 PHP 애플리케이션 키트는 **실행 경로의 `web` 디렉터리**에 마련해 둘 것을 전제했습니다. 다른 디렉터리에 마련했더라도 **컨테이너 측 경로는 저 경로(`/var/www/html`)여야 합니다.**

```bash
$ docker run --name origami -p 80:80 -d -v ./web:/var/www/html ghcr.io/nodeulnaru/apball:7.4
```
