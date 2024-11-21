Abitti Disk Image
================================
Abitti Disk Image (formerly DigabiOS) is a collection of Linux distributions maintained by the [Finnish Matriculation Examination Board](http://www.ylioppilastutkinto.fi/) (MEB). The distributions are based on Debian GNU/Linux and used for disk images distributed for the matriculation examination environment called Abitti.

For information regarding use of the Abitti trademark, please consult https://abitti.net/abitti-trademark.html.


## Distributions

 * The client distribution runs on candidates’ devices
 * The server distribution runs on exam arrangers’ devices


## Documentation
For documentation, see `doc/*.md`. Manual for `live-build` toolset: 
[Debian Live Manual](https://live-team.pages.debian.net/live-manual/).


### How to build
To get an overview of the building process see [`doc/building.md`](doc/building.md). However, while this repository contains the code required to build the kernel and the image the complete Abitti image contains packages from various sources.


### Sources
Abitti Disk Image is not an open source project. The Abitti Disk Image contains binary packages from various sources:

* Abitti Disk Image uses GNU/Linux kernel obtained from Debian source packages. The source kernels are as-is except a one-line patch that disables booting with an arbitrary initrd. The patched kernel sources can be found at https://static.abitti.fi/kernel-sources/index.html.
* Most of the binary files in the image are unchanged Debian packages. The package owning a file can be queried using the standard Debian tool `dpkg`. The sources of these unchanged packages are provided by [the Debian project](https://www.debian.org/distrib/packages). The sources of changed GPL licensed packages can be found at https://static.abitti.fi/patched-sources/index.html.
* The Abitti Disk Image contains closed source software. The MEB has signed license agreements with the respective parties and further gives Abitti users rights mentioned in the [Abitti license agreement](https://www.abitti.fi/kayttoehdot/).
* The Abitti exam system, which in this case means code showing the exam questions, material and recording the test takers’ submissions is owned by the MEB. It is licensed according to the aforementioned Abitti license agreement. Some modules are open source, see https://abitti.net.

## Disclaimer
The source code is released here on grounds of transparency. The maintainers of the repository do not actively investigate pull request or issues. To contact MEB regarding this repository, please use the address abitti@ylioppilastutkinto.fi.

MEB reserves the right to revise the content of this repository without prior notice.

All use of the content of this repository is done at one's own risk.

