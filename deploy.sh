VERSION=0.0.1
BUNDLE_IMAGE=quay.io/brejohns/mate-operator-bundle:$VERSION
IMG=quay.io/brejohns/mate:$VERSION
INDEX_IMAGE=quay.io/brejohns/mate-operator-index:$VERSION
BUNDLE_CHANNELS=alpha




make docker-build IMG=$IMG
make docker-push IMG=$IMG

make bundle CHANNELS=$BUNDLE_CHANNELS DEFAULT_CHANNEL=$BUNDLE_CHANNELS

make bundle IMG=$IMG VERSION=$VERSION

make bundle-build BUNDLE_IMG=$BUNDLE_IMAGE

make packagemanifests VERSION=$VERSION CHANNEL=$BUNDLE_CHANNELS IS_CHANNEL_DEFAULT=1 IMG=$BUNDLE_IMAGE


opm index add --bundles $BUNDLE_IMAGE --tag $INDEX_IMAGE --container-tool docker
docker push $INDEX_IMAGE


operator-sdk run packagemanifests ./packagemanifests --namespace my-namespace --version $VERSION --verbose  
operator-sdk cleanup mate