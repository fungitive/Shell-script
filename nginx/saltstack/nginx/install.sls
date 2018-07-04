nginx-source:
  file.managed:
    - name: /usr/local/src/nginx-1.12.2.tar.gz
    - source: salt://nginx/files/nginx-1.12.2.tar.gz
    - user: root
    - group: root
    - mode: 0644
nginx-pkg:
  pkg.installed:
    - pkgs:
      - openssl-devel
      - pcre-devel
      - zlib-devel
      - gcc-c++
nginx-user:
  user.present:
    - name: nginx
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin
#解压nginx
extract_nginx:
  cmd.run:
    - cwd: /usr/local/src/
    - names:
      - tar xvf nginx-1.12.2.tar.gz
    - unless: test -d /usr/local/src/nginx-1.12.2
    - require: nginx-source
#安装nginx
nginx-install:
  cmd.run:
    - cwd: /usr/local/src/nginx-1.12.2
    - names:
      - ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module  && make && make install && chown -R nginx.nginx /usr/local/nginx
    - unless: test -d /usr/local/nginx
    - require:
      - cmd: extract_nginx
      - pkg: nginx-pkg
cache_dir:
  cmd.run:
    - names:
      - mkdir -p /usr/local/nginx/conf/conf.d && chown -R nginx.nginx /usr/local/nginx/
    - require:
      - cmd: nginx_install
    - unless: test -d /usr/local/nginx/conf/conf.d/
  file.managed:
    - name: /home/nginx/conf/conf.d/www.example.com.conf
    - unless: test -e /home/nginx/conf/conf.d/www.example.com.conf
    - source: salt://nginx/files/vhost.conf
