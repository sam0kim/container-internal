arr_ns=$(ip netns list | awk '{print $1}')

for i in $arr_ns
do
  `ip netns del "$i"`
done

storage_home="/vagrant/overlaynet/storage"
rm -f ${storage_home}/*/*
