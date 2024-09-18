cd amcu/mtb_shared
release_dirs=$(find . -type d -name "release*")
for count in $release_dirs; do
    echo "removing $count"
    rm -rf "$count"
done
echo "all cypress components cleaned"
