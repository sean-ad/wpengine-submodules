# wpengine-submodules
A script for deploying a WordPress project to WP Engine where the project includes private submodules. WPEngine only supports public submodules at the current time but sometimes that's not what we want.

Local workstation: Linux / MacOSX only

Make sure you have your keys set up at WPEngine first, and that Git Push is enabled.

What this script does:


1. Checks out the project into a temporary directory
2. Retrieves the submodules
3. Pushes the newly-built temporary repo to WPEngine
4. Cleans up


Thanks to https://github.com/hello-jason/bedrock-deploy-to-wpengine for the idea
