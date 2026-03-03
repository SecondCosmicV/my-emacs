#!/bin/bash

mkdir -p ~/.emacs.d/plugins
ln -s $(realpath init.el) ~/.emacs.d/
ln -s $(realpath src) ~/.emacs.d/

