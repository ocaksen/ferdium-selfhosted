# Ferdium — Coolify (Self-Hosted) Kurulumu

Ferdium masaüstü uygulamasını, sunucuda **tarayıcıdan erişilebilir** bir web masaüstü
(KasmVNC) içinde çalıştırır. Böylece Windows'una hiçbir şey kurmadan, herhangi bir
tarayıcıdan birden fazla WhatsApp + Telegram + Slack + mail vb. hesabını tek yerden
kullanabilirsin.

> Ferdium tamamen ücretsiz ve açık kaynaktır — Rambox'ın aksine paywall/kısıtlama yok.

## Nasıl çalışıyor?

```
Tarayıcın → Coolify (Linux sunucun) → Docker container
                                        ├─ KasmVNC (web masaüstü, port 3000)
                                        └─ Ferdium
                                           ├─ WhatsApp #1, #2, ...
                                           └─ Telegram, Slack, Gmail...
```

## Dosyalar

| Dosya | Görevi |
|-------|--------|
| `Dockerfile` | Ubuntu tabanlı web masaüstüne Ferdium `.deb` paketini kurar (en güncel sürümü otomatik bulur) |
| `root/defaults/autostart` | Container açılınca Ferdium'u otomatik başlatır |
| `docker-compose.yml` | Coolify için servis tanımı + web giriş şifresi |

---

## Coolify'da kurulum adımları

### 1. Bu klasörü bir Git deposuna gönder (GitHub/GitLab)

```bash
git init
git add .
git commit -m "Ferdium self-hosted (KasmVNC)"
git branch -M main
git remote add origin <SENIN_REPO_URL>
git push -u origin main
```

### 2. Coolify'da yeni kaynak oluştur

1. Coolify panelinde ilgili projede **+ New Resource** → **Docker Compose** (veya
   **Public/Private Repository**) seç.
2. Bu Git deposunu bağla, branch: `main`.
3. Build Pack olarak **Dockerfile / Docker Compose** seçili olsun (repo kökünü kullanır).

### 3. Şifreyi mutlaka değiştir

`docker-compose.yml` içindeki şu satırı **kesinlikle** değiştir:

```yaml
- PASSWORD=BURAYA_GUCLU_BIR_SIFRE_YAZ
```

> Bu şifre, tarayıcıdan Ferdium'a girerken sorulacak. Değiştirmezsen hesaplarına
> herkes erişebilir!

### 4. Domain bağla

Coolify'ın **Domains** alanına örn. `ferdium.senin-domainin.com` yaz. Coolify otomatik
HTTPS (SSL) verecek. Container içi port: **3000**.

### 5. Deploy

**Deploy** butonuna bas. İlk kurulumda Ferdium indirilip kurulacağı için birkaç dakika
sürebilir.

---

## Kullanım

1. `https://ferdium.senin-domainin.com` adresine git.
2. Kullanıcı adı/şifre sorulunca `CUSTOM_USER` ve `PASSWORD` değerlerini gir.
3. Ferdium açılınca hizmet ekle (**+**) ile WhatsApp ekle, QR'ı telefonunla okut.
4. Aynı şekilde ikinci WhatsApp'ı, Telegram'ı, Slack'i, mail'i ekle.

Tüm oturumların `ferdium-config` volume'ünde kalıcı saklanır — container yeniden
başlasa da hesapların bağlı kalır.

> Not: Ferdium hesaplarını cihazlar arası senkronlamak için isteğe bağlı bir
> **Ferdium-server** de kurulabilir; bu kurulum için gerekli değil.

---

## Güvenlik notları

- Bu kurulum **kişisel kullanım** içindir. Container'a giren kişi tüm giriş yapılmış
  hesaplarını görür → güçlü şifre şart.
- Mümkünse Coolify tarafında ek olarak IP kısıtlaması / ekstra Basic Auth da ekle.
- `PASSWORD` değerini repoya açıkça yazmak yerine Coolify'ın **Environment Variables**
  bölümünden gizli (secret) olarak tanımlaman daha güvenlidir.

## Sorun giderme

- **Ferdium açılmıyor / boş ekran:** `.deb` içindeki binary yolu farklıysa
  `root/defaults/autostart` içindeki `/opt/Ferdium/ferdium` yolunu kontrol et.
- **Ekran donuyor / çöküyor:** `docker-compose.yml` içindeki `shm_size` değerini
  `2gb` yap.
