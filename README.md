Digabi Live (Live-Linux)
================================
TL;DR Sources for Digabi Live, a Live-Linux preview, created by The 
Matriculation Examination Board of Finland.


## Goals
Live system goals:

 * prevent cheating (using forbidden materials, communication w/ other 
  students, using internet when forbidden)
 * provide solid system for attending the exam


## Howto
Assuming you have required packages installed (see below), building new image is quite easy:

    git clone https://github.com/digabi/digabi-live.git
    cd digabi-live
    make dist

After building, image can be found in `dist/` directory.

Our images are published via [SourceForge](http://sourceforge.net/projects/digabi/files/).

For instructions on using `live-build`, see [Debian Live Manual](http://live.debian.net/manual/3.x/)

## Contact
 * [The Matriculation Examination Board of Finland](http://www.ylioppilastutkinto.fi/), PB50, 00581 Helsinki, Finland
 * Project website: [digabi.fi](http://digabi.fi/)
 * [github.com/digabi/digabi-live](https://github.com/digabi/digabi-live)
 * email: [digabi@ylioppilastutkinto.fi](mailto:digabi@ylioppilastutkinto.fi)


## Requirements for build system
 * [Debian](http://www.debian.org/) 8.0 (jessie)
 * packages: `live-build, build-essential, kernel-package, apt-cacher-ng` (for full list: see `doc/INSTALL.md`)
 * you may use [Digabi Buildbox](http://sourceforge.net/projects/digabi/files/tools), VirtualBox machine image for build environment. You probably want to run `sudo apt-get update && sudo apt-get dist-upgrade` after first run

## Documentation
See `doc/*.md`.


## Disclaimer
The current version of the Matriculation Examination Board's exam 
operating system aims to demonstrate the exam execution environment. 
The Matriculation Examination Board reserves the right to revise the 
exam operating system without prior notice.  As this is solely a test 
version, the final product may be different.

The operating system is designed so that it will not make modifications 
to the workstation. All testing is done at one's own risk.


## License
This product is based on upcoming Debian 8.0 (jessie), and includes 
software w/ various licenses. For licensing information, see [Debian 
License information ](http://www.debian.org/legal/licenses/). Work done 
by MEB is licensed under GPLv3, except MEB logo (provided by 
`digabi-customization` package), and when otherwise noted. Content in 
`gh-pages` branch has its own licenses.
