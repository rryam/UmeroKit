#!/bin/zsh

swift package --allow-writing-to-directory ./docs \
generate-documentation --target UmeroKit \
--disable-indexing \
--transform-for-static-hosting \
--hosting-base-path UmeroKit \
--output-path ./docs
