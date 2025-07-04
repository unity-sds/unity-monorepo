# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.13.0] - 2025-07-01

### Added
* Modify Unity-Py Jupyter notebook to provide documentation on how to update an OGC process

## [0.12.0] - 2025-06-10

### Added
* Introduce a new class as part of stage-out process: STACCollectionCreator class - Utility for creating STAC Collections from file lists 

## [0.11.1] - 2025-06-09

### Added
* Cognito token fetching now appropriately stores and checks token expiration on token use.


## [0.11.0] - 2025-05-19

### Added
* When creating STAC catalogs using the Collection resource, if an asset is a file local to the catalog file, then the file:size and file:checksum values will be added to the asset's STAC entry.

## [0.10.1] - 2025-03-04

### Added

### Fixed

* Do not fail on case insensitive portion of collection id in DataService::create_collection routine
* Fixed error handling of DataService routines to use .text instead of the invalid .message attrbute of the response object
* Cleaned up JSON submitted by DataService::create_collection to not contain less random values

### Changed

* Enforce a specific capitalization for the case insensitive portion of a collection id in DataService::create_collection
* DataService::create_collection now returns the JSON it submitted to the API

## [0.10.0] - 2025-02-19

### Added
* Unit test to validate the health services schema

### Fixed
* Schema definition of health service as it wasn't properly validating enumerated values

### Changed
* The health services schema has been updated to account for the new fields, componentCategory, componentType, and description
* Improved error handling of health service methods related to fetching health information from API
* Unit tests have been updated to use mock data rather than live API endpoints
* Updated printing of health status report to include new fields mentioned above

### Removed
* Superfluous unit test that creates a health_service instance

### Security

### Deprecated

## [0.9.0] - 2025-02-19

### Added

### Fixed

### Changed
* Changed Health Service to report information from updated Health API endpoint.
* Minor changes to the Health Service Status report.
* Updated health JSON schema definition to match updated output from Health API endpoint.

### Removed

### Security

### Deprecated

## [0.8.1] - 2025-02-10

### Added

### Fixed

### Changed

* Updated the the OGC Processes API Jupyter Notebook to provide more detail.

### Removed

### Security

### Deprecated

=======
## [0.8.0] - 2025-1-14

### Added

### Fixed

### Changed

* Updated the unity-py to include the Data Service Delete.

### Removed

### Security

### Deprecated

## [0.7.0] - 2024-11-21

### Added

### Fixed

* updated poetry build for 'version' workflow

### Changed

* Updated the usage of the OGC Processes Client to conform more closely to OGC Processes API spec.

### Removed

### Security

### Deprecated

## [0.6.1] - 2024-09-05

### Added

* Added sphinx doc gen

### Fixed

### Changed

### Removed

### Security

### Deprecated

## [0.6.0] - 2024-08-13

### Added

* Added app-pacakge build system client and integrations

### Fixed

### Changed

### Removed

### Security

### Deprecated

## [0.5.0] - 2024-07-31

### Added

### Fixed

* cleaned up some README formatting

### Changed

* changed endpoints from cloudfront urls to DNS entries

### Removed

### Security

### Deprecated

## [0.5.0] - 2024-07-23

### Added

* Health Service with variuos functions that allow user's to inspect the health status of the system

### Fixed

### Changed

* Health status information is included when an instantiated unity object is printed.
* OGC Process API support to use ogc_processes client published by SPS

### Removed

### Security

### Deprecated

## [0.4.0] - 2024-03-29

### Added

* We've added the ability to override settings in the default config file by passing in a config file with the settings needing to be overridden when instantiating a Unity object. [56](https://github.com/unity-sds/unity-py/issues/56)
* Collection creation (create_collection) through dataService library
* Added support for defining custom metadata for project and venue.
* Added methods to return STAC content instead of unity domain objects if requested
* Added properties parsing of stac metadata to dataset objects

### Fixed

### Changed

* Updated get_collections and get_collection_data to support limit parameter.
* Updated get_collection_data to support filter parameter which takes CQL string.

### Removed

### Security

### Deprecated

## [0.3.0] - 2024-02-12

### Added

### Fixed

* fixed an issue with encoding a json deploy request twice [71](https://github.com/unity-sds/unity-py/issues/71)

### Changed

* We now use the asset URI/HREF as the key into the assets, and use the "metadata" and "data" types as asset-roles: [69](https://github.com/unity-sds/unity-py/issues/69)

### Removed

### Security

### Deprecated

## [0.2.2] - 2024-01-03

### Added

* Added project/venue support [5](https://github.com/unity-sds/unity-py/issues/58)

### Fixed

### Changed

### Removed

### Security

### Deprecated

## [0.2.1] - 2023-11-29

### Added

* python code coverage via coveralls

### Fixed

### Changed

* updated install to support python 3.8 and above.

### Removed

### Security

### Deprecated

## [0.2.1] - 2023-11-29

### Added

* python code coverage via coveralls

### Fixed

### Changed

* updated install to support python 3.8 and above.

### Removed

### Security

### Deprecated

## [0.2.0] - 2023-08-10

### Added

* Added parsing of collection in stac items

### Fixed

* fixed release workflow to test against `unity-sds-client` not `unity_py`

### Changed

* updated package name so that imports reference `unity_sds_client` not `unity_py`

### Removed

### Security

### Deprecated

## [0.1.2] - 2023-06-28

### Added

* added method for retrieving datasets `Collection.datasets` from a collection

### Fixed

* Added some directory slash stripping to ensure no trailing slash when specifying "to_stac" output director

### Changed

* Changed name of package from unity-py to unity-sds-client

## [0.1.1] - 2023-06-27

### Added

* Added pypi repository publication to unity-py repository [[7](https://github.com/unity-sds/unity-py/issues/7)].
* Added to_stac methods for writing STAC from unity-py resources (e.g. collection, dataset, datafiles)
* Added from_stac methods for creating unity-py resources (e.g. collection, dataset, datafiles) from STAC files
* Added capability to add files to published application catalogs
* added dependency on pystac > 1.7.3 to unity-py
* added addition of dataset properties to stac read/write
* Added functionality to download latest available version of the application parameter files stored in the Dockstore [[30](https://github.com/unity-sds/unity-py/issues/30)]

### Fixed

* Added some directory slash stripping to ensure no trailing slash when specifying "to_stac" output director

### Changed

* all assets written out to STAC items are made relative (if they are non-URIs, relative, or exist in the same directory tree of the STAC files)
* Changed name of package from unity-py to unity-sds-client

### Removed

* Removed support for python 3.8

## [0.1.0] - 2023-04-17

### Added

#### Unity-Py Updates

* Added Services and Classes to ecapsulate funcionality per Unity Service Area
    1. Process Service & Class — Deploy a process, List processes, get metadata about a processes, query jobs per process, execute a job
    2. Job Class — Facilitate API calls to U-SPS to monitor jobs, get job results, or dismiss jobs.
    3. Application Service — Courtesy of U-ADS (James and Masha) (See Application Registry below).
* Mercury Dashboard Example
* Miscellaneous quality of life improvements to ease code developing (type hinting, annotations, etc)

#### Application Registry

* [unity-ads-deployment #79](https://github.com/unity-sds/unity-ads-deployment/issues/79) Add Dockstore API access to Unity.py
* [unity-ads-deployment #87](https://github.com/unity-sds/unity-ads-deployment/issues/87) Convert Unity.py Application Package API to use Hosted Workflows
