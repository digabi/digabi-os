Digabi Live
================================

## Introduction
The Matriculation Examination Board of Finland arranges annually two examinations for students finishing their upper secondary school. The most popular subjects may have as many as 30 000 simultaneously attending students. The exams take place in the 450 schools around Finland. The organisation of the exams (the board) is funded by the government (~33%) and students (~66%).

Currently the exams are carried out with paper and pencil. Most questions take the form of small essays while some utilise multiple choice questions. The former are evaluated in a two-phase process where students’ teachers and the board censors are both reviewing the fulfillment. The multiple choice questions are examined by OCR. The students are not allowed to use any material other than given with the questions.

The complete process of organising the exam will gradually utilise IT between 2016 and 2019. After the change the students will draw up their answers using some kind of device – probably a laptop or a tablet. Due to financial reasons the students may bring their own devices to the exam. However, we do not expect the nature of the exam change in the first years. In other words we have to prevent collaboration and access to the Internet.

 

The renewed examination system will contain following subsystems:

*Test system* which interacts with the students. The system must support variety of question types and devices while a number of schools have issues with low bandwidth. We have requirements for availability, integrity and non-repudiation.
*Evaluation system* carries out the two-step evaluation process.
*Extranet* covering the schools, teachers and students supports electronic service processes (e.g. exam registration).
*Data Warehouse* supporting system integration and academic research.
*Identity management system* holds the data concerning the students, teachers and sensors. It works as the backbone for the other systems (e.g. authentication, authorisation and digital signing).
During the year 2013 the project sets standards for the rooms used in the exam, selects the test system and the supporting devices as well as starts planning the new processes.

In addition, there will be a live system, running on student-owned devices (laptops etc.). First (test)version of aforementioned system will be implemented with Linux. This is it.


## Goals
Live system goals:

 * prevent cheating (using forbidden materials, communication w/ other students, using internet when forbidden)
 * provide solid system for attending the exam


## Contact
 * [The Matriculation Examination Board of Finland](http://www.ylioppilastutkinto.fi/), PL50, 00581 Helsinki, Finland
 * [digabi.fi](http://digabi.fi/)
 * [github.com/digabi/digabi-live](https://github.com/digabi/digabi-live)
 * email: [digabi@ylioppilastutkinto.fi](mailto:digabi@ylioppilastutkinto.fi)


## Requirements for build system
 * [Debian](http://www.debian.org/) 7.0 (wheezy)
 * packages: `live-build, build-essential, kernel-package, apt-cacher-ng` (for full list: see `doc/INSTALL.md`)


## Documentation
See `doc/*.md`.


## License
This product is based on Debian 7.0 (wheezy), and includes software w/ various licenses. For licensing information, see [Debian License information ](http://www.debian.org/legal/licenses/).
