<!-- Header block for project -->
<hr>

<div align="center">

![logo](https://user-images.githubusercontent.com/3129134/163255685-857aa780-880f-4c09-b08c-4b53bf4af54d.png)

<h1 align="center">Unity System Test</h1>
<!-- ☝️ Replace with your repo name ☝️ -->

</div>

<pre align="center">System Test area of the Unity Repository</pre>
<!-- ☝️ Replace with a single sentence describing the purpose of your repo / proj ☝️ -->

<!-- Header block for project -->
<!--
[INSERT YOUR BADGES HERE (SEE: https://shields.io)] [![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)
 ☝️ Add badges via: https://shields.io e.g. ![](https://img.shields.io/github/your_chosen_action/your_org/your_repo) ☝️ -->

<!--
[INSERT SCREENSHOT OF YOUR SOFTWARE, IF APPLICABLE]
 ☝️ Screenshot of your software (if applicable) via ![](https://uri-to-your-screenshot) ☝️ -->

<!--[INSERT MORE DETAILED DESCRIPTION OF YOUR REPOSITORY HERE]
 ☝️ Replace with a more detailed description of your repository, including why it was made and whom its intended for.  ☝️ -->
This repository includes the system test plan to be executed against a release of the Unity software system. This is mainly forr developers and integrators of Unity software.

<!--
[INSERT LIST OF IMPORTANT PROJECT / REPO LINKS HERE]
<!-- example links>
[Website](INSERT WEBSITE LINK HERE) | [Docs/Wiki](INSERT DOCS/WIKI SITE LINK HERE) | [Discussion Board](INSERT DISCUSSION BOARD LINK HERE) | [Issue Tracker](INSERT ISSUE TRACKER LINK HERE)
-->

## Features

* BDD driven test plans allow to keep test plans in sync with real world deployments.
* Test plans to address requirements
* tags to allow for testing of shared services, smoke tests, and destructive tests


## Contents

* [Quick Start](#quick-start)
* [Changelog](#changelog)
* [FAQ](#frequently-asked-questions-faq)
* [Contributing Guide](#contributing)
* [License](#license)
* [Support](#support)

## Quick Start

This guide provides a quick way to get started with our project. Please see our [docs](https://unity-sds.gitbook.io/docs/system-lifecycle/testing) for a more comprehensive overview.

### Requirements

* Knowledge of Behavior Driven Development (BDD)
* [Behave framework](https://behave.readthedocs.io/en/stable/)
* Unity username and password for service based testing
* AWS access for in-depth testing


### Setup Instructions

1. Install the required libraries:
  ```
   poetry install
  ```

<!-- ☝️ Replace with a numbered list of how to set up your software prior to running ☝️ -->

### Run Instructions
1. Configure environment for tests
    ```
    cp env.cfg .env.cfg
    vi .env.cfg (fill out this stuff for the environment)
    source .env.cfg
    ```
The configuration requires things like a unity username/password (possibly replaces with a token in the future), specific endpoints you'll want to hit, and project/venues to test against.


2. Run the regression tests
  ```
   sh regression_test.sh
  ```

### A Note On Tags

Most tests are setup with scenario outlines, meaning we can pass in a number of values from a table into a test suite. The tables are often different for de, test, and ops environments since they might refer to specific items that change in dev/test/ops environments like a collection ID or the venue you'll be in. To choose a venue, we use a tag system (e.g. `-t develop`).

Note: the tags define the scenarios run. Within the steps being executed, a call to the tags (`context.tags`) will return the tags annotating the FEATURE or SCENARIO- ***not the ones inserted on the command line!*** The following code will not work

```python
    ## DO NOT DO THIS
    if "develop" in context.tags:
        s = Unity(UnityEnvironments.DEV)
    elif "test" in context.tags:
        s = Unity(UnityEnvironments.TEST)
    elif "prod" in context.tags:
        s = Unity(UnityEnvironments.PROD)
```
Instead, we use an environment variable `UNITY_ENVIRONMENT` to determine the environment to use.

### Usage Examples

```
behave
```

Run against "develop" values
```
behave features/tagged_examples.feature -t develop
```

Run against "test" values
```
behave features/data_catalog/parent_collections.feature -t test
```

run only Shared Service Tests with test data:
```
behave --tags=shared --tags=test
```

note, using `--tags=shared,test` would run any tests tagged with shared OR items marked test.

### Build Instructions (if applicable)

No builds are necessary- these run from source code.

### Test Instructions (if applicable)

1. Test plan is communicated in the feature files of this project.

## Changelog

See our [CHANGELOG.md](CHANGELOG.md) for a history of our changes.

See our [releases page](https://github.com/unity-sds/unity-system-test/releases) for our key versioned releases.

<!-- ☝️ Replace with links to your changelog and releases page ☝️ -->

## Frequently Asked Questions (FAQ)

<!--
[INSERT LINK TO FAQ PAGE OR PROVIDE FAQ INLINE HERE]
 example link to FAQ PAGE>
Questions about our project? Please see our: [FAQ]([INSERT LINK TO FAQ / DISCUSSION BOARD])
-->

<!-- example FAQ inline format>
1. Question 1
   - Answer to question 1
2. Question 2
   - Answer to question 2
-->

<!-- example FAQ inline with no questions yet>
No questions yet. Propose a question to be added here by reaching out to our contributors! See support section below.
-->

<!-- ☝️ Replace with a list of frequently asked questions from your project, or post a link to your FAQ on a discussion board ☝️ -->

## Contributing

Interested in contributing to our project? Please see our: [CONTRIBUTING.md](CONTRIBUTING.md)

## License

See our: [LICENSE](LICENSE)

## Support

TBD

<!-- example list of contacts>
Key points of contact are: [@github-user-1](link to github profile) [@github-user-2](link to github profile)
-->

<!-- ☝️ Replace with the key individuals who should be contacted for questions ☝️ -->
