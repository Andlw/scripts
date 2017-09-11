#!/bin/bash
#
#author liuwei

cowrie_dir=/data/cowrie
cowrie_url=http://github.com/micheloosterhof/cowrie
id cowrie || useradd cowrie
echo "asd.1234" |passwd --stdin cowrie
if [ ! -d $cowrie_dir ]; then
  mkdir $cowrie_dir
fi

for pke in git  python-crypto python-pyasnl python-gmpy2 python2-pip
do
    yum install -y $pke
done
pip install virtualenv
pushd $cowrie_dir
git clone $cowrie_url
cd cowrie
virtualenv cowrie-env
source cowrie-env/bin/activate
pip install -r requirements.txt
chown -R cowrie.cowrie $cowrie_dir
cp -rf cowrie.cfg.dist cowrie.cfg
popd

su cowrie
cd  $cowrie_dir/cowrie/bin && ./cowrie start
#iptables -t nat -I PREROUTING 1 -p tcp  --dport 22 -j REDIRECT --to-port 65522
