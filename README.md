# XRPL Sidechain Hub

The Hub is a central location to hold sidechain builds and validation files. Each sidechain/amendment has its own directory inside the hub.

> The reason the hub exists is because we need to run tests in a standalone environment for each amendment. 

## Create new ammendment or sidechain in the hub

1. Fork this repository
2. Copy the template directory in `template` and paste the dir into either amendments or sidechains.
3. Rename the directory to match the rippled branch name EXACTLY. ie. `hooks` -> `hooks`.
4. Configure your `rippled.cfg` file to include the amendment.
5. Create a pull request. Include the version, rippled branch and repository if different than XRPLF/rippled.

> Someone will review and once approved it is added to the build process.

5. Receive a build confirmation. `gcr.io/metaxrplorer/icv2:latest`
6. Receive a deploy confirmation. Must have setup with Transia. We dont deploy yet.
7. Changes to the repo/branch you provided would trigger a build. (SOON)