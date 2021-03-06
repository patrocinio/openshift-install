INVENTORY=./openshift_inventory

ansible -i $INVENTORY nodes:\!etcd -a 'yum -y install lvm2'
ansible -i $INVENTORY nodes:\!etcd -a 'pvcreate -f /dev/xvde'
# ansible -i $INVENTORY nodes:\!etcd -a 'wipefs -a /dev/sdc'
ansible -i $INVENTORY nodes:\!etcd -a 'vgcreate origin-vg /dev/xvde'
ansible -i $INVENTORY nodes:\!etcd -a 'lvcreate -n origin-lv -l 100%VG origin-vg'
ansible -i $INVENTORY nodes:\!etcd -a 'mkfs.xfs /dev/mapper/origin--vg-origin--lv'
ansible -i $INVENTORY nodes:\!etcd -m shell -a 'mkdir /var/lib/origin'
ansible -i $INVENTORY nodes:\!etcd -m lineinfile -a 'path=/etc/fstab regexp=origin line="/dev/mapper/origin--vg-origin--lv /var/lib/origin xfs defaults 0 0"'
ansible -i $INVENTORY nodes:\!etcd -m shell -a 'mount -a'
