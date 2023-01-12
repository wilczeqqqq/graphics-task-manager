# ArtGear - Graphics Task Manager

[![Tests workflow](https://github.com/wilczeqqqq/graphics-task-manager/actions/workflows/github-ci.yml/badge.svg?branch=master)](https://github.com/wilczeqqqq/graphics-task-manager/actions/workflows/github-ci.yml)
[![Ruby](https://img.shields.io/badge/Ruby-v3.1.2-red)](https://img.shields.io/badge/Ruby-v3.1.2-red)
[![Rails](https://img.shields.io/badge/Rails-v7.0.4-red)](https://img.shields.io/badge/Rails-v7.0.4-red)

# Environment configuration

**Fetch license for Intellij Ultimate or RubyMine:**
* Go to https://account.jetbrains.com and create an account. You can use both your private or student mail account.
* Click `Apply for a free student license`.
* Apply with university email address.
* Proceed with instructions on your mail account.
* Download `Intellij Ultimate` or `RubyMine` and install new software.
* Run IDE and activate a license by logging in. 
* (Optional) If you chose `Intellij Ultimate` install a plugin named `Ruby`.

**Install Ruby SDK:**
* Go to https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.2-1/rubyinstaller-devkit-3.1.2-1-x64.exe
* Install all dependencies.
* Run Ruby Installer and choose option `3`, then `ENTER`.
* After installation click `ENTER` again. CMD line should now close.

**Download project from VCS:**
* Run IDE and choose `Get from VCS`.
* In URL paste `https://github.com/wilczeqqqq/graphics-task-manager.git`


**Configure IDE to work with Ruby on Rails:**
* Launch `graphics-task-manager` project
* `File > Project Structure > Project Settings > Project > SDK` and add Ruby interpreter using Ruby installation path _(Intellij should find it by itself)_
* Run terminal `Alt + F12`
* ```sh
    gem install bundler
    bundle install --path vendor/bundle
    ```
* Double click `Ctrl` and type `Development: graphics-task-manager`, then run it.
* Go to http://localhost:3000, you should see now welcome www site.

**(Optional) Install Node16 and yarn:**
* https://nodejs.org/dist/v16.16.0/node-v16.16.0-x64.msi
* Install all dependencies.
* Open terminal and run `npm install --global yarn`

**(Optional) Install Graphviz:**
* Open terminal and run `choco install graphviz` _(only after node16 and yarn installation)_