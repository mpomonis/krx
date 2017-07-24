kR^X: Comprehensive Kernel Protection Against Just-In-Time Code Reuse

+--------------------+
[+] kR^X Distribution|
+--------------------+

Our kR^X bundle contains the following directories:

	[*] `src': This directory contains the code of that implements the
		protection. Within it, it contains the following:

		[*] `configs': This directory contains the config files for the
			Linux kernel v3.19 that we used when 
			implementing/testing kR^X.
		[*] `utils': This directory contains some necessary utilities
			(`as' wrapper and AWK script) used by kR^X.
		[*] `linux-3.19-krx.patch': The Linux kernel (v3.19) patch
			necessary for placing the code on the top of the address
			space and setting up the MPX `bnd0' register (so that
			it can be used when using the MPX protection scheme).

Currently this repo does not contain the GCC plugins that perform the SFI/MPX
enforcement and the fine-grained KASLR plugins (randomizations and return
address protection schemes). We will add them as soon as possible and update
this document with instructions on how to use them.

+-------------+
[+] Using kR^X|
+-------------+

To use kR^X you need to follow the instructions below (we assume a Debian/Linux
distribution):

	[0.1] Download and untar the Linux kernel v3.19
		wget linux-3.19.tar.gz
		tar xfz linux-3.19.tar.gz
	
	[0.2] Export the location of this repo
		export REPO_DIR="/home/marios/krx"

	[1] Patch the Linux kernel
		cd linux-3.19
		patch -p1 < $REPO_DIR/src/linux-3.19-krx.patch

	[2] Setup the `as' wrapper
		sudo mv /usr/bin/as /usr/bin/as.old && sudo ln -s $REPO_DIR/src/utils/as_wrapper.sh /usr/bin/as
	
	[3] Configure the kernel (in this example we use `config-3.19-amd64.krx.deb' which is similar to the default Debian config file)
		cp $REPO_DIR/src/configs/config-3.19-amd64.krx.deb ./.config
		make oldconfig
	
	[4] Build the kernel
		make -j12
