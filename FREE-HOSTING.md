# Free hosting (no Render)

Run **The ok.mairr Chronicle** on a free always-on box with a free subdomain and free HTTPS.

## What you get

| Piece | Free option |
|---|---|
| Server | [Oracle Cloud Always Free](https://www.oracle.com/cloud/free/) ARM VM |
| Domain | [DuckDNS](https://www.duckdns.org) → `yourname.duckdns.org` |
| HTTPS | Caddy + Let’s Encrypt (automatic) |
| App | Docker Compose in this repo |

Website design changes can wait — this only gets the site online on your own host.

## 1. Create a free DuckDNS name (2 minutes)

1. Sign up at https://www.duckdns.org  
2. Create a subdomain, e.g. `okmairr`  
3. Copy your **token**  
4. Your public URL will be `https://okmairr.duckdns.org`

## 2. Create a free Oracle Cloud VM

1. Sign up for Always Free: https://www.oracle.com/cloud/free/  
2. Create an **Ubuntu** VM (Ampere ARM or the free x86 shape)  
3. In **Networking → Security Lists**, allow inbound:
   - TCP **22** (SSH)
   - TCP **80** (HTTP)
   - TCP **443** (HTTPS)
4. Note the VM **public IP**

SSH in:

```bash
ssh ubuntu@YOUR_PUBLIC_IP
```

## 3. Install Docker on the VM

```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-v2 git
sudo usermod -aG docker "$USER"
# log out and back in so docker works without sudo
```

## 4. Deploy this repo

```bash
git clone https://github.com/perfectaegon/ok-mairr-chronicle.git
cd ok-mairr-chronicle
# ./data from the clone already has your published posts/photos
cp .env.example .env
nano .env
```

Set at least:

```env
DOMAIN=okmairr.duckdns.org
DUCKDNS_SUBDOMAIN=okmairr
DUCKDNS_TOKEN=paste-your-duckdns-token
ADMIN_PASSWORD=pick-a-strong-password
```

Optional (keeps posts/photos backed up to GitHub):

```env
GITHUB_TOKEN=your-github-token
GITHUB_REPO=perfectaegon/ok-mairr-chronicle
```

Start:

```bash
chmod +x bin/deploy-free.sh bin/update-duckdns.sh
bin/deploy-free.sh
```

Open:

- Site: `https://okmairr.duckdns.org`
- Admin: `https://okmairr.duckdns.org/admin`

## 5. Keep DuckDNS pointed at your VM

If the public IP can change, add a cron job:

```bash
crontab -e
```

```cron
*/5 * * * * cd ~/ok-mairr-chronicle && ./bin/update-duckdns.sh >/tmp/duckdns.log 2>&1
```

## Home PC / Raspberry Pi instead of Oracle

Same steps, skip Oracle:

1. Install Docker on the machine you leave on  
2. Open/forward ports **80** and **443** on your router (or use Cloudflare Tunnel later)  
3. Run `bin/deploy-free.sh`  
4. DuckDNS must point at your home public IP  

## Useful commands

```bash
docker compose logs -f          # live logs
docker compose ps               # status
docker compose pull && docker compose up -d --build   # update after git pull
docker compose down             # stop
```

## Move off Render

When this free host is working:

1. Update any bookmarks to your DuckDNS URL  
2. Delete or suspend the Render service so it stops sleeping/waking  

## Later

Buy a real domain when you want (`okmairr.com`) and point DNS at the same VM — only the `DOMAIN=` value in `.env` / Caddy needs to change.
