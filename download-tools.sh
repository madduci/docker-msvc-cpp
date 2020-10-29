#!/usr/bin/env bash 
cd vagrant

vagrant up
vagrant halt
vagrant destroy -f

cd ..
