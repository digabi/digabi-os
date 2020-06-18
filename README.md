DigabiOS (DOS)
================================
TL;DR Sources for DigabiOS, a Live-Linux system, created by The 
Matriculation Examination Board of Finland (In Finnish: 
[Ylioppilastutkintolautakunta](http://www.ylioppilastutkinto.fi/)).


## Goals

### Client

 * runs on student devices (BYOD)
 * prevents cheating (using forbidden materials, communication w/ other 
  students, using internet when forbidden)
 * provides a solid system for attending the exam


### Server

 * runs on school-owned devices
 * hosts local copy of the testing system, syncs data to cloud

## Documentation
For documentation, see `doc/*.md`. Manual for `live-build` toolset: 
[Debian Live Manual](http://live.debian.net/manual/3.x/).


### How to build
See [`doc/building.md`](doc/building.md) for detailed instructions. TL;DR; `make -f Makefile.build dist`.


## Disclaimer
The current version of the Matriculation Examination Board's exam 
operating system aims to demonstrate the exam execution environment. 
The Matriculation Examination Board reserves the right to revise the 
exam operating system without prior notice.  As this is solely a test 
version, the final product may be different.

The operating system is designed so that it will not make modifications 
to the workstation. All testing is done at one's own risk.


## License
This product is based on Debian 9.0 (stretch), and includes 
software w/ various licenses. For licensing information, see [Debian 
License information](http://www.debian.org/legal/licenses/). Work done 
by MEB is licensed under GPLv3, except MEB/Digabi logos (included in 
some `digabi-*` packages), and when otherwise noted.


## Contact
 * [The Matriculation Examination Board of Finland](http://www.ylioppilastutkinto.fi/), PB50, 00581 Helsinki, Finland
 * [github.com/digabi/digabi-os](https://github.com/digabi/digabi-os)
 * email: [digabi@ylioppilastutkinto.fi](mailto:digabi@ylioppilastutkinto.fi)
