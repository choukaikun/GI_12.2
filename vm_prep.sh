#!/usr/bin/env bash

# Create OCR ASM disks
vboxmanage createhd --filename d:/vbox/asm_ocr_01.vdi --size 1024 --variant fixed
vboxmanage createhd --filename f:/vbox/asm_ocr_02.vdi --size 1024 --variant fixed
vboxmanage createhd --filename g:/vbox/asm_ocr_03.vdi --size 1024 --variant fixed

# Create MGMT ASM disks
vboxmanage createhd --filename d:/vbox/asm_mgmt_01.vdi --size 30720 --variant fixed
vboxmanage createhd --filename f:/vbox/asm_mgmt_02.vdi --size 30720 --variant fixed
vboxmanage createhd --filename g:/vbox/asm_mgmt_03.vdi --size 30720 --variant fixed

# Share OCR and MGMT disks to VMs
vboxmanage storageattach iron1 --storagectl "SATA" --port 10 --device 0 --type hdd --medium d:/vbox/asm_ocr_01.vdi --mtype shareable
vboxmanage storageattach iron2 --storagectl "SATA" --port 10 --device 0 --type hdd --medium d:/vbox/asm_ocr_01.vdi --mtype shareable
vboxmanage storageattach iron1 --storagectl "SATA" --port 11 --device 0 --type hdd --medium f:/vbox/asm_ocr_02.vdi --mtype shareable
vboxmanage storageattach iron2 --storagectl "SATA" --port 11 --device 0 --type hdd --medium f:/vbox/asm_ocr_02.vdi --mtype shareable
vboxmanage storageattach iron1 --storagectl "SATA" --port 12 --device 0 --type hdd --medium g:/vbox/asm_ocr_03.vdi --mtype shareable
vboxmanage storageattach iron2 --storagectl "SATA" --port 12 --device 0 --type hdd --medium g:/vbox/asm_ocr_03.vdi --mtype shareable
vboxmanage storageattach iron1 --storagectl "SATA" --port 20 --device 0 --type hdd --medium d:/vbox/asm_mgmt_01.vdi --mtype shareable
vboxmanage storageattach iron2 --storagectl "SATA" --port 20 --device 0 --type hdd --medium d:/vbox/asm_mgmt_01.vdi --mtype shareable
vboxmanage storageattach iron1 --storagectl "SATA" --port 21 --device 0 --type hdd --medium f:/vbox/asm_mgmt_02.vdi --mtype shareable
vboxmanage storageattach iron2 --storagectl "SATA" --port 21 --device 0 --type hdd --medium f:/vbox/asm_mgmt_02.vdi --mtype shareable
vboxmanage storageattach iron1 --storagectl "SATA" --port 22 --device 0 --type hdd --medium g:/vbox/asm_mgmt_03.vdi --mtype shareable
vboxmanage storageattach iron2 --storagectl "SATA" --port 22 --device 0 --type hdd --medium g:/vbox/asm_mgmt_03.vdi --mtype shareable

# Start the VMs
vboxmanage startvm iron1 --type headless
vboxmanage startvm iron2 --type headless

# Cleanup or redo
# vboxmanage storageattach iron1 --storagectl SATA --port 10 --device 0 --medium none
# vboxmanage closemedium disk d:/vbox/asm_ocr_01.vdi --delete
