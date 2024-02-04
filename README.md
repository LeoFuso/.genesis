# Genesis

A quick way to bootstrap a development environment.
Optionally, you may want to initialize a custom profile.

```bash
### Using environment arg
export PRIVATE_KEY_PATH='/media/some/path.key'
chmod +x genesis.sh
./genesis.sh

### Using environment arg and pointing to an specific profile
export PRIVATE_KEY_PATH='/media/some/path.key'
chmod +x genesis.sh
./genesis.sh '' 'custom-profile-name'

### Using an argument explicitly
chmod +x genesis.sh
./genesis.sh '/media/some/path.key'

### Using an argument explicitly and pointing to an specific profile
chmod +x genesis.sh
./genesis.sh '/media/some/path.key' 'custom-profile-name'
```

This project is just a convenience and was made with personal use in mind, but feel free to 
copy it. Go nuts.
