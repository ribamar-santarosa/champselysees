# enc-dec-ruby
Tool for encrypting-decrypting file.

TODO: SHA1, eliminate iv file.

Generate a file to be encrypted to follow examples:
````
contents=secret_file
cat << EOF > ${contents}
file_contents_to_be_encrypted
EOF
#
````

Examples:

````
#set some globals:
password="onlynsaknows" # leave empty for interactive prompt of password
enc_iv_base64_file=out.enc.iv.base64
encrypted_base64_file=out.enc.encrypted.base64

````
````
# enc.rb will generate ${enc_iv_base64_file} and ${enc_iv_base64_file} out of ${contents} and ${password}
./enc.rb ""  ${contents} "" "${password}"


cat "${enc_iv_base64_file}"
# nhzeDWAH8HN9FbNEx1amIw==

cat "${encrypted_base64_file}"
# n9KfAB+ta3BAEONgMZpUK0iahiI/9gdcYIBMegM+4IM=
````
````
# dec.rb can be used with any combination of those files or contents:
./dec.rb "nhzeDWAH8HN9FbNEx1amIw==" "n9KfAB+ta3BAEONgMZpUK0iahiI/9gdcYIBMegM+4IM=" "${password}"
# file_contents_to_be_encrypted


./dec.rb "${enc_iv_base64_file}" "n9KfAB+ta3BAEONgMZpUK0iahiI/9gdcYIBMegM+4IM=" "${password}"



./dec.rb "nhzeDWAH8HN9FbNEx1amIw==" "${encrypted_base64_file}" "${password}"
# file_contents_to_be_encrypted

./dec.rb "${enc_iv_base64_file}" "${encrypted_base64_file}" "${password}"
# file_contents_to_be_encrypted
````
````
# the "${enc_iv_base64_file}" "${encrypted_base64_file}" set by this example are the default
# names. they can be omitted:
./enc.rb ""  ${contents} "" "${password}"
./dec.rb "" "" "${password}"
# file_contents_to_be_encrypted
````
````
#unset globals:
unset password
unset enc_iv_base64_file
unset encrypted_base64_file
````

