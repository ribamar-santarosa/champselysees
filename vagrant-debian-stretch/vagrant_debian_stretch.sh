time=stretch.$(date +"%Y.%m.%d_%H:%M:%S") #timestamp
mkdir vagrant_${time}
cd vagrant_${time}
provider_opt=
vagrant_img=
vagrant_opt=

base_img=debian/stretch64

vagrant_opt="init" ;  vagrant_img=${base_img} ; provider_opt=   # init can't go with provider
outfile=out.vagrant.${vagrant_opt}.${provider_opt}${time}
vagrant ${vagrant_opt} ${vagrant_img} ${provider_opt}   &> /dev/stdout    | tee "${outfile}" | sed 's/^/# /'


vagrant_opt="up" ; vagrant_img= ; provider_opt="--provider=libvirt"
outfile=out.vagrant.${vagrant_opt}.${provider_opt}${time}
vagrant ${vagrant_opt} ${vagrant_img} ${provider_opt}   &> /dev/stdout    | tee "${outfile}" | sed 's/^/# /'


vagrant_opt="global-status" ; vagrant_img= ; provider_opt=
outfile=out.vagrant.${vagrant_opt}.${provider_opt}${time}
vagrant ${vagrant_opt} ${vagrant_img} ${provider_opt}   &> /dev/stdout    | tee "${outfile}" | sed 's/^/# /'

vagrant_opt="ssh -c ls " ; vagrant_img= ; provider_opt=
outfile=out.vagrant.${vagrant_opt}.${provider_opt}${time}
vagrant ${vagrant_opt} ${vagrant_img} ${provider_opt}   &> /dev/stdout    | tee "${outfile}" | sed 's/^/# /'

