# NFV API Conformance Test Specification

This repository hosts the NFV API Conformance test specification for the APIs defined in ETSI NFV GS [SOL002](https://www.etsi.org/deliver/etsi_gs/NFV-SOL/001_099/002/02.04.01_60/gs_NFV-SOL002v020401p.pdf), [SOL003](https://www.etsi.org/deliver/etsi_gs/NFV-SOL/001_099/003/02.04.01_60/gs_NFV-SOL003v020401p.pdf), [SOL005](http://www.etsi.org/deliver/etsi_gs/NFV-SOL/001_099/005/02.04.01_60/gs_NFV-SOL005v020401p.pdf).

The Test Specification is built as a collection of [Robot Framework](robotframework.org/) Test Description. [Robot Framework](robotframework.org/) is a generic test automation framework for acceptance testing and acceptance test-driven development.

**IMPORTANT: This repository and the NFV API Conformance Test Specification is Work in Progress. The Robot Framework Test Descriptions are expected to be consolidated and reviewed in the short term, and possibly re-organized to ease automation of NFV workflows testing. SOL005 Test Descriptions are under development and will be contributed during Q1-2019**

## Content structure

This repository is following the structure of the ETSI NFV GS SOL002, SOL003 and SOL005 specifications. It includes a dedicated folder for each of these NFV spec, with individual sub-folders for every interface in the given specification, following this structure:
```
    <spec_name>/<interface_name>
```
e.g.
```
    SOL002/VNF-Configuration-API/
```
For each of the interface sub-folders, a list of Robot Framework files is included, each providing the set of Test Cases related to a given resource endpoint within the reference interface. In addition, the following sub-folders are included:
```
    <spec_name>/<interface_name>/jsons
    <spec_name>/<interface_name>/schemas/
    <spec_name>/<interface_name>/environment/
```
The *jsons* folders include the templates for the JSON requests to be issued automatically issued by the Test System. The tester is expected to fill or complete the content of these JSON requests according to the tests to be executed.
The *schemas* folders include the JSON schemas for requests and reponses over the . They are extracted from the [SOL002](https://forge.etsi.org/gitlab/nfv/SOL002-SOL003), [SOL003](https://forge.etsi.org/gitlab/nfv/SOL002-SOL003) and [SOL005](https://forge.etsi.org/gitlab/nfv/SOL005) OpenAPIs.
The *environment* folders include the list of variables and parameters used in the Robot Framework Test Cases. The tester is expected to value these variables according to the tests to be executed.

## Dependencies and Preconditions
The main precondition for running the tests is having [Robot Framework](robotframework.org/) installed.
[Robot Framework installation instructions](https://github.com/robotframework/robotframework/blob/master/INSTALL.rst) provide full details of the installation procedure.
For those familiar with installing Python packages with [pip](http://pip-installer.org/) package manager, the following command can be run to install [Robot Framework](robotframework.org/):
```
$ pip install robotframework
```
Robot Framework 3.0 is recommended. It requires Python 3.

### Robot Framework Required Libraries
The Robot Framework Test Cases in this repository depend on the following libraries:

* [RESTInstance](https://github.com/asyrjasalo/RESTinstance)
* [DependencyLibrary](https://github.com/mentalisttraceur/robotframework-dependencylibrary)
* [JSONLibrary](https://github.com/nottyo/robotframework-jsonlibrary)
* [JSONSchemaLibrary](https://github.com/jstaffans/robotframework-jsonschemalibrary)
* [MockServer](https://github.com/tyrjola/robotframework-mockserver)

The [MockServer](https://github.com/tyrjola/robotframework-mockserver) library has been patched to have support of JSON schema validation.
The patch to be applied is available at:
```
    extensions/mockserverlibrary.patch
```
The patch can be installed with the following commands:
```
$ git clone https://github.com/tyrjola/robotframework-mockserver
$ cd  robotframework-mockserver
$ patch <this_repo_dir>/extensions/mockserverlibrary.patch
$ python -m pip install -e robotframework-mockserver
```
## Running Tests
The Robot Framework Test Cases in this repository can be executed with the following command:
```
$ robot <name_of_the_robot_file>
```
To execute all test case files in a directory recursively, just give the directory as an argument. You can also give multiple files or directories in one go and use various command line options supported by Robot Framework. 

For more information about the command line usage, you can run:
```
$ robot --help
```
The [Robot Framework User Guide](http://robotframework.org/robotframework/#user-guide) provides full details on how to execute tests in general.

## How to raise issues

Change requests can be filed at [ETSI Forge Bugzilla](<LINK>). Please report errors, bugs or other issues [here](https://forge.etsi.org/bugzilla/enter_bug.cgi?product=NFV).

## How to contribute

ETSI Forge uses Gitlab to manage submissions to the repository.
For more information on setting up your environment and contributing, you may refer to the [ETSI Forge wiki](https://forge.etsi.org/wiki/index.php/Main_Page).

## License

Copyright (c) ETSI 2018.
 
This software is subject to copyrights owned by ETSI. Non-exclusive permission 
is hereby granted, free of charge, to copy, reproduce and amend this file 
under the following conditions: It is provided "as is", without warranty of any 
kind, expressed or implied. 

ETSI shall never be liable for any claim, damages, or other liability arising 
from its use or inability of use.This permission does not apply to any documentation 
associated with this file for which ETSI keeps all rights reserved. The present 
copyright notice shall be included in all copies of whole or part of this 
file and shall not imply any sub-license right.
