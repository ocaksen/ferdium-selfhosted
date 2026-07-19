# Ferdium'u tarayıcıdan erişilebilir bir web masaüstü (KasmVNC) içinde çalıştırır.
# linuxserver.io'nun KasmVNC temel imajı, herhangi bir Linux masaüstü uygulamasını
# tarayıcıya yansıtmak için tasarlanmıştır.
FROM lscr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# --- Ferdium .deb paketini indir ve kur ---
# Ferdium'un sabit "latest" linki olmadığı için en güncel sürümün amd64 .deb
# adresini GitHub API'den dinamik olarak buluyoruz (böylece ileride bozulmaz).
RUN echo "**** Ferdium kuruluyor ****" && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    DEB_URL="$(curl -fsSL https://api.github.com/repos/ferdium/ferdium-app/releases/latest \
      | grep -oP '\"browser_download_url\":\s*\"\K[^\"]*amd64\.deb')" && \
    echo "İndirilecek: $DEB_URL" && \
    curl -fL "$DEB_URL" -o /tmp/ferdium.deb && \
    apt-get install -y --no-install-recommends /tmp/ferdium.deb && \
    echo "**** temizlik ****" && \
    apt-get clean && \
    rm -rf /tmp/ferdium.deb /var/lib/apt/lists/* /var/tmp/*

# Otomatik başlatma betiği ve ayarları kopyala
COPY /root /

# Windows'ta kopyalanan betiğe çalıştırma izni ver
RUN chmod +x /defaults/autostart

# KasmVNC web arayüzü portu
EXPOSE 3000

# Ferdium oturumları/ayarları burada saklanır (kalıcı olması için volume bağlanır)
VOLUME /config
