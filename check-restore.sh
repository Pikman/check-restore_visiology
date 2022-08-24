set -euxo pipefail

if [ -f /opt/visiology/ul-visiology-$(date +%d'.'%m'.'%Y).tar.gz ] && \
[ -f /opt/visiology/ul-visiology-$(date +%d'.'%m'.'%Y).md5 ]; then

echo "File found"
mkdir -p /opt/visiology/dump/success
mkdir /opt/visiology/dump/failed
mv ul-visiology-$(date +%d'.'%m'.'%Y).{tar.gz,md5} /opt/visiology/dump/ && \

cd /opt/visiology/dump/
find /opt/visiology/dump/ -mtime +1 |  xargs rm -rf

#check md5, restore, restart, mv
md5sum -c ul-visiology-$(date +%d'.'%m'.'%Y).md5 
/opt/visiology/restore-visiology.sh ul-visiology-$(date +%d'.'%m'.'%Y).tar.gz 
/opt/visiology/2.18/run.sh --restart
mv ul-visiology-$(date +%d'.'%m'.'%Y).{tar.gz,md5} /opt/visiology/dump/success || mv ul-visiology-$(date +%d'.'%m'.'%Y).{tar.gz,md5} /opt/visiology/dump/failed

else
echo "File not found"
fi
