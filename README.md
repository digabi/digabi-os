[![Digabi logo](https://digabi.fi/images/digabi-logo.png)](https://digabi.fi) 

Digabi is a codebase used in the Abitti exam system, the digital exam environment for the [Finnish Matriculation Examination](https://www.ylioppilastutkinto.fi/en).

All bug reports, feature requests, and pull requests are appreciated. However, the following should be kept in mind:

* Pull requests based on submitted issues cannot be implemented due to limited resources. Similarly, upstream issues related to third-party projects in use are not forwarded.
* No guarantee can be given that submitted pull requests will be reviewed.
* Our focus is strictly on the Finnish Matriculation Examination, as defined by law. Issues or pull requests unrelated to this mission will not be addressed.
* Official channels should be used for inquiries. The issue tracker and pull requests are not to be used for general questions or support requests.

Before any contribution is accepted to the codebase, to clarify the intellectual property rights associated with contributions to open-source projects owned by the Finnish Matriculation Examination Board, all contributors must sign and submit a Contribution License Agreement (CLA):

* Individuals should sign and send the [Personal CLA](https://digabi.fi/YTL%20Personal%20CLA.pdf) to digabi@ylioppilastutkinto.fi.
* Organizations or corporations should sign and send the [Corporate CLA](https://digabi.fi/YTL%20Corporate%20CLA.pdf) to the same address.

Digabi 1 (DigabiOS)
================================
The current Abitti 1 version runs on Debian Linux. The end-of-life of the underlying DigabiOS distribution will happen after the test days in spring 2026.

In Digabi 1, test takers start their laptops from USB sticks and the servers run in a similar fashion. You can run the server as VirtualBox VM. For this, we have an end-user helper application, Naksu.

While Debian GNU/Linux is itself based on open source, the Abitti exam system is not. Also, the disk image contains 3rd party software with separate licenses. All end-user licenses and the record of processing activities can be found at [Abitti.fi](https://www.abitti.fi/kayttoehdot/).

If you are providing applications to Abitti 1 you might want to take a look at [the instructions](https://digabi.fi/abitti-live.html) how to tinker Digabi 1 (DigabiOS).

## Distributions

 * The client distribution runs on candidates’ devices
 * The server distribution runs on exam arrangers’ devices


## Documentation
For documentation, see `doc/*.md`. Manual for `live-build` toolset: 
[Debian Live Manual](https://live-team.pages.debian.net/live-manual/).


### How to build
To get an overview of the building process see [`doc/building.md`](doc/building.md). However, while this repository contains the code required to build the kernel and the image the complete Abitti image contains packages from various sources.


### Sources
DigabiOS is not an open source project. The DigabiOS contains binary packages from various sources:

* DigabiOS uses GNU/Linux kernel obtained from Debian source packages. The source kernels are as-is except a one-line patch that disables booting with an arbitrary initrd. The patched kernel sources can be found at https://static.abitti.fi/kernel-sources/index.html.
* Most of the binary files in the image are unchanged Debian packages. The package owning a file can be queried using the standard Debian tool `dpkg`. The sources of these unchanged packages are provided by [the Debian project](https://www.debian.org/distrib/packages). The sources of changed GPL licensed packages can be found at https://static.abitti.fi/patched-sources/index.html.
* The DigabiOS contains closed source software. The MEB has signed license agreements with the respective parties and further gives Abitti users rights mentioned in the [Abitti license agreement](https://www.abitti.fi/kayttoehdot/).
* The Abitti exam system, which in this case means code showing the exam questions, material and recording the test takers’ submissions is owned by the MEB. It is licensed according to the aforementioned Abitti license agreement. Some modules are open source, see https://abitti.net.

## Disclaimer
The source code is released here on grounds of transparency. The maintainers of the repository do not actively investigate pull request or issues. To contact MEB regarding this repository, please use the address abitti@ylioppilastutkinto.fi.

MEB reserves the right to revise the content of this repository without prior notice.

All use of the content of this repository is done at one's own risk.

