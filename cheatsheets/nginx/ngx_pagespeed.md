# PageSpeed Module - ngx_pagespeed

* [Build ngx_pagespeed from source](https://modpagespeed.com/doc/build_ngx_pagespeed_from_source)
* [ngx_pagespeed - Github](https://github.com/apache/incubator-pagespeed-ngx)

Install dependencies

    sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip uuid-dev

### Download & prepare ngx_pagespeed module

[check the release notes for the [latest version](https://www.modpagespeed.com/doc/release_notes)

    NPS_VERSION=1.13.35.2-stable
    cd
    wget -O- https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.tar.gz | tar -xz
    nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
    cd "$nps_dir"
    NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
    psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
    [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
    wget -O- ${psol_url} | tar -xz  # extracts to psol/


### Build nginx with dynamic module & http_ssl_module

Check nginx's site for the [latest version](http://nginx.org/en/download.html)

    NGINX_VERSION=1.18.0
    cd
    wget -O- http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -xz
    cd nginx-${NGINX_VERSION}/
    ./configure --add-module=$HOME/$nps_dir --with-http_ssl_module
    make
    make install
    mv /usr/sbin/nginx /root/
    mv /usr/local/nginx/sbin/nginx /usr/sbin/


## Not working!

ngx_http_v2_module is not included

     # nginx: [emerg] the "http2" parameter requires ngx_http_v2_module
    ./objs/nginx -V 2>&1 | grep http_v2


## Configure

Configure (new) config location

## systemd

Edit or create `ngnix.server` if nessecarry.

## Remove nginx

    apt purge nginx nginx-common nginx-core
    rm /usr/sbin/nginx
    ln -s /usr/local/nginx/sbin/nginx /usr/sbin/nginx

or Pin version (if not purged nginx)

To prevent your custom Nginx package from being replaced in the future I **Pinned** the version.

    vi /etc/apt/preferences.d/nginx

    Package: nginx
    Pin: version 1.18.0-0ubuntu1
    Pin-Priority: 1001

