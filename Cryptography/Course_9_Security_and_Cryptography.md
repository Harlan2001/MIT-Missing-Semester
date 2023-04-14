### 1.Entropy.
1.Suppose a password is chosen as a concatenation of four lower-case dictionary words, where each word is selected uniformly at random from a dictionary of size 100,000. An example of such a password is correcthorsebatterystaple. How many bits of entropy does this have? Consider an alternative scheme where a password is chosen as a sequence of 8 random alphanumeric characters (including both lower-case and upper-case letters). An example is rg8Ql34g. How many bits of entropy does this have?

```shell
Entropy = log_2(100000^4) = 66 #correcthorsebatterystaple
Entropy = log_2((26+26+10)^8) = 48 #rg8Ql34g
```

3.Which is the stronger password?

The first one is stronger.
Assuming an attacker can try 10,000 passwords per second, it would take 31.17 trillion years and 692 years, respectively.
### 2.Cryptographic hash functions. 

Download a Debian image from a mirror (e.g. from this Argentinean mirror). Cross-check the hash (e.g. using the sha256sum command) with the hash retrieved from the official Debian site (e.g. this file hosted at debian.org, if you’ve downloaded the linked file from the Argentinean mirror).

Download a CD image from the Debian image site.Use the sha256sum command to compare the hash value of the download image with the hash value published by the official Debian site

```shell
curl -O -L -C - http://debian.xfree.com.ar/debian-cd/current/amd64/iso-cd/debian-mac-10.9.0-amd64-netinst.iso
curl -O https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS
```

```shell
cat SHA256SUMS | grep debian-10.9.0-amd64-netinst.iso
8660593d10de0ce7577c9de4dab886ff540bc9843659c8879d8eea0ab224c109  debian-10.9.0-amd64-netinst.iso

shasum -a 256 debian-10.9.0-amd64-netinst.iso
8660593d10de0ce7577c9de4dab886ff540bc9843659c8879d8eea0ab224c109  debian-10.9.0-amd64-netinst.iso
```

You can see that these two hashes are the same.diff can also be used for direct comparison:
```shell
diff <(cat SHA256SUMS |grep debian-10.9.0-amd64-netinst.iso) <(shasum -a 256 debian-10.9.0-amd64-netinst.iso)
```

### 3.Symmetric cryptography. 

Encrypt a file with AES encryption, using OpenSSL: openssl aes-256-cbc -salt -in {input filename} -out {output filename}. Look at the contents using cat or hexdump. Decrypt it with openssl aes-256-cbc -d -in {input filename} -out {output filename} and confirm that the contents match the original using cmp.

```shell
echo "hello world" > afile #Create a file
openssl aes-256-cbc -salt -in afile -out secfile #Encrypted file
enter aes-256-cbc encryption password:***
Verifying - enter aes-256-cbc encryption password:***
```

Use hexdump to compare two files

```shell
diff <(hexdump afile) <(hexdump secfile)

1,2c1,3
< 0000000 68 65 6c 6c 6f 20 77 6f 72 6c 64 0a
< 000000c
---
> 0000000 53 61 6c 74 65 64 5f 5f cb 18 f1 7c 4f 09 b4 21
> 0000010 d2 f1 56 77 80 01 b1 2f ac 2d 32 35 52 23 2e c6
> 0000020
```

Compare two files using cat
```shell
cat afile
# hello world
cat secfile
# Salted__|O      !Vw/-25R#.%
```

Decrypt the file
```shell
openssl aes-256-cbc -d -in secfile -out notsafefile

cat notsafefile
#hello world
```

### 4.Asymmetric cryptography.

1.Set up SSH keys on a computer you have access to (not Athena, because Kerberos interacts weirdly with SSH keys). Make sure your private key is encrypted with a passphrase, so it is protected at rest.

```shell
 ssh-keygen -t ed25519 
```
2.Set up GPG

3.Send Anish an encrypted email (public key).

```shell
gpg --encrypt --sign --armor -r me@anishathalye.com name_of_fil
```

4.Sign a Git commit with git commit -S or create a signed Git tag with git tag -s. Verify the signature on the commit with git show --show-signature or on the tag with git tag -v.

```shell
 git commit -S -m "sign a commit"
```

if we have

```shell
 echo "test" | gpg --clearsign
 gpg: [stdin]: clear-sign failed: Inappropriate ioctl for device
```

Then execute

```
 export GPG_TTY=$(tty)
```

In addition, the signature algorithm is the same as the name of the name of the ~ /.gitconfig, which is used in the key when the secret key is generated.

```
 gpg -K --keyid-format SHORT
 /Users/lingfeng/.gnupg/pubring.kbx
 ----------------------------------
 sec   rsa2048/56EF5DE3 2021-05-15 [SC] [有效至：2023-05-15]
     35A0BAB790EBBFE193422975097FC49956EF5DE3
 uid         [ 绝对 ] hanxiaomax-mac <hanxiaomax@qq.com>
 ssb   rsa2048/55FB9195 2021-05-15 [E] [有效至：2023-05-15]
```
 
The corresponding.gitconfig is

```
 [user]
     name = hanxiaomax-mac
     email = hanxiaomax@qq.com
     signingKey = 55FB9195
```

After all problems are solved, sign normally

```
 git commit -S -m "sign a commit"
 [main fc8e916] sign a commit
 3 files changed, 3 insertions(+)
 create mode 100644 security/afile
 create mode 100644 security/notsafefile
 create mode 100644 security/secfile
 ```
