Digabi Live (Live-Linux)
================================
TL;DR Sources for Digabi Live, a Live-Linux preview, created by The Matriculation Examination Board of Finland.


## Introduction
*The Matriculation Examination Board of Finland* arranges two examinations for students finishing their upper secondary school annually. The most popular subjects may have as many as 30.000 students attending simultaneously. The exams take place in 450 schools around Finland. Organising the exams is funded by the government (~33%) and students (~66%).

Currently, the exams are carried out with paper and pencil. Most questions take the form of small essays, while some utilise multiple-choice questions. The former are evaluated in a two-phase process where the students’ teachers and the board censors both assess the students’ work. The multiple-choice questions are evaluated by OCR. The students are not allowed to use any material other than what is given on the day of the examination.

The Matriculation Examination Board of Finland started the Digabi project in early spring 2013. The objective of Digabi is to organise the application of IT in the assessments of the Matriculation Examination Board. The complete process of organising the exams with IT will gradually take place in 2016-2019. After the switch, the students will formulate their answers using some kind of device – probably a laptop or a tablet. Due to financial reasons, the students will be allowed to bring their own devices to the exam. However, we do not expect the nature of the exam to change in the first few years. Consequently, we have to prevent collaboration between students and access to the Internet.

The renewed examination system will contain the following subsystems:
 - A test system which interacts with the students. The system must support a variety of question types and devices, while taking into account that a number of schools have issues with low bandwidth. We have requirements for availability, integrity and non-repudiation.
 - An evaluation system that carries out the two-step evaluation process.
 - An extranet covering the schools, teachers and students that supports electronic service processes (e.g. exam registration).
 - A Data Warehouse supporting system integration and academic research.
 - An identity management system that holds the data concerning the students, teachers and censors. It works as the backbone for the other systems (e.g. authentication, authorisation and digital signing).

During the year 2013 the project sets standards for the rooms used in the exam, selects the test system and the supporting devices as well as starts planning the new processes.

There will be a **live (operating) system**, running on student-owned devices (laptops etc.), used for accessing the test system. First (test)version of aforementioned system will be implemented with Linux. This is it.


## Goals
Live system goals:

 * prevent cheating (using forbidden materials, communication w/ other students, using internet when forbidden)
 * provide solid system for attending the exam


## Howto
Assuming you have required packages installed (see below), building new image is quite easy:

    git clone https://github.com/digabi/digabi-live.git
    cd digabi-live
    make dist

After building, image can be found in `dist/` directory.


## Contact
 * [The Matriculation Examination Board of Finland](http://www.ylioppilastutkinto.fi/), PB50, 00581 Helsinki, Finland
 * Project website: [digabi.fi](http://digabi.fi/)
 * [github.com/digabi/digabi-live](https://github.com/digabi/digabi-live)
 * email: [digabi@ylioppilastutkinto.fi](mailto:digabi@ylioppilastutkinto.fi)


## Requirements for build system
 * [Debian](http://www.debian.org/) 7.0 (wheezy)
 * packages: `live-build, build-essential, kernel-package, apt-cacher-ng` (for full list: see `doc/INSTALL.md`)


## Documentation
See `doc/*.md`.


## Disclaimer
The current version of the Matriculation Examination Board's exam operating system aims to demonstrate the exam execution environment. The Matriculation Examination Board reserves the right to revise the exam operating system without prior notice.  As this is solely a test version, the final product may be different.

The operating system is designed so that it will not make modifications to the workstation. All testing is done at one's own risk.


## License
This product is based on Debian 7.0 (wheezy), and includes software w/ various licenses. For licensing information, see [Debian License information ](http://www.debian.org/legal/licenses/). Work done by MEB is licensed under GPLv3, except MEB logo (provided by `digabi-customization` package), and when otherwise noted. Content in `gh-pages` branch has its own licenses.
